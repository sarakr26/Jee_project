package com.projet.jee.Servlets;

import com.projet.jee.dao.EvenementDAO;
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

@WebServlet(name = "CreateEvenementServlet", urlPatterns = {"/events/create"})
public class CreateEvenementServlet extends HttpServlet {
    private EvenementDAO dao = new EvenementDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        
        // Vérifier que l'utilisateur est connecté et est FEDERATION
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        Utilisateur currentUser = (Utilisateur) session.getAttribute("currentUser");
        if (!"FEDERATION".equals(currentUser.getRole())) {
            req.setAttribute("error", "Seuls les utilisateurs de la fédération peuvent créer des événements.");
            req.getRequestDispatcher("/jsp/events/create.jsp").forward(req, resp);
            return;
        }
        
        req.getRequestDispatcher("/jsp/events/create.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        
        // Vérifier que l'utilisateur est connecté et est FEDERATION
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        Utilisateur currentUser = (Utilisateur) session.getAttribute("currentUser");
        if (!"FEDERATION".equals(currentUser.getRole())) {
            req.setAttribute("error", "Seuls les utilisateurs de la fédération peuvent créer des événements.");
            req.getRequestDispatcher("/jsp/events/create.jsp").forward(req, resp);
            return;
        }
        
        String titre = req.getParameter("titre");
        String description = req.getParameter("description");
        String lieu = req.getParameter("lieu");
        String dateDebut = req.getParameter("dateDebut");
        String dateFin = req.getParameter("dateFin");
        String statut = req.getParameter("statut");
        
        // Validation
        if (titre == null || titre.trim().isEmpty()) {
            req.setAttribute("error", "Le titre est requis.");
            req.getRequestDispatcher("/jsp/events/create.jsp").forward(req, resp);
            return;
        }

        Evenement e = new Evenement();
        e.setTitre(titre.trim());
        e.setDescription(description != null ? description.trim() : null);
        e.setLieu(lieu != null ? lieu.trim() : null);
        e.setFederationId(currentUser.getId()); // CORRECTION : Utiliser l'ID de l'utilisateur connecté
        
        try {
            if (dateDebut != null && !dateDebut.isEmpty()) {
                e.setDateDebut(Date.valueOf(dateDebut));
            }
            if (dateFin != null && !dateFin.isEmpty()) {
                e.setDateFin(Date.valueOf(dateFin));
            }
        } catch (IllegalArgumentException ie) {
            req.setAttribute("error", "Format de date invalide.");
            req.getRequestDispatcher("/jsp/events/create.jsp").forward(req, resp);
            return;
        }
        
        e.setStatut(statut != null ? statut : "PLANIFIE");

        try {
            dao.create(e);
            session.setAttribute("successMessage", "Événement créé avec succès.");
            resp.sendRedirect(req.getContextPath() + "/events");
        } catch (Exception ex) {
            ex.printStackTrace();
            req.setAttribute("error", "Erreur lors de la création de l'événement: " + ex.getMessage());
            req.getRequestDispatcher("/jsp/events/create.jsp").forward(req, resp);
        }
    }
}

