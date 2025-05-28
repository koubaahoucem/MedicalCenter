package com.medicalcenter.service;

import com.medicalcenter.config.HibernateUtil;
import com.medicalcenter.dao.AppointmentDAO;
import com.medicalcenter.dao.DoctorDAO;
import com.medicalcenter.dao.PatientDAO;
import com.medicalcenter.model.Appointment;
import com.medicalcenter.model.Doctor;
import com.medicalcenter.model.Patient;
import org.hibernate.Session;
import org.hibernate.query.Query;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class AppointmentService {
    
    private AppointmentDAO appointmentDAO;
    private DoctorDAO doctorDAO;
    private PatientDAO patientDAO;
    
    public AppointmentService() {
        appointmentDAO = new AppointmentDAO();
        doctorDAO = new DoctorDAO();
        patientDAO = new PatientDAO();
    }
    
    /**
     * Create a new appointment
     */
    public boolean createAppointment(int userId, int doctorId, String dateStr, String timeStr, 
                                    String reason, String location, boolean isTeleconsultation) 
                                    throws ParseException {
        
        // Get doctor and patient
        Doctor doctor = doctorDAO.getDoctorById(doctorId);
        Patient patient = patientDAO.getPatientByUserId(userId);
        
        if (doctor == null || patient == null) {
            return false;
        }
        
        // Parse date and time
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        Date appointmentDate = dateFormat.parse(dateStr);
        
        // Combine date and time
        String[] timeParts = timeStr.split(":");
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
        if (!isTimeSlotAvailable(doctor, startTime, endTime)) {
            return false;
        }
        
        // Create appointment
        Appointment appointment = new Appointment();
        appointment.setDoctor(doctor);
        appointment.setPatient(patient);
        appointment.setStartTime(startTime);
        appointment.setEndTime(endTime);
        appointment.setReason(reason);
        appointment.setLocation(location);
        appointment.setTeleconsultation(isTeleconsultation);
        appointment.setStatus("Scheduled");
        
        // Save appointment
        appointmentDAO.saveAppointment(appointment);
        
        return true;
    }
    
    /**
     * Get available time slots for a doctor on a specific date
     */
    public List<String> getAvailableTimes(int doctorId, String dateStr) throws ParseException {
        // Parse date
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        Date date = dateFormat.parse(dateStr);
        
        // Get doctor
        Doctor doctor = doctorDAO.getDoctorById(doctorId);
        if (doctor == null) {
            return new ArrayList<>();
        }
        
        // Set up the calendar for the selected date
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        
        // Reset time to start of day
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        
        // Define working hours (9:00 - 17:00)
        int startHour = 9;
        int endHour = 17;
        
        // Define slot duration in minutes
        int slotDuration = 30;
        
        // Get all appointments for the doctor on the selected date
        Calendar endOfDay = (Calendar) calendar.clone();
        endOfDay.add(Calendar.DAY_OF_MONTH, 1);
        
        List<Appointment> doctorAppointments = appointmentDAO.getAppointmentsByDoctorAndDateRange(
            doctorId, calendar.getTime(), endOfDay.getTime());
        
        // Generate available time slots
        List<String> availableTimes = new ArrayList<>();
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
        
        for (int hour = startHour; hour < endHour; hour++) {
            for (int minute = 0; minute < 60; minute += slotDuration) {
                Calendar slotStart = (Calendar) calendar.clone();
                slotStart.set(Calendar.HOUR_OF_DAY, hour);
                slotStart.set(Calendar.MINUTE, minute);
                
                Calendar slotEnd = (Calendar) slotStart.clone();
                slotEnd.add(Calendar.MINUTE, slotDuration);
                
                // Check if the slot is available
                if (isTimeSlotAvailable(doctorAppointments, slotStart.getTime(), slotEnd.getTime())) {
                    availableTimes.add(timeFormat.format(slotStart.getTime()));
                }
            }
        }
        
        return availableTimes;
    }
    
    /**
     * Check if a time slot is available for a doctor
     */
    private boolean isTimeSlotAvailable(Doctor doctor, Date startTime, Date endTime) {
        List<Appointment> doctorAppointments = appointmentDAO.getAppointmentsByDoctorAndDateRange(
            doctor.getId(), startTime, endTime);
        
        return isTimeSlotAvailable(doctorAppointments, startTime, endTime);
    }
    
    /**
     * Check if a time slot is available based on existing appointments
     */
    private boolean isTimeSlotAvailable(List<Appointment> appointments, Date startTime, Date endTime) {
        for (Appointment appointment : appointments) {
            // Check if the appointment overlaps with the time slot
            if ((appointment.getStartTime().before(endTime) && appointment.getEndTime().after(startTime)) ||
                appointment.getStartTime().equals(startTime)) {
                return false;
            }
        }
        
        return true;
    }

    public List<Appointment> getAppointmentsByPatient(int patientId) {
        return appointmentDAO.getAppointmentsByPatient(patientId);
    }


    /**
     * Cancel an appointment
     */
    public boolean cancelAppointment(int appointmentId, int patientId) {
        try {
            // Get the appointment
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            if (appointment == null) {
                return false;
            }

            // Verify that the appointment belongs to the patient
            if (appointment.getPatient().getId() != patientId) {
                return false;
            }

            // Check if appointment is already cancelled
            if ("Cancelled".equalsIgnoreCase(appointment.getStatus())) {
                return false;
            }

            // Check if appointment is in the past
            if (appointment.getStartTime().before(new Date())) {
                return false;
            }

            // Cancel the appointment
            appointmentDAO.cancelAppointment(appointmentId);

            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Check if an appointment can be cancelled
     */
    public boolean canCancelAppointment(int appointmentId, int patientId) {
        try {
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            if (appointment == null) {
                return false;
            }

            // Check ownership
            if (appointment.getPatient().getId() != patientId) {
                return false;
            }

            // Check if already cancelled
            if ("Cancelled".equalsIgnoreCase(appointment.getStatus())) {
                return false;
            }

            // Check if in the past
            if (appointment.getStartTime().before(new Date())) {
                return false;
            }

            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getAppointmentsThisMonth() {
        return appointmentDAO.getAppointmentsThisMonth().size();
    }

    public List<Appointment> getAppointmentsByDoctor(int id) {
        return appointmentDAO.getAppointmentsByDoctor(id);
    }

    public void saveAppointment(Appointment appointment) {
        appointmentDAO.saveAppointment(appointment);
    }

    public List<Appointment> getAppointmentsByDoctorAndDateRange(int id, Date startTime, Date endTime) {
        return appointmentDAO.getAppointmentsByDoctorAndDateRange(id, startTime, endTime);
    }
}
