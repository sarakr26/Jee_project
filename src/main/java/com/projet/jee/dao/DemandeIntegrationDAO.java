package com.projet.jee.dao;

import com.projet.jee.model.DemandeIntegration;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DemandeIntegrationDAO {

    public List<DemandeIntegration> findByClubId(long clubId) {
        List<DemandeIntegration> demandes = new ArrayList<>();
        String sql = "SELECT * FROM DemandeIntegration WHERE club_id = ? AND statut = 'EN_ATTENTE'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement statement = conn.prepareStatement(sql)) {
            
            statement.setLong(1, clubId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                DemandeIntegration demande = new DemandeIntegration();
                demande.setId(rs.getLong("id"));
                demande.setMembreId(rs.getLong("membre_id"));
                demande.setClubId(rs.getLong("club_id"));
                demande.setStatut(rs.getString("statut"));
                demande.setDateDemande(rs.getDate("dateDemande"));
                demandes.add(demande);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return demandes;
    }
    
    
    public List<DemandeIntegration> findPendingByClub(long clubId) throws SQLException {
        String sql = "SELECT id, dateDemande, statut, membre_id, club_id FROM DemandeIntegration WHERE club_id = ? AND statut = 'EN_ATTENTE' ORDER BY dateDemande DESC";
        List<DemandeIntegration> demandes = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, clubId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    DemandeIntegration d = new DemandeIntegration();
                    d.setId(rs.getLong("id"));
                    d.setDateDemande(rs.getDate("dateDemande"));
                    d.setStatut(rs.getString("statut"));
                    d.setMembreId(rs.getLong("membre_id"));
                    d.setClubId(rs.getLong("club_id"));
                    demandes.add(d);
                }
            }
        }
        return demandes;
    }

    /**
     * Accept a join request using stored procedure
     */
    public void acceptDemande(long demandeId) throws SQLException {
        String callProc = "{CALL sp_accept_demande(?)}";
        try (Connection conn = DBConnection.getConnection();
             CallableStatement stmt = conn.prepareCall(callProc)) {
            
            stmt.setLong(1, demandeId);
            stmt.execute();
        }
    }

    /**
     * Refuse a join request using stored procedure
     */
    public void refuseDemande(long demandeId) throws SQLException {
        String callProc = "{CALL sp_refuse_demande(?)}";
        try (Connection conn = DBConnection.getConnection();
             CallableStatement stmt = conn.prepareCall(callProc)) {
            
            stmt.setLong(1, demandeId);
            stmt.execute();
        }
    }
}