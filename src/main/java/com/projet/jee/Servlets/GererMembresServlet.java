package com.projet.jee.Servlets;

import com.projet.jee.dao.ClubDAO;
import com.projet.jee.dao.DemandeIntegrationDAO;
import com.projet.jee.model.Club;
import com.projet.jee.model.DemandeIntegration;
import com.projet.jee.model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "GererMembresServlet", urlPatterns = { "/president/gerer-membres" })
public class GererMembresServlet extends HttpServlet {
    private ClubDAO clubDAO = new ClubDAO();
    private DemandeIntegrationDAO demandeIntegrationDAO = new DemandeIntegrationDAO();

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
            // Récupérer le club du président
            Club club = clubDAO.getClubByPresidentId(currentUser.getId());

            if (club == null) {
                session.setAttribute("errorMessage", "Vous devez d'abord créer un club pour gérer les membres.");
                response.sendRedirect(request.getContextPath() + "/president/dashboard");
                return;
            }

            // Récupérer les membres du club
            List<Utilisateur> members = clubDAO.getMembersByClubId(club.getId());

            // Récupérer les demandes d'intégration en attente
            List<DemandeIntegration> pendingRequests = demandeIntegrationDAO.getPendingDemandesByClubId(club.getId());

            request.setAttribute("club", club);
            request.setAttribute("members", members);
            request.setAttribute("pendingRequests", pendingRequests);

            request.getRequestDispatcher("/jsp/gerer-membres.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la récupération des membres: " + e.getMessage());
            request.getRequestDispatcher("/jsp/gerer-membres.jsp").forward(request, response);
        }
    }
}