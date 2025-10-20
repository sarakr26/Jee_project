package com.projet.jee.Servlets;

import com.projet.jee.dao.ClubDAO;
import com.projet.jee.dao.FederationDAO;
import com.projet.jee.model.Club;
import com.projet.jee.model.Federation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ClubServlet", urlPatterns = { "/clubs" })
public class ClubServlet extends HttpServlet {
    private ClubDAO dao = new ClubDAO();
    private FederationDAO federationDAO = new FederationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        try {
            String action = req.getParameter("action");
            if ("new".equals(action)) {
                req.setAttribute("federations", federationDAO.findAll());
                req.getRequestDispatcher("/jsp/clubs/form.jsp").forward(req, resp);
                return;
            }
            if ("edit".equals(action)) {
                String id = req.getParameter("id");
                Club c = dao.findById(Long.valueOf(id));
                req.setAttribute("club", c);
                req.setAttribute("federations", federationDAO.findAll());
                req.getRequestDispatcher("/jsp/clubs/form.jsp").forward(req, resp);
                return;
            }
            if ("delete".equals(action)) {
                String id = req.getParameter("id");
                if (id != null)
                    dao.delete(Long.valueOf(id));
                req.getSession().setAttribute("message", "Club supprimé.");
                resp.sendRedirect(req.getContextPath() + "/clubs");
                return;
            }

            String id = req.getParameter("id");
            if (id != null && !id.isEmpty()) {
                Club c = dao.findById(Long.valueOf(id));
                req.setAttribute("club", c);
                req.getRequestDispatcher("/jsp/clubs/detail.jsp").forward(req, resp);
                return;
            }
            List<Club> list = dao.findAll();
            // ensure there are some federations to choose from (dev convenience)
            List<Federation> federations = federationDAO.findAll();
            if (federations.isEmpty()) {
                federationDAO.create(new Federation() {
                    {
                        setNom("Fédération A");
                        setPays("France");
                    }
                });
                federationDAO.create(new Federation() {
                    {
                        setNom("Fédération B");
                        setPays("Maroc");
                    }
                });
                federations = federationDAO.findAll();
            }
            // build a map id->name for easy lookup in JSP
            java.util.Map<String, String> fMap = new java.util.HashMap<>();
            for (Federation f : federations)
                fMap.put(String.valueOf(f.getId()), f.getNom());
            req.setAttribute("federationMap", fMap);
            req.setAttribute("clubs", list);
            req.setAttribute("federations", federations);
            req.getRequestDispatcher("/jsp/clubs/list.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        String action = req.getParameter("action");
        try {
            if ("save".equals(action)) {
                String id = req.getParameter("id");
                Club c = new Club();
                if (id != null && !id.isEmpty())
                    c.setId(Long.valueOf(id));
                c.setNom(req.getParameter("nom"));
                c.setLogo(req.getParameter("logo"));
                c.setDescription(req.getParameter("description"));
                c.setStatut(req.getParameter("statut"));
                String pid = req.getParameter("presidentId");
                if (pid != null && !pid.isEmpty())
                    c.setPresidentId(Long.valueOf(pid));

                if (c.getId() == null)
                    dao.create(c);
                else
                    dao.update(c);
                req.getSession().setAttribute("message", "Club enregistré.");
                resp.sendRedirect(req.getContextPath() + "/clubs");
                return;
            }
            if ("delete".equals(action)) {
                String id = req.getParameter("id");
                if (id != null && !id.isEmpty())
                    dao.delete(Long.valueOf(id));
                req.getSession().setAttribute("message", "Club supprimé.");
                resp.sendRedirect(req.getContextPath() + "/clubs");
                return;
            }
            // fallback to list
            resp.sendRedirect(req.getContextPath() + "/clubs");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
