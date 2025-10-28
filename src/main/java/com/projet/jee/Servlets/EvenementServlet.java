package com.projet.jee.Servlets;

import com.projet.jee.dao.EvenementDAO;
import com.projet.jee.dao.NotificationDAO;
import com.projet.jee.dao.UtilisateurDAO;
import com.projet.jee.model.Evenement;
import com.projet.jee.model.Utilisateur;

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
    private NotificationDAO notificationDAO = new NotificationDAO();
    private UtilisateurDAO utilisateurDAO = new UtilisateurDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // ensure request/response use UTF-8 so accented characters render correctly
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        
        String action = req.getParameter("action");
        String idParam = req.getParameter("id");
        
        try {
            if ("new".equals(action)) {
                // Show create event form
                req.getRequestDispatcher("/jsp/events/create.jsp").forward(req, resp);
                return;
            }
            
            if ("edit".equals(action) && idParam != null) {
                // Show edit event form
                Long id = Long.parseLong(idParam);
                Evenement evenement = dao.findById(id);
                if (evenement != null) {
                    req.setAttribute("evenement", evenement);
                    req.getRequestDispatcher("/jsp/events/edit.jsp").forward(req, resp);
                } else {
                    req.setAttribute("error", "Événement non trouvé.");
                    req.getRequestDispatcher("/jsp/events/list.jsp").forward(req, resp);
                }
                return;
            }
            
            if ("delete".equals(action) && idParam != null) {
                // Delete event
                Long id = Long.parseLong(idParam);
                boolean deleted = dao.delete(id);
                if (deleted) {
                    req.getSession().setAttribute("message", "Événement supprimé avec succès.");
                } else {
                    req.getSession().setAttribute("error", "Erreur lors de la suppression de l'événement.");
                }
                resp.sendRedirect(req.getContextPath() + "/events");
                return;
            }
            
            if ("inscriptions".equals(action) && idParam != null) {
                // Show inscriptions for event
                Long id = Long.parseLong(idParam);
                Evenement evenement = dao.findById(id);
                if (evenement != null) {
                    List<String> participants = dao.getParticipants(id);
                    int nbParticipants = dao.countParticipants(id);
                    
                    req.setAttribute("evenement", evenement);
                    req.setAttribute("participants", participants);
                    req.setAttribute("nbParticipants", nbParticipants);
                    req.getRequestDispatcher("/jsp/events/inscriptions.jsp").forward(req, resp);
                } else {
                    req.setAttribute("error", "Événement non trouvé.");
                    req.getRequestDispatcher("/jsp/events/list.jsp").forward(req, resp);
                }
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
        
        String action = req.getParameter("action");
        String idParam = req.getParameter("id");
        String titre = req.getParameter("titre");
        String description = req.getParameter("description");
        String lieu = req.getParameter("lieu");
        String dateDebut = req.getParameter("dateDebut");
        String dateFin = req.getParameter("dateFin");
        String statut = req.getParameter("statut");
        
        // Basic validation
        if (titre == null || titre.trim().isEmpty()) {
            req.setAttribute("error", "Le titre est requis.");
            String forwardPage = "edit".equals(action) ? "/jsp/events/edit.jsp" : "/jsp/events/create.jsp";
            req.getRequestDispatcher(forwardPage).forward(req, resp);
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
            String forwardPage = "edit".equals(action) ? "/jsp/events/edit.jsp" : "/jsp/events/create.jsp";
            req.getRequestDispatcher(forwardPage).forward(req, resp);
            return;
        }
        
        e.setStatut(statut != null ? statut : "PLANIFIE");
        
        try {
            if ("edit".equals(action) && idParam != null) {
                // Update existing event
                Long id = Long.parseLong(idParam);
                e.setId(id);
                dao.update(e);
                req.getSession().setAttribute("message", "Événement modifié avec succès.");
            } else {
                // Create new event
                dao.create(e);
                req.getSession().setAttribute("message", "Événement créé avec succès.");
                
                // Create notifications for all members about the new event
                try {
                    List<Utilisateur> members = utilisateurDAO.getAllMembers();
                    String message = "Un nouvel événement a été ajouté : \"" + e.getTitre() + "\" - " + 
                                     (e.getDateDebut() != null ? e.getDateDebut().toString() : "");
                    
                    for (Utilisateur member : members) {
                        try {
                            notificationDAO.createNotification(member.getId(), message, "EVENT_ADDED");
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }
                    }
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            resp.sendRedirect(req.getContextPath() + "/events");
        } catch (Exception ex) {
            // log and forward a friendly error
            ex.printStackTrace();
            String errorMessage = "edit".equals(action) ? 
                "Erreur lors de la modification de l'événement: " + ex.getMessage() :
                "Erreur lors de la création de l'événement: " + ex.getMessage();
            req.setAttribute("error", errorMessage);
            
            String forwardPage = "edit".equals(action) ? "/jsp/events/edit.jsp" : "/jsp/events/create.jsp";
            req.getRequestDispatcher(forwardPage).forward(req, resp);
        }
    }
}
