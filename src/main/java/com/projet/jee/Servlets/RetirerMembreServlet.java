package com.projet.jee.Servlets;

import com.projet.jee.dao.ClubDAO;
import com.projet.jee.dao.UtilisateurDAO;
import com.projet.jee.model.Club;
import com.projet.jee.model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "RetirerMembreServlet", urlPatterns = {"/president/retirer-membre"})
public class RetirerMembreServlet extends HttpServlet {
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
            Long membreId = Long.parseLong(request.getParameter("membreId"));

            // Vérifier que le président ne se retire pas lui-même
            if (membreId.equals(currentUser.getId())) {
                session.setAttribute("errorMessage", "Vous ne pouvez pas vous retirer vous-même du club");
                response.sendRedirect(request.getContextPath() + "/president/gerer-membres");
                return;
            }

            // Récupérer le club du président
            Club club = clubDAO.getClubByPresidentId(currentUser.getId());
            if (club == null) {
                session.setAttribute("errorMessage", "Vous devez avoir un club pour retirer des membres");
                response.sendRedirect(request.getContextPath() + "/president/dashboard");
                return;
            }

            // Récupérer le membre à retirer
            Utilisateur membre = utilisateurDAO.findById(membreId);
            if (membre == null) {
                session.setAttribute("errorMessage", "Membre introuvable");
                response.sendRedirect(request.getContextPath() + "/president/gerer-membres");
                return;
            }

            // Vérifier que le membre appartient bien au club du président
            if (membre.getClubId() == null || !membre.getClubId().equals(club.getId())) {
                session.setAttribute("errorMessage", "Ce membre n'appartient pas à votre club");
                response.sendRedirect(request.getContextPath() + "/president/gerer-membres");
                return;
            }

            // Retirer le membre du club (mettre club_id à null)
            boolean success = utilisateurDAO.updateUserClub(membreId, null);

            if (success) {
                session.setAttribute("successMessage", 
                    membre.getPrenom() + " " + membre.getNom() + " a été retiré du club avec succès");
            } else {
                session.setAttribute("errorMessage", "Erreur lors du retrait du membre");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Erreur: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/president/gerer-membres");
    }
}