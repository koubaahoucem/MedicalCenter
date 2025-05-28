package com.medicalcenter.controller.doctorControllers;

import com.medicalcenter.dao.DoctorDAO;
import com.medicalcenter.dao.AppointmentDAO;
import com.medicalcenter.dao.PatientDAO;
import com.medicalcenter.dao.PrescriptionDAO;
import com.medicalcenter.model.Doctor;
import com.medicalcenter.model.Appointment;
import com.medicalcenter.model.Patient;

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
import java.util.Date;
import java.util.List;
import java.util.Calendar;
import java.util.stream.Collectors;

@WebServlet("/doctor/dashboard")
public class DashboardServlet extends HttpServlet {

    private DoctorService doctorDAO = new DoctorService();
    private AppointmentService appointmentDAO = new AppointmentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get current user from session
        User user = (User) session.getAttribute("user");


        try {
            // Get doctor information
            Doctor doctor = doctorDAO.getDoctorByUserId(user.getId());
            if (doctor == null) {
                request.setAttribute("error", "Informations du médecin non trouvées");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // Get today's date range
            Calendar today = Calendar.getInstance();
            today.set(Calendar.HOUR_OF_DAY, 0);
            today.set(Calendar.MINUTE, 0);
            today.set(Calendar.SECOND, 0);
            today.set(Calendar.MILLISECOND, 0);
            Date startOfDay = today.getTime();

            today.set(Calendar.HOUR_OF_DAY, 23);
            today.set(Calendar.MINUTE, 59);
            today.set(Calendar.SECOND, 59);
            Date endOfDay = today.getTime();

            // Get all doctor's appointments
            List<Appointment> allAppointments = appointmentDAO.getAppointmentsByDoctor(doctor.getId());

            // Filter today's appointments
            List<Appointment> todayAppointments = allAppointments.stream()
                    .filter(apt -> apt.getStartTime().after(startOfDay) && apt.getStartTime().before(endOfDay))
                    .collect(Collectors.toList());

            // Count appointments by status
            long todayCount = todayAppointments.size();
            long pendingCount = allAppointments.stream()
                    .filter(apt -> "Pending".equals(apt.getStatus()) || "Scheduled".equals(apt.getStatus()))
                    .count();
            long completedThisMonth = getCompletedAppointmentsThisMonth(allAppointments);

            // Get doctor's patients count
            List<Patient> doctorPatients = getDoctorPatients(doctor.getId());
            int totalPatients = doctorPatients.size();

            // Get recent patients (last 5)
            List<Patient> recentPatients = doctorPatients.stream()
                    .limit(5)
                    .collect(Collectors.toList());

            // Set attributes for JSP
            session.setAttribute("doctor", doctor);
            session.setAttribute("todayAppointmentsCount", todayCount);
            session.setAttribute("totalPatients", totalPatients);
            session.setAttribute("pendingAppointments", pendingCount);
            session.setAttribute("completedThisMonth", completedThisMonth);
            session.setAttribute("todayAppointments", todayAppointments);
            session.setAttribute("recentPatients", recentPatients);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement du tableau de bord: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/doctor/dashboard.jsp");
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
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

    private List<Patient> getDoctorPatients(int doctorId) {
        // Get unique patients from doctor's appointments
        List<Appointment> appointments = appointmentDAO.getAppointmentsByDoctor(doctorId);
        return appointments.stream()
                .map(Appointment::getPatient)
                .distinct()
                .collect(Collectors.toList());
    }
}
