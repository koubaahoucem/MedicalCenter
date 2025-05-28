package com.medicalcenter.controller.doctorControllers;

import com.medicalcenter.dao.PatientDAO;
import com.medicalcenter.dao.DoctorDAO;
import com.medicalcenter.model.Patient;
import com.medicalcenter.model.Doctor;

import com.medicalcenter.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/doctor/patients")
public class DoctorPatientsServlet extends HttpServlet {
    private PatientDAO patientDAO = new PatientDAO();
    private DoctorDAO doctorDAO = new DoctorDAO();

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
                request.setAttribute("error", "Informations du docteur non trouvées");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // Get search and filter parameters
            String searchQuery = request.getParameter("search");
            String ageFilter = request.getParameter("ageFilter");
            String sortBy = request.getParameter("sortBy");

            // Get patients list
            List<Patient> patients;
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                patients = patientDAO.searchPatientsByDoctor(doctor.getId(), searchQuery.trim());
            } else {
                patients = patientDAO.getPatientsByDoctor(doctor.getId());
            }

            // Apply age filter if specified
            if (ageFilter != null && !ageFilter.isEmpty()) {
                patients = patientDAO.filterPatientsByAge(patients, ageFilter);
            }

            // Apply sorting if specified
            if (sortBy != null && !sortBy.isEmpty()) {
                patients = patientDAO.sortPatients(patients, sortBy);
            }

            // Calculate statistics
            int totalPatients = patientDAO.getPatientCountByDoctor(doctor.getId());
            int newPatientsThisWeek = patientDAO.getNewPatientsCountThisWeek(doctor.getId());

            // Set attributes
            session.setAttribute("doctor", doctor);
            session.setAttribute("patients", patients);
            session.setAttribute("totalPatients", totalPatients);
            session.setAttribute("newPatientsThisWeek", newPatientsThisWeek);
            session.setAttribute("searchQuery", searchQuery);
            session.setAttribute("ageFilter", ageFilter);
            session.setAttribute("sortBy", sortBy);

            response.sendRedirect(request.getContextPath() + "/doctor/doctor-patients.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement de la liste des patients: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
