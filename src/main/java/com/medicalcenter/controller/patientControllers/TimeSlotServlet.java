package com.medicalcenter.controller.patientControllers;

import com.medicalcenter.dao.AppointmentDAO;
import com.medicalcenter.dao.DoctorDAO;
import com.medicalcenter.model.Appointment;
import com.medicalcenter.model.Doctor;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/api/timeslots")
public class TimeSlotServlet extends HttpServlet {
    
    private DoctorDAO doctorDAO;
    private AppointmentDAO appointmentDAO;
    
    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAO();
        appointmentDAO = new AppointmentDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            // Get parameters
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String dateStr = request.getParameter("date");
            
            // Parse date
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            Date date = dateFormat.parse(dateStr);
            
            // Get doctor
            Doctor doctor = doctorDAO.getDoctorById(doctorId);
            
            if (doctor == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\": \"Doctor not found\"}");
                return;
            }
            
            // Get available time slots
            List<Map<String, Object>> timeSlots = getAvailableTimeSlots(doctor, date);
            
            // Convert to JSON
            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.append("[");
            
            for (int i = 0; i < timeSlots.size(); i++) {
                Map<String, Object> slot = timeSlots.get(i);
                jsonBuilder.append("{");
                jsonBuilder.append("\"time\": \"").append(slot.get("time")).append("\",");
                jsonBuilder.append("\"available\": ").append(slot.get("available"));
                jsonBuilder.append("}");
                
                if (i < timeSlots.size() - 1) {
                    jsonBuilder.append(",");
                }
            }
            
            jsonBuilder.append("]");
            
            out.print(jsonBuilder.toString());
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Invalid doctor ID\"}");
        } catch (ParseException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Invalid date format\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    private List<Map<String, Object>> getAvailableTimeSlots(Doctor doctor, Date date) {
        List<Map<String, Object>> timeSlots = new ArrayList<>();
        
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
            doctor.getId(), calendar.getTime(), endOfDay.getTime());
        
        // Generate time slots
        for (int hour = startHour; hour < endHour; hour++) {
            for (int minute = 0; minute < 60; minute += slotDuration) {
                Calendar slotStart = (Calendar) calendar.clone();
                slotStart.set(Calendar.HOUR_OF_DAY, hour);
                slotStart.set(Calendar.MINUTE, minute);
                
                Calendar slotEnd = (Calendar) slotStart.clone();
                slotEnd.add(Calendar.MINUTE, slotDuration);
                
                // Check if the slot is available
                boolean isAvailable = isTimeSlotAvailable(doctorAppointments, slotStart.getTime(), slotEnd.getTime());
                
                // Format time
                SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
                String timeStr = timeFormat.format(slotStart.getTime());
                
                // Add to list
                Map<String, Object> slot = new HashMap<>();
                slot.put("time", timeStr);
                slot.put("available", isAvailable);
                
                timeSlots.add(slot);
            }
        }
        
        return timeSlots;
    }
    
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
}
