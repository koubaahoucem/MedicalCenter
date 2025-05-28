package com.medicalcenter.dao;

import com.medicalcenter.config.HibernateUtil;
import com.medicalcenter.model.PrescriptionRenewalRequest;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.ArrayList;
import java.util.List;

public class PrescriptionRenewalRequestDAO {

    public List<PrescriptionRenewalRequest> getRenewalRequestsByDoctorAndStatus(int doctorId, String status) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<PrescriptionRenewalRequest> query = session.createQuery(
                    "FROM PrescriptionRenewalRequest WHERE doctor.id = :doctorId AND status = :status ORDER BY requestDate DESC",
                    PrescriptionRenewalRequest.class);
            query.setParameter("doctorId", doctorId);
            query.setParameter("status", status);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public void saveRenewalRequest(PrescriptionRenewalRequest request) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(request);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public void updateRenewalRequest(PrescriptionRenewalRequest request) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(request);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public PrescriptionRenewalRequest getRenewalRequestById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(PrescriptionRenewalRequest.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<PrescriptionRenewalRequest> getRenewalRequestsByPatient(int patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<PrescriptionRenewalRequest> query = session.createQuery(
                    "FROM PrescriptionRenewalRequest WHERE patient.id = :patientId ORDER BY requestDate DESC",
                    PrescriptionRenewalRequest.class);
            query.setParameter("patientId", patientId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<PrescriptionRenewalRequest> getPendingRenewalRequestsByPatient(int patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<PrescriptionRenewalRequest> query = session.createQuery(
                    "FROM PrescriptionRenewalRequest WHERE patient.id = :patientId AND status = 'Pending' ORDER BY isUrgent DESC, requestDate ASC",
                    PrescriptionRenewalRequest.class);
            query.setParameter("patientId", patientId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<PrescriptionRenewalRequest> getRenewalRequestsByDoctor(int doctorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<PrescriptionRenewalRequest> query = session.createQuery(
                    "FROM PrescriptionRenewalRequest WHERE doctor.id = :doctorId ORDER BY requestDate DESC",
                    PrescriptionRenewalRequest.class);
            query.setParameter("doctorId", doctorId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<PrescriptionRenewalRequest> getPendingRenewalRequestsByDoctor(int doctorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<PrescriptionRenewalRequest> query = session.createQuery(
                    "FROM PrescriptionRenewalRequest WHERE doctor.id = :doctorId AND status = 'Pending' ORDER BY isUrgent DESC, requestDate ASC",
                    PrescriptionRenewalRequest.class);
            query.setParameter("doctorId", doctorId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<PrescriptionRenewalRequest> getRenewalRequestsByPrescription(int prescriptionId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<PrescriptionRenewalRequest> query = session.createQuery(
                    "FROM PrescriptionRenewalRequest WHERE prescription.id = :prescriptionId ORDER BY requestDate DESC",
                    PrescriptionRenewalRequest.class);
            query.setParameter("prescriptionId", prescriptionId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public int getPendingRenewalRequestsCount(int doctorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery(
                    "SELECT COUNT(r) FROM PrescriptionRenewalRequest r WHERE r.doctor.id = :doctorId AND r.status = 'Pending'",
                    Long.class);
            query.setParameter("doctorId", doctorId);
            return query.uniqueResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int getUrgentRenewalRequestsCount(int doctorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery(
                    "SELECT COUNT(r) FROM PrescriptionRenewalRequest r WHERE r.doctor.id = :doctorId AND r.isUrgent = true AND r.status = 'Pending'",
                    Long.class);
            query.setParameter("doctorId", doctorId);
            return query.uniqueResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int getTodayRenewalRequestsCount(int doctorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery(
                    "SELECT COUNT(r) FROM PrescriptionRenewalRequest r WHERE r.doctor.id = :doctorId AND DATE(r.requestDate) = CURRENT_DATE",
                    Long.class);
            query.setParameter("doctorId", doctorId);
            return query.uniqueResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public List<PrescriptionRenewalRequest> getUrgentRenewalRequests(int doctorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<PrescriptionRenewalRequest> query = session.createQuery(
                    "FROM PrescriptionRenewalRequest WHERE doctor.id = :doctorId AND isUrgent = true AND status = 'Pending' ORDER BY requestDate ASC",
                    PrescriptionRenewalRequest.class);
            query.setParameter("doctorId", doctorId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void deleteRenewalRequest(int id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            PrescriptionRenewalRequest renewalRequest = session.get(PrescriptionRenewalRequest.class, id);
            if (renewalRequest != null) {
                session.remove(renewalRequest);
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
