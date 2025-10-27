package com.projet.jee.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import com.projet.jee.model.Evenement;

/**
 * DAO pour la gestion des événements
 */
public class EvenementDAO {

    /**
     * Récupère tous les événements planifiés créés par la fédération
     */
    public List<Evenement> getAllEvenementsPlanifies() throws SQLException {
        List<Evenement> evenements = new ArrayList<>();
        String sql = "SELECT id, titre, description, lieu, dateDebut, dateFin, statut, premier_id, deuxieme_id, troisieme_id "
                +
                "FROM Evenement WHERE statut = 'PLANIFIE' ORDER BY dateDebut";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                evenements.add(mapRow(rs));
            }
        }
        return evenements;
    }

    /**
     * Récupère tous les événements (tous statuts)
     */
    public List<Evenement> getAllEvenements() throws SQLException {
        List<Evenement> evenements = new ArrayList<>();
        String sql = "SELECT id, titre, description, lieu, dateDebut, dateFin, statut, premier_id, deuxieme_id, troisieme_id "
                +
                "FROM Evenement ORDER BY dateDebut DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                evenements.add(mapRow(rs));
            }
        }
        return evenements;
    }

    /**
     * Récupère un événement par son ID
     */
    public Evenement getEvenementById(Long id) throws SQLException {
        String sql = "SELECT id, titre, description, lieu, dateDebut, dateFin, statut, premier_id, deuxieme_id, troisieme_id "
                +
                "FROM Evenement WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    // Alias methods for compatibility
    public List<Evenement> findAll() throws SQLException {
        return getAllEvenements();
    }

    public Evenement findById(Long id) throws SQLException {
        return getEvenementById(id);
    }

    /**
     * Crée un nouvel événement
     */
    public Evenement create(Evenement e) throws SQLException {
        String sql = "INSERT INTO Evenement (titre, description, lieu, dateDebut, dateFin, statut) VALUES (?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
                PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, e.getTitre());
            ps.setString(2, e.getDescription());
            ps.setString(3, e.getLieu());
            ps.setDate(4, e.getDateDebut());
            ps.setDate(5, e.getDateFin());
            ps.setString(6, e.getStatut());

            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next())
                    e.setId(keys.getLong(1));
            }
        }
        return e;
    }

    /**
     * Récupère les événements urgents (dans les 7 prochains jours)
     */
    public List<Evenement> findEvenementsUrgents() throws SQLException {
        List<Evenement> evenements = new ArrayList<>();
        String sql = "SELECT id, titre, description, lieu, dateDebut, dateFin, statut, premier_id, deuxieme_id, troisieme_id "
                +
                "FROM Evenement WHERE dateDebut BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY) " +
                "AND statut IN ('PLANIFIE', 'EN_COURS') ORDER BY dateDebut ASC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                evenements.add(mapRow(rs));
            }
        }
        return evenements;
    }

    /**
     * Récupère les événements prochains (dans les 30 prochains jours)
     */
    public List<Evenement> findEvenementsProchains() throws SQLException {
        List<Evenement> evenements = new ArrayList<>();

        String sql = "SELECT id, titre, description, lieu, dateDebut, dateFin, statut, premier_id, deuxieme_id, troisieme_id "
                +
                "FROM Evenement WHERE dateDebut BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY) " +
                "AND statut = 'PLANIFIE' ORDER BY dateDebut ASC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                evenements.add(mapRow(rs));
            }
        }
        return evenements;
    }

    /**
     * Met à jour un événement existant
     */
    public Evenement update(Evenement e) throws SQLException {
        String sql = "UPDATE Evenement SET titre=?, description=?, lieu=?, dateDebut=?, dateFin=?, statut=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
                PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, e.getTitre());
            ps.setString(2, e.getDescription());
            ps.setString(3, e.getLieu());
            ps.setDate(4, e.getDateDebut());
            ps.setDate(5, e.getDateFin());
            ps.setString(6, e.getStatut());
            ps.setLong(7, e.getId());

            ps.executeUpdate();
        }
        return e;
    }

    /**
     * Supprime un événement par son ID
     */
    public boolean delete(Long id) throws SQLException {
        String sql = "DELETE FROM Evenement WHERE id=?";
        try (Connection c = DBConnection.getConnection();
                PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Récupère les participants inscrits à un événement
     * (Cette méthode nécessite la table Participation)
     */
    public List<String> getParticipants(Long evenementId) throws SQLException {
        List<String> participants = new ArrayList<>();
        String sql = "SELECT u.nom, u.prenom, c.nom as club_nom " +
                "FROM Participation p " +
                "JOIN Utilisateur u ON p.membre_id = u.id " +
                "LEFT JOIN Club c ON u.club_id = c.id " +
                "WHERE p.evenement_id = ? AND p.statut IN ('INVITE', 'CONFIRME') " +
                "ORDER BY u.nom, u.prenom";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, evenementId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String nom = rs.getString("nom");
                    String prenom = rs.getString("prenom");
                    String clubNom = rs.getString("club_nom");
                    String participant = nom + " " + prenom;
                    if (clubNom != null) {
                        participant += " (" + clubNom + ")";
                    }
                    participants.add(participant);
                }
            }
        }
        return participants;
    }

    /**
     * Compte le nombre de participants à un événement
     */
    public int countParticipants(Long evenementId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Participation WHERE evenement_id = ? AND statut IN ('INVITE', 'CONFIRME')";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, evenementId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    /**
     * Map un ResultSet vers un objet Evenement
     */
    private Evenement mapRow(ResultSet rs) throws SQLException {
        Evenement e = new Evenement();
        e.setId(rs.getLong("id"));
        e.setTitre(rs.getString("titre"));
        e.setDescription(rs.getString("description"));
        e.setLieu(rs.getString("lieu"));
        e.setDateDebut(rs.getDate("dateDebut"));
        e.setDateFin(rs.getDate("dateFin"));
        e.setStatut(rs.getString("statut"));

        // Podium fields (can be null)
        Long premierId = rs.getLong("premier_id");
        if (!rs.wasNull())
            e.setPremierId(premierId);

        Long deuxiemeId = rs.getLong("deuxieme_id");
        if (!rs.wasNull())
            e.setDeuxiemeId(deuxiemeId);

        Long troisiemeId = rs.getLong("troisieme_id");
        if (!rs.wasNull())
            e.setTroisiemeId(troisiemeId);

        return e;
    }

    /**
     * Update podium winners for an event
     */
    public boolean updatePodium(Long evenementId, Long premierId, Long deuxiemeId, Long troisiemeId)
            throws SQLException {
        String sql = "UPDATE Evenement SET premier_id=?, deuxieme_id=?, troisieme_id=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (premierId != null) {
                stmt.setLong(1, premierId);
            } else {
                stmt.setNull(1, Types.BIGINT);
            }

            if (deuxiemeId != null) {
                stmt.setLong(2, deuxiemeId);
            } else {
                stmt.setNull(2, Types.BIGINT);
            }

            if (troisiemeId != null) {
                stmt.setLong(3, troisiemeId);
            } else {
                stmt.setNull(3, Types.BIGINT);
            }

            stmt.setLong(4, evenementId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Auto-update events to TERMINE status if they ended more than 1 day ago
     */
    public int autoUpdateFinishedEvents() throws SQLException {
        String sql = "UPDATE Evenement SET statut='TERMINE' " +
                "WHERE statut='PLANIFIE' AND dateFin < DATE_SUB(CURDATE(), INTERVAL 1 DAY)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            return stmt.executeUpdate();
        }
    }

    /**
     * Get events that are finished (TERMINE status)
     */
    public List<Evenement> getFinishedEvents() throws SQLException {
        List<Evenement> evenements = new ArrayList<>();
        String sql = "SELECT id, titre, description, lieu, dateDebut, dateFin, statut, premier_id, deuxieme_id, troisieme_id "
                +
                "FROM Evenement WHERE statut = 'TERMINE' ORDER BY dateFin DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                evenements.add(mapRow(rs));
            }
        }
        return evenements;
    }
}
