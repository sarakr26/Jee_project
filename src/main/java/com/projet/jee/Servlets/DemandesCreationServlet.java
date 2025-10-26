package com.projet.jee.Servlets;

import com.projet.jee.dao.DemandeCreationClubDAO;
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

@WebServlet(name = "DemandesCreationServlet", urlPatterns = {"/demandes/creation"})
public class DemandesCreationServlet extends HttpServlet {
    private DemandeCreationClubDAO demandeDAO = new DemandeCreationClubDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Vérifier l'authentification
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Utilisateur currentUser = (Utilisateur) session.getAttribute("currentUser");
        
        // Vérifier que l'utilisateur est bien de la fédération
        if (!"FEDERATION".equals(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/profile.jsp");
            return;
        }

        // Configurer l'encodage UTF-8
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        try {
            // Récupérer toutes les demandes de création de club
            List<DemandeCreationClub> demandes = demandeDAO.findAll();
            req.setAttribute("demandes", demandes);
            
            // Compter les demandes par statut
            int demandesEnAttente = 0;
            int demandesAcceptees = 0;
            int demandesRefusees = 0;
            
            for (DemandeCreationClub demande : demandes) {
                if ("EN_ATTENTE".equals(demande.getStatut())) {
                    demandesEnAttente++;
                } else if ("ACCEPTEE".equals(demande.getStatut())) {
                    demandesAcceptees++;
                } else if ("REFUSEE".equals(demande.getStatut())) {
                    demandesRefusees++;
                }
            }
            
            req.setAttribute("demandesEnAttente", demandesEnAttente);
            req.setAttribute("demandesAcceptees", demandesAcceptees);
            req.setAttribute("demandesRefusees", demandesRefusees);
            
            // Rediriger vers la page JSP
            req.getRequestDispatcher("/jsp/demandes/creation-list.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur lors du chargement des demandes: " + e.getMessage());
            req.getRequestDispatcher("/jsp/demandes/creation-list.jsp").forward(req, resp);
        }
    }
}
