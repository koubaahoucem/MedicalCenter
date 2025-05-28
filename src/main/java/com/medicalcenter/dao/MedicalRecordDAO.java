package com.medicalcenter.dao;

import com.medicalcenter.config.HibernateUtil;
import com.medicalcenter.model.MedicalRecord;
import com.medicalcenter.model.Patient;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.Date;
import java.util.List;

public class MedicalRecordDAO {

    public void saveMedicalRecord(MedicalRecord record) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(record);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public boolean updateMedicalRecord(MedicalRecord record) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(record);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }

    public MedicalRecord getMedicalRecordById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(MedicalRecord.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<MedicalRecord> getMedicalRecordsByPatient(Patient patient) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<MedicalRecord> query = session.createQuery(
                    "FROM MedicalRecord WHERE patient.id = :patientId ORDER BY createdAt DESC",
                    MedicalRecord.class);
            query.setParameter("patientId", patient.getId());
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<MedicalRecord> getMedicalRecordsByPatientId(int patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<MedicalRecord> query = session.createQuery(
                    "FROM MedicalRecord WHERE patient.id = :patientId ORDER BY createdAt DESC",
                    MedicalRecord.class);
            query.setParameter("patientId", patientId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<MedicalRecord> getAllMedicalRecords() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM MedicalRecord ORDER BY createdAt DESC", MedicalRecord.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<MedicalRecord> getRecentMedicalRecords(int limit) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<MedicalRecord> query = session.createQuery(
                    "FROM MedicalRecord ORDER BY createdAt DESC", MedicalRecord.class);
            query.setMaxResults(limit);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<MedicalRecord> getMedicalRecordsByDateRange(Date startDate, Date endDate) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<MedicalRecord> query = session.createQuery(
                    "FROM MedicalRecord WHERE createdAt BETWEEN :startDate AND :endDate ORDER BY createdAt DESC",
                    MedicalRecord.class);
            query.setParameter("startDate", startDate);
            query.setParameter("endDate", endDate);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<MedicalRecord> searchMedicalRecords(String searchTerm) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<MedicalRecord> query = session.createQuery(
                    "FROM MedicalRecord mr WHERE mr.diagnosis LIKE :searchTerm " +
                            "OR mr.symptoms LIKE :searchTerm " +
                            "OR mr.treatmentPlan LIKE :searchTerm " +
                            "OR mr.notes LIKE :searchTerm " +
                            "OR mr.patient.firstName LIKE :searchTerm " +
                            "OR mr.patient.lastName LIKE :searchTerm",
                    MedicalRecord.class);
            query.setParameter("searchTerm", "%" + searchTerm + "%");
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void deleteMedicalRecord(int id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            MedicalRecord record = session.get(MedicalRecord.class, id);
            if (record != null) {
                session.remove(record);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public int getMedicalRecordCount() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery("SELECT COUNT(mr) FROM MedicalRecord mr", Long.class);
            return query.uniqueResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int getMedicalRecordCountByPatient(int patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery(
                    "SELECT COUNT(mr) FROM MedicalRecord mr WHERE mr.patient.id = :patientId", Long.class);
            query.setParameter("patientId", patientId);
            return query.uniqueResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public MedicalRecord getActiveMedicalRecordByPatientId(int patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<MedicalRecord> query = session.createQuery(
                    "FROM MedicalRecord mr WHERE mr.patient.id = :patientId AND mr.status = 'Active' ORDER BY mr.createdAt DESC",
                    MedicalRecord.class);
            query.setParameter("patientId", patientId);
            query.setMaxResults(1);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error retrieving active medical record for patient ID: " + patientId);
            return null;
        }
    }}