package com.medicalcenter.service;

import com.medicalcenter.dao.PrescriptionDAO;
import com.medicalcenter.model.Prescription;

import java.util.List;

public class PrescriptionService {
    private PrescriptionDAO prescriptionDAO;

    public PrescriptionService() {
        prescriptionDAO = new PrescriptionDAO();
    }


    public List<Prescription> getPrescriptionByMedicalRecord(int id) {
        return prescriptionDAO.getPrescriptionsByRecordId(id);
    }

    public List<Prescription> getAllPrescriptionsByPatientId(int id) {
        return prescriptionDAO.getPrescriptionsByPatientId(id);
    }

    public void savePrescription(Prescription prescription) {
        prescriptionDAO.savePrescription(prescription);
    }

    public Prescription getPrescriptionById(int prescriptionId) {
        return prescriptionDAO.getPrescriptionById(prescriptionId);
    }
}
