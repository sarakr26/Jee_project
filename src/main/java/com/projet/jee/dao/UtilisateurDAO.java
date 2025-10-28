package com.projet.jee.dao;

import com.projet.jee.model.Utilisateur;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UtilisateurDAO {

    public Utilisateur findByEmail(String email) throws SQLException {
        try (Connection c = DBConnection.getConnection()) {
            PreparedStatement ps = c.prepareStatement("SELECT * FROM Utilisateur WHERE email = ?");
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapRow(rs);
            return null;
        }
    }

    public Utilisateur findById(Long id) throws SQLException {
        try (Connection c = DBConnection.getConnection()) {
            PreparedStatement ps = c.prepareStatement("SELECT * FROM Utilisateur WHERE id = ?");
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapRow(rs);
            return null;
        }
    }

    public Utilisateur create(Utilisateur u) throws SQLException {
        try (Connection c = DBConnection.getConnection()) {
            PreparedStatement ps = c.prepareStatement(
                    "INSERT INTO Utilisateur (nom, prenom, email, motDePasse, cin, role, club_id) VALUES (?,?,?,?,?,?,?)",
                    Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, u.getNom());
            ps.setString(2, u.getPrenom());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getMotDePasse());
            ps.setString(5, u.getCin());
            ps.setString(6, u.getRole());
            if (u.getClubId() != null)
                ps.setLong(7, u.getClubId());
            else
                ps.setNull(7, Types.BIGINT);
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next())
                u.setId(keys.getLong(1));
            return u;
        }
    }

    public Utilisateur authenticate(String email, String plainPassword) throws SQLException {
        Utilisateur u = findByEmail(email);
        if (u == null)
            return null;
        if (BCrypt.checkpw(plainPassword, u.getMotDePasse()))
            return u;
        return null;
    }

    /**
     * Met à jour le club_id d'un utilisateur
     */
    public boolean updateUserClub(Long userId, Long clubId) throws SQLException {
        String sql = "UPDATE Utilisateur SET club_id = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (clubId != null) {
                stmt.setLong(1, clubId);
            } else {
                stmt.setNull(1, Types.BIGINT);
            }
            stmt.setLong(2, userId);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Get all members
     */
    public List<Utilisateur> getAllMembers() throws SQLException {
        List<Utilisateur> members = new ArrayList<>();
        String sql = "SELECT id, nom, prenom, email, cin, role, club_id FROM Utilisateur WHERE role = 'MEMBRE' ORDER BY nom, prenom";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Utilisateur member = mapRow(rs);
                members.add(member);
            }
        }
        return members;
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
        if (!rs.wasNull())
            u.setClubId(clubId);
        return u;
    }
}
