package com.projet.jee.dao;

import com.projet.jee.model.Utilisateur;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UtilisateurDAO {

    /**
     * Trouve un utilisateur par son email ET son mot de passe.
     * C'est la méthode correcte à utiliser pour le login.
     * @param email L'email de l'utilisateur.
     * @param password Le mot de passe de l'utilisateur.
     * @return L'objet Utilisateur s'il est trouvé, sinon null.
     */

    public Utilisateur findByEmailAndPassword(String email, String password) {
        Utilisateur user = null;
        // Modifiez la requête SQL pour inclure la vérification du mot de passe
        String sql = "SELECT * FROM Utilisateur WHERE email = ? AND motDePasse = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement statement = conn.prepareStatement(sql)) {
            
            statement.setString(1, email);
            statement.setString(2, password); // Ajoutez le paramètre du mot de passe
            
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                user = new Utilisateur();
                user.setId(rs.getLong("id"));
                user.setNom(rs.getString("nom"));
                user.setPrenom(rs.getString("prenom"));
                user.setEmail(rs.getString("email"));
                user.setCin(rs.getString("cin"));
                user.setRole(rs.getString("role"));
                // Assurez-vous que votre table a bien une colonne club_id
                if (rs.getObject("club_id") != null) {
                    user.setClubId(rs.getLong("club_id"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public Utilisateur findByEmail(String email) {
        Utilisateur user = null;
        String sql = "SELECT * FROM Utilisateur WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, email);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                user = new Utilisateur();
                // ... mapper les champs comme dans l'autre méthode
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
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

    public List<Utilisateur> findByClubId(long clubId) {
        List<Utilisateur> membres = new ArrayList<>();
        String sql = "SELECT * FROM Utilisateur WHERE club_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement statement = conn.prepareStatement(sql)) {
            
            statement.setLong(1, clubId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                membres.add(mapRow(rs)); // On réutilise la méthode mapRow existante
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return membres;
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
