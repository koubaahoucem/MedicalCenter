package com.medicalcenter.service;

import com.medicalcenter.dao.PrescriptionDAO;
import com.medicalcenter.dao.PrescriptionRenewalRequestDAO;
import com.medicalcenter.model.PrescriptionRenewalRequest;

import java.util.List;

public class PrescriptionRenewalRequestService {

    private final PrescriptionRenewalRequestDAO prescriptionRenewalRequestDAO;

    public PrescriptionRenewalRequestService() {
        prescriptionRenewalRequestDAO = new PrescriptionRenewalRequestDAO();
    }

    public List<PrescriptionRenewalRequest> getRenewalRequestsByDoctorAndStatus(int id, String statusFilter) {
        return prescriptionRenewalRequestDAO.getRenewalRequestsByDoctorAndStatus(id, statusFilter);
    }

    public List<PrescriptionRenewalRequest> getRenewalRequestsByDoctor(int id) {
        return prescriptionRenewalRequestDAO.getRenewalRequestsByDoctor(id);
    }

    public int getPendingRenewalRequestsCount(int id) {
        return prescriptionRenewalRequestDAO.getPendingRenewalRequestsCount(id);
    }

    public int getUrgentRenewalRequestsCount(int id) {
        return  prescriptionRenewalRequestDAO.getUrgentRenewalRequestsCount(id);
    }

    public int getTodayRenewalRequestsCount(int id) {
        return prescriptionRenewalRequestDAO.getTodayRenewalRequestsCount(id);
    }

    public PrescriptionRenewalRequest getRenewalRequestById(int requestId) {
        return prescriptionRenewalRequestDAO.getRenewalRequestById(requestId);
    }

    public void updateRenewalRequest(PrescriptionRenewalRequest renewalRequest) {
        prescriptionRenewalRequestDAO.updateRenewalRequest(renewalRequest);
    }
}
