package com.medicalcenter.controller.doctorControllers;

import com.medicalcenter.dao.AppointmentDAO;
import com.medicalcenter.dao.DoctorDAO;
import com.medicalcenter.model.Appointment;
import com.medicalcenter.model.Doctor;
import com.medicalcenter.model.User;
import com.medicalcenter.service.AppointmentService;
import com.medicalcenter.service.DoctorService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/doctor/appointments")
public class AppointmentsListServlet extends HttpServlet {

    private AppointmentService appointmentDAO;
    private DoctorService doctorDAO;

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentService();
        doctorDAO = new DoctorService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
                request.setAttribute("errorMessage", "Profil médecin non trouvé.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            // Get all appointments for the doctor
            List<Appointment> appointments = appointmentDAO.getAppointmentsByDoctor(doctor.getId());

            // Set attributes for JSP
            session.setAttribute("user", user);
            session.setAttribute("doctor", doctor);
            session.setAttribute("appointments", appointments);

            // Forward to the appointments JSP
            response.sendRedirect(request.getContextPath() + "/doctor/appointments.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur est survenue lors du chargement des rendez-vous: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
}
