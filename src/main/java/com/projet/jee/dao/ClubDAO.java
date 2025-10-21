package com.projet.jee.dao;

import com.projet.jee.model.Club;
import com.projet.jee.model.Utilisateur;

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
     * Récupère les clubs par statut
     */
    public List<Club> findByStatut(String statut) throws SQLException {
        List<Club> clubs = new ArrayList<>();
        String sql = "SELECT id, nom, logo, description, statut, president_id FROM Club WHERE statut = ? ORDER BY nom";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, statut);
            try (ResultSet rs = stmt.executeQuery()) {
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
        }
        return clubs;
    }

    /**
     * Crée un club à partir d'une demande approuvée
     */
    public boolean createClubFromDemande(String nom, String description, String logo, Long presidentId)
            throws SQLException {
        String sql = "INSERT INTO Club (nom, description, logo, statut, president_id) VALUES (?, ?, ?, 'ACTIF', ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nom);
            stmt.setString(2, description);
            stmt.setString(3, logo);
            stmt.setLong(4, presidentId);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Récupère le club d'un président
     */
    public Club getClubByPresidentId(Long presidentId) throws SQLException {
        String sql = "SELECT id, nom, logo, description, statut, president_id FROM Club WHERE president_id = ? AND statut = 'ACTIF'";

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

    /**
     * Récupère tous les membres d'un club
     */
    public List<Utilisateur> getMembersByClubId(Long clubId) throws SQLException {
        List<Utilisateur> members = new ArrayList<>();
        String sql = "SELECT id, nom, prenom, email, cin, role, club_id FROM Utilisateur WHERE club_id = ? ORDER BY nom, prenom";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, clubId);
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
}
