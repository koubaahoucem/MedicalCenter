package com.medicalcenter.controller.doctorControllers;

import com.medicalcenter.dao.DoctorDAO;
import com.medicalcenter.dao.PrescriptionDAO;
import com.medicalcenter.model.*;
import com.medicalcenter.service.MedicalRecordService;
import com.medicalcenter.service.PrescriptionRenewalRequestService;
import com.medicalcenter.service.PrescriptionService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@WebServlet("/doctor/prescription-renewals")
public class DoctorPrescriptionRenewalServlet extends HttpServlet {
    
    private DoctorDAO doctorDAO;
    private PrescriptionRenewalRequestService renewalRequestService;
    private PrescriptionDAO prescriptionDAO;
    private MedicalRecordService medicalRecordService;
    private PrescriptionService prescriptionService;
    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAO();
        renewalRequestService = new PrescriptionRenewalRequestService();
        prescriptionDAO = new PrescriptionDAO();
        medicalRecordService = new MedicalRecordService();
        prescriptionService = new PrescriptionService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in and is a doctor
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/unauthorized");
            return;
        }
        
        try {
            // Get doctor information
            Doctor doctor = doctorDAO.getDoctorByUserId(user.getId());
            if (doctor == null) {
                request.setAttribute("errorMessage", "Profil médecin non trouvé.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            
            // Get filter parameters
            String statusFilter = request.getParameter("status");
            String urgencyFilter = request.getParameter("urgency");
            String sortBy = request.getParameter("sortBy");
            
            // Get renewal requests for this doctor
            List<PrescriptionRenewalRequest> renewalRequests;
            
            if (statusFilter != null && !statusFilter.isEmpty()) {
                renewalRequests = renewalRequestService.getRenewalRequestsByDoctorAndStatus(doctor.getId(), statusFilter);
            } else {
                renewalRequests = renewalRequestService.getRenewalRequestsByDoctor(doctor.getId());
            }
            
            // Filter by urgency if specified
            if ("urgent".equals(urgencyFilter)) {
                renewalRequests = renewalRequests.stream()
                    .filter(PrescriptionRenewalRequest::isUrgent)
                    .collect(java.util.stream.Collectors.toList());
            }
            
            // Sort requests
            if ("date".equals(sortBy)) {
                renewalRequests.sort((r1, r2) -> r2.getRequestDate().compareTo(r1.getRequestDate()));
            } else if ("urgency".equals(sortBy)) {
                renewalRequests.sort((r1, r2) -> Boolean.compare(r2.isUrgent(), r1.isUrgent()));
            }
            
            // Get statistics
            int pendingCount = renewalRequestService.getPendingRenewalRequestsCount(doctor.getId());
            int urgentCount = renewalRequestService.getUrgentRenewalRequestsCount(doctor.getId());
            int todayCount = renewalRequestService.getTodayRenewalRequestsCount(doctor.getId());
            
            // Set attributes for JSP
            session.setAttribute("doctor", doctor);
            session.setAttribute("renewalRequests", renewalRequests);
            session.setAttribute("pendingCount", pendingCount);
            session.setAttribute("urgentCount", urgentCount);
            session.setAttribute("todayCount", todayCount);
            session.setAttribute("statusFilter", statusFilter);
            session.setAttribute("urgencyFilter", urgencyFilter);
            session.setAttribute("sortBy", sortBy);
            session.setAttribute("prescription-renewal", "prescription-renewal");
            
            // Forward to JSP
            response.sendRedirect(request.getContextPath() + "/doctor/prescription-renewals.jsp" );
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur est survenue lors du chargement des demandes: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in and is a doctor
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/unauthorized");
            return;
        }
        
        try {
            String action = request.getParameter("action");
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            
            PrescriptionRenewalRequest renewalRequest = renewalRequestService.getRenewalRequestById(requestId);

            Prescription prescription = prescriptionService.getPrescriptionById(renewalRequest.getPrescription().getId());
            if (renewalRequest == null) {
                session.setAttribute("errorMessage", "Demande de renouvellement non trouvée.");
                response.sendRedirect(request.getContextPath() + "/doctor/prescription-renewals");
                return;
            }
            
            // Verify that this request is for this doctor
            Doctor doctor = doctorDAO.getDoctorByUserId(user.getId());
            if (renewalRequest.getDoctor().getId() != doctor.getId()) {
                session.setAttribute("errorMessage", "Vous n'êtes pas autorisé à traiter cette demande.");
                response.sendRedirect(request.getContextPath() + "/doctor/prescription-renewals");
                return;
            }
            
            if ("approve".equals(action)) {
                // Approve the renewal request
                renewalRequest.setStatus("Approved");
                renewalRequest.setResponseDate(new Date());
                renewalRequest.setResponseMessage(request.getParameter("responseMessage"));

                Calendar calendar = Calendar.getInstance();
                calendar.setTime(prescription.getExpiryDate());
                calendar.add(Calendar.DAY_OF_YEAR, 7);
                Date newExpiryDate = calendar.getTime();

                MedicalRecord medicalRecord = medicalRecordService.getActiveMedicalRecordByPatientId(renewalRequest.getPatient().getId());

                Prescription newPrescription = getPrescription(renewalRequest, doctor, medicalRecord);
                newPrescription.setExpiryDate(newExpiryDate);

                // Save new prescription
                prescriptionDAO.savePrescription(newPrescription);
                
                // Update renewal request
                renewalRequestService.updateRenewalRequest(renewalRequest);
                
                session.setAttribute("successMessage", "Demande approuvée et nouvelle ordonnance créée avec succès.");
                
            } else if ("reject".equals(action)) {
                // Reject the renewal request
                renewalRequest.setStatus("Rejected");
                renewalRequest.setResponseDate(new Date());
                renewalRequest.setResponseMessage(request.getParameter("responseMessage"));
                
                renewalRequestService.updateRenewalRequest(renewalRequest);
                
                session.setAttribute("successMessage", "Demande rejetée avec succès.");
            }
            
            response.sendRedirect(request.getContextPath() + "/doctor/prescription-renewals");
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID de demande invalide.");
            response.sendRedirect(request.getContextPath() + "/doctor/prescription-renewals");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Une erreur est survenue lors du traitement de la demande: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/doctor/prescription-renewals");
        }
    }

    private static Prescription getPrescription(PrescriptionRenewalRequest renewalRequest, Doctor doctor, MedicalRecord medicalRecord) {
        Prescription originalPrescription = renewalRequest.getPrescription();
        Prescription newPrescription = new Prescription();
        newPrescription.setDoctor(doctor);
        newPrescription.setRecord(medicalRecord);
        newPrescription.setTitle(originalPrescription.getTitle());
        newPrescription.setDescription(originalPrescription.getDescription());
        newPrescription.setPrescribedDate(new Date());

        // Set expiry date (e.g., 3 months from now)
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.add(java.util.Calendar.MONTH, 3);
        newPrescription.setExpiryDate(cal.getTime());
        return newPrescription;
    }
}
