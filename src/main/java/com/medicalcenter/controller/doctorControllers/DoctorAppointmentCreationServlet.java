package com.medicalcenter.controller.doctorControllers;

import com.medicalcenter.model.*;
import com.medicalcenter.service.AppointmentService;
import com.medicalcenter.service.DoctorService;
import com.medicalcenter.service.PatientService;
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

@WebServlet("/doctor/appointments/new")
public class DoctorAppointmentCreationServlet extends HttpServlet {
    
    private AppointmentService appointmentService;
    private PatientService patientService;
    private DoctorService doctorService;

    @Override
    public void init() throws ServletException {
        appointmentService = new AppointmentService();
        patientService = new PatientService();
        doctorService = new DoctorService();
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
            
            // Get patient ID from parameter
            String patientIdStr = request.getParameter("patientId");
            Patient selectedPatient = null;
            
            if (patientIdStr != null && !patientIdStr.isEmpty()) {
                try {
                    int patientId = Integer.parseInt(patientIdStr);
                    selectedPatient = patientService.getPatientById(patientId);
                    
                    // Verify that this patient is associated with the doctor
                    if (selectedPatient != null && patientService.isPatientOfDoctor(patientId, doctor.getId())) {
                        request.setAttribute("errorMessage", "Ce patient n'est pas associé à votre pratique.");
                        request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "ID patient invalide.");
                    request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                    return;
                }
            }
            
            // Get all patients for this doctor
            List<Patient> patients = patientService.getPatientsByDoctor(doctor.getId());
            
            // Set attributes for JSP
            session.setAttribute("doctor", doctor);
            session.setAttribute("patients", patients);
            session.setAttribute("selectedPatient", selectedPatient);
            session.setAttribute("appointments-new", "appointments-new");
            // Forward to appointment creation form
            response.sendRedirect(request.getContextPath() + "/doctor/appointment-create.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur est survenue lors du chargement du formulaire: " + e.getMessage());
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
            String patientIdStr = request.getParameter("patientId");
            String appointmentDateStr = request.getParameter("appointmentDate");
            String appointmentTimeStr = request.getParameter("appointmentTime");
            String reason = request.getParameter("reason");
            String location = request.getParameter("location");
            String notes = request.getParameter("notes");
            boolean isTeleconsultation = request.getParameter("teleconsultation") != null;
            
            // Validate inputs
            if (patientIdStr == null || patientIdStr.isEmpty() ||
                appointmentDateStr == null || appointmentDateStr.isEmpty() ||
                appointmentTimeStr == null || appointmentTimeStr.isEmpty() ||
                reason == null || reason.isEmpty() ||
                location == null || location.isEmpty()) {
                
                request.setAttribute("errorMessage", "Tous les champs obligatoires doivent être remplis.");
                doGet(request, response);
                return;
            }
            
            int patientId = Integer.parseInt(patientIdStr);
            Patient patient = patientService.getPatientById(patientId);
            
            if (patient == null) {
                request.setAttribute("errorMessage", "Patient introuvable.");
                doGet(request, response);
                return;
            }
            
            // Verify that this patient is associated with the doctor
            if (patientService.isPatientOfDoctor(patientId, doctor.getId())) {
                request.setAttribute("errorMessage", "Ce patient n'est pas associé à votre pratique.");
                doGet(request, response);
                return;
            }
            
            // Parse date and time
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
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
            
            // Check if the time slot is available
            List<Appointment> conflictingAppointments = appointmentService.getAppointmentsByDoctorAndDateRange(
                doctor.getId(), startTime, endTime);
            
            if (!conflictingAppointments.isEmpty()) {
                request.setAttribute("errorMessage", "Ce créneau horaire n'est pas disponible. Veuillez en choisir un autre.");
                doGet(request, response);
                return;
            }
            
            // Create appointment
            Appointment appointment = new Appointment();
            appointment.setDoctor(doctor);
            appointment.setPatient(patient);
            appointment.setStartTime(startTime);
            appointment.setEndTime(endTime);
            appointment.setReason(reason);
            appointment.setLocation(location);
            appointment.setNotes(notes);
            appointment.setTeleconsultation(isTeleconsultation);
            appointment.setStatus("Scheduled");
            
            // Save appointment
            appointmentService.saveAppointment(appointment);
            
            // Set success message and redirect
            session.setAttribute("successMessage", "Rendez-vous créé avec succès pour " + 
                               patient.getFullName() + " le " + 
                               new SimpleDateFormat("dd/MM/yyyy").format(appointmentDate) + 
                               " à " + appointmentTimeStr + ".");
            
            response.sendRedirect(request.getContextPath() + "/doctor/appointments");
            
        } catch (ParseException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Format de date ou d'heure invalide.");
            doGet(request, response);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Identifiant de patient invalide.");
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur est survenue lors de la création du rendez-vous: " + e.getMessage());
            doGet(request, response);
        }
    }
}