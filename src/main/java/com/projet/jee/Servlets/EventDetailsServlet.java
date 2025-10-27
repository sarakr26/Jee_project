package com.projet.jee.Servlets;

import com.projet.jee.dao.EvenementDAO;
import com.projet.jee.dao.ParticipationDAO;
import com.projet.jee.model.Evenement;
import com.projet.jee.model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "EventDetailsServlet", urlPatterns = { "/federation/event-details" })
public class EventDetailsServlet extends HttpServlet {
    private EvenementDAO evenementDAO = new EvenementDAO();
    private ParticipationDAO participationDAO = new ParticipationDAO();

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
            String evenementIdStr = request.getParameter("id");
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

            // Get participants with their club information
            List<Utilisateur> participants = participationDAO.getParticipantMembersByEvenement(evenementId);
            
            // Group participants by club
            Map<String, List<Utilisateur>> participantsByClub = new HashMap<>();
            for (Utilisateur participant : participants) {
                String clubName = getClubName(participant.getClubId());
                if (!participantsByClub.containsKey(clubName)) {
                    participantsByClub.put(clubName, new java.util.ArrayList<>());
                }
                participantsByClub.get(clubName).add(participant);
            }

            request.setAttribute("evenement", evenement);
            request.setAttribute("participants", participants);
            request.setAttribute("participantsByClub", participantsByClub);
            request.setAttribute("totalParticipants", participants.size());
            request.setAttribute("totalClubs", participantsByClub.size());
            
            request.getRequestDispatcher("/jsp/event-details.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/federation/dashboard");
        }
    }

    private String getClubName(Long clubId) {
        if (clubId == null) {
            return "Sans Club";
        }
        try {
            com.projet.jee.dao.ClubDAO clubDAO = new com.projet.jee.dao.ClubDAO();
            com.projet.jee.model.Club club = clubDAO.getClubById(clubId);
            return club != null ? club.getNom() : "Club #" + clubId;
        } catch (SQLException e) {
            return "Club #" + clubId;
        }
    }
}