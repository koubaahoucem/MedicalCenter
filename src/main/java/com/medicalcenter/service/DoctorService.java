package com.medicalcenter.service;

import com.medicalcenter.dao.DoctorDAO;
import com.medicalcenter.model.Doctor;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DoctorService {
    private static final Logger logger = Logger.getLogger(DoctorService.class.getName());

    private DoctorDAO doctorDAO;

    public DoctorService() {
        this.doctorDAO = new DoctorDAO();
    }

    public void saveDoctor(Doctor doctor) {
        try {
            doctorDAO.saveDoctor(doctor);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error saving doctor", e);
        }
    }

    public boolean updateDoctor(Doctor doctor) {
        try {
            doctorDAO.updateDoctor(doctor);
            return true;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating doctor", e);
            return false;
        }
    }

    public Doctor getDoctorById(int id) {
        try {
            return doctorDAO.getDoctorById(id);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error getting doctor by ID", e);
            return null;
        }
    }

    public Doctor getDoctorByUserId(int userId) {
        try {
            return doctorDAO.getDoctorByUserId(userId);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error getting doctor by user ID", e);
            return null;
        }
    }

    public List<Doctor> getAllDoctors() {
        try {
            return doctorDAO.getAllDoctors();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error getting all doctors", e);
            return null;
        }
    }

//    public boolean deleteDoctor(int id) {
//        try {
//            doctorDAO.deleteDoctor(id);
//            return true;
//        } catch (Exception e) {
//            logger.log(Level.SEVERE, "Error deleting doctor", e);
//            return false;
//        }
//    }
}