package com.projet.jee.Servlets;

import com.projet.jee.model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/president/planning")
public class PlanningServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        // On récupère l'utilisateur avec le nom "currentUser"
        Utilisateur user = (Utilisateur) session.getAttribute("currentUser");

        if (user == null || !"PRESIDENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
            return;
        }

        request.getRequestDispatcher("/jsp/president/planning.jsp").forward(request, response);
    }
}