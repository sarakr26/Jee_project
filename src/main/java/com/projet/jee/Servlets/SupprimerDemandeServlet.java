package com.projet.jee.Servlets;

import com.projet.jee.dao.DemandeCreationClubDAO;
import com.projet.jee.model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "SupprimerDemandeServlet", urlPatterns = {"/president/supprimer-demande"})
public class SupprimerDemandeServlet extends HttpServlet {
    private DemandeCreationClubDAO demandeDAO = new DemandeCreationClubDAO();

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
            response.sendRedirect(request.getContextPath() + "/jsp/auth/profile.jsp");
            return;
        }

        try {
            String demandeIdStr = request.getParameter("demandeId");
            
            if (demandeIdStr == null || demandeIdStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "ID de demande invalide.");
                response.sendRedirect(request.getContextPath() + "/president/dashboard");
                return;
            }

            Long demandeId = Long.parseLong(demandeIdStr);

            // Supprimer la demande (seulement si elle appartient au président et est EN_ATTENTE)
            boolean success = demandeDAO.deleteDemande(demandeId, currentUser.getId());

            if (success) {
                session.setAttribute("successMessage", "Votre demande a été supprimée avec succès.");
            } else {
                session.setAttribute("errorMessage", "Impossible de supprimer cette demande. Elle n'existe pas ou n'est plus en attente.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID de demande invalide.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Une erreur est survenue lors de la suppression: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/president/dashboard");
    }
}