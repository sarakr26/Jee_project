package com.projet.jee.Servlets;

import com.projet.jee.dao.ClubDAO;
import com.projet.jee.dao.DemandeCreationClubDAO;
import com.projet.jee.dao.DemandeIntegrationDAO;
import com.projet.jee.model.DemandeCreationClub;
import com.projet.jee.model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ValiderDemandeServlet", urlPatterns = { "/valider/demande" })
public class ValiderDemandeServlet extends HttpServlet {
    private DemandeCreationClubDAO demandeCreationDAO = new DemandeCreationClubDAO();
    private DemandeIntegrationDAO demandeIntegrationDAO = new DemandeIntegrationDAO();
    private ClubDAO clubDAO = new ClubDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        handleRequest(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        handleRequest(req, resp);
    }

    private void handleRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Vérifier l'authentification et le rôle
            Utilisateur currentUser = (Utilisateur) req.getSession().getAttribute("currentUser");
            if (currentUser == null || !"FEDERATION".equals(currentUser.getRole())) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{\"success\":false,\"message\":\"Accès refusé - Authentification requise\"}");
                return;
            }

            String type = req.getParameter("type");
            String idParam = req.getParameter("id");
            String action = req.getParameter("action");
            
            // Validation des paramètres
            if (type == null || idParam == null || action == null) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{\"success\":false,\"message\":\"Paramètres manquants\"}");
                return;
            }
            
            Long demandeId;
            try {
                demandeId = Long.parseLong(idParam);
            } catch (NumberFormatException e) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{\"success\":false,\"message\":\"ID de demande invalide\"}");
                return;
            }

            boolean success = false;
            String message = "";

            if ("creation".equals(type)) {
                if ("APPROUVE".equals(action)) {
                    // Récupérer les détails de la demande avant de la valider
                    DemandeCreationClub demande = demandeCreationDAO.findById(demandeId);
                    if (demande != null) {
                        // Valider la demande
                        success = demandeCreationDAO.validerDemande(demandeId);
                        if (success) {
                            // Créer le club dans la table Club
                            boolean clubCreated = clubDAO.createClubFromDemande(
                                    demande.getNomClub(),
                                    demande.getDescription(),
                                    demande.getLogo(),
                                    demande.getPresidentId());
                            if (clubCreated) {
                                message = "Demande de création validée avec succès et club créé";
                            } else {
                                message = "Demande validée mais erreur lors de la création du club";
                            }
                        } else {
                            message = "Erreur lors de la validation";
                        }
                    } else {
                        message = "Demande introuvable";
                    }
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
