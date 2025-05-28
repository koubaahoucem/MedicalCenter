package com.medicalcenter.controller.patientControllers;

import com.medicalcenter.dao.*;
import com.medicalcenter.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    private PatientDAO patientDAO = new PatientDAO();
    private DoctorDAO doctorDAO = new DoctorDAO();
    private SpecialityDAO specialtyDAO = new SpecialityDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {

            session.setAttribute("user", user);
            session.setAttribute("userRole", user.getRole());
            
            // Load role-specific data
            switch (user.getRole().toLowerCase()) {
                case "patient":
                    loadPatientData(session, user.getId());
                    break;
                case "doctor":
                    loadDoctorData(session, user.getId());
                    break;
                case "admin":
                    loadAdminData(session, user.getId());
                    break;
                default:
                    response.sendRedirect("login.jsp");
                    return;
            }
            
            // Set active page for sidebar
            session.setAttribute("activePage", "profile");

            response.sendRedirect(request.getContextPath() + "/patient/profile.jsp");
                   
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Une erreur est survenue lors du chargement du profil.");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp")
                   .forward(request, response);
        }
    }
    
    private void loadPatientData(HttpSession session, int userId) {
        Patient patient = patientDAO.getPatientByUserId(userId);
        if (patient != null) {
            session.setAttribute("patient", patient);
            
            // Format birth date for input field
            if (patient.getBirthDate() != null) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                session.setAttribute("formattedBirthDate", sdf.format(patient.getBirthDate()));
            }
            
            // Get all doctors for primary doctor selection
            List<Doctor> allDoctors = doctorDAO.getAllDoctors();
            session.setAttribute("allDoctors", allDoctors);
            
            // Get patient's medical records count
            MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();
            int recordCount = medicalRecordDAO.getMedicalRecordCountByPatient(patient.getId());
            session.setAttribute("medicalRecordCount", recordCount);
            
            // Get upcoming appointments count
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            int upcomingAppointments = appointmentDAO.getUpcomingAppointmentsByPatient(patient.getId()).size();
            session.setAttribute("upcomingAppointments", upcomingAppointments);
        }
    }
    
    private void loadDoctorData(HttpSession session, int userId) {
        Doctor doctor = doctorDAO.getDoctorByUserId(userId);
        if (doctor != null) {
            session.setAttribute("doctor", doctor);
            
            // Get all specialties for selection
            List<Specialty> allSpecialties = specialtyDAO.getAllSpecialties();
            session.setAttribute("allSpecialties", allSpecialties);
            
            // Get doctor's statistics
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            int totalAppointments = appointmentDAO.getAppointmentsByDoctor(doctor.getId()).size();
            int upcomingAppointments = appointmentDAO.getUpcomingAppointmentsByDoctor(doctor.getId()).size();
            int completedAppointments = appointmentDAO.getCompletedAppointmentsByDoctor(doctor.getId()).size();

            session.setAttribute("totalAppointments", totalAppointments);
            session.setAttribute("upcomingAppointments", upcomingAppointments);
            session.setAttribute("completedAppointments", completedAppointments);
            
            // Get prescription count
            PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
            int prescriptionCount = prescriptionDAO.getPrescriptionCountByDoctor(doctor.getId());
            session.setAttribute("prescriptionCount", prescriptionCount);
        }
    }
    
    private void loadAdminData(HttpSession session, int userId) {
        // Get system statistics for admin
        UserDAO userDAO = new UserDAO();
        PatientDAO patientDAO = new PatientDAO();
        DoctorDAO doctorDAO = new DoctorDAO();
        
        List<User> allUsers = userDAO.getAllUsers();
        int totalUsers = allUsers != null ? allUsers.size() : 0;
        int totalPatients = patientDAO.getPatientCount();
        int totalDoctors = doctorDAO.getAllDoctors().size();

        session.setAttribute("totalUsers", totalUsers);
        session.setAttribute("totalPatients", totalPatients);
        session.setAttribute("totalDoctors", totalDoctors);
        
        // Get recent users (last 10)
        if (allUsers != null && allUsers.size() > 0) {
            List<User> recentUsers = allUsers.subList(0, Math.min(10, allUsers.size()));
            session.setAttribute("recentUsers", recentUsers);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");
        
        if (userId == null || userRole == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            // Update profile based on role
            switch (userRole.toLowerCase()) {
                case "patient":
                    updatePatientProfile(request, userId);
                    break;
                case "doctor":
                    updateDoctorProfile(request, userId);
                    break;
                case "admin":
                    updateAdminProfile(request, userId);
                    break;
            }
            
            request.setAttribute("success", "Profil mis à jour avec succès.");
            doGet(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la mise à jour du profil: " + e.getMessage());
            doGet(request, response);
        }
    }
    
    private void updatePatientProfile(HttpServletRequest request, int userId) throws Exception {
        Patient patient = patientDAO.getPatientByUserId(userId);
        if (patient == null) {
            throw new Exception("Patient non trouvé");
        }
        
        // Update user information
        User user = patient.getUser();
        user.setEmail(request.getParameter("email"));
        userDAO.updateUser(user);
        
        // Update patient information
        patient.setFirstName(request.getParameter("firstName"));
        patient.setLastName(request.getParameter("lastName"));
        patient.setPhone(request.getParameter("phone"));
        patient.setAddress(request.getParameter("address"));
        
        // Parse and set birth date
        String birthDateStr = request.getParameter("birthDate");
        if (birthDateStr != null && !birthDateStr.isEmpty()) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            patient.setBirthDate(sdf.parse(birthDateStr));
        }
        
        patientDAO.updatePatient(patient);
    }
    
    private void updateDoctorProfile(HttpServletRequest request, int userId) throws Exception {
        Doctor doctor = doctorDAO.getDoctorByUserId(userId);
        if (doctor == null) {
            throw new Exception("Docteur non trouvé");
        }
        
        // Update user information
        User user = doctor.getUser();
        user.setEmail(request.getParameter("email"));
        userDAO.updateUser(user);
        
        // Update doctor information
        doctor.setFirstName(request.getParameter("firstName"));
        doctor.setLastName(request.getParameter("lastName"));
        doctor.setPhone(request.getParameter("phone"));
        doctor.setLicenseNumber(request.getParameter("licenseNumber"));
        
        doctorDAO.updateDoctor(doctor);
    }
    
    private void updateAdminProfile(HttpServletRequest request, int userId) throws Exception {
        User user = userDAO.getUserById(userId);
        if (user == null) {
            throw new Exception("Utilisateur non trouvé");
        }
        
        // Update basic user information
        user.setEmail(request.getParameter("email"));
        user.setUsername(request.getParameter("username"));
        
        userDAO.updateUser(user);
    }
}
