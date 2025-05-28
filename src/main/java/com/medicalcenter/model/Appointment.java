package com.medicalcenter.model;

import jakarta.persistence.*;
import java.util.Calendar;
import java.util.Date;

@Entity
@Table(name = "appointments")
public class Appointment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "doctor_id", nullable = false)
    private Doctor doctor;

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "start_time", nullable = false)
    private Date startTime;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "end_time", nullable = false)
    private Date endTime;

    @Column(name = "status", nullable = false)
    private String status;

    @Column(name = "notes")
    private String notes;

    @Column(name = "reason")
    private String reason;

    @Column(name = "location")
    private String location;

    @Column(name = "is_teleconsultation")
    private boolean teleconsultation;

    // Constructors
    public Appointment() {
        this.status = "Scheduled";
    }

    public Appointment(Doctor doctor, Patient patient, Date startTime, Date endTime) {
        this();
        this.doctor = doctor;
        this.patient = patient;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Doctor getDoctor() {
        return doctor;
    }

    public void setDoctor(Doctor doctor) {
        this.doctor = doctor;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public boolean isTeleconsultation() {
        return teleconsultation;
    }

    public void setTeleconsultation(boolean teleconsultation) {
        this.teleconsultation = teleconsultation;
    }

    // Utility methods
    public long getDurationInMinutes() {
        if (startTime == null || endTime == null) return 0;
        return (endTime.getTime() - startTime.getTime()) / (60 * 1000);
    }

    public boolean isCompleted() {
        return "Completed".equals(status);
    }

    public boolean isCancelled() {
        return "Cancelled".equals(status);
    }

    public boolean isPending() {
        return "Pending".equals(status);
    }

    public boolean isScheduled() {
        return "Scheduled".equals(status);
    }

    // Methods used in JSP
    public Date getAppointmentDate() {
        return startTime;
    }

    public boolean isToday() {
        if (startTime == null) return false;

        Calendar today = Calendar.getInstance();
        Calendar appointmentDay = Calendar.getInstance();
        appointmentDay.setTime(startTime);

        return today.get(Calendar.YEAR) == appointmentDay.get(Calendar.YEAR) &&
                today.get(Calendar.DAY_OF_YEAR) == appointmentDay.get(Calendar.DAY_OF_YEAR);
    }

    public boolean isPast() {
        if (startTime == null) return false;
        return startTime.before(new Date());
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Appointment that = (Appointment) o;
        return id == that.id;
    }

    @Override
    public int hashCode() {
        return 31 * id;
    }


    @Override
    public String toString() {
        return "Appointment{" +
                "id=" + id +
                ", doctor=" + (doctor != null ? doctor.getFullName() : "null") +
                ", patient=" + (patient != null ? patient.getFullName() : "null") +
                ", startTime=" + startTime +
                ", status='" + status + '\'' +
                '}';
    }

}
