package com.medicalcenter.service;

import com.medicalcenter.dao.SpecialityDAO;
import com.medicalcenter.model.Specialty;

import java.util.List;

public class SpecialityService {
    private SpecialityDAO specialityDAO ;

    public SpecialityService() {
        specialityDAO = new SpecialityDAO();
    }

    public List<Specialty> getSpecialities() {
        return specialityDAO.getAllSpecialties();
    }


    public Specialty getSpecialityByName(String specialty) {
        return specialityDAO.getSpecialtyByName(specialty);
    }

    public List<Specialty> getAllSpecialties() {
        return specialityDAO.getAllSpecialties();
    }

    public Specialty getSpecialtyById(int specialtyId) {
        return specialityDAO.getSpecialtyById(specialtyId);
    }
}
