package com.medicalcenter.model;

import jakarta.persistence.*;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "medical_records")
public class MedicalRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "created_at", nullable = false)
    private Date createdAt;

    @Column(name = "status", nullable = false)
    private String status;

    @OneToMany(mappedBy = "record", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<MedicalDocument> documents = new HashSet<>();

    @OneToMany(mappedBy = "record", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Prescription> prescriptions = new HashSet<>();

    // Additional fields for medical information
    @Column(name = "diagnosis")
    private String diagnosis;

    @Column(name = "symptoms")
    private String symptoms;

    @Column(name = "treatment_plan", length = 2000)
    private String treatmentPlan;

    @Column(name = "allergies")
    private String allergies;

    @Column(name = "blood_type")
    private String bloodType;

    @Column(name = "height")
    private Double height;  // in cm

    @Column(name = "weight")
    private Double weight;  // in kg

    @Column(name = "blood_pressure")
    private String bloodPressure;

    @Column(name = "temperature")
    private Double temperature;  // in Celsius

    @Column(name = "notes", length = 2000)
    private String notes;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "last_updated")
    private Date lastUpdated;

    // Constructors
    public MedicalRecord() {
        this.createdAt = new Date();
        this.lastUpdated = new Date();
        this.status = "Active";
    }

    public MedicalRecord(Patient patient) {
        this();
        this.patient = patient;
    }

    public MedicalRecord(Patient patient, String diagnosis, String symptoms) {
        this(patient);
        this.diagnosis = diagnosis;
        this.symptoms = symptoms;
    }

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Set<MedicalDocument> getDocuments() {
        return documents;
    }

    public void setDocuments(Set<MedicalDocument> documents) {
        this.documents = documents;
    }

    public Set<Prescription> getPrescriptions() {
        return prescriptions;
    }

    public void setPrescriptions(Set<Prescription> prescriptions) {
        this.prescriptions = prescriptions;
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
        this.lastUpdated = new Date();
    }

    public String getSymptoms() {
        return symptoms;
    }

    public void setSymptoms(String symptoms) {
        this.symptoms = symptoms;
        this.lastUpdated = new Date();
    }

    public String getTreatmentPlan() {
        return treatmentPlan;
    }

    public void setTreatmentPlan(String treatmentPlan) {
        this.treatmentPlan = treatmentPlan;
        this.lastUpdated = new Date();
    }

    public String getAllergies() {
        return allergies;
    }

    public void setAllergies(String allergies) {
        this.allergies = allergies;
        this.lastUpdated = new Date();
    }

    public String getBloodType() {
        return bloodType;
    }

    public void setBloodType(String bloodType) {
        this.bloodType = bloodType;
        this.lastUpdated = new Date();
    }

    public Double getHeight() {
        return height;
    }

    public void setHeight(Double height) {
        this.height = height;
        this.lastUpdated = new Date();
    }

    public Double getWeight() {
        return weight;
    }

    public void setWeight(Double weight) {
        this.weight = weight;
        this.lastUpdated = new Date();
    }

    public String getBloodPressure() {
        return bloodPressure;
    }

    public void setBloodPressure(String bloodPressure) {
        this.bloodPressure = bloodPressure;
        this.lastUpdated = new Date();
    }

    public Double getTemperature() {
        return temperature;
    }

    public void setTemperature(Double temperature) {
        this.temperature = temperature;
        this.lastUpdated = new Date();
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
        this.lastUpdated = new Date();
    }

    public Date getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(Date lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    // Utility methods
    public void addDocument(MedicalDocument document) {
        documents.add(document);
        document.setRecord(this);
        this.lastUpdated = new Date();
    }

    public void removeDocument(MedicalDocument document) {
        documents.remove(document);
        document.setRecord(null);
        this.lastUpdated = new Date();
    }

    public void addPrescription(Prescription prescription) {
        prescriptions.add(prescription);
        prescription.setRecord(this);
        this.lastUpdated = new Date();
    }

    public void removePrescription(Prescription prescription) {
        prescriptions.remove(prescription);
        prescription.setRecord(null);
        this.lastUpdated = new Date();
    }

    // Calculate BMI if height and weight are available
    public Double calculateBMI() {
        if (height != null && weight != null && height > 0) {
            // BMI = weight(kg) / (height(m))²
            double heightInMeters = height / 100.0;
            return weight / (heightInMeters * heightInMeters);
        }
        return null;
    }

    // Get BMI category
    public String getBMICategory() {
        Double bmi = calculateBMI();
        if (bmi == null) {
            return "Unknown";
        }

        if (bmi < 18.5) {
            return "Underweight";
        } else if (bmi < 25) {
            return "Normal weight";
        } else if (bmi < 30) {
            return "Overweight";
        } else {
            return "Obese";
        }
    }

    // Check if record is recent (within specified days)
    public boolean isRecent(int days) {
        if (lastUpdated == null) return false;
        long diffInMillies = new Date().getTime() - lastUpdated.getTime();
        long diffInDays = diffInMillies / (24 * 60 * 60 * 1000);
        return diffInDays <= days;
    }

    // Get most recent prescription
    public Prescription getMostRecentPrescription() {
        Prescription mostRecent = null;
        Date mostRecentDate = null;

        for (Prescription prescription : prescriptions) {
            if (mostRecentDate == null || prescription.getPrescribedDate().after(mostRecentDate)) {
                mostRecentDate = prescription.getPrescribedDate();
                mostRecent = prescription;
            }
        }

        return mostRecent;
    }

    // Check if record is active
    public boolean isActive() {
        return "Active".equals(status);
    }

    // Check if record is archived
    public boolean isArchived() {
        return "Archived".equals(status);
    }

    // Archive the record
    public void archive() {
        this.status = "Archived";
        this.lastUpdated = new Date();
    }

    // Reactivate the record
    public void reactivate() {
        this.status = "Active";
        this.lastUpdated = new Date();
    }

    // Override toString method
    @Override
    public String toString() {
        return "Medical Record #" + id + " - " + patient.getFullName() + " (" + status + ")";
    }

    // Override equals and hashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        MedicalRecord record = (MedicalRecord) o;

        return id == record.id;
    }

    @Override
    public int hashCode() {
        return 31 * id;
    }
}