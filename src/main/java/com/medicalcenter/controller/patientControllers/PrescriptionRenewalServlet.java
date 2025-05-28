package com.medicalcenter.controller.patientControllers;

import com.medicalcenter.dao.DoctorDAO;
import com.medicalcenter.dao.PatientDAO;
import com.medicalcenter.dao.PrescriptionDAO;
import com.medicalcenter.dao.PrescriptionRenewalRequestDAO;
import com.medicalcenter.model.Doctor;
import com.medicalcenter.model.Patient;
import com.medicalcenter.model.Prescription;
import com.medicalcenter.model.PrescriptionRenewalRequest;
import com.medicalcenter.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet("/patient/prescriptions/renew/*")
public class PrescriptionRenewalServlet extends HttpServlet {

    private PrescriptionDAO prescriptionDAO;
    private PatientDAO patientDAO;
    private DoctorDAO doctorDAO;
    private PrescriptionRenewalRequestDAO renewalRequestDAO;

    @Override
    public void init() throws ServletException {
        prescriptionDAO = new PrescriptionDAO();
        patientDAO = new PatientDAO();
        doctorDAO = new DoctorDAO();
        renewalRequestDAO = new PrescriptionRenewalRequestDAO();
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
            // Get prescription ID from path
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID d'ordonnance manquant");
                return;
            }

            int prescriptionId = Integer.parseInt(pathInfo.substring(1));

            // Get prescription
            Prescription prescription = prescriptionDAO.getPrescriptionById(prescriptionId);
            if (prescription == null) {
                request.setAttribute("errorMessage", "Ordonnance non trouvée.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            // Get patient
            Patient patient = patientDAO.getPatientByUserId(user.getId());
            if (patient == null) {
                request.setAttribute("errorMessage", "Profil patient non trouvé.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            // Get available doctors for this patient
            List<Doctor> availableDoctors = doctorDAO.getDoctorsByPatient(patient.getId());

            // Set attributes
            session.setAttribute("user", user);
            session.setAttribute("patient", patient);
            session.setAttribute("prescription", prescription);
            session.setAttribute("availableDoctors", availableDoctors);

            response.sendRedirect(request.getContextPath() + "/patient/prescription-renewal.jsp");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID d'ordonnance invalide");
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
            // Get form parameters
            int prescriptionId = Integer.parseInt(request.getParameter("prescriptionId"));
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String message = request.getParameter("message");
            boolean isUrgent = Boolean.parseBoolean(request.getParameter("isUrgent"));

            // Get entities
            Patient patient = patientDAO.getPatientByUserId(user.getId());
            Prescription prescription = prescriptionDAO.getPrescriptionById(prescriptionId);
            Doctor doctor = doctorDAO.getDoctorById(doctorId);

            if (patient == null || prescription == null || doctor == null) {
                request.setAttribute("errorMessage", "Données invalides.");
                doGet(request, response);
                return;
            }

            // Create renewal request
            PrescriptionRenewalRequest renewalRequest = new PrescriptionRenewalRequest();
            renewalRequest.setPrescription(prescription);
            renewalRequest.setPatient(patient);
            renewalRequest.setDoctor(doctor);
            renewalRequest.setRequestDate(new Date());
            renewalRequest.setMessage(message);
            renewalRequest.setUrgent(isUrgent);
            renewalRequest.setStatus("Pending");

            // Save renewal request
            renewalRequestDAO.saveRenewalRequest(renewalRequest);

            // Set success message and redirect
            session.setAttribute("successMessage", "Votre demande de renouvellement a été envoyée avec succès.");
            response.sendRedirect(request.getContextPath() + "/patient/prescriptions");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur est survenue: " + e.getMessage());
            doGet(request, response);
        }
    }
}
