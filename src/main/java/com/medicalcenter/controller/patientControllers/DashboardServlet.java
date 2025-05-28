package com.medicalcenter.controller.patientControllers;

import com.medicalcenter.dao.*;
import com.medicalcenter.model.*;
import com.medicalcenter.service.SpecialityService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/patient/dashboard")
public class DashboardServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;
    private PrescriptionDAO prescriptionDAO;
    private DoctorDAO doctorDAO;
    private PatientDAO patientDAO;
    private SpecialityService specialityService;
    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
        prescriptionDAO = new PrescriptionDAO();
        doctorDAO = new DoctorDAO();
        patientDAO = new PatientDAO();
        specialityService = new SpecialityService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get current user from session
        User user = (User) session.getAttribute("user");

        try {


            // Get patient information
            Patient patient = patientDAO.getPatientByUserId(user.getId());
            // Get appointments
            List<Appointment> upcomingAppointments = appointmentDAO.getUpcomingAppointmentsByPatient(patient.getId());
            Appointment nextAppointment = upcomingAppointments.isEmpty() ? null : upcomingAppointments.get(0);

            // Get prescriptions
            List<Prescription> prescriptions = prescriptionDAO.getPrescriptionsByPatient(patient.getId());
            int prescriptionsToRenew = countPrescriptionsToRenew(prescriptions);

            // Get doctors
            List<Doctor> doctors = doctorDAO.getDoctorsByPatient(patient.getId());

            // Set attributes for JSP
            session.setAttribute("user", user); // Ensure user is available in JSP
            session.setAttribute("patient", patient); // Add patient information
            session.setAttribute("upcomingAppointments", upcomingAppointments);
            session.setAttribute("nextAppointment", nextAppointment);
            session.setAttribute("appointmentCount", upcomingAppointments.size());
            session.setAttribute("prescriptions", prescriptions);
            session.setAttribute("prescriptionCount", prescriptions.size());
            session.setAttribute("prescriptionsToRenew", prescriptionsToRenew);
            session.setAttribute("doctors", doctors);
            session.setAttribute("activePage", "dashboard");

            // Forward to dashboard JSP
            response.sendRedirect(request.getContextPath() + "/patient/dashboard.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur est survenue lors du chargement du tableau de bord: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    private int countPrescriptionsToRenew(List<Prescription> prescriptions) {
        int count = 0;

        for (Prescription prescription : prescriptions) {
            if (prescription.isExpired() || prescription.isExpiringSoon()) {
                count++;
            }
        }

        return count;
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
