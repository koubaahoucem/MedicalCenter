package com.medicalcenter.dao;

import com.medicalcenter.config.HibernateUtil;
import com.medicalcenter.model.Doctor;
import com.medicalcenter.model.Patient;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class DoctorDAO {

    public void saveDoctor(Doctor doctor) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(doctor);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public void updateDoctor(Doctor doctor) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(doctor);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public Doctor getDoctorById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Doctor.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Doctor getDoctorByUserId(int userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Doctor> query = session.createQuery(
                    "FROM Doctor WHERE user.id = :userId",
                    Doctor.class);
            query.setParameter("userId", userId);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Doctor> getAllDoctors() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Doctor ORDER BY lastName, firstName", Doctor.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<Doctor> getDoctorsByPatient(int patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Patient patient = session.get(Patient.class, patientId);
            if (patient != null) {
                // Convert Set to List and sort by last name and first name
                return patient.getDoctors()
                        .stream()
                        .sorted(Comparator
                                .comparing(Doctor::getLastName)
                                .thenComparing(Doctor::getFirstName))
                        .toList();
            } else {
                return new ArrayList<>();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }


    public List<Doctor> searchDoctors(String searchTerm) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Doctor> query = session.createQuery(
                    "FROM Doctor WHERE LOWER(firstName) LIKE :searchTerm OR LOWER(lastName) LIKE :searchTerm",
                    Doctor.class);
            query.setParameter("searchTerm", "%" + searchTerm.toLowerCase() + "%");
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}
