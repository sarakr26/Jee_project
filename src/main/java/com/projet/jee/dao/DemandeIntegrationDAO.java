package com.projet.jee.dao;

import com.projet.jee.model.DemandeIntegration;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO pour la gestion des demandes d'intégration
 */
public class DemandeIntegrationDAO {

    /**
     * Crée une nouvelle demande d'intégration
     */
    public boolean createDemande(Long membreId, Long clubId) throws SQLException {
        // Vérifier d'abord si une demande EN_ATTENTE existe déjà
        if (hasPendingDemande(membreId, clubId)) {
            return false; // Demande déjà existante
        }

        String sql = "INSERT INTO DemandeIntegration (dateDemande, statut, membre_id, club_id) VALUES (?, 'EN_ATTENTE', ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDate(1, new Date(System.currentTimeMillis()));
            stmt.setLong(2, membreId);
            stmt.setLong(3, clubId);
            
            int rows = stmt.executeUpdate();
            return rows > 0;
        }
    }

    /**
     * Vérifie si une demande EN_ATTENTE existe déjà pour ce membre et ce club
     */
    public boolean hasPendingDemande(Long membreId, Long clubId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM DemandeIntegration WHERE membre_id = ? AND club_id = ? AND statut = 'EN_ATTENTE'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, membreId);
            stmt.setLong(2, clubId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * Récupère une demande d'intégration par son ID
     */
    public DemandeIntegration getDemandeById(Long id) throws SQLException {
        String sql = "SELECT id, dateDemande, statut, membre_id, club_id FROM DemandeIntegration WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    DemandeIntegration demande = new DemandeIntegration();
                    demande.setId(rs.getLong("id"));
                    demande.setDateDemande(rs.getDate("dateDemande"));
                    demande.setStatut(rs.getString("statut"));
                    demande.setMembreId(rs.getLong("membre_id"));
                    demande.setClubId(rs.getLong("club_id"));
                    return demande;
                }
            }
        }
        return null;
    }

    /**
     * Récupère toutes les demandes d'intégration pour un club spécifique
     */
    public List<DemandeIntegration> getDemandesByClub(Long clubId) throws SQLException {
        List<DemandeIntegration> demandes = new ArrayList<>();
        String sql = "SELECT id, dateDemande, statut, membre_id, club_id FROM DemandeIntegration WHERE club_id = ? ORDER BY dateDemande DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, clubId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    DemandeIntegration demande = new DemandeIntegration();
                    demande.setId(rs.getLong("id"));
                    demande.setDateDemande(rs.getDate("dateDemande"));
                    demande.setStatut(rs.getString("statut"));
                    demande.setMembreId(rs.getLong("membre_id"));
                    demande.setClubId(rs.getLong("club_id"));
                    demandes.add(demande);
                }
            }
        }
        return demandes;
    }

    /**
     * Récupère les demandes d'intégration en attente pour un club
     */
    public List<DemandeIntegration> getPendingDemandesByClub(Long clubId) throws SQLException {
        List<DemandeIntegration> demandes = new ArrayList<>();
        String sql = "SELECT id, dateDemande, statut, membre_id, club_id FROM DemandeIntegration WHERE club_id = ? AND statut = 'EN_ATTENTE' ORDER BY dateDemande DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, clubId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    DemandeIntegration demande = new DemandeIntegration();
                    demande.setId(rs.getLong("id"));
                    demande.setDateDemande(rs.getDate("dateDemande"));
                    demande.setStatut(rs.getString("statut"));
                    demande.setMembreId(rs.getLong("membre_id"));
                    demande.setClubId(rs.getLong("club_id"));
                    demandes.add(demande);
                }
            }
        }
        return demandes;
    }

    /**
     * Récupère les demandes d'intégration pour un club avec les informations du membre
     */
    public List<DemandeIntegration> getDemandesWithMembreInfoByClub(Long clubId) throws SQLException {
        List<DemandeIntegration> demandes = new ArrayList<>();
        String sql = "SELECT di.id, di.dateDemande, di.statut, di.membre_id, di.club_id, " +
                     "u.nom, u.prenom, u.email, c.nom as club_nom " +
                     "FROM DemandeIntegration di " +
                     "INNER JOIN Utilisateur u ON di.membre_id = u.id " +
                     "INNER JOIN Club c ON di.club_id = c.id " +
                     "WHERE di.club_id = ? " +
                     "ORDER BY di.dateDemande DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, clubId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    DemandeIntegration demande = new DemandeIntegration();
                    demande.setId(rs.getLong("id"));
                    demande.setDateDemande(rs.getDate("dateDemande"));
                    demande.setStatut(rs.getString("statut"));
                    demande.setMembreId(rs.getLong("membre_id"));
                    demande.setClubId(rs.getLong("club_id"));
                    demande.setMembreNom(rs.getString("nom"));
                    demande.setMembrePrenom(rs.getString("prenom"));
                    demande.setMembreEmail(rs.getString("email"));
                    demande.setClubNom(rs.getString("club_nom"));
                    demandes.add(demande);
                }
            }
        }
        return demandes;
    }

    /**
     * Accepte une demande d'intégration et ajoute le membre au club
     */
    public boolean accepterDemande(Long demandeId) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // Récupérer la demande
            DemandeIntegration demande = getDemandeById(demandeId);
            if (demande == null || !"EN_ATTENTE".equals(demande.getStatut())) {
                conn.rollback();
                return false;
            }
            
            // Mettre à jour le statut de la demande
            String updateDemande = "UPDATE DemandeIntegration SET statut = 'ACCEPTEE' WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateDemande)) {
                stmt.setLong(1, demandeId);
                stmt.executeUpdate();
            }
            
            // Ajouter le membre au club
            String updateMembre = "UPDATE Utilisateur SET club_id = ? WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateMembre)) {
                stmt.setLong(1, demande.getClubId());
                stmt.setLong(2, demande.getMembreId());
                stmt.executeUpdate();
            }
            
            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    /**
     * Refuse une demande d'intégration
     */
    public boolean refuserDemande(Long demandeId) throws SQLException {
        String sql = "UPDATE DemandeIntegration SET statut = 'REFUSEE' WHERE id = ? AND statut = 'EN_ATTENTE'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, demandeId);
            int rows = stmt.executeUpdate();
            return rows > 0;
        }
    }
}

