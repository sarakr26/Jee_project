package com.projet.jee.Servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.projet.jee.dao.UtilisateurDAO;
import com.projet.jee.dao.VerificationTokenDAO;
import com.projet.jee.model.Utilisateur;
import com.projet.jee.model.VerificationToken;

@WebServlet(name = "VerifyServlet", urlPatterns = {"/verify"})
public class VerifyServlet extends HttpServlet {
    private VerificationTokenDAO tokenDao = new VerificationTokenDAO();
    private UtilisateurDAO utilisateurDAO = new UtilisateurDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        if (token == null || token.trim().isEmpty()) {
            req.setAttribute("error", "Jeton invalide.");
            req.getRequestDispatcher("/jsp/auth/register.jsp").forward(req, resp);
            return;
        }

        try {
            VerificationToken vt = tokenDao.findByToken(token);
            if (vt == null) {
                req.setAttribute("error", "Jeton introuvable ou expiré.");
                req.getRequestDispatcher("/jsp/auth/register.jsp").forward(req, resp);
                return;
            }

            // optional: check expiry (24h)
            long ageMs = System.currentTimeMillis() - vt.getCreatedAt().getTime();
            if (ageMs > 24L * 3600L * 1000L) {
                tokenDao.deleteById(vt.getId());
                req.setAttribute("error", "Le lien de vérification a expiré.");
                req.getRequestDispatcher("/jsp/auth/register.jsp").forward(req, resp);
                return;
            }

            // create user (but double-check email wasn't registered meanwhile)
            if (utilisateurDAO.findByEmail(vt.getEmail()) != null) {
                // someone already registered with this email; remove token and inform
                tokenDao.deleteById(vt.getId());
                req.getSession().setAttribute("message", "Ce compte a déjà été créé.");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            // create user
            Utilisateur u = new Utilisateur();
            u.setNom(vt.getNom());
            u.setPrenom(vt.getPrenom());
            u.setEmail(vt.getEmail());
            u.setMotDePasse(vt.getMotDePasse()); // already hashed
            u.setCin(vt.getCin());
            u.setRole(vt.getRole());

            utilisateurDAO.create(u);
            tokenDao.deleteById(vt.getId());

            req.getSession().setAttribute("message", "Votre adresse e-mail a été vérifiée. Vous pouvez maintenant vous connecter.");
            resp.sendRedirect(req.getContextPath() + "/login");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur lors de la vérification du jeton.");
            req.getRequestDispatcher("/jsp/auth/register.jsp").forward(req, resp);
        }
    }
}
