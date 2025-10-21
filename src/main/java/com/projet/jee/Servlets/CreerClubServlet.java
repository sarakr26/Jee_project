package com.projet.jee.Servlets;

import com.projet.jee.dao.DemandeCreationClubDAO;
import com.projet.jee.model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet(name = "CreerClubServlet", urlPatterns = { "/president/creer-club" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class CreerClubServlet extends HttpServlet {
    private DemandeCreationClubDAO demandeDAO = new DemandeCreationClubDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
            request.setCharacterEncoding("UTF-8");
            String nomClub = request.getParameter("nomClub");
            String description = request.getParameter("description");

            // Validation des données
            if (nomClub == null || nomClub.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Le nom du club est obligatoire.");
                response.sendRedirect(request.getContextPath() + "/president/dashboard");
                return;
            }

            // Vérifier si le président a déjà une demande en attente
            if (demandeDAO.hasPendingDemande(currentUser.getId())) {
                session.setAttribute("errorMessage",
                        "Vous avez déjà une demande de création de club en attente. Veuillez attendre la réponse de la fédération.");
                response.sendRedirect(request.getContextPath() + "/president/dashboard");
                return;
            }

            // Traiter le fichier logo
            String logoFileName = null;
            Part logoPart = request.getPart("logo");

            if (logoPart != null && logoPart.getSize() > 0) {
                // Extraire le nom du fichier depuis le header Content-Disposition (compatible
                // Servlet 3.0)
                String contentDisposition = logoPart.getHeader("content-disposition");
                String originalFileName = null;

                if (contentDisposition != null) {
                    for (String content : contentDisposition.split(";")) {
                        if (content.trim().startsWith("filename")) {
                            originalFileName = content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
                            break;
                        }
                    }
                }

                if (originalFileName == null || originalFileName.isEmpty()) {
                    session.setAttribute("errorMessage", "Nom de fichier invalide.");
                    response.sendRedirect(request.getContextPath() + "/president/dashboard");
                    return;
                }

                String fileExtension = "";
                int dotIndex = originalFileName.lastIndexOf('.');
                if (dotIndex > 0) {
                    fileExtension = originalFileName.substring(dotIndex);
                }

                // Valider l'extension du fichier
                if (!fileExtension.matches("\\.(jpg|jpeg|png|gif|svg)$")) {
                    session.setAttribute("errorMessage",
                            "Format de fichier non valide. Veuillez uploader une image (jpg, jpeg, png, gif, svg).");
                    response.sendRedirect(request.getContextPath() + "/president/dashboard");
                    return;
                }

                // Générer un nom de fichier unique
                logoFileName = "logo_" + UUID.randomUUID().toString() + fileExtension;

                // Définir le répertoire d'upload
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator
                        + "logos";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Sauvegarder le fichier
                String filePath = uploadPath + File.separator + logoFileName;
                Files.copy(logoPart.getInputStream(), Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
            }

            // Créer la demande
            boolean success = demandeDAO.createDemande(nomClub.trim(), description != null ? description.trim() : "",
                    logoFileName, currentUser.getId());

            if (success) {
                session.setAttribute("successMessage", "Votre demande de création du club \"" + nomClub
                        + "\" a été envoyée avec succès à la fédération ! Vous recevrez une réponse prochainement.");
            } else {
                session.setAttribute("errorMessage",
                        "Une erreur est survenue lors de l'envoi de votre demande. Veuillez réessayer.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Erreur lors de la création de la demande: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/president/dashboard");
    }
}
