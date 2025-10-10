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

@WebServlet(name = "RefuserDemandeServlet", urlPatterns = {"/president/refuser-demande"})
public class RefuserDemandeServlet extends HttpServlet {
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
        
        // Vérifier que l'utilisateur est bien un PRESIDENT
        if (!"PRESIDENT".equals(currentUser.getRole())) {
            session.setAttribute("errorMessage", "Vous n'avez pas les droits pour effectuer cette action.");
            response.sendRedirect(request.getContextPath() + "/president/dashboard");
            return;
        }

        try {
            // Vérifier que le président a bien un club
            Club presidentClub = clubDAO.getClubByPresidentId(currentUser.getId());
            if (presidentClub == null) {
                session.setAttribute("errorMessage", "Vous devez d'abord créer un club pour gérer les demandes d'intégration.");
                response.sendRedirect(request.getContextPath() + "/president/dashboard");
                return;
            }

            String demandeIdStr = request.getParameter("demandeId");
            if (demandeIdStr == null || demandeIdStr.isEmpty()) {
                session.setAttribute("errorMessage", "ID de demande invalide.");
                response.sendRedirect(request.getContextPath() + "/president/dashboard");
                return;
            }

            Long demandeId = Long.parseLong(demandeIdStr);
            
            // Refuser la demande
            boolean success = demandeDAO.refuserDemande(demandeId);
            
            if (success) {
                session.setAttribute("successMessage", "La demande a été refusée.");
            } else {
                session.setAttribute("errorMessage", "Impossible de refuser cette demande. Elle a peut-être déjà été traitée.");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID de demande invalide.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Erreur lors du refus de la demande: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/president/dashboard");
    }
}

