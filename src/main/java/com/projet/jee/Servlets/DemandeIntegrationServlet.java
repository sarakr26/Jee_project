package com.projet.jee.Servlets;

import com.projet.jee.dao.DemandeIntegrationDAO;
import com.projet.jee.dao.ClubDAO;
import com.projet.jee.model.Club;
import com.projet.jee.model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "DemandeIntegrationServlet", urlPatterns = {"/membre/integrer-club"})
public class DemandeIntegrationServlet extends HttpServlet {
    private DemandeIntegrationDAO demandeDAO = new DemandeIntegrationDAO();
    private ClubDAO clubDAO = new ClubDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
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
            String clubIdStr = request.getParameter("clubId");
            if (clubIdStr == null || clubIdStr.isEmpty()) {
                session.setAttribute("errorMessage", "ID du club invalide.");
                response.sendRedirect(request.getContextPath() + "/membre/dashboard");
                return;
            }

            Long clubId = Long.parseLong(clubIdStr);
            
            // Vérifier que le club existe
            Club club = clubDAO.getClubById(clubId);
            if (club == null) {
                session.setAttribute("errorMessage", "Le club demandé n'existe pas.");
                response.sendRedirect(request.getContextPath() + "/membre/dashboard");
                return;
            }

            // Vérifier si une demande est déjà en attente
            if (demandeDAO.hasPendingDemande(currentUser.getId(), clubId)) {
                session.setAttribute("errorMessage", "Vous avez déjà une demande en attente pour ce club.");
                response.sendRedirect(request.getContextPath() + "/membre/dashboard");
                return;
            }

            // Créer la demande d'intégration
            boolean success = demandeDAO.createDemande(currentUser.getId(), clubId);
            
            if (success) {
                session.setAttribute("successMessage", "Votre demande d'intégration au club \"" + club.getNom() + "\" a été envoyée avec succès ! Vous recevrez une réponse prochainement.");
            } else {
                session.setAttribute("errorMessage", "Une erreur est survenue lors de l'envoi de votre demande. Veuillez réessayer.");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID du club invalide.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Erreur lors de la création de la demande: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/membre/dashboard");
    }
}

