package com.projet.jee.dao;

import com.projet.jee.model.Message;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO pour la gestion des messages internes.
 */
public class MessageDAO {

    /**
     * Envoie un message à tous les membres d'un club.
     */
    public void envoyerMessageAuClub(Long expediteurId, Long clubId, String sujet, String contenu) throws SQLException {
        String insertMessageSql = "INSERT INTO Message (expediteur_id, club_id, sujet, contenu, date_envoi) VALUES (?, ?, ?, ?, ?)";
        String selectMembresSql = "SELECT id FROM Utilisateur WHERE club_id = ? AND role = 'MEMBRE'";
        String insertDestSql = "INSERT INTO MessageDestinataire (message_id, destinataire_id, lu) VALUES (?, ?, false)";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            Long messageId = null;

            try (PreparedStatement stmt = conn.prepareStatement(insertMessageSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                stmt.setLong(1, expediteurId);
                stmt.setLong(2, clubId);
                stmt.setString(3, sujet);
                stmt.setString(4, contenu);
                stmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
                stmt.executeUpdate();

                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        messageId = rs.getLong(1);
                    }
                }
            }

            if (messageId == null) {
                conn.rollback();
                throw new SQLException("Impossible de récupérer l'ID du message créé");
            }

            // Récupérer tous les membres du club
            List<Long> destinataires = new ArrayList<>();
            try (PreparedStatement stmt = conn.prepareStatement(selectMembresSql)) {
                stmt.setLong(1, clubId);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        destinataires.add(rs.getLong("id"));
                    }
                }
            }

            // Créer une entrée par destinataire
            try (PreparedStatement stmt = conn.prepareStatement(insertDestSql)) {
                for (Long destId : destinataires) {
                    stmt.setLong(1, messageId);
                    stmt.setLong(2, destId);
                    stmt.addBatch();
                }
                stmt.executeBatch();
            }

            conn.commit();
        }
    }

    /**
     * Récupère la boîte de réception d'un utilisateur.
     */
    public List<Message> getInbox(Long utilisateurId) throws SQLException {
        String sql = "SELECT m.*, c.nom AS club_nom FROM Message m "
                + "JOIN MessageDestinataire md ON md.message_id = m.id "
                + "JOIN Club c ON m.club_id = c.id "
                + "WHERE md.destinataire_id = ? "
                + "ORDER BY m.date_envoi DESC";

        List<Message> messages = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, utilisateurId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    messages.add(mapRow(rs));
                }
            }
        }
        return messages;
    }

    /**
     * Récupère les messages envoyés par un utilisateur.
     */
    public List<Message> getSent(Long expediteurId) throws SQLException {
        String sql = "SELECT m.*, c.nom AS club_nom FROM Message m "
                + "JOIN Club c ON m.club_id = c.id "
                + "WHERE m.expediteur_id = ? ORDER BY m.date_envoi DESC";
        List<Message> messages = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, expediteurId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    messages.add(mapRow(rs));
                }
            }
        }
        return messages;
    }

    /**
     * Marque un message comme lu pour un destinataire.
     */
    public void marquerCommeLu(Long messageId, Long destinataireId) throws SQLException {
        String sql = "UPDATE MessageDestinataire SET lu = true WHERE message_id = ? AND destinataire_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, messageId);
            stmt.setLong(2, destinataireId);
            stmt.executeUpdate();
        }
    }

    private Message mapRow(ResultSet rs) throws SQLException {
        Message m = new Message();
        m.setId(rs.getLong("id"));
        m.setExpediteurId(rs.getLong("expediteur_id"));
        m.setClubId(rs.getLong("club_id"));
        m.setSujet(rs.getString("sujet"));
        m.setContenu(rs.getString("contenu"));
        m.setDateEnvoi(rs.getTimestamp("date_envoi"));
        try {
            // champ calculé, peut ne pas exister si la requête ne joint pas Club
            String clubNom = rs.getString("club_nom");
            m.setClubNom(clubNom);
        } catch (SQLException ignored) {
            // colonne absente : laisser clubNom à null
        }
        return m;
    }
}


