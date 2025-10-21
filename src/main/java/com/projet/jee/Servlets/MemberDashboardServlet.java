package com.projet.jee.Servlets;

import com.projet.jee.dao.ClubDAO;
import com.projet.jee.dao.EvenementDAO;
import com.projet.jee.model.Club;
import com.projet.jee.model.Evenement;
import com.projet.jee.model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "MemberDashboardServlet", urlPatterns = {"/membre/dashboard"})
public class MemberDashboardServlet extends HttpServlet {
    private ClubDAO clubDAO = new ClubDAO();
    private EvenementDAO evenementDAO = new EvenementDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Utilisateur currentUser = (Utilisateur) session.getAttribute("currentUser");
        
        // Vérifier que l'utilisateur est bien un MEMBRE
        if (!"MEMBRE".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/jsp/auth/profile.jsp");
            return;
        }

        try {
            // Récupérer tous les clubs actifs
            List<Club> clubs = clubDAO.getAllActiveClubs();
            request.setAttribute("clubs", clubs);
            
            // Récupérer tous les événements planifiés
            List<Evenement> evenements = evenementDAO.getAllEvenementsPlanifies();
            request.setAttribute("evenements", evenements);
            
            request.getRequestDispatcher("/jsp/membre-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la récupération des données: " + e.getMessage());
            request.getRequestDispatcher("/jsp/membre-dashboard.jsp").forward(request, response);
        }
    }
}

