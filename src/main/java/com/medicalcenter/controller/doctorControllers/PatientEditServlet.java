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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/doctor/patients/edit")
public class PatientEditServlet extends HttpServlet {
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

            // Get patient ID
            String patientIdStr = request.getParameter("id");
            if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/doctor/patients");
                return;
            }

            int patientId = Integer.parseInt(patientIdStr);
            Patient patient = patientDAO.getPatientById(patientId);

            if (patient == null) {
                request.setAttribute("error", "Patient non trouvé");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // Verify that this patient belongs to this doctor
            if (!patientDAO.isPatientOfDoctor(patientId, doctor.getId())) {
                request.setAttribute("error", "Accès non autorisé à ce patient");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            session.setAttribute("patient", patient);
            session.setAttribute("doctor", doctor);
            response.sendRedirect(request.getContextPath() + "/doctor/patient-edit.jsp");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/doctor/patients");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement du patient: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {


        HttpSession session = request.getSession();

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get current user from session
        User user = (User) session.getAttribute("user");
        // Security check
        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        try {
            // Get doctor information
            Doctor doctor = doctorDAO.getDoctorByUserId(user.getId());
            if (doctor == null) {
                request.setAttribute("error", "Informations du docteur non trouvées");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // Get patient ID
            String patientIdStr = request.getParameter("patientId");
            if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/doctor/patients");
                return;
            }

            int patientId = Integer.parseInt(patientIdStr);
            Patient patient = patientDAO.getPatientById(patientId);

            if (patient == null) {
                request.setAttribute("error", "Patient non trouvé");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // Verify that this patient belongs to this doctor
            if (!patientDAO.isPatientOfDoctor(patientId, doctor.getId())) {
                request.setAttribute("error", "Accès non autorisé à ce patient");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // Get form parameters
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String birthDateStr = request.getParameter("birthDate");

            // Validation
            if (firstName == null || firstName.trim().isEmpty() ||
                lastName == null || lastName.trim().isEmpty()) {
                session.setAttribute("error", "Le prénom et le nom sont obligatoires");
                session.setAttribute("patient", patient);
                response.sendRedirect(request.getContextPath() + "/doctor/patient-edit.jsp");
                return;
            }

            // Update patient information
            patient.setFirstName(firstName.trim());
            patient.setLastName(lastName.trim());
            patient.setPhone(phone != null ? phone.trim() : null);
            patient.setAddress(address != null ? address.trim() : null);

            // Parse birth date
            if (birthDateStr != null && !birthDateStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date birthDate = sdf.parse(birthDateStr);
                    patient.setBirthDate(birthDate);
                } catch (ParseException e) {
                    session.setAttribute("error", "Format de date de naissance invalide");
                    session.setAttribute("patient", patient);
                    response.sendRedirect(request.getContextPath() + "/doctor/patient-edit.jsp");
                    return;
                }
            }

            // Update patient in database
            boolean success = patientDAO.updatePatient(patient);

            if (success) {
                session.setAttribute("success", "Informations du patient mises à jour avec succès");
                response.sendRedirect(request.getContextPath() + "/doctor/patients?updated=true");
            } else {
                session.setAttribute("error", "Erreur lors de la mise à jour du patient");
                session.setAttribute("patient", patient);
                response.sendRedirect(request.getContextPath() + "/doctor/patient-edit.jsp");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/doctor/patients");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la mise à jour: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
