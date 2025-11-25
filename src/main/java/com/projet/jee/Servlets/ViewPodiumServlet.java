package com.projet.jee.Servlets;

import com.projet.jee.dao.ClubDAO;
import com.projet.jee.dao.EvenementDAO;
import com.projet.jee.dao.UtilisateurDAO;
import com.projet.jee.model.Club;
import com.projet.jee.model.Evenement;
import com.projet.jee.model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ViewPodiumServlet", urlPatterns = {"/view-podium"})
public class ViewPodiumServlet extends HttpServlet {
    private EvenementDAO evenementDAO = new EvenementDAO();
    private UtilisateurDAO utilisateurDAO = new UtilisateurDAO();
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
        
        if (!"PRESIDENT".equals(currentUser.getRole()) && !"FEDERATION".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/jsp/auth/profile.jsp");
            return;
        }

        try {
            String evenementIdStr = request.getParameter("evenementId");
            if (evenementIdStr == null) {
                response.sendRedirect(request.getContextPath() + 
                    ("PRESIDENT".equals(currentUser.getRole()) ? "/president/dashboard" : "/federation/dashboard"));
                return;
            }

            Long evenementId = Long.parseLong(evenementIdStr);
            
            // Get the event
            Evenement evenement = evenementDAO.getEvenementById(evenementId);
            if (evenement == null) {
                session.setAttribute("errorMessage", "Événement introuvable");
                response.sendRedirect(request.getContextPath() + 
                    ("PRESIDENT".equals(currentUser.getRole()) ? "/president/dashboard" : "/federation/dashboard"));
                return;
            }

            // Only show podium for TERMINE events
            if (!"TERMINE".equals(evenement.getStatut())) {
                session.setAttribute("errorMessage", "Le podium n'est pas encore disponible pour cet événement");
                response.sendRedirect(request.getContextPath() + 
                    ("PRESIDENT".equals(currentUser.getRole()) ? "/president/dashboard" : "/federation/dashboard"));
                return;
            }

            // Get podium winners with their clubs
            Utilisateur premier = null;
            Utilisateur deuxieme = null;
            Utilisateur troisieme = null;
            Club clubPremier = null;
            Club clubDeuxieme = null;
            Club clubTroisieme = null;

            if (evenement.getPremierId() != null) {
                premier = utilisateurDAO.findById(evenement.getPremierId());
                if (premier != null && premier.getClubId() != null) {
                    clubPremier = clubDAO.getClubById(premier.getClubId());
                }
            }
            if (evenement.getDeuxiemeId() != null) {
                deuxieme = utilisateurDAO.findById(evenement.getDeuxiemeId());
                if (deuxieme != null && deuxieme.getClubId() != null) {
                    clubDeuxieme = clubDAO.getClubById(deuxieme.getClubId());
                }
            }
            if (evenement.getTroisiemeId() != null) {
                troisieme = utilisateurDAO.findById(evenement.getTroisiemeId());
                if (troisieme != null && troisieme.getClubId() != null) {
                    clubTroisieme = clubDAO.getClubById(troisieme.getClubId());
                }
            }

            request.setAttribute("evenement", evenement);
            request.setAttribute("premier", premier);
            request.setAttribute("deuxieme", deuxieme);
            request.setAttribute("troisieme", troisieme);
            request.setAttribute("clubPremier", clubPremier);
            request.setAttribute("clubDeuxieme", clubDeuxieme);
            request.setAttribute("clubTroisieme", clubTroisieme);
            
            request.getRequestDispatcher("/jsp/podium.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + 
                ("PRESIDENT".equals(currentUser.getRole()) ? "/president/dashboard" : "/federation/dashboard"));
        }
    }
}
