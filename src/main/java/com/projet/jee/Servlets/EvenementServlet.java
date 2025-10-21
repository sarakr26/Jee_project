package com.projet.jee.Servlets;

import com.projet.jee.dao.EvenementDAO;
import com.projet.jee.model.Evenement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "EvenementServlet", urlPatterns = {"/events"})
public class EvenementServlet extends HttpServlet {
    private EvenementDAO dao = new EvenementDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // ensure request/response use UTF-8 so accented characters render correctly
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        
        String action = req.getParameter("action");
        
        try {
            if ("new".equals(action)) {
                // Show create event form
                req.getRequestDispatcher("/jsp/events/create.jsp").forward(req, resp);
                return;
            }
            
            // Default: show events list
            List<Evenement> list = dao.findAll();
            req.setAttribute("events", list);
            req.getRequestDispatcher("/jsp/events/list.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // ensure request body decoded using UTF-8
        req.setCharacterEncoding("UTF-8");
        // ensure response is encoded as UTF-8 when forwarding or redirecting
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        String titre = req.getParameter("titre");
        String description = req.getParameter("description");
        String lieu = req.getParameter("lieu");
        String dateDebut = req.getParameter("dateDebut");
        String dateFin = req.getParameter("dateFin");
        String statut = req.getParameter("statut");
        // Basic validation
        if (titre == null || titre.trim().isEmpty()) {
            req.setAttribute("error", "Le titre est requis.");
            req.getRequestDispatcher("/jsp/events/create.jsp").forward(req, resp);
            return;
        }

        Evenement e = new Evenement();
        e.setTitre(titre.trim());
        e.setDescription(description != null ? description.trim() : null);
        e.setLieu(lieu != null ? lieu.trim() : null);
        try {
            if (dateDebut != null && !dateDebut.isEmpty()) e.setDateDebut(Date.valueOf(dateDebut));
            if (dateFin != null && !dateFin.isEmpty()) e.setDateFin(Date.valueOf(dateFin));
        } catch (IllegalArgumentException ie) {
            req.setAttribute("error", "Format de date invalide.");
            req.getRequestDispatcher("/jsp/events/create.jsp").forward(req, resp);
            return;
        }
        e.setStatut(statut != null ? statut : "PLANIFIE");
        try {
            dao.create(e);
            // success: redirect to list with a success message via session attribute
            req.getSession().setAttribute("message", "Événement créé avec succès.");
            resp.sendRedirect(req.getContextPath() + "/events");
        } catch (Exception ex) {
            // log and forward a friendly error
            ex.printStackTrace();
            req.setAttribute("error", "Erreur lors de la création de l'événement: " + ex.getMessage());
            req.getRequestDispatcher("/jsp/events/create.jsp").forward(req, resp);
        }
    }
}
