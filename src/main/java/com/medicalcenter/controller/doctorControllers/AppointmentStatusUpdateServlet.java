package com.medicalcenter.controller.doctorControllers;

import com.medicalcenter.dao.AppointmentDAO;
import com.medicalcenter.dao.DoctorDAO;
import com.medicalcenter.model.Appointment;
import com.medicalcenter.model.Doctor;
import com.medicalcenter.model.User;
import com.medicalcenter.service.DoctorService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/doctor/appointments/update-status")
public class AppointmentStatusUpdateServlet extends HttpServlet {
    
    private AppointmentDAO appointmentDAO;
    private DoctorService doctorDAO;
    
    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
        doctorDAO = new DoctorService();
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
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get doctor information
            Doctor doctor = doctorDAO.getDoctorByUserId(user.getId());
            
            if (doctor == null) {
                session.setAttribute("errorMessage", "Profil médecin non trouvé.");
                response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                return;
            }
            
            // Get parameters
            String appointmentIdStr = request.getParameter("appointmentId");
            String newStatus = request.getParameter("status");
            String notes = request.getParameter("notes");
            
            if (appointmentIdStr == null || newStatus == null) {
                session.setAttribute("errorMessage", "Paramètres manquants.");
                response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                return;
            }
            
            int appointmentId = Integer.parseInt(appointmentIdStr);
            
            // Get the appointment and verify it belongs to this doctor
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            
            if (appointment == null || appointment.getDoctor().getId() != doctor.getId()) {
                session.setAttribute("errorMessage", "Rendez-vous non trouvé ou non autorisé.");
                response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                return;
            }
            
            // Update appointment status
            appointment.setStatus(newStatus);
            if (notes != null && !notes.trim().isEmpty()) {
                appointment.setNotes(notes);
            }
            
            appointmentDAO.updateAppointment(appointment);
            
            session.setAttribute("successMessage", "Statut du rendez-vous mis à jour avec succès.");
            response.sendRedirect(request.getContextPath() + "/doctor/appointments");
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Une erreur est survenue lors de la mise à jour: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/doctor/appointments");
        }
    }
}
