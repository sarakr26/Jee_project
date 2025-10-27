package com.projet.jee.Servlets;

import com.projet.jee.dao.ClubDAO;
import com.projet.jee.dao.EvenementDAO;
import com.projet.jee.dao.ParticipationDAO;
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
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "SelectRepresentativesServlet", urlPatterns = { "/president/select-representatives" })
public class SelectRepresentativesServlet extends HttpServlet {
    private ClubDAO clubDAO = new ClubDAO();
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

        if (!"PRESIDENT".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/jsp/auth/profile.jsp");
            return;
        }

        try {
            String evenementIdStr = request.getParameter("evenementId");
            if (evenementIdStr == null) {
                response.sendRedirect(request.getContextPath() + "/president/dashboard");
                return;
            }

            Long evenementId = Long.parseLong(evenementIdStr);

            // Get the event
            Evenement evenement = evenementDAO.getEvenementById(evenementId);
            if (evenement == null) {
                session.setAttribute("errorMessage", "Événement introuvable");
                response.sendRedirect(request.getContextPath() + "/president/dashboard");
                return;
            }

            // Check if event is less than 2 days away
            LocalDate today = LocalDate.now();
            LocalDate eventDate = evenement.getDateDebut().toLocalDate();
            long daysUntilEvent = ChronoUnit.DAYS.between(today, eventDate);

            if (daysUntilEvent < 2) {
                session.setAttribute("errorMessage",
                        "Vous ne pouvez plus sélectionner de représentants. L'événement commence dans moins de 2 jours.");
                response.sendRedirect(request.getContextPath() + "/president/dashboard");
                return;
            }

            // Get president's club
            Club club = clubDAO.getClubByPresidentId(currentUser.getId());
            if (club == null) {
                session.setAttribute("errorMessage",
                        "Vous devez avoir un club actif pour sélectionner des représentants");
                response.sendRedirect(request.getContextPath() + "/president/dashboard");
                return;
            }

            // Get club members
            List<Utilisateur> members = clubDAO.getMembersByClubId(club.getId());

            // Get already selected participants
            List<Utilisateur> selectedMembers = participationDAO.getParticipantMembersByEvenement(evenementId);
            List<Long> selectedIds = new ArrayList<>();
            for (Utilisateur u : selectedMembers) {
                if (u.getClubId() != null && u.getClubId().equals(club.getId())) {
                    selectedIds.add(u.getId());
                }
            }

            request.setAttribute("evenement", evenement);
            request.setAttribute("club", club);
            request.setAttribute("members", members);
            request.setAttribute("selectedIds", selectedIds);

            request.getRequestDispatcher("/jsp/select-representatives.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/president/dashboard");
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

        if (!"PRESIDENT".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/jsp/auth/profile.jsp");
            return;
        }

        try {
            String evenementIdStr = request.getParameter("evenementId");
            String[] selectedMemberIds = request.getParameterValues("memberIds");

            if (evenementIdStr == null) {
                session.setAttribute("errorMessage", "Événement non spécifié");
                response.sendRedirect(request.getContextPath() + "/president/dashboard");
                return;
            }

            Long evenementId = Long.parseLong(evenementIdStr);

            // Get the event and check deadline
            Evenement evenement = evenementDAO.getEvenementById(evenementId);
            if (evenement == null) {
                session.setAttribute("errorMessage", "Événement introuvable");
                response.sendRedirect(request.getContextPath() + "/president/dashboard");
                return;
            }

            // Check if event is less than 2 days away
            LocalDate today = LocalDate.now();
            LocalDate eventDate = evenement.getDateDebut().toLocalDate();
            long daysUntilEvent = ChronoUnit.DAYS.between(today, eventDate);

            if (daysUntilEvent < 2) {
                session.setAttribute("errorMessage",
                        "Vous ne pouvez plus modifier la sélection. L'événement commence dans moins de 2 jours.");
                response.sendRedirect(request.getContextPath() + "/president/dashboard");
                return;
            }

            // Get president's club
            Club club = clubDAO.getClubByPresidentId(currentUser.getId());
            if (club == null) {
                session.setAttribute("errorMessage", "Vous devez avoir un club actif");
                response.sendRedirect(request.getContextPath() + "/president/dashboard");
                return;
            }

            // Validate selection (max 2 representatives)
            if (selectedMemberIds != null && selectedMemberIds.length > 2) {
                session.setAttribute("errorMessage", "Vous ne pouvez sélectionner que 2 représentants maximum");
                response.sendRedirect(
                        request.getContextPath() + "/president/select-representatives?evenementId=" + evenementId);
                return;
            }

            // Remove existing participants from this club for this event
            List<Utilisateur> existingParticipants = participationDAO.getParticipantMembersByEvenement(evenementId);
            for (Utilisateur u : existingParticipants) {
                if (u.getClubId() != null && u.getClubId().equals(club.getId())) {
                    participationDAO.removeParticipant(u.getId(), evenementId);
                }
            }

            // Add new participants
            if (selectedMemberIds != null && selectedMemberIds.length > 0) {
                List<Long> memberIds = new ArrayList<>();
                for (String idStr : selectedMemberIds) {
                    Long memberId = Long.parseLong(idStr);

                    // Verify member belongs to president's club
                    List<Utilisateur> clubMembers = clubDAO.getMembersByClubId(club.getId());
                    boolean isValid = false;
                    for (Utilisateur m : clubMembers) {
                        if (m.getId().equals(memberId)) {
                            isValid = true;
                            break;
                        }
                    }

                    if (isValid) {
                        memberIds.add(memberId);
                    }
                }

                if (!memberIds.isEmpty()) {
                    participationDAO.addParticipants(evenementId, memberIds);
                    session.setAttribute("successMessage",
                            "Représentants sélectionnés avec succès (" + memberIds.size() + " membre(s))");
                } else {
                    session.setAttribute("successMessage", "Aucun représentant sélectionné");
                }
            } else {
                session.setAttribute("successMessage", "Aucun représentant sélectionné");
            }

            response.sendRedirect(request.getContextPath() + "/president/dashboard");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Erreur lors de la sélection: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/president/dashboard");
        }
    }
}