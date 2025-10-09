package com.projet.jee.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Simple DB connection helper. Adjust constants if your DB credentials differ.
 */
public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/chess_club_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = ""; // change if your MySQL root has a password

    static {
        try {
            // ensure the driver class is loaded
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            // driver not found — let the app fail later when attempting connections
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
