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
    
    // Vous ajouterez ici les méthodes pour approuver/rejeter plus tard
}