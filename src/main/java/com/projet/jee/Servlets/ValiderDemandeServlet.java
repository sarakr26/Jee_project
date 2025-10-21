package com.projet.jee.Servlets;

import com.projet.jee.dao.DemandeCreationClubDAO;
import com.projet.jee.dao.DemandeIntegrationDAO;
import com.projet.jee.model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ValiderDemandeServlet", urlPatterns = {"/valider-demande"})
public class ValiderDemandeServlet extends HttpServlet {
    private DemandeCreationClubDAO demandeCreationDAO = new DemandeCreationClubDAO();
    private DemandeIntegrationDAO demandeIntegrationDAO = new DemandeIntegrationDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Vérifier l'authentification et le rôle
            Utilisateur currentUser = (Utilisateur) req.getSession().getAttribute("currentUser");
            if (currentUser == null || !"FEDERATION".equals(currentUser.getRole())) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès refusé");
                return;
            }

            String type = req.getParameter("type");
            Long demandeId = Long.parseLong(req.getParameter("demandeId"));
            String action = req.getParameter("action");

            boolean success = false;
            String message = "";

            if ("creation".equals(type)) {
                if ("APPROUVE".equals(action)) {
                    success = demandeCreationDAO.validerDemande(demandeId);
                    message = success ? "Demande de création validée avec succès" : "Erreur lors de la validation";
                } else if ("REFUSE".equals(action)) {
                    success = demandeCreationDAO.refuserDemande(demandeId);
                    message = success ? "Demande de création refusée" : "Erreur lors du refus";
                }
            } else if ("integration".equals(type)) {
                if ("APPROUVE".equals(action)) {
                    success = demandeIntegrationDAO.validerDemande(demandeId);
                    message = success ? "Demande d'intégration validée avec succès" : "Erreur lors de la validation";
                } else if ("REFUSE".equals(action)) {
                    success = demandeIntegrationDAO.refuserDemande(demandeId);
                    message = success ? "Demande d'intégration refusée" : "Erreur lors du refus";
                }
            }

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write("{\"success\":" + success + ",\"message\":\"" + message + "\"}");

        } catch (Exception e) {
            e.printStackTrace();
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write("{\"success\":false,\"message\":\"Erreur: " + e.getMessage() + "\"}");
        }
    }
}
