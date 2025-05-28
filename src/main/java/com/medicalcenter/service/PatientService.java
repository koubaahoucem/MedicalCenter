package com.medicalcenter.service;

import com.medicalcenter.dao.PatientDAO;
import com.medicalcenter.model.Patient;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PatientService {
    private static final Logger logger = Logger.getLogger(PatientService.class.getName());

    private PatientDAO patientDAO;

    public PatientService() {
        this.patientDAO = new PatientDAO();
    }

    public int savePatient(Patient patient) {
        try {
            patientDAO.savePatient(patient);
            return 1;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error saving patient", e);
            return -1;
        }
    }

    public boolean updatePatient(Patient patient) {
        try {
            patientDAO.updatePatient(patient);
            return true;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating patient", e);
            return false;
        }
    }

    public Patient getPatientById(int id) {
        try {
            return patientDAO.getPatientById(id);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error getting patient by ID", e);
            return null;
        }
    }

    public Patient getPatientByUserId(int userId) {
        try {
            return patientDAO.getPatientByUserId(userId);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error getting patient by user ID", e);
            return null;
        }
    }

    public List<Patient> getAllPatients() {
        try {
            return patientDAO.getAllPatients();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error getting all patients", e);
            return null;
        }
    }

    public boolean deletePatient(int id) {
        try {
            patientDAO.deletePatient(id);
            return true;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error deleting patient", e);
            return false;
        }
    }

    public boolean isPatientOfDoctor(int patientId, int id) {
        return !patientDAO.isPatientOfDoctor(patientId, id);
    }

    public List<Patient> getPatientsByDoctor(int id) {
        return patientDAO.getPatientsByDoctor(id);
    }
}