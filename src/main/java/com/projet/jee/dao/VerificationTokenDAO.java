package com.projet.jee.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

import com.projet.jee.model.VerificationToken;

public class VerificationTokenDAO {

    // Create the token row. Assumes a DB table named 'verification_tokens' exists with columns:
    // id (bigint PK), token varchar, nom, prenom, email, motDePasse, cin, role, created_at timestamp
    public VerificationToken createToken(VerificationToken t) throws SQLException {
        String sql = "INSERT INTO verification_tokens (token, nom, prenom, email, motDePasse, cin, role, created_at) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, t.getToken());
            ps.setString(2, t.getNom());
            ps.setString(3, t.getPrenom());
            ps.setString(4, t.getEmail());
            ps.setString(5, t.getMotDePasse());
            ps.setString(6, t.getCin());
            ps.setString(7, t.getRole());
            ps.setTimestamp(8, t.getCreatedAt() != null ? t.getCreatedAt() : new Timestamp(System.currentTimeMillis()));
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) t.setId(keys.getLong(1));
            return t;
        }
    }

    public VerificationToken findByToken(String token) throws SQLException {
        String sql = "SELECT * FROM verification_tokens WHERE token = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                VerificationToken t = new VerificationToken();
                t.setId(rs.getLong("id"));
                t.setToken(rs.getString("token"));
                t.setNom(rs.getString("nom"));
                t.setPrenom(rs.getString("prenom"));
                t.setEmail(rs.getString("email"));
                t.setMotDePasse(rs.getString("motDePasse"));
                t.setCin(rs.getString("cin"));
                t.setRole(rs.getString("role"));
                t.setCreatedAt(rs.getTimestamp("created_at"));
                return t;
            }
            return null;
        }
    }

    public boolean deleteById(Long id) throws SQLException {
        String sql = "DELETE FROM verification_tokens WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        }
    }
}
