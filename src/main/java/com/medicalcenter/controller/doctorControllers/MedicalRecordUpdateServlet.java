package com.medicalcenter.controller.doctorControllers;

import com.medicalcenter.dao.MedicalRecordDAO;
import com.medicalcenter.dao.DoctorDAO;
import com.medicalcenter.dao.PatientDAO;
import com.medicalcenter.model.MedicalRecord;
import com.medicalcenter.model.Doctor;

import com.medicalcenter.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/doctor/medical-record/edit")
public class MedicalRecordUpdateServlet extends HttpServlet {
    private MedicalRecordDAO medicalRecordDAO;
    private DoctorDAO doctorDAO;
    private PatientDAO patientDAO;

    @Override
    public void init() throws ServletException {
        medicalRecordDAO = new MedicalRecordDAO();
        doctorDAO = new DoctorDAO();
        patientDAO = new PatientDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Check if user is logged in and is a doctor
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            // Get doctor information
            Doctor doctor = doctorDAO.getDoctorByUserId(user.getId());
            if (doctor == null) {
                request.setAttribute("errorMessage", "Informations du médecin non trouvées.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            // Get medical record ID
            String recordIdStr = request.getParameter("recordId");
            if (recordIdStr == null || recordIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "ID du dossier médical manquant.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            int recordId = Integer.parseInt(recordIdStr);
            MedicalRecord medicalRecord = medicalRecordDAO.getMedicalRecordById(recordId);
            
            if (medicalRecord == null) {
                request.setAttribute("errorMessage", "Dossier médical non trouvé.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            // Set attributes for JSP
            session.setAttribute("doctor", doctor);
            session.setAttribute("medicalRecord", medicalRecord);
            session.setAttribute("patient", medicalRecord.getPatient());
            session.setAttribute("activePage", "medical-records");

            // Forward to edit form
            response.sendRedirect(request.getContextPath() +"/doctor/medical-record-edit.jsp");

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID du dossier médical invalide.");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur est survenue lors du chargement du dossier médical: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Check if user is logged in and is a doctor
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        try {
            // Get doctor information
            Doctor doctor = doctorDAO.getDoctorByUserId(user.getId());
            if (doctor == null) {
                request.setAttribute("errorMessage", "Informations du médecin non trouvées.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            // Get medical record ID
            String recordIdStr = request.getParameter("recordId");
            if (recordIdStr == null || recordIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "ID du dossier médical manquant.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            int recordId = Integer.parseInt(recordIdStr);
            MedicalRecord medicalRecord = medicalRecordDAO.getMedicalRecordById(recordId);
            
            if (medicalRecord == null) {
                request.setAttribute("errorMessage", "Dossier médical non trouvé.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            // Get form parameters
            String diagnosis = request.getParameter("diagnosis");
            String symptoms = request.getParameter("symptoms");
            String treatmentPlan = request.getParameter("treatmentPlan");
            String allergies = request.getParameter("allergies");
            String bloodType = request.getParameter("bloodType");
            String heightStr = request.getParameter("height");
            String weightStr = request.getParameter("weight");
            String bloodPressure = request.getParameter("bloodPressure");
            String temperatureStr = request.getParameter("temperature");
            String notes = request.getParameter("notes");
            String status = request.getParameter("status");

            // Validate required fields
            if (diagnosis == null || diagnosis.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Le diagnostic est obligatoire.");
                request.setAttribute("medicalRecord", medicalRecord);
                request.setAttribute("patient", medicalRecord.getPatient());
                request.setAttribute("doctor", doctor);
                request.getRequestDispatcher("/WEB-INF/views/doctor/medical-record-edit.jsp").forward(request, response);
                return;
            }

            // Update medical record fields
            medicalRecord.setDiagnosis(diagnosis.trim());
            medicalRecord.setSymptoms(symptoms != null ? symptoms.trim() : null);
            medicalRecord.setTreatmentPlan(treatmentPlan != null ? treatmentPlan.trim() : null);
            medicalRecord.setAllergies(allergies != null ? allergies.trim() : null);
            medicalRecord.setBloodType(bloodType != null ? bloodType.trim() : null);
            medicalRecord.setBloodPressure(bloodPressure != null ? bloodPressure.trim() : null);
            medicalRecord.setNotes(notes != null ? notes.trim() : null);
            medicalRecord.setStatus(status != null ? status.trim() : "Active");

            // Parse numeric fields
            try {
                if (heightStr != null && !heightStr.trim().isEmpty()) {
                    medicalRecord.setHeight(Double.parseDouble(heightStr.trim()));
                }
                if (weightStr != null && !weightStr.trim().isEmpty()) {
                    medicalRecord.setWeight(Double.parseDouble(weightStr.trim()));
                }
                if (temperatureStr != null && !temperatureStr.trim().isEmpty()) {
                    medicalRecord.setTemperature(Double.parseDouble(temperatureStr.trim()));
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Valeurs numériques invalides pour la taille, le poids ou la température.");
                request.setAttribute("medicalRecord", medicalRecord);
                request.setAttribute("patient", medicalRecord.getPatient());
                request.setAttribute("doctor", doctor);
                request.getRequestDispatcher("/WEB-INF/views/doctor/medical-record-edit.jsp").forward(request, response);
                return;
            }

            // Update the medical record
            boolean success = medicalRecordDAO.updateMedicalRecord(medicalRecord);
            
            if (success) {
                // Redirect to medical records view with success message
                response.sendRedirect(request.getContextPath() + "/doctor/medical-records?patientId=" + 
                                    medicalRecord.getPatient().getId() + "&success=updated");
            } else {
                session.setAttribute("errorMessage", "Erreur lors de la mise à jour du dossier médical.");
                session.setAttribute("medicalRecord", medicalRecord);
                session.setAttribute("patient", medicalRecord.getPatient());
                session.setAttribute("doctor", doctor);
                response.sendRedirect(request.getContextPath() +"/doctor/medical-record-edit.jsp");            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID du dossier médical invalide.");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur est survenue lors de la mise à jour: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
}
