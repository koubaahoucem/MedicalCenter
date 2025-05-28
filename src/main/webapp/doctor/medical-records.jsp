<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dossier Médical - ${patient.fullName} - Centre Médical</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome pour les icônes -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <%@ include file="../css/doctor/doctor-styles.jsp" %>
    <!-- Page-specific styles -->
    <style>
        .medical-record-section {
            border: none;
            border-radius: 10px;
        }
        .medical-record-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
            padding: 1rem 1.25rem;
            border-radius: 10px 10px 0 0;
        }
        .medical-record-body {
            padding: 1.25rem;
        }
        .patient-info-card {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border-radius: 15px;
        }
        .health-metric {
            text-align: center;
            padding: 1rem;
            border-radius: 10px;
            background-color: #f8f9fa;
            border: 1px solid #e9ecef;
        }
        .health-metric i {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }
        .allergy-badge {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        .medication-badge {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
        .timeline {
            position: relative;
            padding-left: 30px;
        }
        .timeline::before {
            content: '';
            position: absolute;
            left: 15px;
            top: 0;
            bottom: 0;
            width: 2px;
            background-color: #dee2e6;
        }
        .timeline-item {
            position: relative;
            margin-bottom: 2rem;
        }
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -23px;
            top: 5px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background-color: #3498db;
            border: 2px solid #fff;
            box-shadow: 0 0 0 2px #dee2e6;
        }
        .timeline-date {
            font-size: 0.875rem;
            color: #6c757d;
            margin-bottom: 0.5rem;
        }
        .timeline-content {
            background-color: #fff;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 1rem;
        }
    </style>
</head>
<body>
<!-- Navbar supérieure -->
<%@ include file="../doctor-header.jsp" %>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <c:set var="activePage" value="medical-records" scope="request" />
        <%@ include file="../doctor-sidebar.jsp" %>


        <!-- Contenu principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Dossier médical - ${patient.fullName}</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <div class="btn-group me-2">
                        <a href="${pageContext.request.contextPath}/doctor/prescriptions/new?patientId=${patient.id}" class="btn btn-sm btn-primary">
                            <i class="fas fa-prescription me-1"></i> Nouvelle ordonnance
                        </a>
                        <button type="button" class="btn btn-sm btn-outline-secondary" onclick="window.print()">
                            <i class="fas fa-print me-1"></i> Imprimer
                        </button>
                    </div>
                    <a href="${pageContext.request.contextPath}/doctor/appointments" class="btn btn-sm btn-outline-secondary">
                        <i class="fas fa-arrow-left me-1"></i> Retour
                    </a>
                </div>
            </div>

            <!-- Affichage des messages d'erreur ou de succès -->
            <c:if test="${param.success == 'updated'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>Dossier médical mis à jour avec succès.
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Informations patient -->
            <div class="card patient-info-card">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h4 class="mb-1">${patient.fullName}</h4>
                            <p class="mb-2">
                                <c:if test="${not empty patient.birthDate}">
                                    <i class="fas fa-birthday-cake me-2"></i>
                                    <fmt:formatDate value="${patient.birthDate}" pattern="dd/MM/yyyy"/>
                                </c:if>
                                <c:if test="${not empty patient.phone}">
                                    <span class="ms-3"><i class="fas fa-phone me-2"></i>${patient.phone}</span>
                                </c:if>
                            </p>
                            <p class="mb-0">
                                <c:if test="${not empty patient.address}">
                                    <i class="fas fa-map-marker-alt me-2"></i>${patient.address}
                                </c:if>
                            </p>
                        </div>
                        <div class="col-md-4 text-end">
                            <div class="d-flex justify-content-end align-items-center">
                                <div class="bg-white bg-opacity-25 rounded-circle d-flex align-items-center justify-content-center" style="width: 80px; height: 80px;">
                                    <i class="fas fa-user fa-2x text-white"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <c:if test="${not empty currentRecord}">
                <!-- Informations médicales actuelles -->
                <div class="card medical-record-section">
                    <div class="medical-record-header">
                        <h5 class="mb-0"><i class="fas fa-heartbeat me-2"></i> Informations médicales actuelles</h5>
                    </div>
                    <div class="medical-record-body">
                        <div class="row mb-4">
                            <div class="col-md-4 mb-3">
                                <div class="health-metric">
                                    <i class="fas fa-tint text-danger"></i>
                                    <h6>Groupe sanguin</h6>
                                    <p class="h5 mb-0">${not empty currentRecord.bloodType ? currentRecord.bloodType : 'Non renseigné'}</p>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="health-metric">
                                    <i class="fas fa-weight text-primary"></i>
                                    <h6>Poids</h6>
                                    <p class="h5 mb-0">
                                        <c:choose>
                                            <c:when test="${not empty currentRecord.weight}">
                                                <fmt:formatNumber value="${currentRecord.weight}" maxFractionDigits="1"/> kg
                                            </c:when>
                                            <c:otherwise>Non mesuré</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <c:if test="${not empty currentRecord.calculateBMI()}">
                                        <small class="text-muted">
                                            IMC: <fmt:formatNumber value="${currentRecord.calculateBMI()}" maxFractionDigits="1"/>
                                        </small>
                                    </c:if>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="health-metric">
                                    <i class="fas fa-heartbeat text-danger"></i>
                                    <h6>Tension artérielle</h6>
                                    <p class="h5 mb-0">${not empty currentRecord.bloodPressure ? currentRecord.bloodPressure : 'Non mesurée'}</p>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <h6>Allergies</h6>
                                <div class="mb-3">
                                    <c:choose>
                                        <c:when test="${not empty currentRecord.allergies}">
                                            <c:forEach var="allergy" items="${fn:split(currentRecord.allergies, ',')}">
                                                <span class="badge allergy-badge p-2 m-1">${fn:trim(allergy)}</span>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Aucune allergie connue</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <h6>Diagnostic actuel</h6>
                                <p>${not empty currentRecord.diagnosis ? currentRecord.diagnosis : 'Aucun diagnostic'}</p>
                            </div>
                        </div>

                        <c:if test="${not empty currentRecord.notes}">
                            <div class="row">
                                <div class="col-12">
                                    <h6>Notes médicales</h6>
                                    <p>${currentRecord.notes}</p>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:if>

            <!-- Historique médical -->
            <div class="card medical-record-section">
                <div class="medical-record-header">
                    <h5 class="mb-0"><i class="fas fa-history me-2"></i> Historique médical</h5>
                </div>
                <div class="medical-record-body">
                    <c:choose>
                        <c:when test="${not empty medicalRecords}">
                            <div class="timeline">
                                <c:forEach var="record" items="${medicalRecords}" varStatus="status">
                                    <div class="timeline-item">
                                        <div class="timeline-date">
                                            <fmt:formatDate value="${record.createdAt}" pattern="dd MMM yyyy"/>
                                        </div>
                                        <div class="timeline-content">
                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <h6 class="mb-0">
                                                    <c:choose>
                                                        <c:when test="${not empty record.diagnosis}">
                                                            ${record.diagnosis}
                                                        </c:when>
                                                        <c:otherwise>Consultation médicale</c:otherwise>
                                                    </c:choose>
                                                </h6>
                                                <span class="badge ${record.isActive() ? 'bg-success' : 'bg-secondary'}">
                                                        ${record.status}
                                                </span>
                                            </div>
                                            <c:if test="${not empty record.symptoms}">
                                                <p><strong>Symptômes:</strong> ${record.symptoms}</p>
                                            </c:if>
                                            <c:if test="${not empty record.treatmentPlan}">
                                                <p><strong>Plan de traitement:</strong> ${record.treatmentPlan}</p>
                                            </c:if>
                                            <c:if test="${not empty record.notes}">
                                                <p><strong>Notes:</strong> ${record.notes}</p>
                                            </c:if>
                                            <c:if test="${not empty prescriptions}">
                                                <div class="mt-2">
                                                    <strong>Prescriptions:</strong>
                                                    <c:forEach var="prescription" items="${prescriptions}">
                                                        <span class="medication-badge p-1 m-1">${prescription.description}</span>
                                                    </c:forEach>
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center mt-2">
                                            <small class="text-muted">
                                                <fmt:formatDate value="${record.lastUpdated}" pattern="dd/MM/yyyy à HH:mm"/>
                                            </small>
                                            <c:if test="${record.isActive()}">
                                                <a href="${pageContext.request.contextPath}/doctor/medical-record/edit?recordId=${record.id}"
                                                   class="btn btn-sm btn-outline-primary">
                                                    <i class="fas fa-edit me-1"></i> Modifier
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted">Aucun historique médical disponible</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Bootstrap JS Bundle avec Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
