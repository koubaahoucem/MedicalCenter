package com.medicalcenter.controller.patientControllers;

import com.medicalcenter.dao.DoctorDAO;
import com.medicalcenter.dao.PatientDAO;
import com.medicalcenter.dao.PatientDoctorDAO;
import com.medicalcenter.model.Doctor;
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

@WebServlet("/patient/doctors")
public class PatientAddDoctorServlet extends HttpServlet {
    
    private DoctorDAO doctorDAO;
    private PatientDAO patientDAO;
    private PatientDoctorDAO patientDoctorDAO;
    
    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAO();
        patientDAO = new PatientDAO();
        patientDoctorDAO = new PatientDoctorDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        try {
            Patient patient = patientDAO.getPatientByUserId(user.getId());
            if (patient == null) {
                request.setAttribute("errorMessage", "Profil patient non trouvé.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            
            // Get search parameters
            String searchTerm = request.getParameter("search");
            String specialtyId = request.getParameter("specialtyId");
            
            // Get all doctors or search results
            List<Doctor> availableDoctors;
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                availableDoctors = doctorDAO.searchDoctors(searchTerm.trim());
            } else  {
                availableDoctors = doctorDAO.getAllDoctors();
            }
            
            // Get patient's current doctors
            List<Doctor> patientDoctors = doctorDAO.getDoctorsByPatient(patient.getId());
            
            // Remove already associated doctors from available list
            availableDoctors.removeAll(patientDoctors);
            
            // Set attributes
            session.setAttribute("user", user);
            session.setAttribute("patient", patient);
            session.setAttribute("availableDoctors", availableDoctors);
            session.setAttribute("patientDoctors", patientDoctors);
            session.setAttribute("searchTerm", searchTerm);
            session.setAttribute("selectedSpecialtyId", specialtyId);
            
            response.sendRedirect(request.getContextPath() + "/patient/add-doctor.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur est survenue: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        try {
            Patient patient = patientDAO.getPatientByUserId(user.getId());
            if (patient == null) {
                request.setAttribute("errorMessage", "Profil patient non trouvé.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            
            String action = request.getParameter("action");
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            
            if ("add".equals(action)) {
                // Add doctor to patient
                patientDoctorDAO.addDoctorToPatient(patient.getId(), doctorId);
                session.setAttribute("successMessage", "Médecin ajouté avec succès à votre liste.");
            } else if ("remove".equals(action)) {
                // Remove doctor from patient
                patientDoctorDAO.removeDoctorFromPatient(patient.getId(), doctorId);
                session.setAttribute("successMessage", "Médecin retiré de votre liste.");
            }
            
            response.sendRedirect(request.getContextPath() + "/patient/doctors");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur est survenue: " + e.getMessage());
            doGet(request, response);
        }
    }
}
