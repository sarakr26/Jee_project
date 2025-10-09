package com.projet.jee.dao;

import com.projet.jee.model.Utilisateur;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;

public class UtilisateurDAO {

    public Utilisateur findByEmail(String email) throws SQLException {
        try (Connection c = DBConnection.getConnection()) {
            PreparedStatement ps = c.prepareStatement("SELECT * FROM Utilisateur WHERE email = ?");
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
            return null;
        }
    }

    public Utilisateur findById(Long id) throws SQLException {
        try (Connection c = DBConnection.getConnection()) {
            PreparedStatement ps = c.prepareStatement("SELECT * FROM Utilisateur WHERE id = ?");
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
            return null;
        }
    }

    public Utilisateur create(Utilisateur u) throws SQLException {
        try (Connection c = DBConnection.getConnection()) {
            PreparedStatement ps = c.prepareStatement("INSERT INTO Utilisateur (nom, prenom, email, motDePasse, cin, role, club_id) VALUES (?,?,?,?,?,?,?)", Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, u.getNom());
            ps.setString(2, u.getPrenom());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getMotDePasse());
            ps.setString(5, u.getCin());
            ps.setString(6, u.getRole());
            if (u.getClubId() != null) ps.setLong(7, u.getClubId()); else ps.setNull(7, Types.BIGINT);
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) u.setId(keys.getLong(1));
            return u;
        }
    }

    public Utilisateur authenticate(String email, String plainPassword) throws SQLException {
        Utilisateur u = findByEmail(email);
        if (u == null) return null;
        if (BCrypt.checkpw(plainPassword, u.getMotDePasse())) return u;
        return null;
    }

    private Utilisateur mapRow(ResultSet rs) throws SQLException {
        Utilisateur u = new Utilisateur();
        u.setId(rs.getLong("id"));
        u.setNom(rs.getString("nom"));
        u.setPrenom(rs.getString("prenom"));
        u.setEmail(rs.getString("email"));
        u.setMotDePasse(rs.getString("motDePasse"));
        u.setCin(rs.getString("cin"));
        u.setRole(rs.getString("role"));
        long clubId = rs.getLong("club_id");
        if (!rs.wasNull()) u.setClubId(clubId);
        return u;
    }
}
