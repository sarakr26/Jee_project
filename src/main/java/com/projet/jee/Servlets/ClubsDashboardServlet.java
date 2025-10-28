package com.projet.jee.Servlets;

import com.projet.jee.dao.ClubDAO;
import com.projet.jee.dao.UtilisateurDAO;
import com.projet.jee.model.Club;
import com.projet.jee.model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ClubsDashboardServlet", urlPatterns = {"/federation/clubs"})
public class ClubsDashboardServlet extends HttpServlet {
    private ClubDAO clubDAO = new ClubDAO();
    private UtilisateurDAO utilisateurDAO = new UtilisateurDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Vérifier l'authentification et le rôle
            Utilisateur currentUser = (Utilisateur) req.getSession().getAttribute("currentUser");
            if (currentUser == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            
            if (!"FEDERATION".equals(currentUser.getRole())) {
                req.setAttribute("error", "Accès refusé. Rôle FEDERATION requis.");
                req.getRequestDispatcher("/jsp/auth/profile.jsp").forward(req, resp);
                return;
            }

            // Récupérer tous les clubs actifs
            List<Club> clubs = clubDAO.getAllActiveClubs();
            
            // Créer une structure pour stocker les informations complètes de chaque club
            List<Map<String, Object>> clubsInfo = new ArrayList<>();
            
            for (Club club : clubs) {
                Map<String, Object> clubInfo = new HashMap<>();
                clubInfo.put("club", club);
                
                // Récupérer les informations du président
                Utilisateur president = utilisateurDAO.findById(club.getPresidentId());
                if (president != null) {
                    clubInfo.put("president", president);
                }
                
                // Récupérer le nombre de membres du club
                List<Utilisateur> members = clubDAO.getMembersByClubId(club.getId());
                clubInfo.put("nombreMembres", members != null ? members.size() : 0);
                
                clubsInfo.add(clubInfo);
            }

            // Passer les données à la JSP
            req.setAttribute("clubsInfo", clubsInfo);
            req.setAttribute("nombreClubs", clubs.size());

            req.getRequestDispatcher("/jsp/clubs-dashboard.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur lors du chargement des clubs: " + e.getMessage());
            req.getRequestDispatcher("/jsp/federation-dashboard.jsp").forward(req, resp);
        }
    }
} 
