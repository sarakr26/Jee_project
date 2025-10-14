package com.projet.jee.Servlets;

import com.projet.jee.dao.UtilisateurDAO;
import com.projet.jee.model.Utilisateur;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    private UtilisateurDAO dao = new UtilisateurDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/auth/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setCharacterEncoding("UTF-8");
            String nom = req.getParameter("nom");
            String prenom = req.getParameter("prenom");
            String email = req.getParameter("email");
            String cin = req.getParameter("cin");
            String pwd = req.getParameter("motDePasse");
            String pwd2 = req.getParameter("motDePasse2");
            String role = req.getParameter("role");

            if (nom == null || prenom == null || email == null || pwd == null || pwd2 == null || cin == null) {
                req.setAttribute("error", "Tous les champs sont requis.");
                req.getRequestDispatcher("/jsp/auth/register.jsp").forward(req, resp);
                return;
            }
            if (!pwd.equals(pwd2)) {
                req.setAttribute("error", "Les mots de passe ne correspondent pas.");
                req.getRequestDispatcher("/jsp/auth/register.jsp").forward(req, resp);
                return;
            }
            if (pwd.length() < 6) {
                req.setAttribute("error", "Le mot de passe doit contenir au moins 6 caractères.");
                req.getRequestDispatcher("/jsp/auth/register.jsp").forward(req, resp);
                return;
            }

            Utilisateur u = new Utilisateur();
            u.setNom(nom.trim());
            u.setPrenom(prenom.trim());
            u.setEmail(email.trim());
            u.setCin(cin.trim());
            u.setRole(role != null ? role : "MEMBRE");
            String hashed = BCrypt.hashpw(pwd, BCrypt.gensalt());
            u.setMotDePasse(hashed);

            dao.create(u);
            req.getSession().setAttribute("message", "Inscription réussie. Connectez-vous.");
            resp.sendRedirect(req.getContextPath() + "/");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur lors de l'inscription: " + e.getMessage());
            req.getRequestDispatcher("/jsp/auth/register.jsp").forward(req, resp);
        }
    }
}