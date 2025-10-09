package com.projet.jee.Servlets;

import com.projet.jee.dao.UtilisateurDAO;
import com.projet.jee.model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    private UtilisateurDAO dao = new UtilisateurDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Use the site's index as the login page
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setCharacterEncoding("UTF-8");
            String email = req.getParameter("email");
            String pwd = req.getParameter("motDePasse");
            Utilisateur u = dao.authenticate(email, pwd);
            if (u == null) {
                req.setAttribute("error", "Identifiants invalides.");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
                return;
            }
            // store user in session
            req.getSession().setAttribute("currentUser", u);
            resp.sendRedirect(req.getContextPath() + "/jsp/auth/profile.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur lors de la connexion: " + e.getMessage());
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
    }
}
