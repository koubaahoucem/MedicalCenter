package com.medicalcenter.dao;

import com.medicalcenter.config.HibernateUtil;
import com.medicalcenter.model.Specialty;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class SpecialityDAO {

    public void saveSpecialty(Specialty specialty) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(specialty);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public void updateSpecialty(Specialty specialty) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(specialty);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public Specialty getSpecialtyById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Specialty.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Specialty getSpecialtyByName(String name) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Specialty> query = session.createQuery(
                    "FROM Specialty WHERE name = :name", Specialty.class);
            query.setParameter("name", name);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Specialty> getAllSpecialties() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Specialty ORDER BY name", Specialty.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Specialty> searchSpecialties(String searchTerm) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Specialty> query = session.createQuery(
                    "FROM Specialty WHERE name LIKE :searchTerm OR description LIKE :searchTerm",
                    Specialty.class);
            query.setParameter("searchTerm", "%" + searchTerm + "%");
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void deleteSpecialty(int id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Specialty specialty = session.get(Specialty.class, id);
            if (specialty != null) {
                session.remove(specialty);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public int getSpecialtyCount() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery("SELECT COUNT(s) FROM Specialty s", Long.class);
            return query.uniqueResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public boolean isSpecialtyNameUnique(String name) {
        return getSpecialtyByName(name) == null;
    }
}