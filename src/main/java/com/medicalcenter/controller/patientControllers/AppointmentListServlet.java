package com.medicalcenter.controller.patientControllers;

import com.medicalcenter.dao.AppointmentDAO;
import com.medicalcenter.dao.PatientDAO;
import com.medicalcenter.model.Appointment;
import com.medicalcenter.model.Patient;
import com.medicalcenter.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/patient/appointments")
public class AppointmentListServlet extends HttpServlet {
    
    private AppointmentDAO appointmentDAO;
    private PatientDAO patientDAO;
    
    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
        patientDAO = new PatientDAO();
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
            // Get patient information
            Patient patient = patientDAO.getPatientByUserId(user.getId());
            
            if (patient == null) {
                request.setAttribute("errorMessage", "Profil patient non trouvé.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            
            // Get all appointments for the patient
            List<Appointment> appointments = appointmentDAO.getAppointmentsByPatient(patient.getId());
            
            // Set attributes for JSP
            session.setAttribute("user", user);
            session.setAttribute("patient", patient);
            session.setAttribute("appointments", appointments);
            session.setAttribute("activePage", "appointments");
            // Forward to the appointments list JSP
            response.sendRedirect(request.getContextPath() + "/patient/appointments-list.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur est survenue lors du chargement des rendez-vous: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
}
