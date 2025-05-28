package com.medicalcenter.service;

import com.medicalcenter.dao.UserDAO;
import com.medicalcenter.model.User;
import com.medicalcenter.util.EmailUtil;
import com.medicalcenter.util.SecurityUtil;

import java.util.logging.Level;
import java.util.logging.Logger;

public class AuthService {
    private static final Logger logger = Logger.getLogger(AuthService.class.getName());

    private UserDAO userDAO;

    public AuthService() {
        this.userDAO = new UserDAO();
    }

    public int registerUser(User user) {
        try {
            // Check if username already exists
            if (isUsernameTaken(user.getUsername())) {
                return -1;
            }

            // Check if email already exists
            if (isEmailTaken(user.getEmail())) {
                return -2;
            }
            userDAO.saveUser(user);
            // Save user and return the generated ID
            return 1;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error registering user", e);
            return -3;
        }
    }

    public User authenticateUser(String username, String password) {
        try {
            User user = userDAO.getUserByUsername(username);
            if (user != null && SecurityUtil.verifyPassword(password, user.getPassword())) {
                return user;
            }
            return null;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error authenticating user", e);
            return null;
        }
    }

    public boolean isUsernameTaken(String username) {
        try {
            return userDAO.getUserByUsername(username) != null;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error checking username", e);
            return true; // Assume taken to be safe
        }
    }

    public boolean isEmailTaken(String email) {
        try {
            return userDAO.getUserByEmail(email) != null;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error checking email", e);
            return true; // Assume taken to be safe
        }
    }

    public boolean sendPasswordResetEmail(String email) {
        try {
            User user = userDAO.getUserByEmail(email);
            if (user == null) {
                return false;
            }

            // Generate reset token
            String token = SecurityUtil.generateResetToken();

            // Save token to database with expiration
//            userDAO.saveResetToken(user.getId(), token);

            // Send email with reset link
            String resetLink = "http://localhost:8080/medical-center/reset-password.jsp?token=" + token;
            String subject = "Password Reset - Medical Center";
            String body = "Dear " + user.getUsername() + ",\n\n"
                    + "You have requested to reset your password. Please click the link below to reset your password:\n\n"
                    + resetLink + "\n\n"
                    + "This link will expire in 24 hours.\n\n"
                    + "If you did not request a password reset, please ignore this email.\n\n"
                    + "Regards,\nMedical Center Team";

            return EmailUtil.sendEmail(email, subject, body);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error sending password reset email", e);
            return false;
        }
    }
    public User getUserByEmail(String email){
        return userDAO.getUserByEmail(email);
    }
    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        try {
            User user = userDAO.getUserById(userId);
            if (user != null && SecurityUtil.verifyPassword(oldPassword, user.getPassword())) {
                user.setPassword(SecurityUtil.hashPassword(newPassword));
                userDAO.updateUser(user);
                return true;
            }
            return false;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error changing password", e);
            return false;
        }
    }
}