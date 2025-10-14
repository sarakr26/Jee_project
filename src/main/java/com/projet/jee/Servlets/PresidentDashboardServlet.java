package com.projet.jee.Servlets;

import com.projet.jee.dao.DemandeIntegrationDAO;
import com.projet.jee.dao.UtilisateurDAO;
import com.projet.jee.model.DemandeIntegration;
import com.projet.jee.model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/president/dashboard")
public class PresidentDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        // On récupère l'utilisateur avec le nom "currentUser"
        Utilisateur user = (Utilisateur) session.getAttribute("currentUser");

        if (user == null || !"PRESIDENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
            return;
        }

        Long clubId = user.getClubId();
        if (clubId == null) {
            response.getWriter().println("Erreur : Le président n'est associé à aucun club.");
            return;
        }

        UtilisateurDAO utilisateurDAO = new UtilisateurDAO();
        DemandeIntegrationDAO demandeDAO = new DemandeIntegrationDAO();

        List<Utilisateur> membres = utilisateurDAO.findByClubId(clubId);
        List<DemandeIntegration> demandes = demandeDAO.findByClubId(clubId);

        request.setAttribute("membres", membres);
        request.setAttribute("demandes", demandes);

        request.getRequestDispatcher("/jsp/president/gestion_membres.jsp").forward(request, response);
    }
}