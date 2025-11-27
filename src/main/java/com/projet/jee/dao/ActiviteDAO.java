package com.projet.jee.dao;

import com.projet.jee.model.Activite;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO pour la gestion des activités
 */
public class ActiviteDAO {

    /**
     * Récupère toutes les activités d'un planning
     */
    public List<Activite> getActivitesByPlanningId(Long planningId) throws SQLException {
        List<Activite> activites = new ArrayList<>();
        String sql = "SELECT id, titre, type, dateDebut, dateFin, planning_id " +
                     "FROM Activite WHERE planning_id = ? ORDER BY dateDebut ASC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, planningId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    activites.add(mapRow(rs));
                }
            }
        }
        return activites;
    }

    /**
     * Récupère une activité par son ID
     */
    public Activite getActiviteById(Long id) throws SQLException {
        String sql = "SELECT id, titre, type, dateDebut, dateFin, planning_id " +
                     "FROM Activite WHERE id = ?";

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

    /**
     * Récupère les activités à venir d'un planning
     */
    public List<Activite> getActivitesFuturesByPlanningId(Long planningId) throws SQLException {
        List<Activite> activites = new ArrayList<>();
        String sql = "SELECT id, titre, type, dateDebut, dateFin, planning_id " +
                     "FROM Activite WHERE planning_id = ? AND dateDebut >= NOW() " +
                     "ORDER BY dateDebut ASC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, planningId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    activites.add(mapRow(rs));
                }
            }
        }
        return activites;
    }

    /**
     * Récupère les activités d'un planning pour un mois donné
     */
    public List<Activite> getActivitesByPlanningAndMonth(Long planningId, int year, int month) throws SQLException {
        List<Activite> activites = new ArrayList<>();
        String sql = "SELECT id, titre, type, dateDebut, dateFin, planning_id " +
                     "FROM Activite WHERE planning_id = ? " +
                     "AND YEAR(dateDebut) = ? AND MONTH(dateDebut) = ? " +
                     "ORDER BY dateDebut ASC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, planningId);
            stmt.setInt(2, year);
            stmt.setInt(3, month);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    activites.add(mapRow(rs));
                }
            }
        }
        return activites;
    }

    /**
     * Crée une nouvelle activité
     */
    public Activite create(Activite activite) throws SQLException {
        String sql = "INSERT INTO Activite (titre, type, dateDebut, dateFin, planning_id) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, activite.getTitre());
            stmt.setString(2, activite.getType());
            stmt.setTimestamp(3, activite.getDateDebut());
            stmt.setTimestamp(4, activite.getDateFin());
            stmt.setLong(5, activite.getPlanningId());

            stmt.executeUpdate();
            try (ResultSet keys = stmt.getGeneratedKeys()) {
                if (keys.next()) {
                    activite.setId(keys.getLong(1));
                }
            }
        }
        return activite;
    }

    /**
     * Met à jour une activité
     */
    public boolean update(Activite activite) throws SQLException {
        String sql = "UPDATE Activite SET titre = ?, type = ?, dateDebut = ?, dateFin = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, activite.getTitre());
            stmt.setString(2, activite.getType());
            stmt.setTimestamp(3, activite.getDateDebut());
            stmt.setTimestamp(4, activite.getDateFin());
            stmt.setLong(5, activite.getId());

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Supprime une activité
     */
    public boolean delete(Long id) throws SQLException {
        String sql = "DELETE FROM Activite WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Map un ResultSet vers un objet Activite
     */
    private Activite mapRow(ResultSet rs) throws SQLException {
        Activite activite = new Activite();
        activite.setId(rs.getLong("id"));
        activite.setTitre(rs.getString("titre"));
        activite.setType(rs.getString("type"));
        activite.setDateDebut(rs.getTimestamp("dateDebut"));
        activite.setDateFin(rs.getTimestamp("dateFin"));
        activite.setPlanningId(rs.getLong("planning_id"));
        return activite;
    }
}


