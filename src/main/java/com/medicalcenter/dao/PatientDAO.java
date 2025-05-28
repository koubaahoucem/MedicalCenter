package com.medicalcenter.dao;

import com.medicalcenter.config.HibernateUtil;
import com.medicalcenter.model.Patient;
import com.medicalcenter.model.User;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.*;
import java.util.stream.Collectors;

public class PatientDAO {
    public List<Patient> sortPatients(List<Patient> patients, String sortBy) {
        if (sortBy == null || sortBy.isEmpty()) {
            return patients;
        }

        switch (sortBy) {
            case "name":
                return patients.stream()
                        .sorted(Comparator.comparing(Patient::getLastName)
                                .thenComparing(Patient::getFirstName))
                        .collect(Collectors.toList());
            case "age":
                return patients.stream()
                        .sorted((p1, p2) -> {
                            if (p1.getBirthDate() == null && p2.getBirthDate() == null) return 0;
                            if (p1.getBirthDate() == null) return 1;
                            if (p2.getBirthDate() == null) return -1;
                            return p2.getBirthDate().compareTo(p1.getBirthDate()); // Younger first
                        })
                        .collect(Collectors.toList());
            default:
                return patients;
        }
    }
    public List<Patient> filterPatientsByAge(List<Patient> patients, String ageFilter) {
        if (ageFilter == null || ageFilter.isEmpty()) {
            return patients;
        }

        return patients.stream().filter(patient -> {
            if (patient.getBirthDate() == null) return false;

            int age = calculateAge(patient.getBirthDate());
            switch (ageFilter) {
                case "0-18": return age <= 18;
                case "19-35": return age >= 19 && age <= 35;
                case "36-50": return age >= 36 && age <= 50;
                case "51-65": return age >= 51 && age <= 65;
                case "65+": return age > 65;
                default: return true;
            }
        }).collect(Collectors.toList());
    }
    public List<Patient> getPatientsByDoctor(int doctorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Patient> query = session.createQuery(
                    "SELECT DISTINCT p FROM Patient p " +
                            "JOIN p.appointments a " +
                            "WHERE a.doctor.id = :doctorId " +
                            "ORDER BY p.lastName, p.firstName", Patient.class);
            query.setParameter("doctorId", doctorId);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<Patient> searchPatientsByDoctor(int doctorId, String searchQuery) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Patient> query = session.createQuery(
                    "SELECT DISTINCT p FROM Patient p " +
                            "JOIN p.appointments a " +
                            "WHERE a.doctor.id = :doctorId " +
                            "AND (LOWER(p.firstName) LIKE LOWER(:search) " +
                            "OR LOWER(p.lastName) LIKE LOWER(:search) " +
                            "OR LOWER(p.phone) LIKE LOWER(:search)) " +
                            "ORDER BY p.lastName, p.firstName", Patient.class);
            query.setParameter("doctorId", doctorId);
            query.setParameter("search", "%" + searchQuery + "%");
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }


    public void savePatient(Patient patient) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(patient);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public boolean updatePatient(Patient patient) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(patient);
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

    public Patient getPatientById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Patient.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Patient getPatientByUserId(int userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Patient> query = session.createQuery(
                    "FROM Patient p WHERE p.user.id = :userId", Patient.class);
            query.setParameter("userId", userId);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Patient> getAllPatients() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Patient", Patient.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public boolean isPatientOfDoctor(int patientId, int doctorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery(
                    "SELECT COUNT(a) FROM Appointment a " +
                            "WHERE a.patient.id = :patientId " +
                            "AND a.doctor.id = :doctorId", Long.class);
            query.setParameter("patientId", patientId);
            query.setParameter("doctorId", doctorId);
            return query.uniqueResult() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public List<Patient> searchPatients(String searchTerm) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Patient> query = session.createQuery(
                    "FROM Patient p WHERE p.firstName LIKE :searchTerm " +
                            "OR p.lastName LIKE :searchTerm " +
                            "OR p.phone LIKE :searchTerm " +
                            "OR p.user.email LIKE :searchTerm", Patient.class);
            query.setParameter("searchTerm", "%" + searchTerm + "%");
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void deletePatient(int id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Patient patient = session.get(Patient.class, id);
            if (patient != null) {
                session.remove(patient);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public int getPatientCount() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery("SELECT COUNT(p) FROM Patient p", Long.class);
            return query.uniqueResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    private int calculateAge(Date birthDate) {
        if (birthDate == null) return 0;

        Calendar birth = Calendar.getInstance();
        birth.setTime(birthDate);
        Calendar now = Calendar.getInstance();

        int age = now.get(Calendar.YEAR) - birth.get(Calendar.YEAR);
        if (now.get(Calendar.DAY_OF_YEAR) < birth.get(Calendar.DAY_OF_YEAR)) {
            age--;
        }
        return age;
    }

    // Utility method to calculate age for JSP
    public static int getAge(Date birthDate) {
        if (birthDate == null) return 0;

        Calendar birth = Calendar.getInstance();
        birth.setTime(birthDate);
        Calendar now = Calendar.getInstance();

        int age = now.get(Calendar.YEAR) - birth.get(Calendar.YEAR);
        if (now.get(Calendar.DAY_OF_YEAR) < birth.get(Calendar.DAY_OF_YEAR)) {
            age--;
        }
        return age;
    }
    public int getPatientCountByDoctor(int doctorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery(
                    "SELECT COUNT(DISTINCT p) FROM Patient p " +
                            "JOIN p.appointments a " +
                            "WHERE a.doctor.id = :doctorId", Long.class);
            query.setParameter("doctorId", doctorId);
            return query.uniqueResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int getNewPatientsCountThisWeek(int doctorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.DAY_OF_MONTH, -7);
            Date weekAgo = calendar.getTime();

            Query<Long> query = session.createQuery(
                    "SELECT COUNT(DISTINCT p) FROM Patient p " +
                            "JOIN p.appointments a " +
                            "WHERE a.doctor.id = :doctorId " +
                            "AND a.startTime >= :weekAgo", Long.class);
            query.setParameter("doctorId", doctorId);
            query.setParameter("weekAgo", weekAgo);
            return query.uniqueResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}