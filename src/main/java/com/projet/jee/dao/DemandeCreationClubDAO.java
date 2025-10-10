package com.projet.jee.dao;

import com.projet.jee.model.DemandeCreationClub;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO pour la gestion des demandes de création de club
 */
public class DemandeCreationClubDAO {

    /**
     * Crée une nouvelle demande de création de club
     */
    public boolean createDemande(String nomClub, String description, Long presidentId) throws SQLException {
        String sql = "INSERT INTO DemandeCreationClub (nomClub, description, dateDemande, statut, president_id) " +
                     "VALUES (?, ?, ?, 'EN_ATTENTE', ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, nomClub);
            stmt.setString(2, description);
            stmt.setDate(3, new Date(System.currentTimeMillis()));
            stmt.setLong(4, presidentId);
            
            int rows = stmt.executeUpdate();
            return rows > 0;
        }
    }

    /**
     * Vérifie si le président a déjà une demande en attente
     */
    public boolean hasPendingDemande(Long presidentId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM DemandeCreationClub WHERE president_id = ? AND statut = 'EN_ATTENTE'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, presidentId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * Récupère toutes les demandes en attente
     */
    public List<DemandeCreationClub> getDemandesEnAttente() throws SQLException {
        List<DemandeCreationClub> demandes = new ArrayList<>();
        String sql = "SELECT id, nomClub, description, dateDemande, statut, president_id " +
                     "FROM DemandeCreationClub WHERE statut = 'EN_ATTENTE' ORDER BY dateDemande DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                DemandeCreationClub demande = new DemandeCreationClub();
                demande.setId(rs.getLong("id"));
                demande.setNomClub(rs.getString("nomClub"));
                demande.setDescription(rs.getString("description"));
                demande.setDateDemande(rs.getDate("dateDemande"));
                demande.setStatut(rs.getString("statut"));
                demande.setPresidentId(rs.getLong("president_id"));
                demandes.add(demande);
            }
        }
        return demandes;
    }

    /**
     * Récupère les demandes d'un président spécifique
     */
    public List<DemandeCreationClub> getDemandesByPresident(Long presidentId) throws SQLException {
        List<DemandeCreationClub> demandes = new ArrayList<>();
        String sql = "SELECT id, nomClub, description, dateDemande, statut, president_id " +
                     "FROM DemandeCreationClub WHERE president_id = ? ORDER BY dateDemande DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, presidentId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    DemandeCreationClub demande = new DemandeCreationClub();
                    demande.setId(rs.getLong("id"));
                    demande.setNomClub(rs.getString("nomClub"));
                    demande.setDescription(rs.getString("description"));
                    demande.setDateDemande(rs.getDate("dateDemande"));
                    demande.setStatut(rs.getString("statut"));
                    demande.setPresidentId(rs.getLong("president_id"));
                    demandes.add(demande);
                }
            }
        }
        return demandes;
    }
}

