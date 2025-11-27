package com.projet.jee.Servlets;

import com.projet.jee.dao.ClubDAO;
import com.projet.jee.dao.MessageDAO;
import com.projet.jee.model.Club;
import com.projet.jee.model.Message;
import com.projet.jee.model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "MessageServlet", urlPatterns = { "/messages" })
public class MessageServlet extends HttpServlet {

    private MessageDAO messageDAO = new MessageDAO();
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
        String action = request.getParameter("action");
        if (action == null) {
            action = "inbox";
        }

        try {
            if ("sent".equals(action)) {
                List<Message> sent = messageDAO.getSent(currentUser.getId());
                request.setAttribute("messages", sent);
                request.getRequestDispatcher("/jsp/messages/sent.jsp").forward(request, response);
            } else if ("compose".equals(action)) {
                if ("FEDERATION".equals(currentUser.getRole())) {
                    // La fédération peut choisir un club
                    List<Club> clubs = clubDAO.getAllActiveClubs();
                    request.setAttribute("clubs", clubs);
                }
                request.getRequestDispatcher("/jsp/messages/compose.jsp").forward(request, response);
            } else {
                // Inbox par défaut
                List<Message> inbox = messageDAO.getInbox(currentUser.getId());
                request.setAttribute("messages", inbox);
                request.getRequestDispatcher("/jsp/messages/inbox.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
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
        String action = request.getParameter("action");
        if (action == null) {
            action = "send";
        }

        if ("send".equals(action)) {
            String sujet = request.getParameter("sujet");
            String contenu = request.getParameter("contenu");
            String clubIdParam = request.getParameter("clubId");

            try {
                Long clubId = null;

                if ("PRESIDENT".equals(currentUser.getRole())) {
                    // le président envoie au club qu'il dirige
                    Club club = clubDAO.getClubByPresidentId(currentUser.getId());
                    if (club != null) {
                        clubId = club.getId();
                    }
                } else if ("FEDERATION".equals(currentUser.getRole()) && clubIdParam != null && !clubIdParam.isEmpty()) {
                    clubId = Long.parseLong(clubIdParam);
                }

                if (clubId != null && sujet != null && !sujet.trim().isEmpty()
                        && contenu != null && !contenu.trim().isEmpty()) {
                    messageDAO.envoyerMessageAuClub(currentUser.getId(), clubId, sujet.trim(), contenu.trim());
                }

                response.sendRedirect(request.getContextPath() + "/messages?action=sent");
            } catch (Exception e) {
                throw new ServletException(e);
            }
        } else {
            doGet(request, response);
        }
    }
}



