package com.medicalcenter.controller.patientControllers;

import com.medicalcenter.dao.PatientDAO;
import com.medicalcenter.dao.PrescriptionDAO;
import com.medicalcenter.model.Patient;
import com.medicalcenter.model.Prescription;
import com.medicalcenter.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/patient/prescriptions")
public class PrescriptionListServlet extends HttpServlet {

    private PrescriptionDAO prescriptionDAO;
    private PatientDAO patientDAO;

    @Override
    public void init() throws ServletException {
        prescriptionDAO = new PrescriptionDAO();
        patientDAO = new PatientDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            // Get patient information
            Patient patient = patientDAO.getPatientByUserId(user.getId());

            if (patient == null) {
                request.setAttribute("errorMessage", "Profil patient non trouvé.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            // Get all prescriptions for the patient
            List<Prescription> prescriptions = prescriptionDAO.getPrescriptionsByPatient(patient.getId());

            // Get selected prescription if any
            String prescriptionIdParam = request.getParameter("id");
            Prescription selectedPrescription = null;

            if (prescriptionIdParam != null && !prescriptionIdParam.isEmpty()) {
                try {
                    int prescriptionId = Integer.parseInt(prescriptionIdParam);
                    selectedPrescription = prescriptionDAO.getPrescriptionById(prescriptionId);
                } catch (NumberFormatException e) {
                    // Invalid ID format, ignore
                }
            }

            // If no prescription is selected and there are prescriptions, select the first one
            if (selectedPrescription == null && !prescriptions.isEmpty()) {
                selectedPrescription = prescriptions.get(0);
            }

            // Set attributes for JSP
            session.setAttribute("user", user);
            session.setAttribute("patient", patient);
            session.setAttribute("prescriptions", prescriptions);
            session.setAttribute("selectedPrescription", selectedPrescription);

            // Forward to the prescriptions list JSP
            response.sendRedirect(request.getContextPath() + "/patient/prescriptions-list.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur est survenue lors du chargement des ordonnances: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
}

