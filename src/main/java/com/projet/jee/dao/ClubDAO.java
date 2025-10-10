package com.projet.jee.dao;

import com.projet.jee.model.Club;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO pour la gestion des clubs
 */
public class ClubDAO {

    /**
     * Récupère tous les clubs avec le statut ACTIF
     */
    public List<Club> getAllActiveClubs() throws SQLException {
        List<Club> clubs = new ArrayList<>();
        String sql = "SELECT id, nom, logo, description, statut, president_id FROM Club WHERE statut = 'ACTIF' ORDER BY nom";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Club club = new Club();
                club.setId(rs.getLong("id"));
                club.setNom(rs.getString("nom"));
                club.setLogo(rs.getString("logo"));
                club.setDescription(rs.getString("description"));
                club.setStatut(rs.getString("statut"));
                club.setPresidentId(rs.getLong("president_id"));
                clubs.add(club);
            }
        }
        return clubs;
    }

    /**
     * Récupère un club par son ID
     */
    public Club getClubById(Long id) throws SQLException {
        String sql = "SELECT id, nom, logo, description, statut, president_id FROM Club WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Club club = new Club();
                    club.setId(rs.getLong("id"));
                    club.setNom(rs.getString("nom"));
                    club.setLogo(rs.getString("logo"));
                    club.setDescription(rs.getString("description"));
                    club.setStatut(rs.getString("statut"));
                    club.setPresidentId(rs.getLong("president_id"));
                    return club;
                }
            }
        }
        return null;
    }

    /**
     * Récupère le club dont l'utilisateur est le président
     */
    public Club getClubByPresidentId(Long presidentId) throws SQLException {
        String sql = "SELECT id, nom, logo, description, statut, president_id FROM Club WHERE president_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, presidentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Club club = new Club();
                    club.setId(rs.getLong("id"));
                    club.setNom(rs.getString("nom"));
                    club.setLogo(rs.getString("logo"));
                    club.setDescription(rs.getString("description"));
                    club.setStatut(rs.getString("statut"));
                    club.setPresidentId(rs.getLong("president_id"));
                    return club;
                }
            }
        }
        return null;
    }
}

