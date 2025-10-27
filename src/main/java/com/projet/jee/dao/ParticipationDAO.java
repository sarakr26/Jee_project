package com.projet.jee.dao;

import com.projet.jee.model.Participation;
import com.projet.jee.model.Utilisateur;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class ParticipationDAO {

    /**
     * Add members to an event (tournament)
     */
    public boolean addParticipants(Long evenementId, List<Long> membreIds) throws SQLException {
        String sql = "INSERT INTO Participation (dateInvitation, statut, membre_id, evenement_id) VALUES (?, 'INVITE', ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            Date today = new Date(System.currentTimeMillis());
            
            for (Long membreId : membreIds) {
                stmt.setDate(1, today);
                stmt.setLong(2, membreId);
                stmt.setLong(3, evenementId);
                stmt.addBatch();
            }
            
            int[] results = stmt.executeBatch();
            return results.length > 0;
        }
    }

    /**
     * Get participants for an event
     */
    public List<Participation> getParticipantsByEvenement(Long evenementId) throws SQLException {
        List<Participation> participants = new ArrayList<>();
        String sql = "SELECT id, dateInvitation, dateConfirmation, statut, membre_id, evenement_id " +
                     "FROM Participation WHERE evenement_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, evenementId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Participation p = new Participation();
                    p.setId(rs.getLong("id"));
                    p.setDateInvitation(rs.getDate("dateInvitation"));
                    p.setDateConfirmation(rs.getDate("dateConfirmation"));
                    p.setStatut(rs.getString("statut"));
                    p.setMembreId(rs.getLong("membre_id"));
                    p.setEvenementId(rs.getLong("evenement_id"));
                    participants.add(p);
                }
            }
        }
        return participants;
    }

    /**
     * Get participants with member details for an event
     */
    public List<Utilisateur> getParticipantMembersByEvenement(Long evenementId) throws SQLException {
        List<Utilisateur> members = new ArrayList<>();
        String sql = "SELECT u.id, u.nom, u.prenom, u.email, u.cin, u.role, u.club_id " +
                     "FROM Utilisateur u " +
                     "INNER JOIN Participation p ON u.id = p.membre_id " +
                     "WHERE p.evenement_id = ? " +
                     "ORDER BY u.nom, u.prenom";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, evenementId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Utilisateur member = new Utilisateur();
                    member.setId(rs.getLong("id"));
                    member.setNom(rs.getString("nom"));
                    member.setPrenom(rs.getString("prenom"));
                    member.setEmail(rs.getString("email"));
                    member.setCin(rs.getString("cin"));
                    member.setRole(rs.getString("role"));
                    member.setClubId(rs.getLong("club_id"));
                    members.add(member);
                }
            }
        }
        return members;
    }

    /**
     * Check if a member is already participating in an event
     */
    public boolean isParticipating(Long membreId, Long evenementId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Participation WHERE membre_id = ? AND evenement_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, membreId);
            stmt.setLong(2, evenementId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * Remove a participant from an event
     */
    public boolean removeParticipant(Long membreId, Long evenementId) throws SQLException {
        String sql = "DELETE FROM Participation WHERE membre_id = ? AND evenement_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, membreId);
            stmt.setLong(2, evenementId);
            
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Get count of participants from a specific club for an event
     */
    public int getClubParticipantCount(Long clubId, Long evenementId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Participation p " +
                     "INNER JOIN Utilisateur u ON p.membre_id = u.id " +
                     "WHERE u.club_id = ? AND p.evenement_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, clubId);
            stmt.setLong(2, evenementId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
}