package com.medicalcenter.dao;

import com.medicalcenter.config.HibernateUtil;
import com.medicalcenter.model.MedicalDocument;
import com.medicalcenter.model.MedicalRecord;
import com.medicalcenter.model.User;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.Date;
import java.util.List;

public class MedicalDocumentDAO {

    public void saveMedicalDocument(MedicalDocument document) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(document);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public void updateMedicalDocument(MedicalDocument document) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(document);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public MedicalDocument getMedicalDocumentById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(MedicalDocument.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<MedicalDocument> getMedicalDocumentsByRecord(MedicalRecord record) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<MedicalDocument> query = session.createQuery(
                    "FROM MedicalDocument WHERE record.id = :recordId ORDER BY uploadedAt DESC",
                    MedicalDocument.class);
            query.setParameter("recordId", record.getId());
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<MedicalDocument> getMedicalDocumentsByRecordId(int recordId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<MedicalDocument> query = session.createQuery(
                    "FROM MedicalDocument WHERE record.id = :recordId ORDER BY uploadedAt DESC",
                    MedicalDocument.class);
            query.setParameter("recordId", recordId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<MedicalDocument> getMedicalDocumentsByUploader(User uploader) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<MedicalDocument> query = session.createQuery(
                    "FROM MedicalDocument WHERE uploadedBy.id = :uploaderId ORDER BY uploadedAt DESC",
                    MedicalDocument.class);
            query.setParameter("uploaderId", uploader.getId());
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<MedicalDocument> getAllMedicalDocuments() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM MedicalDocument ORDER BY uploadedAt DESC", MedicalDocument.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<MedicalDocument> getRecentMedicalDocuments(int limit) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<MedicalDocument> query = session.createQuery(
                    "FROM MedicalDocument ORDER BY uploadedAt DESC", MedicalDocument.class);
            query.setMaxResults(limit);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<MedicalDocument> getMedicalDocumentsByDateRange(Date startDate, Date endDate) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<MedicalDocument> query = session.createQuery(
                    "FROM MedicalDocument WHERE uploadedAt BETWEEN :startDate AND :endDate ORDER BY uploadedAt DESC",
                    MedicalDocument.class);
            query.setParameter("startDate", startDate);
            query.setParameter("endDate", endDate);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<MedicalDocument> searchMedicalDocuments(String searchTerm) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<MedicalDocument> query = session.createQuery(
                    "FROM MedicalDocument md WHERE md.description LIKE :searchTerm " +
                            "OR md.filePath LIKE :searchTerm",
                    MedicalDocument.class);
            query.setParameter("searchTerm", "%" + searchTerm + "%");
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void deleteMedicalDocument(int id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            MedicalDocument document = session.get(MedicalDocument.class, id);
            if (document != null) {
                session.remove(document);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public int getMedicalDocumentCount() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery("SELECT COUNT(md) FROM MedicalDocument md", Long.class);
            return query.uniqueResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int getMedicalDocumentCountByRecord(int recordId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery(
                    "SELECT COUNT(md) FROM MedicalDocument md WHERE md.record.id = :recordId", Long.class);
            query.setParameter("recordId", recordId);
            return query.uniqueResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}