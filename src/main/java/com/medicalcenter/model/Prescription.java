package com.medicalcenter.model;

import jakarta.persistence.*;
import java.util.Calendar;
import java.util.Date;

@Entity
@Table(name = "prescriptions")
public class Prescription {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "record_id", nullable = false)
    private MedicalRecord record;

    @ManyToOne
    @JoinColumn(name = "doctor_id", nullable = false)
    private Doctor doctor;

    @Temporal(TemporalType.DATE)
    @Column(name = "prescribed_date", nullable = false)
    private Date prescribedDate;

    @Column(name = "description", nullable = false)
    private String description;

    @Column(name = "title")
    private String title;

    @Column(name = "file_path")
    private String filePath;

    @Temporal(TemporalType.DATE)
    @Column(name = "expiry_date")
    private Date expiryDate;

    // Constructors
    public Prescription() {
        this.prescribedDate = new Date();
        // Set default expiry date to 30 days from now
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_MONTH, 30);
        this.expiryDate = calendar.getTime();
    }

    public Prescription(MedicalRecord record, Doctor doctor, String description) {
        this();
        this.record = record;
        this.doctor = doctor;
        this.description = description;
    }

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public MedicalRecord getRecord() {
        return record;
    }

    public void setRecord(MedicalRecord record) {
        this.record = record;
    }

    public Doctor getDoctor() {
        return doctor;
    }

    public void setDoctor(Doctor doctor) {
        this.doctor = doctor;
    }

    public Date getPrescribedDate() {
        return prescribedDate;
    }

    public void setPrescribedDate(Date prescribedDate) {
        this.prescribedDate = prescribedDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    // Utility methods
    public Patient getPatient() {
        if (record != null) {
            return record.getPatient();
        }
        return null;
    }

    public boolean isRecent(int days) {
        if (prescribedDate == null) return false;
        long diffInMillies = new Date().getTime() - prescribedDate.getTime();
        long diffInDays = diffInMillies / (24 * 60 * 60 * 1000);
        return diffInDays <= days;
    }

    // Methods used in JSP
    public boolean isExpired() {
        if (expiryDate == null) return false;
        return expiryDate.before(new Date());
    }

    public boolean isExpiringSoon() {
        if (expiryDate == null) return false;

        Calendar soon = Calendar.getInstance();
        soon.add(Calendar.DAY_OF_MONTH, 7); // Consider "soon" as within 7 days

        Date now = new Date();
        return expiryDate.after(now) && expiryDate.before(soon.getTime());
    }

}
