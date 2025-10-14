package com.projet.jee.dao;

import com.projet.jee.model.Utilisateur;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UtilisateurDAO {

    // NOTE: Cette méthode est incorrecte pour un système avec BCrypt et ne devrait pas être utilisée pour le login.
    public Utilisateur findByEmailAndPassword(String email, String password) {
        // ... code existant ...
        return null; // Laisser tel quel pour l'instant
    }

    public Utilisateur findByEmail(String email) {
        Utilisateur user = null;
        String sql = "SELECT * FROM Utilisateur WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, email);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                // CORRECTION : Utiliser mapRow pour remplir complètement l'objet utilisateur
                user = mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public Utilisateur findById(Long id) throws SQLException {
        // ... code existant ...
        return null;
    }

    public Utilisateur create(Utilisateur u) throws SQLException {
        // ... code existant ...
        return u;
    }

    public List<Utilisateur> findByClubId(long clubId) {
        // ... code existant ...
        return new ArrayList<>();
    }

    public Utilisateur authenticate(String email, String plainPassword) throws SQLException {
        // --- DÉBOGAGE ---
        System.out.println("\n--- [DEBUG] UtilisateurDAO: Méthode authenticate ---");
        System.out.println("Email reçu par le DAO : " + email);
        // --- FIN DÉBOGAGE ---

        Utilisateur u = findByEmail(email);

        // --- DÉBOGAGE ---
        if (u != null) {
            System.out.println("Utilisateur trouvé dans la BDD : " + u.getEmail());
            // La ligne suivante est la plus importante. Elle nous montrera ce qui est passé à BCrypt.
            System.out.println("Mot de passe haché récupéré de la BDD : '" + u.getMotDePasse() + "'");
        } else {
            System.out.println("AUCUN utilisateur trouvé dans la BDD pour l'email : " + email);
        }
        // --- FIN DÉBOGAGE ---

        if (u != null) {
            // Vérification pour éviter l'erreur si le mot de passe est null dans la BDD
            if (u.getMotDePasse() != null && BCrypt.checkpw(plainPassword, u.getMotDePasse())) {
                System.out.println("Authentification réussie pour " + email);
                return u;
            }
        }
        System.out.println("Authentification échouée pour " + email);
        return null;
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
}