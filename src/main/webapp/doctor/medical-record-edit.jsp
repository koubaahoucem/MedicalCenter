<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier Dossier Médical - ${patient.fullName} - Centre Médical</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome pour les icônes -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <%@ include file="../css/doctor/doctor-styles.jsp" %>
    
    <style>
        .form-section {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border: 1px solid #e9ecef;
        }
        
        .form-section h5 {
            color: #495057;
            border-bottom: 2px solid #3498db;
            padding-bottom: 0.5rem;
            margin-bottom: 1rem;
        }
        
        .patient-info-header {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .form-control:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
        }
        
        .btn-primary {
            background-color: #3498db;
            border-color: #3498db;
        }
        
        .btn-primary:hover {
            background-color: #2980b9;
            border-color: #2980b9;
        }
        
        .required {
            color: #e74c3c;
        }
    </style>
</head>
<body>
<!-- Navbar supérieure -->
<%@ include file="../doctor-header.jsp" %>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <c:set var="activePage" value="medical-records-edit" scope="request" />
        <%@ include file="../doctor-sidebar.jsp" %>

        <!-- Contenu principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Modifier le dossier médical - ${patient.fullName}</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="${pageContext.request.contextPath}/doctor/medical-records?patientId=${patient.id}" class="btn btn-sm btn-outline-secondary">
                        <i class="fas fa-arrow-left me-1"></i> Retour au dossier
                    </a>
                </div>
            </div>

            <!-- Affichage des messages d'erreur ou de succès -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Informations patient -->
            <div class="patient-info-header">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h4 class="mb-1">${patient.fullName}</h4>
                        <p class="mb-0">
                            <c:if test="${not empty patient.birthDate}">
                                <i class="fas fa-birthday-cake me-2"></i>
                                <fmt:formatDate value="${patient.birthDate}" pattern="dd/MM/yyyy"/>
                            </c:if>
                            <c:if test="${not empty patient.phone}">
                                <span class="ms-3"><i class="fas fa-phone me-2"></i>${patient.phone}</span>
                            </c:if>
                        </p>
                    </div>
                    <div class="col-md-4 text-end">
                        <div class="bg-white bg-opacity-25 rounded-circle d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                            <i class="fas fa-user fa-lg text-white"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Formulaire de modification -->
            <form method="post" action="${pageContext.request.contextPath}/doctor/medical-record/edit">
                <input type="hidden" name="recordId" value="${medicalRecord.id}">
                
                <!-- Informations générales -->
                <div class="form-section">
                    <h5><i class="fas fa-stethoscope me-2"></i>Informations générales</h5>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="diagnosis" class="form-label">Diagnostic <span class="required">*</span></label>
                            <input type="text" class="form-control" id="diagnosis" name="diagnosis" 
                                   value="${medicalRecord.diagnosis}" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="status" class="form-label">Statut</label>
                            <select class="form-select" id="status" name="status">
                                <option value="Active" ${medicalRecord.status == 'Active' ? 'selected' : ''}>Actif</option>
                                <option value="Archived" ${medicalRecord.status == 'Archived' ? 'selected' : ''}>Archivé</option>
                                <option value="Under Review" ${medicalRecord.status == 'Under Review' ? 'selected' : ''}>En révision</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12 mb-3">
                            <label for="symptoms" class="form-label">Symptômes</label>
                            <textarea class="form-control" id="symptoms" name="symptoms" rows="3">${medicalRecord.symptoms}</textarea>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12 mb-3">
                            <label for="treatmentPlan" class="form-label">Plan de traitement</label>
                            <textarea class="form-control" id="treatmentPlan" name="treatmentPlan" rows="4">${medicalRecord.treatmentPlan}</textarea>
                        </div>
                    </div>
                </div>

                <!-- Informations médicales -->
                <div class="form-section">
                    <h5><i class="fas fa-heartbeat me-2"></i>Informations médicales</h5>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label for="bloodType" class="form-label">Groupe sanguin</label>
                            <select class="form-select" id="bloodType" name="bloodType">
                                <option value="">Sélectionner...</option>
                                <option value="A+" ${medicalRecord.bloodType == 'A+' ? 'selected' : ''}>A+</option>
                                <option value="A-" ${medicalRecord.bloodType == 'A-' ? 'selected' : ''}>A-</option>
                                <option value="B+" ${medicalRecord.bloodType == 'B+' ? 'selected' : ''}>B+</option>
                                <option value="B-" ${medicalRecord.bloodType == 'B-' ? 'selected' : ''}>B-</option>
                                <option value="AB+" ${medicalRecord.bloodType == 'AB+' ? 'selected' : ''}>AB+</option>
                                <option value="AB-" ${medicalRecord.bloodType == 'AB-' ? 'selected' : ''}>AB-</option>
                                <option value="O+" ${medicalRecord.bloodType == 'O+' ? 'selected' : ''}>O+</option>
                                <option value="O-" ${medicalRecord.bloodType == 'O-' ? 'selected' : ''}>O-</option>
                            </select>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="height" class="form-label">Taille (cm)</label>
                            <input type="number" class="form-control" id="height" name="height" 
                                   value="${medicalRecord.height}" step="0.1" min="0" max="300">
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="weight" class="form-label">Poids (kg)</label>
                            <input type="number" class="form-control" id="weight" name="weight" 
                                   value="${medicalRecord.weight}" step="0.1" min="0" max="500">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="bloodPressure" class="form-label">Tension artérielle</label>
                            <input type="text" class="form-control" id="bloodPressure" name="bloodPressure" 
                                   value="${medicalRecord.bloodPressure}" placeholder="ex: 120/80">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="temperature" class="form-label">Température (°C)</label>
                            <input type="number" class="form-control" id="temperature" name="temperature" 
                                   value="${medicalRecord.temperature}" step="0.1" min="30" max="45">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12 mb-3">
                            <label for="allergies" class="form-label">Allergies</label>
                            <input type="text" class="form-control" id="allergies" name="allergies" 
                                   value="${medicalRecord.allergies}" placeholder="Séparer par des virgules">
                            <div class="form-text">Séparez les allergies par des virgules (ex: Pénicilline, Arachides, Pollen)</div>
                        </div>
                    </div>
                </div>

                <!-- Notes -->
                <div class="form-section">
                    <h5><i class="fas fa-sticky-note me-2"></i>Notes médicales</h5>
                    <div class="row">
                        <div class="col-12 mb-3">
                            <label for="notes" class="form-label">Notes</label>
                            <textarea class="form-control" id="notes" name="notes" rows="5">${medicalRecord.notes}</textarea>
                            <div class="form-text">Notes additionnelles, observations, recommandations...</div>
                        </div>
                    </div>
                </div>

                <!-- Boutons d'action -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <button type="submit" class="btn btn-primary me-2">
                            <i class="fas fa-save me-1"></i> Enregistrer les modifications
                        </button>
                        <a href="${pageContext.request.contextPath}/doctor/medical-records?patientId=${patient.id}" 
                           class="btn btn-outline-secondary">
                            <i class="fas fa-times me-1"></i> Annuler
                        </a>
                    </div>
                    <div>
                        <small class="text-muted">
                            <i class="fas fa-info-circle me-1"></i>
                            Dernière modification: 
                            <c:choose>
                                <c:when test="${not empty medicalRecord.lastUpdated}">
                                    <fmt:formatDate value="${medicalRecord.lastUpdated}" pattern="dd/MM/yyyy à HH:mm"/>
                                </c:when>
                                <c:otherwise>
                                    <fmt:formatDate value="${medicalRecord.createdAt}" pattern="dd/MM/yyyy à HH:mm"/>
                                </c:otherwise>
                            </c:choose>
                        </small>
                    </div>
                </div>
            </form>
        </main>
    </div>
