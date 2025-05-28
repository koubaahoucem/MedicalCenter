package com.medicalcenter.controller.patientControllers;

import com.medicalcenter.dao.AppointmentDAO;
import com.medicalcenter.dao.PatientDAO;
import com.medicalcenter.model.Appointment;
import com.medicalcenter.model.Patient;
import com.medicalcenter.model.User;
import com.medicalcenter.service.AppointmentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Date;

@WebServlet("/patient/appointments/cancel/*")
public class AppointmentCancelServlet extends HttpServlet {
    
    private AppointmentDAO appointmentDAO;
    private PatientDAO patientDAO;
    private AppointmentService appointmentService;
    
    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
        patientDAO = new PatientDAO();
        appointmentService = new AppointmentService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        try {
            // Extract appointment ID from URL path
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.length() <= 1) {
                request.setAttribute("errorMessage", "ID de rendez-vous manquant.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            
            // Remove leading slash and parse appointment ID
            String appointmentIdStr = pathInfo.substring(1);
            int appointmentId;
            
            try {
                appointmentId = Integer.parseInt(appointmentIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "ID de rendez-vous invalide.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            
            // Get patient information
            Patient patient = patientDAO.getPatientByUserId(user.getId());
            if (patient == null) {
                request.setAttribute("errorMessage", "Profil patient non trouvé.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            
            // Get the appointment
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            if (appointment == null) {
                request.setAttribute("errorMessage", "Rendez-vous non trouvé.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            
            // Verify that the appointment belongs to the current patient
            if (appointment.getPatient().getId() != patient.getId()) {
                request.setAttribute("errorMessage", "Vous n'êtes pas autorisé à annuler ce rendez-vous.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            
            // Check if appointment is already cancelled
            if ("Cancelled".equalsIgnoreCase(appointment.getStatus())) {
                request.setAttribute("errorMessage", "Ce rendez-vous est déjà annulé.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            
            // Check if appointment is in the past
            if (appointment.getStartTime().before(new Date())) {
                request.setAttribute("errorMessage", "Impossible d'annuler un rendez-vous passé.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            
            // Show confirmation page
            session.setAttribute("appointment", appointment);
            response.sendRedirect(request.getContextPath() + "/patient/appointment-cancel-confirm.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Une erreur est survenue lors du chargement de la page d'annulation: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        try {
            // Get appointment ID from form
            String appointmentIdStr = request.getParameter("appointmentId");
            if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
                session.setAttribute("errorMessage", "ID de rendez-vous manquant.");
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            }
            
            int appointmentId;
            try {
                appointmentId = Integer.parseInt(appointmentIdStr);
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "ID de rendez-vous invalide.");
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            }
            
            // Get patient information
            Patient patient = patientDAO.getPatientByUserId(user.getId());
            if (patient == null) {
                session.setAttribute("errorMessage", "Profil patient non trouvé.");
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            }
            
            // Cancel the appointment using the service
            boolean success = appointmentService.cancelAppointment(appointmentId, patient.getId());
            
            if (success) {
                session.setAttribute("successMessage", "Votre rendez-vous a été annulé avec succès.");
            } else {
                session.setAttribute("errorMessage", "Impossible d'annuler le rendez-vous. Veuillez réessayer.");
            }
            
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Une erreur est survenue lors de l'annulation du rendez-vous: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
        }
    }
}