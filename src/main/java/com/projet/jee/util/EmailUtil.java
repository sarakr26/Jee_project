package com.projet.jee.util;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailUtil {
    // Sends a simple verification email. SMTP configuration is read from system properties or env vars.
    // Required system properties or env vars:
    // mail.smtp.host, mail.smtp.port, mail.smtp.user, mail.smtp.password, mail.from
    public static void sendVerificationEmail(String to, String subject, String body) throws MessagingException {
        String host = System.getProperty("mail.smtp.host", System.getenv("MAIL_SMTP_HOST"));
        String port = System.getProperty("mail.smtp.port", System.getenv("MAIL_SMTP_PORT"));
        final String user = System.getProperty("mail.smtp.user", System.getenv("MAIL_SMTP_USER"));
        final String pass = System.getProperty("mail.smtp.password", System.getenv("MAIL_SMTP_PASSWORD"));
        String from = System.getProperty("mail.from", System.getenv("MAIL_FROM"));

        if (host == null || port == null || user == null || pass == null || from == null) {
            // SMTP not configured; throw to allow caller to handle fallback
            throw new MessagingException("SMTP configuration missing (set mail.smtp.host/port/user/password and mail.from)");
        }

        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, pass);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(from));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);
        message.setContent(body, "text/html; charset=UTF-8");

        Transport.send(message);
    }
}
