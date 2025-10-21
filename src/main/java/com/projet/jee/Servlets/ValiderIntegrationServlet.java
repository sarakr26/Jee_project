package com.projet.jee.Servlets;

import com.projet.jee.dao.ClubDAO;
import com.projet.jee.dao.DemandeIntegrationDAO;
import com.projet.jee.dao.UtilisateurDAO;
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

@WebServlet(name = "ValiderIntegrationServlet", urlPatterns = {"/president/valider-integration"})
public class ValiderIntegrationServlet extends HttpServlet {
    private DemandeIntegrationDAO demandeIntegrationDAO = new DemandeIntegrationDAO();
    private UtilisateurDAO utilisateurDAO = new UtilisateurDAO();
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

        // Vérifier que l'utilisateur est bien un PRESIDENT
        if (!"PRESIDENT".equals(currentUser.getRole())) {
            session.setAttribute("errorMessage", "Accès refusé");
            response.sendRedirect(request.getContextPath() + "/president/dashboard");
            return;
        }

        try {
            Long demandeId = Long.parseLong(request.getParameter("demandeId"));
            String action = request.getParameter("action");

            // Récupérer la demande
            DemandeIntegration demande = demandeIntegrationDAO.getDemandeById(demandeId);
            
            if (demande == null) {
                session.setAttribute("errorMessage", "Demande introuvable");
                response.sendRedirect(request.getContextPath() + "/president/gerer-membres");
                return;
            }

            // Vérifier que la demande concerne bien le club du président
            Club club = clubDAO.getClubByPresidentId(currentUser.getId());
            if (club == null || !club.getId().equals(demande.getClubId())) {
                session.setAttribute("errorMessage", "Vous ne pouvez pas valider cette demande");
                response.sendRedirect(request.getContextPath() + "/president/gerer-membres");
                return;
            }

            boolean success = false;
            String message = "";

            if ("ACCEPTEE".equals(action)) {
                // Valider la demande
                success = demandeIntegrationDAO.validerDemande(demandeId);
                if (success) {
                    // Mettre à jour le club_id du membre
                    boolean userUpdated = utilisateurDAO.updateUserClub(demande.getMembreId(), demande.getClubId());
                    if (userUpdated) {
                        message = "Demande acceptée avec succès. Le membre a été ajouté au club.";
                    } else {
                        message = "Demande acceptée mais erreur lors de l'ajout du membre au club";
                    }
                } else {
                    message = "Erreur lors de l'acceptation de la demande";
                }
            } else if ("REFUSEE".equals(action)) {
                success = demandeIntegrationDAO.refuserDemande(demandeId);
                message = success ? "Demande refusée" : "Erreur lors du refus de la demande";
            }

            if (success) {
                session.setAttribute("successMessage", message);
            } else {
                session.setAttribute("errorMessage", message);
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Erreur: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/president/gerer-membres");
    }
}
