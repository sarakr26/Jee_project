package com.projet.jee.Servlets;

import com.projet.jee.dao.ClubDAO;
import com.projet.jee.dao.EvenementDAO;
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
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "MapsServlet", urlPatterns = { "/maps" })
public class MapsServlet extends HttpServlet {
    private ClubDAO clubDAO = new ClubDAO();
    private EvenementDAO evenementDAO = new EvenementDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String view = request.getParameter("view");

        try {
            if ("events".equals(view)) {
                // Vue carte des événements
                List<Evenement> events = evenementDAO.getAllEvenementsPlanifies();
                request.setAttribute("events", events);
                request.setAttribute("viewType", "events");
                request.getRequestDispatcher("/jsp/maps.jsp").forward(request, response);
            } else if ("club".equals(view)) {
                // Vue carte d'un club spécifique
                String clubIdParam = request.getParameter("id");
                if (clubIdParam != null) {
                    Long clubId = Long.parseLong(clubIdParam);
                    Club club = clubDAO.getClubById(clubId);
                    if (club != null) {
                        request.setAttribute("club", club);
                        request.setAttribute("viewType", "singleClub");
                        request.getRequestDispatcher("/jsp/maps.jsp").forward(request, response);
                        return;
                    }
                }
                // Si club non trouvé, afficher tous les clubs
                List<Club> clubs = clubDAO.getAllActiveClubs();
                request.setAttribute("clubs", clubs);
                request.setAttribute("viewType", "clubs");
                request.getRequestDispatcher("/jsp/maps.jsp").forward(request, response);
            } else {
                // Vue par défaut : carte de tous les clubs actifs
                List<Club> clubs = clubDAO.getAllActiveClubs();
                request.setAttribute("clubs", clubs);
                request.setAttribute("viewType", "clubs");
                request.getRequestDispatcher("/jsp/maps.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la récupération des données: " + e.getMessage());
            request.getRequestDispatcher("/jsp/maps.jsp").forward(request, response);
        }
    }
}

