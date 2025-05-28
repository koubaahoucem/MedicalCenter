package com.medicalcenter.controller.patientControllers;

import com.medicalcenter.dao.MedicalRecordDAO;
import com.medicalcenter.dao.MedicalDocumentDAO;
import com.medicalcenter.dao.PatientDAO;
import com.medicalcenter.model.*;

import com.medicalcenter.service.AppointmentService;
import com.medicalcenter.service.MedicalRecordService;
import com.medicalcenter.service.PrescriptionService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Calendar;

@WebServlet("/patient/medical-record")
public class MedicalRecordServlet extends HttpServlet {
    private MedicalRecordDAO medicalRecordDAO;
    private MedicalDocumentDAO medicalDocumentDAO;
    private PatientDAO patientDAO;
    private AppointmentService appointmentService;
    private MedicalRecordService medicalRecordService;
    private PrescriptionService prescriptionService;

    @Override
    public void init() throws ServletException {
        medicalRecordDAO = new MedicalRecordDAO();
        medicalDocumentDAO = new MedicalDocumentDAO();
        patientDAO = new PatientDAO();
        appointmentService = new AppointmentService();
        medicalRecordService = new MedicalRecordService();
        prescriptionService = new PrescriptionService();
    }

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
            // Get patient information
            Patient patient = patientDAO.getPatientByUserId(user.getId());
            if (patient == null) {
                request.setAttribute("error", "Patient information not found.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            // Calculate patient statistics
            int totalAppointments = appointmentService.getAppointmentsByPatient(patient.getId()).size();
            int totalMedicalRecords = medicalRecordService.getMedicalRecordsByPatientID(patient.getId()).size();

            // Set additional attributes
            request.setAttribute("totalAppointments", totalAppointments);
            request.setAttribute("totalMedicalRecords", totalMedicalRecords);

            // Calculate age if birth date is available
            if (patient.getBirthDate() != null) {
                Calendar birthCalendar = Calendar.getInstance();
                birthCalendar.setTime(patient.getBirthDate());
                Calendar today = Calendar.getInstance();
                int age = today.get(Calendar.YEAR) - birthCalendar.get(Calendar.YEAR);
                if (today.get(Calendar.DAY_OF_YEAR) < birthCalendar.get(Calendar.DAY_OF_YEAR)) {
                    age--;
                }
                request.setAttribute("patientAge", age);
            }

            // Get medical records for the patient
            List<MedicalRecord> medicalRecords = medicalRecordDAO.getMedicalRecordsByPatientId(patient.getId());

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

            // Get medical documents for the current record
            List<MedicalDocument> documents = new ArrayList<>();
            if (currentRecord != null) {
                documents = medicalDocumentDAO.getMedicalDocumentsByRecordId(currentRecord.getId());
            }

            // Get all prescriptions from all records and sort by date
            List<Prescription> allPrescriptions = prescriptionService.getAllPrescriptionsByPatientId(patient.getId());
            if (medicalRecords != null) {
                // Sort prescriptions by prescribed date (most recent first)
                Collections.sort(allPrescriptions, new Comparator<Prescription>() {
                    @Override
                    public int compare(Prescription p1, Prescription p2) {
                        return p2.getPrescribedDate().compareTo(p1.getPrescribedDate());
                    }
                });
            }


            // Set attributes for JSP
            session.setAttribute("patient", patient);
            session.setAttribute("currentRecord", currentRecord);
            session.setAttribute("medicalRecords", medicalRecords);
            session.setAttribute("documents", documents);
            session.setAttribute("currentPrescriptions", allPrescriptions);
            session.setAttribute("allPrescriptions", allPrescriptions);
            session.setAttribute("activePage", "medical-record");

            // Forward to JSP
            response.sendRedirect(request.getContextPath() + "/patient/medical-record.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading your medical record: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
