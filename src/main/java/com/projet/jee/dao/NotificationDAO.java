package com.projet.jee.dao;

import com.projet.jee.model.Notification;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    /**
     * Create a new notification
     */
    public boolean createNotification(Long membreId, String message, String type) throws SQLException {
        String sql = "INSERT INTO Notification (message, type, dateCreation, lu, membre_id) VALUES (?, ?, ?, false, ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, message);
            stmt.setString(2, type);
            stmt.setDate(3, new Date(System.currentTimeMillis()));
            stmt.setLong(4, membreId);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Get all notifications for a member
     */
    public List<Notification> getNotificationsByMembre(Long membreId) throws SQLException {
        String sql = "SELECT * FROM Notification WHERE membre_id = ? ORDER BY dateCreation DESC LIMIT 50";
        List<Notification> notifications = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, membreId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapRow(rs));
                }
            }
        }
        return notifications;
    }

    /**
     * Get unread notifications count for a member
     */
    public int getUnreadCount(Long membreId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Notification WHERE membre_id = ? AND lu = false";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, membreId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    /**
     * Mark a notification as read
     */
    public boolean markAsRead(Long notificationId) throws SQLException {
        String sql = "UPDATE Notification SET lu = true WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, notificationId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Mark all notifications as read for a member
     */
    public boolean markAllAsRead(Long membreId) throws SQLException {
        String sql = "UPDATE Notification SET lu = true WHERE membre_id = ? AND lu = false";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, membreId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Map ResultSet to Notification object
     */
    private Notification mapRow(ResultSet rs) throws SQLException {
        Notification notification = new Notification();
        notification.setId(rs.getLong("id"));
        notification.setMessage(rs.getString("message"));
        notification.setType(rs.getString("type"));
        notification.setDateCreation(rs.getDate("dateCreation"));
        notification.setLu(rs.getBoolean("lu"));
        notification.setMembreId(rs.getLong("membre_id"));
        return notification;
    }
}

