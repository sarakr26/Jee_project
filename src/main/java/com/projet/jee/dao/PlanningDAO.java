package com.projet.jee.dao;

import com.projet.jee.model.Planning;
import java.sql.*;


public class PlanningDAO {

    /**
     * Ensure a planning exists for the given club. If not, create it.
     * Uses stored procedure sp_ensure_planning.
     * @return planning ID
     */
    public Long ensurePlanningForClub(long clubId) throws SQLException {
        String callProc = "{CALL sp_ensure_planning(?, ?)}";
        try (Connection conn = DBConnection.getConnection();
             CallableStatement stmt = conn.prepareCall(callProc)) {
            
            stmt.setLong(1, clubId);
            stmt.registerOutParameter(2, Types.BIGINT);
            stmt.execute();
            
            return stmt.getLong(2);
        }
    }

    
    public Planning findByClubId(long clubId) throws SQLException {
        String sql = "SELECT id, club_id FROM Planning WHERE club_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, clubId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Planning p = new Planning();
                    p.setId(rs.getLong("id"));
                    p.setClubId(rs.getLong("club_id"));
                    return p;
                }
            }
        }
        return null;
    }

    
    public int deleteById(long id) throws SQLException {
        String sql = "DELETE FROM Planning WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            return stmt.executeUpdate();
        }
    }
}