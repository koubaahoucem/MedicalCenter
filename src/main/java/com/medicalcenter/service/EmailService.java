package com.medicalcenter.service;

import com.medicalcenter.util.EmailUtil;
import com.medicalcenter.model.Doctor;

import java.util.logging.Level;
import java.util.logging.Logger;

public class EmailService {
    private static final Logger logger = Logger.getLogger(EmailService.class.getName());
    
    public boolean sendPatientInvitation(String patientEmail, String patientName, Doctor doctor, String invitationToken) {
        try {
            String subject = "Invitation à rejoindre le Centre Médical - Dr. " + doctor.getFullName();
            
            String body = buildInvitationEmailBody(patientName, doctor, invitationToken);
            
            return EmailUtil.sendEmail(patientEmail, subject, body);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error sending patient invitation", e);
            return false;
        }
    }
    
    private String buildInvitationEmailBody(String patientName, Doctor doctor, String invitationToken) {
        StringBuilder body = new StringBuilder();
        
        body.append("Bonjour ").append(patientName != null ? patientName : "").append(",\n\n");
        
        body.append("Le Dr. ").append(doctor.getFullName());
        if (doctor.getSpecialty() != null) {
            body.append(" (").append(doctor.getSpecialty().getName()).append(")");
        }
        body.append(" vous invite à créer votre compte patient sur notre plateforme médicale.\n\n");
        
        body.append("Avantages de votre compte patient :\n");
        body.append("• Prise de rendez-vous en ligne 24h/24\n");
        body.append("• Accès à votre dossier médical\n");
        body.append("• Demandes de renouvellement d'ordonnances\n");
        body.append("• Communication sécurisée avec votre médecin\n");
        body.append("• Rappels automatiques de rendez-vous\n\n");
        
        body.append("Pour créer votre compte, cliquez sur le lien suivant :\n");
        body.append("http://localhost:8080/medicalcenter/register?token=").append(invitationToken).append("\n\n");
        
        body.append("Ce lien est valide pendant 7 jours.\n\n");
        
        body.append("Informations du médecin :\n");
        body.append("Dr. ").append(doctor.getFullName()).append("\n");
        if (doctor.getPhone() != null) {
            body.append("Téléphone : ").append(doctor.getPhone()).append("\n");
        }
        body.append("Email : ").append(doctor.getUser().getEmail()).append("\n\n");
        
        body.append("Si vous avez des questions, n'hésitez pas à nous contacter.\n\n");
        body.append("Cordialement,\n");
        body.append("L'équipe du Centre Médical");
        
        return body.toString();
    }
    
    public boolean sendAppointmentReminder(String patientEmail, String patientName, String appointmentDetails) {
        try {
            String subject = "Rappel de rendez-vous - Centre Médical";
            
            String body = "Bonjour " + (patientName != null ? patientName : "") + ",\n\n" +
                         "Nous vous rappelons votre rendez-vous :\n\n" +
                         appointmentDetails + "\n\n" +
                         "Merci de confirmer votre présence.\n\n" +
                         "Cordialement,\n" +
                         "L'équipe du Centre Médical";
            
            return EmailUtil.sendEmail(patientEmail, subject, body);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error sending appointment reminder", e);
            return false;
        }
    }
}
