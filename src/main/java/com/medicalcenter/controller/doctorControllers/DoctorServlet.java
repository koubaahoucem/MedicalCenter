package com.medicalcenter.controller.doctorControllers;

import com.medicalcenter.dao.DoctorDAO;
import com.medicalcenter.model.Doctor;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/doctors")
public class DoctorServlet extends HttpServlet {
    
    private DoctorDAO doctorDAO;
    
    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {

            List<Doctor> doctors;
            doctors = doctorDAO.getAllDoctors();

            
            // Convert to JSON
            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.append("[");
            
            for (int i = 0; i < doctors.size(); i++) {
                Doctor doctor = doctors.get(i);
                jsonBuilder.append("{");
                jsonBuilder.append("\"id\":").append(doctor.getId()).append(",");
                jsonBuilder.append("\"firstName\":\"").append(doctor.getFirstName()).append("\",");
                jsonBuilder.append("\"lastName\":\"").append(doctor.getLastName()).append("\"");
                jsonBuilder.append("}");
                
                if (i < doctors.size() - 1) {
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
