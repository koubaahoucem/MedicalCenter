package com.medicalcenter.dao;

import com.medicalcenter.config.HibernateUtil;
import com.medicalcenter.model.Appointment;
import com.medicalcenter.model.Doctor;
import com.medicalcenter.model.Patient;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class AppointmentDAO {

    public void saveAppointment(Appointment appointment) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(appointment);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public void updateAppointment(Appointment appointment) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(appointment);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public Appointment getAppointmentById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Appointment.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Appointment> getAppointmentsByPatient(int patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Appointment> query = session.createQuery(
                    "FROM Appointment WHERE patient.id = :patientId ORDER BY startTime",
                    Appointment.class);
            query.setParameter("patientId", patientId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<Appointment> getUpcomingAppointmentsByPatient(int patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Appointment> query = session.createQuery(
                    "FROM Appointment WHERE patient.id = :patientId AND startTime >= :now ORDER BY startTime",
                    Appointment.class);
            query.setParameter("patientId", patientId);
            query.setParameter("now", new Date());
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<Appointment> getAppointmentsByDoctor(int doctorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Appointment> query = session.createQuery(
                    "FROM Appointment WHERE doctor.id = :doctorId ORDER BY startTime",
                    Appointment.class);
            query.setParameter("doctorId", doctorId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<Appointment> getUpcomingAppointmentsByDoctor(int doctorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Appointment> query = session.createQuery(
                    "FROM Appointment WHERE doctor.id = :doctorId AND startTime >= :now ORDER BY startTime",
                    Appointment.class);
            query.setParameter("doctorId", doctorId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<Appointment> getCompletedAppointmentsByDoctor(int doctorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Appointment> query = session.createQuery(
                    "FROM Appointment WHERE doctor.id = :doctorId AND startTime <= :now ORDER BY startTime",
                    Appointment.class);
            query.setParameter("doctorId", doctorId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    public List<Appointment> getAppointmentsThisMonth() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Calendar calendar = Calendar.getInstance();

            // Set to first day of the month at 00:00:00
            calendar.set(Calendar.DAY_OF_MONTH, 1);
            calendar.set(Calendar.HOUR_OF_DAY, 0);
            calendar.set(Calendar.MINUTE, 0);
            calendar.set(Calendar.SECOND, 0);
            calendar.set(Calendar.MILLISECOND, 0);
            Date startOfMonth = calendar.getTime();

            // Set to last day of the month at 23:59:59
            calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
            calendar.set(Calendar.HOUR_OF_DAY, 23);
            calendar.set(Calendar.MINUTE, 59);
            calendar.set(Calendar.SECOND, 59);
            calendar.set(Calendar.MILLISECOND, 999);
            Date endOfMonth = calendar.getTime();

            Query<Appointment> query = session.createQuery(
                    "FROM Appointment WHERE startTime BETWEEN :start AND :end ORDER BY startTime",
                    Appointment.class);
            query.setParameter("start", startOfMonth);
            query.setParameter("end", endOfMonth);

            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<Appointment> getAppointmentsByDoctorAndDateRange(int doctorId, Date startDate, Date endDate) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Appointment> query = session.createQuery(
                    "FROM Appointment WHERE doctor.id = :doctorId AND " +
                            "((startTime <= :endDate AND endTime >= :startDate) OR " +
                            "(startTime >= :startDate AND startTime < :endDate)) AND " +
                            "status != 'Cancelled'",
                    Appointment.class);
            query.setParameter("doctorId", doctorId);
            query.setParameter("startDate", startDate);
            query.setParameter("endDate", endDate);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public void cancelAppointment(int appointmentId) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Appointment appointment = session.get(Appointment.class, appointmentId);
            if (appointment != null) {
                appointment.setStatus("Cancelled");
                session.merge(appointment);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public List<Appointment> getAllAppointments() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Appointment ORDER BY startTime", Appointment.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}
