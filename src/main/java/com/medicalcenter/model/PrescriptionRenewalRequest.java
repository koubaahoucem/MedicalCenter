package com.medicalcenter.model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "prescription_renewal_requests")
public class PrescriptionRenewalRequest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "prescription_id", nullable = false)
    private Prescription prescription;

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @ManyToOne
    @JoinColumn(name = "doctor_id", nullable = false)
    private Doctor doctor;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "request_date", nullable = false)
    private Date requestDate;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "response_date")
    private Date responseDate;

    @Column(name = "message", columnDefinition = "TEXT")
    private String message;

    @Column(name = "response_message", columnDefinition = "TEXT")
    private String responseMessage;

    @Column(name = "status", nullable = false)
    private String status; // Pending, Approved, Rejected

    @Column(name = "is_urgent")
    private boolean isUrgent;

    // Constructors
    public PrescriptionRenewalRequest() {
        this.requestDate = new Date();
        this.status = "Pending";
    }

    public PrescriptionRenewalRequest(Prescription prescription, Patient patient, Doctor doctor) {
        this();
        this.prescription = prescription;
        this.patient = patient;
        this.doctor = doctor;
    }

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Prescription getPrescription() {
        return prescription;
    }

    public void setPrescription(Prescription prescription) {
        this.prescription = prescription;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public Doctor getDoctor() {
        return doctor;
    }

    public void setDoctor(Doctor doctor) {
        this.doctor = doctor;
    }

    public Date getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Date requestDate) {
        this.requestDate = requestDate;
    }

    public Date getResponseDate() {
        return responseDate;
    }

    public void setResponseDate(Date responseDate) {
        this.responseDate = responseDate;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getResponseMessage() {
        return responseMessage;
    }

    public void setResponseMessage(String responseMessage) {
        this.responseMessage = responseMessage;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isUrgent() {
        return isUrgent;
    }

    public void setUrgent(boolean urgent) {
        isUrgent = urgent;
    }

    // Utility methods
    public boolean isPending() {
        return "Pending".equals(status);
    }

    public boolean isApproved() {
        return "Approved".equals(status);
    }

    public boolean isRejected() {
        return "Rejected".equals(status);
    }

    public boolean isToday() {
        if (requestDate == null) return false;

        java.util.Calendar today = java.util.Calendar.getInstance();
        java.util.Calendar requestCal = java.util.Calendar.getInstance();
        requestCal.setTime(requestDate);

        return today.get(java.util.Calendar.YEAR) == requestCal.get(java.util.Calendar.YEAR) &&
                today.get(java.util.Calendar.DAY_OF_YEAR) == requestCal.get(java.util.Calendar.DAY_OF_YEAR);
    }

    public long getDaysAgo() {
        if (requestDate == null) return 0;

        long diffInMillies = new Date().getTime() - requestDate.getTime();
        return diffInMillies / (1000 * 60 * 60 * 24);
    }

    @Override
    public String toString() {
        return "PrescriptionRenewalRequest{" +
                "id=" + id +
                ", patient=" + (patient != null ? patient.getFullName() : "null") +
                ", doctor=" + (doctor != null ? doctor.getFullName() : "null") +
                ", status='" + status + '\'' +
                ", isUrgent=" + isUrgent +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        PrescriptionRenewalRequest that = (PrescriptionRenewalRequest) o;
        return id == that.id;
    }

    @Override
    public int hashCode() {
        return 31 * id;
    }
}
