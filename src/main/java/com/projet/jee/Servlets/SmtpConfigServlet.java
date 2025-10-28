package com.projet.jee.Servlets;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.projet.jee.util.EmailUtil;

@WebServlet(name = "SmtpConfigServlet", urlPatterns = {"/admin/smtp-config", "/admin/test-smtp"})
public class SmtpConfigServlet extends HttpServlet {
    private static final String CONFIG_FILE = "smtp.properties";
    private Properties smtpProps = new Properties();

    @Override
    public void init() throws ServletException {
        // Load existing configuration if any
        try {
            smtpProps.load(getServletContext().getResourceAsStream("/WEB-INF/" + CONFIG_FILE));
        } catch (Exception e) {
            // Config doesn't exist yet, that's OK
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Pre-fill form with existing values
        req.setAttribute("smtpHost", smtpProps.getProperty("mail.smtp.host"));
        req.setAttribute("smtpPort", smtpProps.getProperty("mail.smtp.port"));
        req.setAttribute("smtpUser", smtpProps.getProperty("mail.smtp.user"));
        req.setAttribute("mailFrom", smtpProps.getProperty("mail.from"));
        
        req.getRequestDispatcher("/jsp/admin/email-config.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/admin/test-smtp".equals(path)) {
            handleTestSmtp(req, resp);
        } else {
            handleSaveConfig(req, resp);
        }
    }

    private void handleSaveConfig(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String smtpHost = req.getParameter("smtpHost");
        String smtpPort = req.getParameter("smtpPort");
        String smtpUser = req.getParameter("smtpUser");
        String smtpPassword = req.getParameter("smtpPassword");
        String mailFrom = req.getParameter("mailFrom");

        if (smtpHost == null || smtpPort == null || smtpUser == null || smtpPassword == null || mailFrom == null) {
            req.setAttribute("error", "Tous les champs sont requis");
            doGet(req, resp);
            return;
        }

        // Update properties
        smtpProps.setProperty("mail.smtp.host", smtpHost);
        smtpProps.setProperty("mail.smtp.port", smtpPort);
        smtpProps.setProperty("mail.smtp.user", smtpUser);
        smtpProps.setProperty("mail.smtp.password", smtpPassword);
        smtpProps.setProperty("mail.from", mailFrom);

        // Save to file
        String configPath = getServletContext().getRealPath("/WEB-INF/" + CONFIG_FILE);
        try (FileOutputStream out = new FileOutputStream(configPath)) {
            smtpProps.store(out, "SMTP Configuration");
            
            // Also set as system properties for immediate use
            System.setProperty("mail.smtp.host", smtpHost);
            System.setProperty("mail.smtp.port", smtpPort);
            System.setProperty("mail.smtp.user", smtpUser);
            System.setProperty("mail.smtp.password", smtpPassword);
            System.setProperty("mail.from", mailFrom);

            req.setAttribute("message", "Configuration enregistrée avec succès");
        } catch (Exception e) {
            req.setAttribute("error", "Erreur lors de l'enregistrement : " + e.getMessage());
        }
        
        doGet(req, resp);
    }

    private void handleTestSmtp(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        
        try {
            // Use the submitted values for the test
            System.setProperty("mail.smtp.host", req.getParameter("smtpHost"));
            System.setProperty("mail.smtp.port", req.getParameter("smtpPort"));
            System.setProperty("mail.smtp.user", req.getParameter("smtpUser"));
            System.setProperty("mail.smtp.password", req.getParameter("smtpPassword"));
            System.setProperty("mail.from", req.getParameter("mailFrom"));

            // Send test email to the configured from address
            EmailUtil.sendVerificationEmail(
                req.getParameter("mailFrom"),
                "Test de la configuration SMTP",
                "<p>Ceci est un email de test pour vérifier la configuration SMTP.</p>"
            );
            
            resp.getWriter().write("{\"success\":true}");
        } catch (Exception e) {
            resp.getWriter().write("{\"success\":false,\"error\":\"" + e.getMessage().replace("\"", "'") + "\"}");
        }
    }
}