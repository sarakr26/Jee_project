package com.projet.jee.Servlets;

import com.projet.jee.dao.NotificationDAO;
import com.projet.jee.model.Notification;
import com.projet.jee.model.Utilisateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "NotificationServlet", urlPatterns = {"/membre/notifications", "/president/notifications"})
public class NotificationServlet extends HttpServlet {
    private NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        Utilisateur currentUser = (Utilisateur) session.getAttribute("currentUser");
        
        // Only members and presidents can access notifications
        if (!"MEMBRE".equals(currentUser.getRole()) && !"PRESIDENT".equals(currentUser.getRole())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            String action = request.getParameter("action");
            
            if ("count".equals(action)) {
                // Return unread count
                int count = notificationDAO.getUnreadCount(currentUser.getId());
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print("{\"count\":" + count + "}");
                out.flush();
            } else if ("markAllRead".equals(action)) {
                // Mark all as read
                notificationDAO.markAllAsRead(currentUser.getId());
                response.setStatus(HttpServletResponse.SC_OK);
            } else {
                // Return all notifications
                List<Notification> notifications = notificationDAO.getNotificationsByMembre(currentUser.getId());
                
                // Build JSON string manually
                StringBuilder jsonBuilder = new StringBuilder();
                jsonBuilder.append("[");
                for (int i = 0; i < notifications.size(); i++) {
                    Notification notif = notifications.get(i);
                    jsonBuilder.append("{");
                    jsonBuilder.append("\"id\":").append(notif.getId()).append(",");
                    jsonBuilder.append("\"message\":\"").append(escapeJson(notif.getMessage())).append("\",");
                    jsonBuilder.append("\"type\":\"").append(escapeJson(notif.getType())).append("\",");
                    jsonBuilder.append("\"dateCreation\":\"").append(notif.getDateCreation() != null ? escapeJson(notif.getDateCreation().toString()) : "").append("\",");
                    jsonBuilder.append("\"lu\":").append(notif.isLu());
                    jsonBuilder.append("}");
                    if (i < notifications.size() - 1) {
                        jsonBuilder.append(",");
                    }
                }
                jsonBuilder.append("]");
                
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(jsonBuilder.toString());
                out.flush();
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t")
                  .replace("/", "\\/")
                  .replace("\b", "\\b")
                  .replace("\f", "\\f");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String notificationId = request.getParameter("notificationId");
            if (notificationId != null) {
                // Mark specific notification as read
                Long id = Long.parseLong(notificationId);
                notificationDAO.markAsRead(id);
                response.setStatus(HttpServletResponse.SC_OK);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}

