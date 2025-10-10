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

@WebServlet(name = "CreerClubServlet", urlPatterns = {"/president/creer-club"})
public class CreerClubServlet extends HttpServlet {
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
            request.setCharacterEncoding("UTF-8");
            String nomClub = request.getParameter("nomClub");
            String description = request.getParameter("description");

            // Validation des données
            if (nomClub == null || nomClub.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Le nom du club est obligatoire.");
                response.sendRedirect(request.getContextPath() + "/president/dashboard");
                return;
            }

            // Vérifier si le président a déjà une demande en attente
            if (demandeDAO.hasPendingDemande(currentUser.getId())) {
                session.setAttribute("errorMessage", "Vous avez déjà une demande de création de club en attente. Veuillez attendre la réponse de la fédération.");
                response.sendRedirect(request.getContextPath() + "/president/dashboard");
                return;
            }

            // Créer la demande
            boolean success = demandeDAO.createDemande(nomClub.trim(), description != null ? description.trim() : "", currentUser.getId());
            
            if (success) {
                session.setAttribute("successMessage", "Votre demande de création du club \"" + nomClub + "\" a été envoyée avec succès à la fédération ! Vous recevrez une réponse prochainement.");
            } else {
                session.setAttribute("errorMessage", "Une erreur est survenue lors de l'envoi de votre demande. Veuillez réessayer.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Erreur lors de la création de la demande: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/president/dashboard");
    }
}

