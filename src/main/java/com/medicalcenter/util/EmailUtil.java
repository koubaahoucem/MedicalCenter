package com.medicalcenter.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EmailUtil {
    private static final Logger logger = Logger.getLogger(EmailUtil.class.getName());

    // Replace with your actual email configuration
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_USERNAME = "your-email@gmail.com";
    private static final String EMAIL_PASSWORD = "your-app-password";

    public static boolean sendEmail(String recipient, String subject, String body) {
        try {
            // Set up mail server properties
            Properties properties = new Properties();
            properties.put("mail.smtp.host", SMTP_HOST);
            properties.put("mail.smtp.port", SMTP_PORT);
            properties.put("mail.smtp.auth", "true");
            properties.put("mail.smtp.starttls.enable", "true");

            // Create session with authenticator
            Session session = Session.getInstance(properties, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
                }
            });

            // Create message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
            message.setSubject(subject);
            message.setText(body);

            // Send message
            Transport.send(message);

            logger.log(Level.INFO, "Email sent successfully to: {0}", recipient);
            return true;
        } catch (MessagingException e) {
            logger.log(Level.SEVERE, "Failed to send email to: " + recipient, e);
            return false;
        }
    }
}