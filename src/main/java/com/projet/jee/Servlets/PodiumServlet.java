package com.projet.jee.Servlets;

import com.projet.jee.dao.EvenementDAO;
import com.projet.jee.dao.ParticipationDAO;
import com.projet.jee.dao.UtilisateurDAO;
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

@WebServlet(name = "PodiumServlet", urlPatterns = {"/federation/podium"})
public class PodiumServlet extends HttpServlet {
    private EvenementDAO evenementDAO = new EvenementDAO();
    private ParticipationDAO participationDAO = new ParticipationDAO();
    private UtilisateurDAO utilisateurDAO = new UtilisateurDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Utilisateur currentUser = (Utilisateur) session.getAttribute("currentUser");
        
        if (!"FEDERATION".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/jsp/auth/profile.jsp");
            return;
        }

        try {
            String evenementIdStr = request.getParameter("evenementId");
            if (evenementIdStr == null) {
                response.sendRedirect(request.getContextPath() + "/federation/dashboard");
                return;
            }

            Long evenementId = Long.parseLong(evenementIdStr);
            
            // Get the event
            Evenement evenement = evenementDAO.getEvenementById(evenementId);
            if (evenement == null) {
                session.setAttribute("errorMessage", "Événement introuvable");
                response.sendRedirect(request.getContextPath() + "/federation/dashboard");
                return;
            }

            // Only allow podium selection for TERMINE events
            if (!"TERMINE".equals(evenement.getStatut())) {
                session.setAttribute("errorMessage", "Le podium ne peut être défini que pour les événements terminés");
                response.sendRedirect(request.getContextPath() + "/federation/dashboard");
                return;
            }

            // Get all participants for this event
            List<Utilisateur> participants = participationDAO.getParticipantMembersByEvenement(evenementId);

            // Get current podium winners if already set
            Utilisateur premier = null;
            Utilisateur deuxieme = null;
            Utilisateur troisieme = null;

            if (evenement.getPremierId() != null) {
                premier = utilisateurDAO.findById(evenement.getPremierId());
            }
            if (evenement.getDeuxiemeId() != null) {
                deuxieme = utilisateurDAO.findById(evenement.getDeuxiemeId());
            }
            if (evenement.getTroisiemeId() != null) {
                troisieme = utilisateurDAO.findById(evenement.getTroisiemeId());
            }

            request.setAttribute("evenement", evenement);
            request.setAttribute("participants", participants);
            request.setAttribute("premier", premier);
            request.setAttribute("deuxieme", deuxieme);
            request.setAttribute("troisieme", troisieme);
            
            request.getRequestDispatcher("/jsp/podium-selection.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/federation/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Utilisateur currentUser = (Utilisateur) session.getAttribute("currentUser");
        
        if (!"FEDERATION".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/jsp/auth/profile.jsp");
            return;
        }

        try {
            String evenementIdStr = request.getParameter("evenementId");
            String premierIdStr = request.getParameter("premierId");
            String deuxiemeIdStr = request.getParameter("deuxiemeId");
            String troisiemeIdStr = request.getParameter("troisiemeId");
            
            if (evenementIdStr == null) {
                session.setAttribute("errorMessage", "Événement non spécifié");
                response.sendRedirect(request.getContextPath() + "/federation/dashboard");
                return;
            }

            Long evenementId = Long.parseLong(evenementIdStr);
            
            // Get the event
            Evenement evenement = evenementDAO.getEvenementById(evenementId);
            if (evenement == null || !"TERMINE".equals(evenement.getStatut())) {
                session.setAttribute("errorMessage", "Événement invalide");
                response.sendRedirect(request.getContextPath() + "/federation/dashboard");
                return;
            }

            // Parse podium IDs
            Long premierId = (premierIdStr != null && !premierIdStr.isEmpty()) ? Long.parseLong(premierIdStr) : null;
            Long deuxiemeId = (deuxiemeIdStr != null && !deuxiemeIdStr.isEmpty()) ? Long.parseLong(deuxiemeIdStr) : null;
            Long troisiemeId = (troisiemeIdStr != null && !troisiemeIdStr.isEmpty()) ? Long.parseLong(troisiemeIdStr) : null;

            // Validate that winners are different
            if (premierId != null && deuxiemeId != null && premierId.equals(deuxiemeId)) {
                session.setAttribute("errorMessage", "Les gagnants doivent être différents");
                response.sendRedirect(request.getContextPath() + "/federation/podium?evenementId=" + evenementId);
                return;
            }
            if (premierId != null && troisiemeId != null && premierId.equals(troisiemeId)) {
                session.setAttribute("errorMessage", "Les gagnants doivent être différents");
                response.sendRedirect(request.getContextPath() + "/federation/podium?evenementId=" + evenementId);
                return;
            }
            if (deuxiemeId != null && troisiemeId != null && deuxiemeId.equals(troisiemeId)) {
                session.setAttribute("errorMessage", "Les gagnants doivent être différents");
                response.sendRedirect(request.getContextPath() + "/federation/podium?evenementId=" + evenementId);
                return;
            }

            // Update podium
            boolean success = evenementDAO.updatePodium(evenementId, premierId, deuxiemeId, troisiemeId);
            
            if (success) {
                session.setAttribute("successMessage", "Podium mis à jour avec succès");
            } else {
                session.setAttribute("errorMessage", "Erreur lors de la mise à jour du podium");
            }
            
            response.sendRedirect(request.getContextPath() + "/federation/event-details?id=" + evenementId);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Erreur lors de la mise à jour: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/federation/dashboard");
        }
    }
}