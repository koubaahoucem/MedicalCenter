package com.medicalcenter.controller;

import com.medicalcenter.model.Doctor;
import com.medicalcenter.model.Patient;
import com.medicalcenter.model.Specialty;
import com.medicalcenter.model.User;
import com.medicalcenter.service.AuthService;
import com.medicalcenter.service.DoctorService;
import com.medicalcenter.service.PatientService;
import com.medicalcenter.service.SpecialityService;
import com.medicalcenter.util.SecurityUtil;
import com.medicalcenter.util.ValidationUtil;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(AuthServlet.class.getName());

    private AuthService authService;
    private PatientService patientService;
    private DoctorService doctorService;
    private SpecialityService specialityService;
    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
        patientService = new PatientService();
        doctorService = new DoctorService();
        specialityService = new SpecialityService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if ("/logout".equals(pathInfo)) {
            // Handle logout
            HttpSession session = request.getSession(false); // Retrieve the session without creating a new one if it doesn't exist
            if (session != null) {
                // Iterate through all session attributes and remove them
                Enumeration<String> attributeNames = session.getAttributeNames();
                while (attributeNames.hasMoreElements()) {
                    String attributeName = attributeNames.nextElement();
                    session.removeAttribute(attributeName); // Remove each attribute individually
                }

                // Invalidate the session to completely destroy it
                session.invalidate();
            }

            // Redirect to the login page with a success message
            response.sendRedirect(request.getContextPath() + "/login.jsp?success=logout");
        } else {
            // Default to the login page
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if ("/login".equals(pathInfo)) {
            handleLogin(request, response);
        } else if ("/register".equals(pathInfo)) {
            handleRegistration(request, response);

        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        boolean rememberMe = "on".equals(request.getParameter("rememberMe"));

        try {
            User user = authService.authenticateUser(username, password);

            if (user != null) {
                // Create session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("role", user.getRole());

                // Set session timeout (30 minutes by default, 7 days if remember me)
                if (rememberMe) {
                    session.setMaxInactiveInterval(7 * 24 * 60 * 60); // 7 days in seconds
                }

                // Log the successful login
                logger.log(Level.INFO, "User {0} logged in successfully", username);
                RequestDispatcher rd;
                // Redirect based on role
                switch (user.getRole()) {
                    case "admin":
                        response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
                        break;
                    case "doctor":
                        rd = getServletContext().getRequestDispatcher("/doctor/dashboard");
                        rd.forward(request,response);
                        break;
                    case "patient":
                        rd = getServletContext().getRequestDispatcher("/patient/dashboard");
                        rd.forward(request,response);
                        break;
                    default:
                        response.sendRedirect(request.getContextPath() + "/index.jsp");
                }
            } else {
                // Log the failed login attempt
                logger.log(Level.WARNING, "Failed login attempt for username: {0}", username);

                // Redirect to login page with error
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error during login", e);
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=system");
        }
    }

    private void handleRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form parameters
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");
        String terms = request.getParameter("terms");
        String specialty = request.getParameter("specialty");
        // Validate input
        Map<String, String> errors = validateRegistrationInput(firstName, lastName, username,
                email, password, confirmPassword, role, terms);

        if (!errors.isEmpty()) {
            // Store errors and form data in session for redisplay
            HttpSession session = request.getSession();
            session.setAttribute("registrationErrors", errors);
            session.setAttribute("registrationData", request.getParameterMap());

            // Redirect back to registration form
            response.sendRedirect(request.getContextPath() + "/register.jsp");
            return;
        }
        Specialty specialty1 = specialityService.getSpecialityByName(specialty);
        try {
            // Create user
            User user = new User();
            user.setUsername(username);
            user.setPassword(SecurityUtil.hashPassword(password));
            user.setEmail(email);
            user.setRole(role);
            user.setCreatedAt(new Date());

            // Save user to database
            int userId = authService.registerUser(user);

            if (userId>0) {
                User user1 = authService.getUserByEmail(email);
                // Create role-specific record
                if ("patient".equals(role)) {
                    Patient patient = new Patient();
                    patient.setUser(user1);
                    patient.setFirstName(firstName);
                    patient.setLastName(lastName);

                    patientService.savePatient(patient);
                } else if ("doctor".equals(role)) {
                    Doctor doctor = new Doctor();
                    doctor.setUser(user1);
                    doctor.setFirstName(firstName);
                    doctor.setLastName(lastName);
                    doctor.setSpecialty(specialty1);
                    // License number would typically be verified separately
                    doctor.setLicenseNumber("PENDING_VERIFICATION");

                    doctorService.saveDoctor(doctor);
                }

                // Log successful registration
                logger.log(Level.INFO, "New user registered: {0} as {1}", new Object[]{username, role});

                // Redirect to login page with success message
                response.sendRedirect(request.getContextPath() + "/login.jsp?success=registered");
            } else {
                // Registration failed
                logger.log(Level.WARNING, "Registration failed for username: {0}", username);

                // Store error message in session
                HttpSession session = request.getSession();
                errors.put("general", "Registration failed. Please try again.");
                session.setAttribute("registrationErrors", errors);
                session.setAttribute("registrationData", request.getParameterMap());

                // Redirect back to registration form
                response.sendRedirect(request.getContextPath() + "/register.jsp");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error during registration", e);

            // Store error message in session
            HttpSession session = request.getSession();
            errors.put("general", "An error occurred during registration: " + e.getMessage());
            session.setAttribute("registrationErrors", errors);
            session.setAttribute("registrationData", request.getParameterMap());

            // Redirect back to registration form
            response.sendRedirect(request.getContextPath() + "/register.jsp");
        }
    }

    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/forgot-password.jsp?error=invalid");
            return;
        }

        try {
            boolean success = authService.sendPasswordResetEmail(email);

            if (success) {
                response.sendRedirect(request.getContextPath() +
                        "/forgot-password.jsp?success=sent");
            } else {
                response.sendRedirect(request.getContextPath() +
                        "/forgot-password.jsp?error=notfound");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error during password reset", e);
            response.sendRedirect(request.getContextPath() +
                    "/forgot-password.jsp?error=system");
        }
    }

    private Map<String, String> validateRegistrationInput(String firstName, String lastName,
                                                          String username, String email, String password, String confirmPassword,
                                                          String role, String terms) {

        Map<String, String> errors = new HashMap<>();

        // Validate first name
        if (firstName == null || firstName.trim().isEmpty()) {
            errors.put("firstName", "First name is required");
        } else if (firstName.length() > 50) {
            errors.put("firstName", "First name cannot exceed 50 characters");
        }

        // Validate last name
        if (lastName == null || lastName.trim().isEmpty()) {
            errors.put("lastName", "Last name is required");
        } else if (lastName.length() > 50) {
            errors.put("lastName", "Last name cannot exceed 50 characters");
        }

        // Validate username
        if (username == null || username.trim().isEmpty()) {
            errors.put("username", "Username is required");
        } else if (username.length() < 4 || username.length() > 50) {
            errors.put("username", "Username must be between 4 and 50 characters");
        } else if (!ValidationUtil.isValidUsername(username)) {
            errors.put("username", "Username can only contain letters, numbers, and underscores");
        } else if (authService.isUsernameTaken(username)) {
            errors.put("username", "Username is already taken");
        }

        // Validate email
        if (email == null || email.trim().isEmpty()) {
            errors.put("email", "Email is required");
        } else if (!ValidationUtil.isValidEmail(email)) {
            errors.put("email", "Invalid email format");
        } else if (authService.isEmailTaken(email)) {
            errors.put("email", "Email is already registered");
        }

        // Validate password
        if (password == null || password.trim().isEmpty()) {
            errors.put("password", "Password is required");
        } else if (password.length() < 8) {
            errors.put("password", "Password must be at least 8 characters long");
        } else if (!ValidationUtil.isStrongPassword(password)) {
            errors.put("password", "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character");
        }

        // Validate password confirmation
        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            errors.put("confirmPassword", "Please confirm your password");
        } else if (!confirmPassword.equals(password)) {
            errors.put("confirmPassword", "Passwords do not match");
        }

        // Validate role
        if (role == null || role.trim().isEmpty()) {
            errors.put("role", "Please select a role");
        } else if (!role.equals("patient") && !role.equals("doctor")) {
            errors.put("role", "Invalid role selected");
        }

        // Validate terms agreement
        if (terms == null || !terms.equals("on")) {
            errors.put("terms", "You must agree to the terms and conditions");
        }

        return errors;
    }
}