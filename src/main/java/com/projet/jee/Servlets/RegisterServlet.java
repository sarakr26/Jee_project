package com.projet.jee.Servlets;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.mindrot.jbcrypt.BCrypt;

import com.projet.jee.dao.UtilisateurDAO;
import com.projet.jee.dao.VerificationTokenDAO;
import com.projet.jee.model.VerificationToken;
import com.projet.jee.util.EmailUtil;

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

            // Validate email format server-side
            if (email == null || email.trim().isEmpty()) {
                req.setAttribute("error", "L'email est requis.");
                req.getRequestDispatcher("/jsp/auth/register.jsp").forward(req, resp);
                return;
            }
            String emailTrim = email.trim();
            Pattern emailPattern = Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
            Matcher m = emailPattern.matcher(emailTrim);
            if (!m.matches()) {
                req.setAttribute("error", "Adresse e-mail invalide.");
                req.getRequestDispatcher("/jsp/auth/register.jsp").forward(req, resp);
                return;
            }

            // Check duplicate email
            try {
                if (dao.findByEmail(emailTrim) != null) {
                    req.setAttribute("error", "Un compte existe déjà avec cet e-mail.");
                    req.getRequestDispatcher("/jsp/auth/register.jsp").forward(req, resp);
                    return;
                }
            } catch (Exception ex) {
                ex.printStackTrace();
                req.setAttribute("error", "Erreur lors de la vérification de l'adresse e-mail.");
                req.getRequestDispatcher("/jsp/auth/register.jsp").forward(req, resp);
                return;
            }

            // Instead of creating the user now, create a verification token entry and send email.
            VerificationTokenDAO tokenDao = new VerificationTokenDAO();
            VerificationToken vt = new VerificationToken();
            vt.setNom(nom.trim());
            vt.setPrenom(prenom.trim());
            vt.setEmail(emailTrim);
            vt.setCin(cin.trim());
            vt.setRole(role != null ? role : "MEMBRE");
            String hashed = BCrypt.hashpw(pwd, BCrypt.gensalt());
            vt.setMotDePasse(hashed);
            vt.setToken(java.util.UUID.randomUUID().toString());
            vt.setCreatedAt(new java.sql.Timestamp(System.currentTimeMillis()));

            tokenDao.createToken(vt);

            // build verification link
            String verifyLink = req.getScheme() + "://" + req.getServerName() + (req.getServerPort() == 80 || req.getServerPort() == 443 ? "" : ":" + req.getServerPort())
                    + req.getContextPath() + "/verify?token=" + vt.getToken();

            String body = "<p>Bonjour " + vt.getPrenom() + ",</p>"
                    + "<p>Merci de vous être inscrit. Veuillez cliquer sur le lien ci-dessous pour vérifier votre adresse e-mail et activer votre compte :</p>"
                    + "<p><a href=\"" + verifyLink + "\">Vérifier mon e-mail</a></p>"
                    + "<p>Si vous n'avez pas demandé cette inscription, ignorez ce message.</p>";

            try {
                EmailUtil.sendVerificationEmail(vt.getEmail(), "Vérification de votre adresse e-mail", body);
                req.getSession().setAttribute("message", "Un e-mail de vérification a été envoyé. Vérifiez votre boîte mail.");
                resp.sendRedirect(req.getContextPath() + "/");
            } catch (Exception mailEx) {
                mailEx.printStackTrace();
                // Development mode: Log the verification link instead of failing
                System.out.println("\n----------------------------------------");
                System.out.println("DEVELOPMENT MODE: Email sending failed");
                System.out.println("Verification link: " + verifyLink);
                System.out.println("----------------------------------------\n");
                
                // Still redirect with success message in dev mode
                req.getSession().setAttribute("message", 
                    "Mode développement: L'email n'a pas pu être envoyé, mais le lien de vérification a été imprimé dans la console du serveur.");
                resp.sendRedirect(req.getContextPath() + "/");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur lors de l'inscription: " + e.getMessage());
            req.getRequestDispatcher("/jsp/auth/register.jsp").forward(req, resp);
        }
    }
}
