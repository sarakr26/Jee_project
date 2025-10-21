package com.projet.jee.Servlets;

import com.projet.jee.dao.ClubDAO;
import com.projet.jee.dao.DemandeCreationClubDAO;
import com.projet.jee.dao.DemandeIntegrationDAO;
import com.projet.jee.dao.EvenementDAO;
import com.projet.jee.model.Club;
import com.projet.jee.model.DemandeCreationClub;
import com.projet.jee.model.DemandeIntegration;
import com.projet.jee.model.Evenement;
import com.projet.jee.model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "FederationDashboardServlet", urlPatterns = {"/federation/dashboard"})
public class FederationDashboardServlet extends HttpServlet {
    private ClubDAO clubDAO = new ClubDAO();
    private DemandeCreationClubDAO demandeCreationDAO = new DemandeCreationClubDAO();
    private DemandeIntegrationDAO demandeIntegrationDAO = new DemandeIntegrationDAO();
    private EvenementDAO evenementDAO = new EvenementDAO();

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

            // Récupérer les données pour le tableau de bord
            List<DemandeCreationClub> demandesCreation = demandeCreationDAO.findAll();
            List<DemandeIntegration> demandesIntegration = demandeIntegrationDAO.findAll();
            List<Club> clubsActifs = clubDAO.findByStatut("ACTIF");
            List<Evenement> evenementsUrgents = evenementDAO.findEvenementsUrgents();
            List<Evenement> evenementsProchains = evenementDAO.findEvenementsProchains();

            // Calculer les indicateurs clés
            int nombreClubsActifs = clubsActifs.size();
            int demandesEnAttente = (int) demandesCreation.stream().filter(d -> "EN_ATTENTE".equals(d.getStatut())).count();
            int demandesIntegrationEnAttente = (int) demandesIntegration.stream().filter(d -> "EN_ATTENTE".equals(d.getStatut())).count();
            int totalDemandesEnAttente = demandesEnAttente + demandesIntegrationEnAttente;

            // Passer les données à la JSP
            req.setAttribute("demandesCreation", demandesCreation);
            req.setAttribute("demandesIntegration", demandesIntegration);
            req.setAttribute("clubsActifs", clubsActifs);
            req.setAttribute("evenementsUrgents", evenementsUrgents);
            req.setAttribute("evenementsProchains", evenementsProchains);
            req.setAttribute("nombreClubsActifs", nombreClubsActifs);
            req.setAttribute("demandesEnAttente", totalDemandesEnAttente);
            req.setAttribute("demandesCreationEnAttente", demandesEnAttente);
            req.setAttribute("demandesIntegrationEnAttente", demandesIntegrationEnAttente);

            req.getRequestDispatcher("/jsp/federation-dashboard.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur lors du chargement du tableau de bord: " + e.getMessage());
            req.getRequestDispatcher("/jsp/auth/profile.jsp").forward(req, resp);
        }
    }
}
