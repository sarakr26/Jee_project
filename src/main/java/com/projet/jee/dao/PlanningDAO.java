package com.projet.jee.dao;

import com.projet.jee.model.Planning;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * DAO pour la gestion des plannings
 */
public class PlanningDAO {

    /**
     * Récupère le planning d'un club
     */
    public Planning getPlanningByClubId(Long clubId) throws SQLException {
        String sql = "SELECT id, club_id FROM Planning WHERE club_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, clubId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Planning planning = new Planning();
                    planning.setId(rs.getLong("id"));
                    planning.setClubId(rs.getLong("club_id"));
                    return planning;
                }
            }
        }
        return null;
    }

    /**
     * Crée un planning pour un club (si il n'existe pas)
     */
    public Planning createPlanningForClub(Long clubId) throws SQLException {
        // Vérifier si un planning existe déjà
        Planning existing = getPlanningByClubId(clubId);
        if (existing != null) {
            return existing;
        }

        String sql = "INSERT INTO Planning (club_id) VALUES (?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setLong(1, clubId);
            stmt.executeUpdate();

            try (ResultSet keys = stmt.getGeneratedKeys()) {
                if (keys.next()) {
                    Planning planning = new Planning();
                    planning.setId(keys.getLong(1));
                    planning.setClubId(clubId);
                    return planning;
                }
            }
        }
        return null;
    }

    /**
     * Supprime un planning (cascade avec les activités)
     */
    public boolean deletePlanning(Long planningId) throws SQLException {
        String sql = "DELETE FROM Planning WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, planningId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Récupère un planning par son ID
     */
    public Planning getPlanningById(Long id) throws SQLException {
        String sql = "SELECT id, club_id FROM Planning WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Planning planning = new Planning();
                    planning.setId(rs.getLong("id"));
                    planning.setClubId(rs.getLong("club_id"));
                    return planning;
                }
            }
        }
        return null;
    }
}


