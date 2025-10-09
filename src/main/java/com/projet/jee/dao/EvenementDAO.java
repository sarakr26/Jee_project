package com.projet.jee.dao;

import com.projet.jee.model.Evenement;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EvenementDAO {

    public List<Evenement> findAll() throws SQLException {
        List<Evenement> list = new ArrayList<>();
        String sql = "SELECT id, titre, description, lieu, dateDebut, dateFin, statut, federation_id FROM Evenement";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Evenement e = mapRow(rs);
                list.add(e);
            }
        }
        return list;
    }

    public Evenement findById(Long id) throws SQLException {
        String sql = "SELECT id, titre, description, lieu, dateDebut, dateFin, statut, federation_id FROM Evenement WHERE id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public Evenement create(Evenement e) throws SQLException {
        String sql = "INSERT INTO Evenement (titre, description, lieu, dateDebut, dateFin, statut, federation_id) VALUES (?,?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, e.getTitre());
            ps.setString(2, e.getDescription());
            ps.setString(3, e.getLieu());
            ps.setDate(4, e.getDateDebut());
            ps.setDate(5, e.getDateFin());
            ps.setString(6, e.getStatut());
            if (e.getFederationId() == null) ps.setNull(7, Types.BIGINT);
            else ps.setLong(7, e.getFederationId());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) e.setId(keys.getLong(1));
            }
        }
        return e;
    }

    public boolean delete(Long id) throws SQLException {
        String sql = "DELETE FROM Evenement WHERE id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    private Evenement mapRow(ResultSet rs) throws SQLException {
        Evenement e = new Evenement();
        e.setId(rs.getLong("id"));
        e.setTitre(rs.getString("titre"));
        e.setDescription(rs.getString("description"));
        e.setLieu(rs.getString("lieu"));
        e.setDateDebut(rs.getDate("dateDebut"));
        e.setDateFin(rs.getDate("dateFin"));
        e.setStatut(rs.getString("statut"));
        long fid = rs.getLong("federation_id");
        if (!rs.wasNull()) e.setFederationId(fid);
        return e;
    }
}
