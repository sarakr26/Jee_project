package com.projet.jee.dao;

import com.projet.jee.model.Utilisateur;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UtilisateurDAO {

    public Utilisateur create(Utilisateur u) throws SQLException {
        // --- DÉBOGAGE ---
        System.out.println("\n--- [DEBUG] UtilisateurDAO: Tentative de création d'utilisateur ---");
        System.out.println("Email à insérer : " + u.getEmail());
        System.out.println("Rôle à insérer : " + u.getRole());
        // --- FIN DÉBOGAGE ---

        String sql = "INSERT INTO Utilisateur (nom, prenom, email, motDePasse, cin, role) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement statement = null;
        try {
            conn = DBConnection.getConnection();
            statement = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, u.getNom());
            statement.setString(2, u.getPrenom());
            statement.setString(3, u.getEmail());
            statement.setString(4, u.getMotDePasse());
            statement.setString(5, u.getCin());
            statement.setString(6, u.getRole());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                // --- DÉBOGAGE ---
                System.out.println("ÉCHEC de l'insertion, aucune ligne affectée.");
                // --- FIN DÉBOGAGE ---
                throw new SQLException("La création de l'utilisateur a échoué, aucune ligne affectée.");
            }

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    u.setId(generatedKeys.getLong(1));
                    // --- DÉBOGAGE ---
                    System.out.println("SUCCÈS de l'insertion. Nouvel ID : " + u.getId());
                    // --- FIN DÉBOGAGE ---
                } else {
                    throw new SQLException("La création de l'utilisateur a échoué, aucun ID obtenu.");
                }
            }
        } finally {
            if (statement != null) statement.close();
            if (conn != null) conn.close();
        }
        return u;
    }

    public Utilisateur findByEmail(String email) {
        Utilisateur user = null;
        String sql = "SELECT * FROM Utilisateur WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, email);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                user = mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public Utilisateur authenticate(String email, String plainPassword) throws SQLException {
        Utilisateur u = findByEmail(email);
        if (u != null) {
            if (u.getMotDePasse() != null && BCrypt.checkpw(plainPassword, u.getMotDePasse())) {
                return u;
            }
        }
        return null;
    }

    public List<Utilisateur> findByClubId(long clubId) {
        List<Utilisateur> membres = new ArrayList<>();
        String sql = "SELECT * FROM Utilisateur WHERE club_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement statement = conn.prepareStatement(sql)) {
            
            statement.setLong(1, clubId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                membres.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return membres;
    }

    private Utilisateur mapRow(ResultSet rs) throws SQLException {
        Utilisateur user = new Utilisateur();
        user.setId(rs.getLong("id"));
        user.setNom(rs.getString("nom"));
        user.setPrenom(rs.getString("prenom"));
        user.setEmail(rs.getString("email"));
        user.setMotDePasse(rs.getString("motDePasse"));
        user.setCin(rs.getString("cin"));
        user.setRole(rs.getString("role"));
        if (rs.getObject("club_id") != null) {
            user.setClubId(rs.getLong("club_id"));
        }
        return user;
    }

    // Méthodes non utilisées ou incorrectes pour le contexte actuel, laissées pour référence
    public Utilisateur findByEmailAndPassword(String email, String password) {
        return null;
    }

    public Utilisateur findById(Long id) throws SQLException {
        return null;
    }
}