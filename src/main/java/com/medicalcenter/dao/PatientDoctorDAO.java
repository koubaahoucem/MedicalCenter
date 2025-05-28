package com.medicalcenter.dao;

import com.medicalcenter.config.HibernateUtil;
import com.medicalcenter.model.Doctor;
import com.medicalcenter.model.Patient;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

public class PatientDoctorDAO {

    public void addDoctorToPatient(int patientId, int doctorId) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            Patient patient = session.get(Patient.class, patientId);
            Doctor doctor = session.get(Doctor.class, doctorId);

            if (patient != null && doctor != null && !patient.getDoctors().contains(doctor)) {
                patient.getDoctors().add(doctor);
                doctor.getPatients().add(patient);

                session.persist(patient); // or session.merge(patient) if detached
                session.persist(doctor);  // optional, depending on cascade settings
            }

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public void removeDoctorFromPatient(int patientId, int doctorId) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            Patient patient = session.get(Patient.class, patientId);
            Doctor doctor = session.get(Doctor.class, doctorId);

            if (patient != null && doctor != null) {
                patient.getDoctors().remove(doctor);
                doctor.getPatients().remove(patient); // if bidirectional

                // Save changes (optional depending on cascade settings)
                session.persist(patient);
                session.persist(doctor);
            }

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

}
