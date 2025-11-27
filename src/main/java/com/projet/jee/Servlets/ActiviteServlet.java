package com.projet.jee.Servlets;

import com.projet.jee.dao.ActiviteDAO;
import com.projet.jee.dao.PlanningDAO;
import com.projet.jee.dao.ClubDAO;
import com.projet.jee.model.Activite;
import com.projet.jee.model.Club;
import com.projet.jee.model.Planning;
import com.projet.jee.model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;

@WebServlet(name = "ActiviteServlet", urlPatterns = { "/planning/activite" })
public class ActiviteServlet extends HttpServlet {
    private ActiviteDAO activiteDAO = new ActiviteDAO();
    private PlanningDAO planningDAO = new PlanningDAO();
    private ClubDAO clubDAO = new ClubDAO();

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

        Utilisateur currentUser = (Utilisateur) session.getAttribute("currentUser");
        
        // Seuls les présidents peuvent gérer les activités
        if (!"PRESIDENT".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/planning");
            return;
        }

        try {
            String action = request.getParameter("action");
            String idParam = request.getParameter("id");
            
            // Récupérer le club et le planning du président
            Club club = clubDAO.getClubByPresidentId(currentUser.getId());
            if (club == null) {
                request.setAttribute("error", "Vous devez avoir un club actif.");
                response.sendRedirect(request.getContextPath() + "/president/dashboard");
                return;
            }

            Planning planning = planningDAO.getPlanningByClubId(club.getId());
            if (planning == null) {
                planning = planningDAO.createPlanningForClub(club.getId());
            }

            if ("new".equals(action)) {
                // Afficher le formulaire de création
                request.setAttribute("club", club);
                request.setAttribute("planning", planning);
                request.getRequestDispatcher("/jsp/planning/create-activite.jsp").forward(request, response);
                return;
            }

            if ("edit".equals(action) && idParam != null) {
                // Afficher le formulaire d'édition
                Long id = Long.parseLong(idParam);
                Activite activite = activiteDAO.getActiviteById(id);
                
                // Vérifier que l'activité appartient au planning du président
                if (activite != null && activite.getPlanningId().equals(planning.getId())) {
                    request.setAttribute("activite", activite);
                    request.setAttribute("club", club);
                    request.setAttribute("planning", planning);
                    request.getRequestDispatcher("/jsp/planning/edit-activite.jsp").forward(request, response);
                } else {
                    request.getSession().setAttribute("error", "Activité non trouvée ou accès non autorisé.");
                    response.sendRedirect(request.getContextPath() + "/planning");
                }
                return;
            }

            if ("delete".equals(action) && idParam != null) {
                // Supprimer l'activité
                Long id = Long.parseLong(idParam);
                Activite activite = activiteDAO.getActiviteById(id);
                
                // Vérifier que l'activité appartient au planning du président
                if (activite != null && activite.getPlanningId().equals(planning.getId())) {
                    boolean deleted = activiteDAO.delete(id);
                    if (deleted) {
                        request.getSession().setAttribute("message", "Activité supprimée avec succès.");
                    } else {
                        request.getSession().setAttribute("error", "Erreur lors de la suppression.");
                    }
                } else {
                    request.getSession().setAttribute("error", "Activité non trouvée ou accès non autorisé.");
                }
                response.sendRedirect(request.getContextPath() + "/planning");
                return;
            }

            // Par défaut, rediriger vers le planning
            response.sendRedirect(request.getContextPath() + "/planning");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/planning");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Utilisateur currentUser = (Utilisateur) session.getAttribute("currentUser");
        
        // Seuls les présidents peuvent créer/modifier des activités
        if (!"PRESIDENT".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/planning");
            return;
        }

        try {
            String action = request.getParameter("action");
            String idParam = request.getParameter("id");

            // Récupérer le planning
            Club club = clubDAO.getClubByPresidentId(currentUser.getId());
            if (club == null) {
                request.getSession().setAttribute("error", "Vous devez avoir un club actif.");
                response.sendRedirect(request.getContextPath() + "/president/dashboard");
                return;
            }

            Planning planning = planningDAO.getPlanningByClubId(club.getId());
            if (planning == null) {
                planning = planningDAO.createPlanningForClub(club.getId());
            }

            String titre = request.getParameter("titre");
            String type = request.getParameter("type");
            String dateDebutStr = request.getParameter("dateDebut");
            String dateFinStr = request.getParameter("dateFin");

            // Validation
            if (titre == null || titre.trim().isEmpty()) {
                request.setAttribute("error", "Le titre est requis.");
                request.setAttribute("club", club);
                request.setAttribute("planning", planning);
                if ("edit".equals(action)) {
                    request.getRequestDispatcher("/jsp/planning/edit-activite.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("/jsp/planning/create-activite.jsp").forward(request, response);
                }
                return;
            }

            // Convertir les dates
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            Timestamp dateDebut = null;
            Timestamp dateFin = null;

            try {
                if (dateDebutStr != null && !dateDebutStr.isEmpty()) {
                    dateDebut = new Timestamp(sdf.parse(dateDebutStr).getTime());
                }
                if (dateFinStr != null && !dateFinStr.isEmpty()) {
                    dateFin = new Timestamp(sdf.parse(dateFinStr).getTime());
                }
            } catch (ParseException e) {
                request.setAttribute("error", "Format de date invalide. Format attendu: YYYY-MM-DDTHH:MM");
                request.setAttribute("club", club);
                request.setAttribute("planning", planning);
                if ("edit".equals(action)) {
                    request.getRequestDispatcher("/jsp/planning/edit-activite.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("/jsp/planning/create-activite.jsp").forward(request, response);
                }
                return;
            }

            if (dateDebut == null || dateFin == null) {
                request.setAttribute("error", "Les dates de début et fin sont requises.");
                request.setAttribute("club", club);
                request.setAttribute("planning", planning);
                if ("edit".equals(action)) {
                    request.getRequestDispatcher("/jsp/planning/edit-activite.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("/jsp/planning/create-activite.jsp").forward(request, response);
                }
                return;
            }

            if (dateFin.before(dateDebut)) {
                request.setAttribute("error", "La date de fin doit être après la date de début.");
                request.setAttribute("club", club);
                request.setAttribute("planning", planning);
                if ("edit".equals(action)) {
                    request.getRequestDispatcher("/jsp/planning/edit-activite.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("/jsp/planning/create-activite.jsp").forward(request, response);
                }
                return;
            }

            if ("edit".equals(action) && idParam != null) {
                // Modification
                Long id = Long.parseLong(idParam);
                Activite existingActivite = activiteDAO.getActiviteById(id);
                
                if (existingActivite != null && existingActivite.getPlanningId().equals(planning.getId())) {
                    existingActivite.setTitre(titre.trim());
                    existingActivite.setType(type != null ? type.trim() : null);
                    existingActivite.setDateDebut(dateDebut);
                    existingActivite.setDateFin(dateFin);
                    
                    boolean updated = activiteDAO.update(existingActivite);
                    if (updated) {
                        request.getSession().setAttribute("message", "Activité modifiée avec succès.");
                    } else {
                        request.getSession().setAttribute("error", "Erreur lors de la modification.");
                    }
                } else {
                    request.getSession().setAttribute("error", "Activité non trouvée ou accès non autorisé.");
                }
            } else {
                // Création
                Activite activite = new Activite();
                activite.setTitre(titre.trim());
                activite.setType(type != null ? type.trim() : null);
                activite.setDateDebut(dateDebut);
                activite.setDateFin(dateFin);
                activite.setPlanningId(planning.getId());
                
                activiteDAO.create(activite);
                request.getSession().setAttribute("message", "Activité créée avec succès.");
            }

            response.sendRedirect(request.getContextPath() + "/planning");

        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/planning");
        }
    }
}

