package com.medicalcenter.controller.doctorControllers;

import com.medicalcenter.model.Appointment;
import com.medicalcenter.model.Doctor;
import com.medicalcenter.model.Specialty;
import com.medicalcenter.model.User;
import com.medicalcenter.service.AppointmentService;
import com.medicalcenter.service.DoctorService;
import com.medicalcenter.service.SpecialityService;
import com.medicalcenter.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@WebServlet("/doctor/profile")
public class DoctorProfileServlet extends HttpServlet {
    
    private DoctorService doctorService;
    private SpecialityService specialtyService;
    private UserService userService;
    private AppointmentService appointmentService;
    @Override
    public void init() throws ServletException {
        doctorService = new DoctorService();
        specialtyService = new SpecialityService();
        userService = new UserService();
        appointmentService = new AppointmentService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Check if user is logged in and is a doctor
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/unauthorized");
            return;
        }
        
        try {
            // Get doctor information
            Doctor doctor = doctorService.getDoctorByUserId(user.getId());
            if (doctor == null) {
                request.setAttribute("errorMessage", "Profil médecin non trouvé.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            List<Appointment> allAppointments = appointmentService.getAppointmentsByDoctor(doctor.getId());

            // Get all specialties for the dropdown
            List<Specialty> specialties = specialtyService.getAllSpecialties();
            int appointmentsThisMonth = appointmentService.getAppointmentsThisMonth();
            long completedThisMonth = getCompletedAppointmentsThisMonth(allAppointments);

            // Set attributes for JSP
            session.setAttribute("doctor", doctor);
            session.setAttribute("specialties", specialties);
            session.setAttribute("appointmentsThisMonth", appointmentsThisMonth);

            // Check if this is an edit request
            String action = request.getParameter("action");
            if ("edit".equals(action)) {
                response.sendRedirect(request.getContextPath() +"/doctor/profile-edit.jsp");
            } else {
                response.sendRedirect(request.getContextPath() +"/doctor/profile-view.jsp");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur est survenue lors du chargement du profil: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in and is a doctor
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/unauthorized");
            return;
        }
        
        try {
            // Get doctor information
            Doctor doctor = doctorService.getDoctorByUserId(user.getId());
            if (doctor == null) {
                request.setAttribute("errorMessage", "Profil médecin non trouvé.");
                doGet(request, response);
                return;
            }
            
            // Get form parameters
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String licenseNumber = request.getParameter("licenseNumber");
            String specialtyIdStr = request.getParameter("specialtyId");
            
            // Validate inputs
            if (firstName == null || firstName.trim().isEmpty() ||
                lastName == null || lastName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                licenseNumber == null || licenseNumber.trim().isEmpty() ||
                specialtyIdStr == null || specialtyIdStr.trim().isEmpty()) {
                
                request.setAttribute("errorMessage", "Tous les champs obligatoires doivent être remplis.");
                request.setAttribute("action", "edit");
                doGet(request, response);
                return;
            }
            
            // Validate email format
            if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                request.setAttribute("errorMessage", "Format d'email invalide.");
                request.setAttribute("action", "edit");
                doGet(request, response);
                return;
            }
            
            // Check if email is already used by another user
            User existingUser = userService.getUserByEmail(email);
            if (existingUser != null && existingUser.getId() != user.getId()) {
                request.setAttribute("errorMessage", "Cette adresse email est déjà utilisée.");
                request.setAttribute("action", "edit");
                doGet(request, response);
                return;
            }
            
            // Get specialty
            int specialtyId = Integer.parseInt(specialtyIdStr);
            Specialty specialty = specialtyService.getSpecialtyById(specialtyId);
            if (specialty == null) {
                request.setAttribute("errorMessage", "Spécialité invalide.");
                request.setAttribute("action", "edit");
                doGet(request, response);
                return;
            }
            
            // Update user information
            user.setEmail(email);
            userService.updateUser(user);
            
            // Update doctor information
            doctor.setFirstName(firstName.trim());
            doctor.setLastName(lastName.trim());
            doctor.setPhone(phone != null ? phone.trim() : null);
            doctor.setLicenseNumber(licenseNumber.trim());
            doctor.setSpecialty(specialty);
            
            doctorService.updateDoctor(doctor);
            
            // Update session
            session.setAttribute("user", user);
            
            // Set success message and redirect
            session.setAttribute("successMessage", "Profil mis à jour avec succès.");
            response.sendRedirect(request.getContextPath() + "/doctor/profile");
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "ID de spécialité invalide.");
            request.setAttribute("action", "edit");
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur est survenue lors de la mise à jour du profil: " + e.getMessage());
            request.setAttribute("action", "edit");
            doGet(request, response);
        }
    }
    private long getCompletedAppointmentsThisMonth(List<Appointment> appointments) {
        Calendar thisMonth = Calendar.getInstance();
        thisMonth.set(Calendar.DAY_OF_MONTH, 1);
        thisMonth.set(Calendar.HOUR_OF_DAY, 0);
        thisMonth.set(Calendar.MINUTE, 0);
        thisMonth.set(Calendar.SECOND, 0);
        Date startOfMonth = thisMonth.getTime();

        return appointments.stream()
                .filter(apt -> "Completed".equals(apt.getStatus()))
                .filter(apt -> apt.getStartTime().after(startOfMonth))
                .count();
    }
}