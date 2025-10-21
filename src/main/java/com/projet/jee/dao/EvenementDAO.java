package com.projet.jee.dao;

import com.projet.jee.model.Evenement;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO pour la gestion des événements
 */
public class EvenementDAO {

    /**
     * Récupère tous les événements planifiés créés par la fédération
     */
    public List<Evenement> getAllEvenementsPlanifies() throws SQLException {
        List<Evenement> evenements = new ArrayList<>();
        String sql = "SELECT id, titre, description, lieu, dateDebut, dateFin, statut, federation_id " +
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
        String sql = "SELECT id, titre, description, lieu, dateDebut, dateFin, statut, federation_id " +
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
        String sql = "SELECT id, titre, description, lieu, dateDebut, dateFin, statut, federation_id " +
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
        String sql = "INSERT INTO Evenement (titre, description, lieu, dateDebut, dateFin, statut, federation_id) VALUES (?,?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection(); 
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, e.getTitre());
            ps.setString(2, e.getDescription());
            ps.setString(3, e.getLieu());
            ps.setDate(4, e.getDateDebut());
            ps.setDate(5, e.getDateFin());
            ps.setString(6, e.getStatut());
            if (e.getFederationId() == null) ps.setNull(7, Types.BIGINT);
            else ps.setLong(7, e.getFederationId());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) e.setId(keys.getLong(1));
            }
        }
        return e;
    }

    /**
     * Supprime un événement par son ID
     */
    public boolean delete(Long id) throws SQLException {
        String sql = "DELETE FROM Evenement WHERE id = ?";
        try (Connection c = DBConnection.getConnection(); 
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Récupère les événements urgents (dans les 7 prochains jours)
     */
    public List<Evenement> findEvenementsUrgents() throws SQLException {
        List<Evenement> evenements = new ArrayList<>();
        String sql = "SELECT id, titre, description, lieu, dateDebut, dateFin, statut, federation_id " +
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
        String sql = "SELECT id, titre, description, lieu, dateDebut, dateFin, statut, federation_id " +
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
        long fid = rs.getLong("federation_id");
        if (!rs.wasNull()) e.setFederationId(fid);
        return e;
    }
}
