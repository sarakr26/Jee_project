package com.projet.jee.dao;

import com.projet.jee.model.Club;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClubDAO {

    public List<Club> findAll() throws SQLException {
        List<Club> list = new ArrayList<>();
        String sql = "SELECT id, nom, logo, description, statut, president_id FROM Club";
        try (Connection c = DBConnection.getConnection();
                PreparedStatement ps = c.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Club club = mapRow(rs);
                list.add(club);
            }
        }
        return list;
    }

    public Club findById(Long id) throws SQLException {
        String sql = "SELECT id, nom, logo, description, statut, president_id FROM Club WHERE id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapRow(rs);
            }
        }
        return null;
    }

    public Club create(Club club) throws SQLException {
        String sql = "INSERT INTO Club (nom, logo, description, statut, president_id) VALUES (?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
                PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, club.getNom());
            ps.setString(2, club.getLogo());
            ps.setString(3, club.getDescription());
            ps.setString(4, club.getStatut() != null ? club.getStatut() : "EN_ATTENTE");
            if (club.getPresidentId() == null)
                ps.setNull(5, Types.BIGINT);
            else
                ps.setLong(5, club.getPresidentId());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next())
                    club.setId(keys.getLong(1));
            }
        }
        return club;
    }

    public boolean update(Club club) throws SQLException {
        String sql = "UPDATE Club SET nom = ?, logo = ?, description = ?, statut = ?, president_id = ? WHERE id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, club.getNom());
            ps.setString(2, club.getLogo());
            ps.setString(3, club.getDescription());
            ps.setString(4, club.getStatut());
            if (club.getPresidentId() == null)
                ps.setNull(5, Types.BIGINT);
            else
                ps.setLong(5, club.getPresidentId());
            ps.setLong(6, club.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(Long id) throws SQLException {
        String sql = "DELETE FROM Club WHERE id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    private Club mapRow(ResultSet rs) throws SQLException {
        Club club = new Club();
        club.setId(rs.getLong("id"));
        club.setNom(rs.getString("nom"));
        club.setLogo(rs.getString("logo"));
        club.setDescription(rs.getString("description"));
        club.setStatut(rs.getString("statut"));
        long pid = rs.getLong("president_id");
        if (!rs.wasNull())
            club.setPresidentId(pid);
        return club;
    }
}
