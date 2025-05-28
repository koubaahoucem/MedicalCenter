package com.medicalcenter.dao;

import com.medicalcenter.config.HibernateUtil;
import com.medicalcenter.model.Doctor;
import com.medicalcenter.model.MedicalRecord;
import com.medicalcenter.model.Prescription;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class PrescriptionDAO {

    public void savePrescription(Prescription prescription) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(prescription);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public void updatePrescription(Prescription prescription) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(prescription);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public Prescription getPrescriptionById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Prescription.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Prescription> getPrescriptionsByRecord(MedicalRecord record) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Prescription> query = session.createQuery(
                    "FROM Prescription WHERE record.id = :recordId ORDER BY prescribedDate DESC",
                    Prescription.class);
            query.setParameter("recordId", record.getId());
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Prescription> getPrescriptionsByRecordId(int recordId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Prescription> query = session.createQuery(
                    "FROM Prescription WHERE record.id = :recordId ORDER BY prescribedDate DESC",
                    Prescription.class);
            query.setParameter("recordId", recordId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Prescription> getPrescriptionsByDoctor(Doctor doctor) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Prescription> query = session.createQuery(
                    "FROM Prescription WHERE doctor.id = :doctorId ORDER BY prescribedDate DESC",
                    Prescription.class);
            query.setParameter("doctorId", doctor.getId());
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Prescription> getPrescriptionsByDoctorId(int doctorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Prescription> query = session.createQuery(
                    "FROM Prescription WHERE doctor.id = :doctorId ORDER BY prescribedDate DESC",
                    Prescription.class);
            query.setParameter("doctorId", doctorId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Prescription> getPrescriptionsByPatientId(int patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Prescription> query = session.createQuery(
                    "FROM Prescription p WHERE p.record.patient.id = :patientId ORDER BY p.prescribedDate DESC",
                    Prescription.class);
            query.setParameter("patientId", patientId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Prescription> getAllPrescriptions() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Prescription ORDER BY prescribedDate DESC", Prescription.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Prescription> getRecentPrescriptions(int limit) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Prescription> query = session.createQuery(
                    "FROM Prescription ORDER BY prescribedDate DESC", Prescription.class);
            query.setMaxResults(limit);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Prescription> getPrescriptionsByDateRange(Date startDate, Date endDate) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Prescription> query = session.createQuery(
                    "FROM Prescription WHERE prescribedDate BETWEEN :startDate AND :endDate ORDER BY prescribedDate DESC",
                    Prescription.class);
            query.setParameter("startDate", startDate);
            query.setParameter("endDate", endDate);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Prescription> searchPrescriptions(String searchTerm) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Prescription> query = session.createQuery(
                    "FROM Prescription p WHERE p.description LIKE :searchTerm " +
                            "OR p.doctor.firstName LIKE :searchTerm " +
                            "OR p.doctor.lastName LIKE :searchTerm " +
                            "OR p.record.patient.firstName LIKE :searchTerm " +
                            "OR p.record.patient.lastName LIKE :searchTerm",
                    Prescription.class);
            query.setParameter("searchTerm", "%" + searchTerm + "%");
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void deletePrescription(int id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Prescription prescription = session.get(Prescription.class, id);
            if (prescription != null) {
                session.remove(prescription);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public int getPrescriptionCount() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery("SELECT COUNT(p) FROM Prescription p", Long.class);
            return query.uniqueResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int getPrescriptionCountByDoctor(int doctorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery(
                    "SELECT COUNT(p) FROM Prescription p WHERE p.doctor.id = :doctorId", Long.class);
            query.setParameter("doctorId", doctorId);
            return query.uniqueResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public List<Prescription> getPrescriptionsByPatient(int patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Prescription> query = session.createQuery(
                    "SELECT p FROM Prescription p WHERE p.record.patient.id = :patientId", Prescription.class);
            query.setParameter("patientId", patientId);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}