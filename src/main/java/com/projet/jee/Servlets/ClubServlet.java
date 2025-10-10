package com.projet.jee.Servlets;

import com.projet.jee.dao.ClubDAO;
import com.projet.jee.model.Club;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ClubServlet", urlPatterns = {"/clubs"})
public class ClubServlet extends HttpServlet {
    private ClubDAO dao = new ClubDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        try {
            String id = req.getParameter("id");
            if (id != null && !id.isEmpty()) {
                Club c = dao.findById(Long.valueOf(id));
                req.setAttribute("club", c);
                req.getRequestDispatcher("/jsp/clubs/detail.jsp").forward(req, resp);
                return;
            }
            List<Club> list = dao.findAll();
            req.setAttribute("clubs", list);
            req.getRequestDispatcher("/jsp/clubs/list.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // Basic create/update/delete could be implemented on POST depending on 'action' param
}
