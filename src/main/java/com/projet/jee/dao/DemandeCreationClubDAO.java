package com.projet.jee.dao;

import com.projet.jee.model.DemandeCreationClub;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO pour la gestion des demandes de création de club
 */
public class DemandeCreationClubDAO {

    /**
     * Crée une nouvelle demande de création de club
     */
    public boolean createDemande(String nomClub, String description, String logo, Long presidentId)
            throws SQLException {
        String sql = "INSERT INTO DemandeCreationClub (nomClub, description, logo, dateDemande, statut, president_id) "
                +
                "VALUES (?, ?, ?, ?, 'EN_ATTENTE', ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nomClub);
            stmt.setString(2, description);
            stmt.setString(3, logo);
            stmt.setDate(4, new Date(System.currentTimeMillis()));
            stmt.setLong(5, presidentId);

            int rows = stmt.executeUpdate();
            return rows > 0;
        }
    }

    /**
     * Vérifie si le président a déjà une demande en attente
     */
    public boolean hasPendingDemande(Long presidentId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM DemandeCreationClub WHERE president_id = ? AND statut = 'EN_ATTENTE'";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, presidentId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * Récupère toutes les demandes en attente
     */
    public List<DemandeCreationClub> getDemandesEnAttente() throws SQLException {
        List<DemandeCreationClub> demandes = new ArrayList<>();
        String sql = "SELECT id, nomClub, description, logo, dateDemande, statut, president_id " +
                "FROM DemandeCreationClub WHERE statut = 'EN_ATTENTE' ORDER BY dateDemande DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                DemandeCreationClub demande = new DemandeCreationClub();
                demande.setId(rs.getLong("id"));
                demande.setNomClub(rs.getString("nomClub"));
                demande.setDescription(rs.getString("description"));
                demande.setLogo(rs.getString("logo"));
                demande.setDateDemande(rs.getDate("dateDemande"));
                demande.setStatut(rs.getString("statut"));
                demande.setPresidentId(rs.getLong("president_id"));
                demandes.add(demande);
            }
        }
        return demandes;
    }

    /**
     * Récupère les demandes d'un président spécifique
     */
    public List<DemandeCreationClub> getDemandesByPresident(Long presidentId) throws SQLException {
        List<DemandeCreationClub> demandes = new ArrayList<>();
        String sql = "SELECT id, nomClub, description, logo, dateDemande, statut, president_id " +
                "FROM DemandeCreationClub WHERE president_id = ? ORDER BY dateDemande DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, presidentId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    DemandeCreationClub demande = new DemandeCreationClub();
                    demande.setId(rs.getLong("id"));
                    demande.setNomClub(rs.getString("nomClub"));
                    demande.setDescription(rs.getString("description"));
                    demande.setLogo(rs.getString("logo"));
                    demande.setDateDemande(rs.getDate("dateDemande"));
                    demande.setStatut(rs.getString("statut"));
                    demande.setPresidentId(rs.getLong("president_id"));
                    demandes.add(demande);
                }
            }
        }
        return demandes;
    }

    /**
     * Récupère une demande par son ID
     */
    public DemandeCreationClub findById(Long id) throws SQLException {
        String sql = "SELECT id, nomClub, description, logo, dateDemande, statut, president_id " +
                "FROM DemandeCreationClub WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    DemandeCreationClub demande = new DemandeCreationClub();
                    demande.setId(rs.getLong("id"));
                    demande.setNomClub(rs.getString("nomClub"));
                    demande.setDescription(rs.getString("description"));
                    demande.setLogo(rs.getString("logo"));
                    demande.setDateDemande(rs.getDate("dateDemande"));
                    demande.setStatut(rs.getString("statut"));
                    demande.setPresidentId(rs.getLong("president_id"));
                    return demande;
                }
            }
        }
        return null;
    }

    /**
     * Récupère toutes les demandes
     */
    public List<DemandeCreationClub> findAll() throws SQLException {
        List<DemandeCreationClub> demandes = new ArrayList<>();
        String sql = "SELECT d.id, d.nomClub, d.description, d.logo, d.dateDemande, d.statut, d.president_id, " +
                "u.nom as nomPresident, u.prenom as prenomPresident, u.email as emailPresident " +
                "FROM DemandeCreationClub d " +
                "LEFT JOIN Utilisateur u ON d.president_id = u.id " +
                "ORDER BY d.dateDemande DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                DemandeCreationClub demande = new DemandeCreationClub();
                demande.setId(rs.getLong("id"));
                demande.setNomClub(rs.getString("nomClub"));
                demande.setDescription(rs.getString("description"));
                demande.setLogo(rs.getString("logo"));
                demande.setDateDemande(rs.getDate("dateDemande"));
                demande.setStatut(rs.getString("statut"));
                demande.setPresidentId(rs.getLong("president_id"));
                demande.setNomPresident(rs.getString("nomPresident"));
                demande.setPrenomPresident(rs.getString("prenomPresident"));
                demande.setEmailPresident(rs.getString("emailPresident"));
                demandes.add(demande);
            }
        }
        return demandes;
    }

    /**
     * Valide une demande de création de club
     */
    public boolean validerDemande(Long demandeId) throws SQLException {
        String sql = "UPDATE DemandeCreationClub SET statut = 'ACCEPTEE' WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, demandeId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Refuse une demande de création de club
     */
    public boolean refuserDemande(Long demandeId) throws SQLException {
        String sql = "UPDATE DemandeCreationClub SET statut = 'REFUSEE' WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, demandeId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Supprime une demande de création de club (seulement si EN_ATTENTE)
     */
    public boolean deleteDemande(Long demandeId, Long presidentId) throws SQLException {
        String sql = "DELETE FROM DemandeCreationClub WHERE id = ? AND president_id = ? AND statut = 'EN_ATTENTE'";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, demandeId);
            stmt.setLong(2, presidentId);
            return stmt.executeUpdate() > 0;
        }
    }
}
