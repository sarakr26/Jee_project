package com.projet.jee.dao;

import com.projet.jee.model.Activite;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class ActiviteDAO {

    
    public int create(Activite activite) throws SQLException {
        String sql = "INSERT INTO Activite (titre, type, dateDebut, dateFin, planning_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, activite.getTitre());
            stmt.setString(2, activite.getType());
            stmt.setTimestamp(3, activite.getDateDebut());
            stmt.setTimestamp(4, activite.getDateFin());
            stmt.setLong(5, activite.getPlanningId());
            
            int rows = stmt.executeUpdate();
            
            if (rows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        activite.setId(rs.getLong(1));
                    }
                }
            }
            return rows;
        }
    }

    
    public int update(Activite activite) throws SQLException {
        String sql = "UPDATE Activite SET titre = ?, type = ?, dateDebut = ?, dateFin = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, activite.getTitre());
            stmt.setString(2, activite.getType());
            stmt.setTimestamp(3, activite.getDateDebut());
            stmt.setTimestamp(4, activite.getDateFin());
            stmt.setLong(5, activite.getId());
            
            return stmt.executeUpdate();
        }
    }

    
    public int delete(long id) throws SQLException {
        String sql = "DELETE FROM Activite WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            return stmt.executeUpdate();
        }
    }

    
    public Activite findById(long id) throws SQLException {
        String sql = "SELECT id, titre, type, dateDebut, dateFin, planning_id FROM Activite WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToActivite(rs);
                }
            }
        }
        return null;
    }

    
    public List<Activite> findByPlanningId(long planningId) throws SQLException {
        String sql = "SELECT id, titre, type, dateDebut, dateFin, planning_id FROM Activite WHERE planning_id = ? ORDER BY dateDebut ASC";
        List<Activite> activities = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, planningId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    activities.add(mapResultSetToActivite(rs));
                }
            }
        }
        return activities;
    }

    
    public List<Activite> findUpcomingByClub(long clubId, Timestamp from) throws SQLException {
        String sql = "SELECT a.id, a.titre, a.type, a.dateDebut, a.dateFin, a.planning_id " +
                     "FROM Activite a " +
                     "JOIN Planning p ON a.planning_id = p.id " +
                     "WHERE p.club_id = ? AND a.dateFin >= ? " +
                     "ORDER BY a.dateDebut ASC";
        List<Activite> activities = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, clubId);
            stmt.setTimestamp(2, from);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    activities.add(mapResultSetToActivite(rs));
                }
            }
        }
        return activities;
    }

    
    private Activite mapResultSetToActivite(ResultSet rs) throws SQLException {
        Activite a = new Activite();
        a.setId(rs.getLong("id"));
        a.setTitre(rs.getString("titre"));
        a.setType(rs.getString("type"));
        a.setDateDebut(rs.getTimestamp("dateDebut"));
        a.setDateFin(rs.getTimestamp("dateFin"));
        a.setPlanningId(rs.getLong("planning_id"));
        return a;
    }
}