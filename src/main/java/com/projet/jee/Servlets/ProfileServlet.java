package com.projet.jee.Servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.projet.jee.dao.ClubDAO;
import com.projet.jee.dao.DBConnection;
import com.projet.jee.dao.UtilisateurDAO;
import com.projet.jee.model.Club;
import com.projet.jee.model.Utilisateur;

@WebServlet(urlPatterns = {"/profile", "/profile/update"})
public class ProfileServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ProfileServlet.class.getName());
    private final UtilisateurDAO utilisateurDAO = new UtilisateurDAO();
    private final ClubDAO clubDAO = new ClubDAO();

    private int countClubMembers(Long clubId) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT COUNT(*) as count FROM Utilisateur WHERE club_id = ? AND role = 'MEMBRE'")) {
            
            stmt.setLong(1, clubId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
            return 0;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Move any flash message from session to request so JSP can render it
        Object flashMessage = request.getSession().getAttribute("message");
        Object flashType = request.getSession().getAttribute("messageType");
        if (flashMessage != null) {
            request.setAttribute("message", flashMessage);
            request.getSession().removeAttribute("message");
        }
        if (flashType != null) {
            request.setAttribute("messageType", flashType);
            request.getSession().removeAttribute("messageType");
        }

        Utilisateur currentUser = (Utilisateur) request.getSession().getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // For presidents, fetch additional club information
        if ("PRESIDENT".equals(currentUser.getRole()) && currentUser.getClubId() != null) {
            try {
                Club club = clubDAO.getClubById(currentUser.getClubId());
                if (club != null) {
                    request.setAttribute("club", club);
                    // Count members from Utilisateur table
                    int memberCount = countClubMembers(currentUser.getClubId());
                    request.setAttribute("memberCount", memberCount);
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Erreur lors de la récupération des informations du club", e);
                request.setAttribute("message", "Erreur lors de la récupération des informations du club");
                request.setAttribute("messageType", "danger");
            }
        }

        // Forward to the appropriate profile page based on role
        String page;
        switch (currentUser.getRole()) {
            case "MEMBRE":
                page = "/jsp/auth/membre-profile.jsp";
                break;
            case "PRESIDENT":
                page = "/jsp/auth/president-profile.jsp";
                break;
            case "FEDERATION":
            default:
                page = "/jsp/auth/profile.jsp";
                break;
        }
        
        request.getRequestDispatcher(page).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Utilisateur currentUser = (Utilisateur) request.getSession().getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");

        try {
            if (nom != null && !nom.trim().isEmpty() && prenom != null && !prenom.trim().isEmpty()) {
                currentUser.setNom(nom.trim());
                currentUser.setPrenom(prenom.trim());
                
                boolean updated = utilisateurDAO.updateProfile(currentUser);
                
                if (updated) {
                    // Update the session user information
                    request.getSession().setAttribute("currentUser", currentUser);
                    request.getSession().setAttribute("message", "Profil mis à jour avec succès");
                    request.getSession().setAttribute("messageType", "success");
                } else {
                    request.getSession().setAttribute("message", "Erreur lors de la mise à jour du profil");
                    request.getSession().setAttribute("messageType", "danger");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la mise à jour du profil", e);
            request.getSession().setAttribute("message", "Erreur lors de la mise à jour du profil");
            request.getSession().setAttribute("messageType", "danger");
        }

        // Use Post/Redirect/Get: put a flash message into session and redirect to GET
        try {
            if (nom != null && !nom.trim().isEmpty() && prenom != null && !prenom.trim().isEmpty()) {
                // message already set above in session when update succeeded/failed
            } else {
                // If no update (invalid data), show a warning
                request.getSession().setAttribute("message", "Aucune modification envoyée");
                request.getSession().setAttribute("messageType", "warning");
            }
        } finally {
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }
}
