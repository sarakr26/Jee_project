package com.projet.jee.Servlets;

import com.projet.jee.dao.EvenementDAO;
import com.projet.jee.dao.DemandeCreationClubDAO;
import com.projet.jee.dao.DemandeIntegrationDAO;
import com.projet.jee.dao.ClubDAO;
import com.projet.jee.model.Evenement;
import com.projet.jee.model.DemandeCreationClub;
import com.projet.jee.model.DemandeIntegration;
import com.projet.jee.model.Club;
import com.projet.jee.model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet(name = "PresidentDashboardServlet", urlPatterns = {"/president/dashboard"})
public class PresidentDashboardServlet extends HttpServlet {
    private EvenementDAO evenementDAO = new EvenementDAO();
    private DemandeCreationClubDAO demandeDAO = new DemandeCreationClubDAO();
    private DemandeIntegrationDAO demandeIntegrationDAO = new DemandeIntegrationDAO();
    private ClubDAO clubDAO = new ClubDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Utilisateur currentUser = (Utilisateur) session.getAttribute("currentUser");
        
        // Vérifier que l'utilisateur est bien un PRESIDENT
        if (!"PRESIDENT".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/jsp/auth/profile.jsp");
            return;
        }

        try {
            // Récupérer tous les événements créés par la fédération
            List<Evenement> evenements = evenementDAO.getEvenementsByFederation();
            request.setAttribute("evenements", evenements);
            
            // Récupérer les demandes de création de club du président
            List<DemandeCreationClub> demandes = demandeDAO.getDemandesByPresident(currentUser.getId());
            request.setAttribute("demandes", demandes);
            
            // Récupérer le club du président s'il en a un
            Club presidentClub = clubDAO.getClubByPresidentId(currentUser.getId());
            List<DemandeIntegration> demandesIntegration = new ArrayList<>();
            
            if (presidentClub != null) {
                request.setAttribute("presidentClub", presidentClub);
                // Récupérer les demandes d'intégration pour son club
                demandesIntegration = demandeIntegrationDAO.getDemandesWithMembreInfoByClub(presidentClub.getId());
            }
            request.setAttribute("demandesIntegration", demandesIntegration);
            
            request.getRequestDispatcher("/jsp/president-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la récupération des données: " + e.getMessage());
            request.getRequestDispatcher("/jsp/president-dashboard.jsp").forward(request, response);
        }
    }
}

