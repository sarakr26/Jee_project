package com.projet.jee.dao;

import com.projet.jee.model.Evenement;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
                Evenement evenement = new Evenement();
                evenement.setId(rs.getLong("id"));
                evenement.setTitre(rs.getString("titre"));
                evenement.setDescription(rs.getString("description"));
                evenement.setLieu(rs.getString("lieu"));
                evenement.setDateDebut(rs.getDate("dateDebut"));
                evenement.setDateFin(rs.getDate("dateFin"));
                evenement.setStatut(rs.getString("statut"));
                evenement.setFederationId(rs.getLong("federation_id"));
                evenements.add(evenement);
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
                Evenement evenement = new Evenement();
                evenement.setId(rs.getLong("id"));
                evenement.setTitre(rs.getString("titre"));
                evenement.setDescription(rs.getString("description"));
                evenement.setLieu(rs.getString("lieu"));
                evenement.setDateDebut(rs.getDate("dateDebut"));
                evenement.setDateFin(rs.getDate("dateFin"));
                evenement.setStatut(rs.getString("statut"));
                evenement.setFederationId(rs.getLong("federation_id"));
                evenements.add(evenement);
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
                    Evenement evenement = new Evenement();
                    evenement.setId(rs.getLong("id"));
                    evenement.setTitre(rs.getString("titre"));
                    evenement.setDescription(rs.getString("description"));
                    evenement.setLieu(rs.getString("lieu"));
                    evenement.setDateDebut(rs.getDate("dateDebut"));
                    evenement.setDateFin(rs.getDate("dateFin"));
                    evenement.setStatut(rs.getString("statut"));
                    evenement.setFederationId(rs.getLong("federation_id"));
                    return evenement;
                }
            }
        }
        return null;
    }
}

