package com.projet.jee.Servlets;

import com.projet.jee.dao.ClubDAO;
import com.projet.jee.dao.EvenementDAO;
import com.projet.jee.dao.DemandeCreationClubDAO;
import com.projet.jee.dao.NotificationDAO;
import com.projet.jee.model.Club;
import com.projet.jee.model.Evenement;
import com.projet.jee.model.DemandeCreationClub;
import com.projet.jee.model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "PresidentDashboardServlet", urlPatterns = { "/president/dashboard" })
public class PresidentDashboardServlet extends HttpServlet {
    private EvenementDAO evenementDAO = new EvenementDAO();
    private DemandeCreationClubDAO demandeDAO = new DemandeCreationClubDAO();
    private ClubDAO clubDAO = new ClubDAO();
    private NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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
            // Récupérer tous les événements planifiés
            List<Evenement> evenements = evenementDAO.getAllEvenementsPlanifies();
            request.setAttribute("evenements", evenements);

            // Récupérer les demandes du président
            List<DemandeCreationClub> demandes = demandeDAO.getDemandesByPresident(currentUser.getId());
            request.setAttribute("demandes", demandes);

            // Récupérer le club du président s'il existe
            Club club = clubDAO.getClubByPresidentId(currentUser.getId());
            request.setAttribute("club", club);

            // Si le club existe, récupérer le nombre de membres
            if (club != null) {
                List<Utilisateur> members = clubDAO.getMembersByClubId(club.getId());
                request.setAttribute("memberCount", members.size());
            }
            
            // Get unread notifications count for the president
            int unreadCount = notificationDAO.getUnreadCount(currentUser.getId());
            request.setAttribute("unreadCount", unreadCount);

            request.getRequestDispatcher("/jsp/president-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la récupération des données: " + e.getMessage());
            request.getRequestDispatcher("/jsp/president-dashboard.jsp").forward(request, response);
        }
    }
}
