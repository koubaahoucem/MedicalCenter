package com.medicalcenter.model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "medical_documents")
public class MedicalDocument {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "record_id", nullable = false)
    private MedicalRecord record;

    @Column(name = "file_path", nullable = false)
    private String filePath;

    @Column(name = "description")
    private String description;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "uploaded_at", nullable = false)
    private Date uploadedAt;

    @ManyToOne
    @JoinColumn(name = "uploaded_by", nullable = false)
    private User uploadedBy;

    // Constructors
    public MedicalDocument() {
        this.uploadedAt = new Date();
    }

    public MedicalDocument(MedicalRecord record, String filePath, User uploadedBy) {
        this();
        this.record = record;
        this.filePath = filePath;
        this.uploadedBy = uploadedBy;
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

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(Date uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    public User getUploadedBy() {
        return uploadedBy;
    }

    public void setUploadedBy(User uploadedBy) {
        this.uploadedBy = uploadedBy;
    }

    // Utility methods
    public String getFileName() {
        if (filePath == null) return null;
        int lastSlashIndex = filePath.lastIndexOf('/');
        if (lastSlashIndex == -1) {
            lastSlashIndex = filePath.lastIndexOf('\\');
        }
        if (lastSlashIndex != -1 && lastSlashIndex < filePath.length() - 1) {
            return filePath.substring(lastSlashIndex + 1);
        }
        return filePath;
    }

    public String getFileExtension() {
        String fileName = getFileName();
        if (fileName == null) return null;
        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex != -1 && lastDotIndex < fileName.length() - 1) {
            return fileName.substring(lastDotIndex + 1);
        }
        return "";
    }
}