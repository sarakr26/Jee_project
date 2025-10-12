package com.projet.jee.dao;

import com.projet.jee.model.Federation;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FederationDAO {

    public List<Federation> findAll() throws SQLException {
        List<Federation> list = new ArrayList<>();
        String sql = "SELECT id, nom, pays FROM Federation";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Federation f = new Federation();
                f.setId(rs.getLong("id"));
                f.setNom(rs.getString("nom"));
                f.setPays(rs.getString("pays"));
                list.add(f);
            }
        }
        return list;
    }

    public Federation findById(Long id) throws SQLException {
        String sql = "SELECT id, nom, pays FROM Federation WHERE id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Federation f = new Federation();
                    f.setId(rs.getLong("id"));
                    f.setNom(rs.getString("nom"));
                    f.setPays(rs.getString("pays"));
                    return f;
                }
            }
        }
        return null;
    }

    public Federation create(Federation f) throws SQLException {
        String sql = "INSERT INTO Federation (nom, pays) VALUES (?,?)";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, f.getNom());
            ps.setString(2, f.getPays());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) { if (keys.next()) f.setId(keys.getLong(1)); }
        }
        return f;
    }
}
