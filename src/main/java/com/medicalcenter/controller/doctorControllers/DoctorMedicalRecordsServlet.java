package com.medicalcenter.controller.doctorControllers;

import com.medicalcenter.model.*;
import com.medicalcenter.service.DoctorService;
import com.medicalcenter.service.MedicalRecordService;
import com.medicalcenter.service.PatientService;
import com.medicalcenter.service.PrescriptionService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/doctor/medical-records")
public class DoctorMedicalRecordsServlet extends HttpServlet {
    
    private PatientService patientService;
    private MedicalRecordService medicalRecordService;
    private DoctorService doctorService;
    private PrescriptionService prescriptionService;
    
    @Override
    public void init() throws ServletException {
        patientService = new PatientService();
        medicalRecordService = new MedicalRecordService();
        doctorService = new DoctorService();
        prescriptionService = new PrescriptionService();
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
            response.sendRedirect(request.getContextPath() + "/login");
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
            
            // Get patient ID from request
            String patientIdParam = request.getParameter("patientId");
            if (patientIdParam == null || patientIdParam.isEmpty()) {
                request.setAttribute("errorMessage", "ID patient manquant.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            
            int patientId;
            try {
                patientId = Integer.parseInt(patientIdParam);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "ID patient invalide.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            
            // Get patient information
            Patient patient = patientService.getPatientById(patientId);
            if (patient == null) {
                request.setAttribute("errorMessage", "Patient non trouvé.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            
            // Get all medical records for the patient
            List<MedicalRecord> medicalRecords = medicalRecordService.getMedicalRecordsByPatientId(patientId);
            
            // Get the most recent active medical record
            MedicalRecord currentRecord = null;
            if (medicalRecords != null && !medicalRecords.isEmpty()) {
                for (MedicalRecord record : medicalRecords) {
                    if (record.isActive()) {
                        currentRecord = record;
                        break;
                    }
                }
                // If no active record, get the most recent one
                if (currentRecord == null) {
                    currentRecord = medicalRecords.get(0);
                }
            }
            List<Prescription> prescriptions = prescriptionService.getPrescriptionByMedicalRecord(currentRecord.getId());
            // Set attributes for JSP
            session.setAttribute("user", user);
            session.setAttribute("doctor", doctor);
            session.setAttribute("patient", patient);
            session.setAttribute("medicalRecords", medicalRecords);
            session.setAttribute("currentRecord", currentRecord);
            session.setAttribute("prescriptions", prescriptions);

            // Forward to the medical records JSP
            response.sendRedirect(request.getContextPath() + "/doctor/medical-records.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur est survenue lors du chargement du dossier médical: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
}
