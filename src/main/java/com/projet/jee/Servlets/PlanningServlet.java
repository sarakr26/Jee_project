package com.projet.jee.Servlets;

import com.projet.jee.dao.ClubDAO;
import com.projet.jee.dao.PlanningDAO;
import com.projet.jee.dao.ActiviteDAO;
import com.projet.jee.model.Club;
import com.projet.jee.model.Planning;
import com.projet.jee.model.Utilisateur;
import com.projet.jee.model.Activite;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "PlanningServlet", urlPatterns = { "/planning" })
public class PlanningServlet extends HttpServlet {
    private PlanningDAO planningDAO = new PlanningDAO();
    private ActiviteDAO activiteDAO = new ActiviteDAO();
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
        
        try {
            Club club = null;
            Planning planning = null;
            List<Activite> activites = null;

            // Pour un Président, récupérer son club
            if ("PRESIDENT".equals(currentUser.getRole())) {
                club = clubDAO.getClubByPresidentId(currentUser.getId());
                if (club == null) {
                    request.setAttribute("error", "Vous devez avoir un club actif pour accéder au planning.");
                    if (request.getRequestURI().contains("/president")) {
                        response.sendRedirect(request.getContextPath() + "/president/dashboard");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/jsp/auth/profile.jsp");
                    }
                    return;
                }
            }
            // Pour un Membre, récupérer le club auquel il appartient
            else if ("MEMBRE".equals(currentUser.getRole())) {
                if (currentUser.getClubId() != null) {
                    club = clubDAO.getClubById(currentUser.getClubId());
                } else {
                    request.setAttribute("error", "Vous devez être membre d'un club pour accéder au planning.");
                    response.sendRedirect(request.getContextPath() + "/membre/dashboard");
                    return;
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/jsp/auth/profile.jsp");
                return;
            }

            if (club != null) {
                // Récupérer ou créer le planning pour ce club
                planning = planningDAO.getPlanningByClubId(club.getId());
                if (planning == null) {
                    // Créer un planning s'il n'existe pas (seulement pour les présidents)
                    if ("PRESIDENT".equals(currentUser.getRole())) {
                        planning = planningDAO.createPlanningForClub(club.getId());
                    }
                }

                if (planning != null) {
                    // Récupérer les activités
                    String view = request.getParameter("view");
                    if ("month".equals(view)) {
                        // Vue mensuelle (à implémenter si nécessaire)
                        String yearParam = request.getParameter("year");
                        String monthParam = request.getParameter("month");
                        if (yearParam != null && monthParam != null) {
                            int year = Integer.parseInt(yearParam);
                            int month = Integer.parseInt(monthParam);
                            activites = activiteDAO.getActivitesByPlanningAndMonth(planning.getId(), year, month);
                        } else {
                            activites = activiteDAO.getActivitesFuturesByPlanningId(planning.getId());
                        }
                    } else {
                        // Vue par défaut : activités futures
                        activites = activiteDAO.getActivitesFuturesByPlanningId(planning.getId());
                    }
                }
            }

            request.setAttribute("club", club);
            request.setAttribute("planning", planning);
            request.setAttribute("activites", activites);

            // Rediriger vers la page JSP appropriée
            if ("PRESIDENT".equals(currentUser.getRole())) {
                request.getRequestDispatcher("/jsp/planning/president-planning.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/jsp/planning/membre-planning.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la récupération du planning: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/" + 
                ("PRESIDENT".equals(currentUser.getRole()) ? "president" : "membre") + "/dashboard");
        }
    }
}


