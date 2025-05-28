package com.medicalcenter.model;

import jakarta.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "doctors")
public class Doctor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @OneToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "first_name", nullable = false)
    private String firstName;

    @Column(name = "last_name", nullable = false)
    private String lastName;

    @Column(name = "phone")
    private String phone;

    @Column(name = "license_number", nullable = false)
    private String licenseNumber;

    @ManyToOne // Many Doctors can belong to One Specialty
    @JoinColumn(name = "specialty_id", nullable = false) // Foreign key column
    private Specialty specialty;

    @OneToMany(mappedBy = "doctor", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Appointment> appointments = new HashSet<>();

    @OneToMany(mappedBy = "doctor", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Prescription> prescriptions = new HashSet<>();

    @ManyToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinTable(
            name = "doctor_patient",
            joinColumns = @JoinColumn(name = "doctor_id"),
            inverseJoinColumns = @JoinColumn(name = "patient_id")
    )
    private Set<Patient> patients = new HashSet<>();


    // Constructors
    public Doctor() {
    }

    public Doctor(User user, String firstName, String lastName, String licenseNumber) {
        this.user = user;
        this.firstName = firstName;
        this.lastName = lastName;
        this.licenseNumber = licenseNumber;
    }

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getLicenseNumber() {
        return licenseNumber;
    }

    public void setLicenseNumber(String licenseNumber) {
        this.licenseNumber = licenseNumber;
    }


    public Set<Appointment> getAppointments() {
        return appointments;
    }

    public void setAppointments(Set<Appointment> appointments) {
        this.appointments = appointments;
    }

    public Set<Prescription> getPrescriptions() {
        return prescriptions;
    }

    public void setPrescriptions(Set<Prescription> prescriptions) {
        this.prescriptions = prescriptions;
    }
    public void addAppointment(Appointment appointment) {
        appointments.add(appointment);
        appointment.setDoctor(this);
    }

    public void removeAppointment(Appointment appointment) {
        appointments.remove(appointment);
        appointment.setDoctor(null);
    }

    public void addPrescription(Prescription prescription) {
        prescriptions.add(prescription);
        prescription.setDoctor(this);
    }

    public void removePrescription(Prescription prescription) {
        prescriptions.remove(prescription);
        prescription.setDoctor(null);
    }

    // Full name utility method
    public String getFullName() {
        return firstName + " " + lastName;
    }
    // Get count of appointments by status
    public int getAppointmentCountByStatus(String status) {
        int count = 0;
        for (Appointment appointment : appointments) {
            if (appointment.getStatus().equals(status)) {
                count++;
            }
        }
        return count;
    }

    // Get upcoming appointments
    public Set<Appointment> getUpcomingAppointments() {
        Set<Appointment> upcoming = new HashSet<>();
        for (Appointment appointment : appointments) {
            if (appointment.getStartTime().after(new java.util.Date()) &&
                    !appointment.isCancelled()) {
                upcoming.add(appointment);
            }
        }
        return upcoming;
    }

    // Override toString method
    @Override
    public String toString() {
        return "Dr. " + firstName + " " + lastName;
    }

    // Override equals and hashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Doctor doctor = (Doctor) o;

        return id == doctor.id;
    }

    @Override
    public int hashCode() {
        return 31 * id;
    }

    public Specialty getSpecialty() {
        return specialty;
    }

    public void setSpecialty(Specialty specialty) {
        this.specialty = specialty;
    }

    public Set<Patient> getPatients() {
        return patients;
    }

    public void setPatients(Set<Patient> patients) {
        this.patients = patients;
    }
}