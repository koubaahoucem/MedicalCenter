package com.medicalcenter.controller.patientControllers;

import com.medicalcenter.service.AppointmentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/api/available-times")
public class AvailableTimesApiServlet extends HttpServlet {
    
    private AppointmentService appointmentService;
    
    @Override
    public void init() throws ServletException {
        appointmentService = new AppointmentService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            String doctorId = request.getParameter("doctorId");
            String date = request.getParameter("date");
            
            if (doctorId == null || doctorId.isEmpty() || date == null || date.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"Missing required parameters\"}");
                return;
            }
            
            List<String> availableTimes = appointmentService.getAvailableTimes(
                Integer.parseInt(doctorId), 
                date
            );
            
            // Convert to JSON
            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.append("[");
            
            for (int i = 0; i < availableTimes.size(); i++) {
                jsonBuilder.append("\"").append(availableTimes.get(i)).append("\"");
                
                if (i < availableTimes.size() - 1) {
                    jsonBuilder.append(",");
                }
            }
            
            jsonBuilder.append("]");
            out.print(jsonBuilder.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}
