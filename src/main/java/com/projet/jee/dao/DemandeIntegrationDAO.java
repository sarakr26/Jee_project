package com.projet.jee.dao;

import com.projet.jee.model.DemandeIntegration;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;

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
     * Récupère toutes les demandes d'intégration
     */
    public java.util.List<DemandeIntegration> findAll() throws SQLException {
        java.util.List<DemandeIntegration> demandes = new java.util.ArrayList<>();
        String sql = "SELECT d.id, d.dateDemande, d.statut, d.membre_id, d.club_id, " +
                     "u.nom as nomMembre, u.prenom as prenomMembre, u.email as emailMembre, " +
                     "c.nom as nomClub " +
                     "FROM DemandeIntegration d " +
                     "LEFT JOIN Utilisateur u ON d.membre_id = u.id " +
                     "LEFT JOIN Club c ON d.club_id = c.id " +
                     "ORDER BY d.dateDemande DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                DemandeIntegration demande = new DemandeIntegration();
                demande.setId(rs.getLong("id"));
                demande.setDateDemande(rs.getDate("dateDemande"));
                demande.setStatut(rs.getString("statut"));
                demande.setMembreId(rs.getLong("membre_id"));
                demande.setClubId(rs.getLong("club_id"));
                demande.setNomMembre(rs.getString("nomMembre"));
                demande.setPrenomMembre(rs.getString("prenomMembre"));
                demande.setEmailMembre(rs.getString("emailMembre"));
                demande.setNomClub(rs.getString("nomClub"));
                demandes.add(demande);
            }
        }
        return demandes;
    }

    /**
     * Valide une demande d'intégration
     */
    public boolean validerDemande(Long demandeId) throws SQLException {
        String sql = "UPDATE DemandeIntegration SET statut = 'APPROUVE' WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, demandeId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Refuse une demande d'intégration
     */
    public boolean refuserDemande(Long demandeId) throws SQLException {
        String sql = "UPDATE DemandeIntegration SET statut = 'REFUSE' WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, demandeId);
            return stmt.executeUpdate() > 0;
        }
    }
}