</div>

<!-- Bootstrap JS Bundle avec Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
// Auto-calculate BMI when height and weight are entered
document.getElementById('height').addEventListener('input', calculateBMI);
document.getElementById('weight').addEventListener('input', calculateBMI);

function calculateBMI() {
    const height = parseFloat(document.getElementById('height').value);
    const weight = parseFloat(document.getElementById('weight').value);
    
    if (height && weight && height > 0) {
        const heightInMeters = height / 100;
        const bmi = weight / (heightInMeters * heightInMeters);
        
        // You could display BMI here if needed
        console.log('BMI:', bmi.toFixed(1));
    }
}

// Form validation
document.querySelector('form').addEventListener('submit', function(e) {
    const diagnosis = document.getElementById('diagnosis').value.trim();
    
    if (!diagnosis) {
        e.preventDefault();
        alert('Le diagnostic est obligatoire.');
        document.getElementById('diagnosis').focus();
        return false;
    }
    
    // Validate numeric fields
    const height = document.getElementById('height').value;
    const weight = document.getElementById('weight').value;
    const temperature = document.getElementById('temperature').value;
    
    if (height && (isNaN(height) || height < 0 || height > 300)) {
        e.preventDefault();
        alert('La taille doit être un nombre valide entre 0 et 300 cm.');
        document.getElementById('height').focus();
        return false;
    }
    
    if (weight && (isNaN(weight) || weight < 0 || weight > 500)) {
        e.preventDefault();
        alert('Le poids doit être un nombre valide entre 0 et 500 kg.');
        document.getElementById('weight').focus();
        return false;
    }
    
    if (temperature && (isNaN(temperature) || temperature < 30 || temperature > 45)) {
        e.preventDefault();
        alert('La température doit être un nombre valide entre 30 et 45°C.');
        document.getElementById('temperature').focus();
        return false;
    }
});
</script>
</body>
</html>
