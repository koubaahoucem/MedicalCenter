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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@WebServlet("/patient/appointment-create")
public class AppointmentCreationServlet extends HttpServlet {
    
    private DoctorDAO doctorDAO;
    private PatientDAO patientDAO;
    private AppointmentDAO appointmentDAO;
    private SpecialityDAO specialtyDAO;
    
    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAO();
        patientDAO = new PatientDAO();
        appointmentDAO = new AppointmentDAO();
        specialtyDAO = new SpecialityDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get all doctors
            List<Doctor> doctors = doctorDAO.getAllDoctors();
            session.setAttribute("doctors", doctors);
            
            // Get all specialties
            List<Specialty> specialties = specialtyDAO.getAllSpecialties();
            session.setAttribute("specialties", specialties);
            
            // Forward to the appointment form
            response.sendRedirect(request.getContextPath() + "/patient/appointment-form.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur est survenue lors du chargement du formulaire de rendez-vous: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
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
            // Get form parameters
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String appointmentDateStr = request.getParameter("appointmentDate");
            String appointmentTimeStr = request.getParameter("appointmentTime");
            String reason = request.getParameter("reason");
            String location = request.getParameter("location");
            boolean isTeleconsultation = request.getParameter("teleconsultation") != null;
            
            // Validate inputs
            if (doctorId <= 0 || appointmentDateStr == null || appointmentDateStr.isEmpty() || 
                appointmentTimeStr == null || appointmentTimeStr.isEmpty() || 
                reason == null || reason.isEmpty() || 
                location == null || location.isEmpty()) {
                
                request.setAttribute("errorMessage", "Tous les champs sont obligatoires.");
                doGet(request, response);
                return;
            }
            
            // Parse date and time
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            Date appointmentDate = dateFormat.parse(appointmentDateStr);
            
            // Combine date and time
            String[] timeParts = appointmentTimeStr.split(":");
            int hour = Integer.parseInt(timeParts[0]);
            int minute = Integer.parseInt(timeParts[1]);
            
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(appointmentDate);
            calendar.set(Calendar.HOUR_OF_DAY, hour);
            calendar.set(Calendar.MINUTE, minute);
            calendar.set(Calendar.SECOND, 0);
            
            Date startTime = calendar.getTime();
            
            // Calculate end time (default: 30 minutes)
            calendar.add(Calendar.MINUTE, 30);
            Date endTime = calendar.getTime();
            
            // Get doctor and patient
            Doctor doctor = doctorDAO.getDoctorById(doctorId);
            Patient patient = patientDAO.getPatientByUserId(user.getId());
            
            if (doctor == null || patient == null) {
                request.setAttribute("errorMessage", "Médecin ou patient introuvable.");
                doGet(request, response);
                return;
            }
            
//            // Check if the time slot is available
//            if (!isTimeSlotAvailable(doctor, startTime, endTime)) {
//                request.setAttribute("errorMessage", "Ce créneau horaire n'est plus disponible. Veuillez en choisir un autre.");
//                doGet(request, response);
//                return;
//            }
            
            // Create appointment
            Appointment appointment = new Appointment(doctor, patient, startTime, endTime);
            appointment.setReason(reason);
            appointment.setLocation(location);
            appointment.setTeleconsultation(isTeleconsultation);
            appointment.setStatus("Scheduled");
            
            // Save appointment
            appointmentDAO.saveAppointment(appointment);
            
            // Set success message and redirect to appointments list
            session.setAttribute("successMessage", "Votre rendez-vous a été pris avec succès pour le " + 
                                 dateFormat.format(appointmentDate) + " à " + appointmentTimeStr + ".");
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
            
        } catch (ParseException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Format de date ou d'heure invalide.");
            doGet(request, response);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Identifiant de médecin invalide.");
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur est survenue lors de la prise de rendez-vous: " + e.getMessage());
            doGet(request, response);
        }
    }
    
    private boolean isTimeSlotAvailable(Doctor doctor, Date startTime, Date endTime) {
        // Check if the doctor has any overlapping appointments
        List<Appointment> doctorAppointments = appointmentDAO.getAppointmentsByDoctorAndDateRange(
            doctor.getId(), startTime, endTime);
        
        return doctorAppointments.isEmpty();
    }
}
