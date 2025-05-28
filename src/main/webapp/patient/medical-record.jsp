<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Dossier Médical · Centre Médical</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <!-- Custom CSS extracted to keep JSP lean -->
    <jsp:include page="../css/patient/style.jsp" />

    <!-- Extra styles for timeline + soft cards (local to this page) -->
    <style>
        /* Correction pour la navbar fixe */
        body {
            padding-top: 70px; /* Ajustez cette valeur selon la hauteur réelle de votre navbar */
        }

        @media (max-width: 768px) {
            body {
                padding-top: 60px;
            }
        }

        /* Vos styles existants */
        /* ===== Timeline ===== */
        .timeline {
            position: relative;
        }
        .timeline::before {
            content: "";
            position: absolute;
            top: 0;
            bottom: 0;
            left: 8px;
            width: 2px;
            background: var(--bs-primary);
            opacity: .25;
        }
        .timeline-item {
            position: relative;
            padding-left: 1.75rem;
        }
        .timeline-item::before {
            content: "";
            position: absolute;
            left: 0;
            top: 6px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: var(--bs-primary);
        }

        /* ===== Print optimisation ===== */
        @media print {
            nav.navbar, #sidebar, .btn-group, .breadcrumb {
                display: none !important;
            }
            main {
                margin: 0 !important;
                padding: 0 !important;
            }
            .card {
                page-break-inside: avoid;
            }
            body {
                padding-top: 0 !important;
            }
        }
    </style>
</head>
<body>
<!-- ===== Navigation ===== -->
<jsp:include page="../header.jsp" />

<div class="container-fluid ">
    <div class="row">
        <!-- Sidebar -->
        <c:set var="activePage" value="medical-record" scope="request" />
        <jsp:include page="../sidebar.jsp" />

        <!-- ===== Main Content ===== -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-5 py-4 ">
            <!-- Page header -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 border-bottom pb-3 mb-4 ">
                <h1 class="h2 mb-0"><i class="fas fa-file-medical me-2 text-primary"></i>Mon dossier médical</h1>
                <div class="btn-group">
                    <button class="btn btn-sm btn-outline-secondary" onclick="downloadMedicalRecord()">
                        <i class="fas fa-download me-1"></i>Télécharger
                    </button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="printMedicalRecord()">
                        <i class="fas fa-print me-1"></i>Imprimer
                    </button>
                    <button class="btn btn-sm btn-outline-primary" onclick="shareMedicalRecord()">
                        <i class="fas fa-share-alt me-1"></i>Partager
                    </button>
                </div>
            </div>

            <!-- ===== Messages ===== -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger d-flex align-items-center" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>${error}
                </div>
            </c:if>

            <c:if test="${empty patient}">
                <div class="alert alert-warning d-flex align-items-center" role="alert">
                    <i class="fas fa-info-circle me-2"></i>Aucune information patient trouvée.
                </div>
            </c:if>

            <c:if test="${not empty patient}">
                <!-- ░░ Informations personnelles ░░ -->
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-light border-0 d-flex align-items-center">
                        <h5 class="mb-0"><i class="fas fa-user-circle me-2 text-primary"></i>Informations personnelles</h5>
                    </div>
                    <div class="card-body py-4">
                        <div class="row g-4">
                            <div class="col-lg-8">
                                <dl class="row mb-0 small">
                                    <dt class="col-sm-4">Nom complet</dt>
                                    <dd class="col-sm-8">${patient.firstName} ${patient.lastName}</dd>

                                    <dt class="col-sm-4">Date de naissance</dt>
                                    <dd class="col-sm-8">
                                        <c:choose>
                                            <c:when test="${not empty patient.birthDate}">
                                                <fmt:formatDate value="${patient.birthDate}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>Non renseignée</c:otherwise>
                                        </c:choose>
                                    </dd>

                                    <dt class="col-sm-4">Téléphone</dt>
                                    <dd class="col-sm-8">${not empty patient.phone ? patient.phone : 'Non renseigné'}</dd>

                                    <dt class="col-sm-4">Adresse</dt>
                                    <dd class="col-sm-8">${not empty patient.address ? patient.address : 'Non renseignée'}</dd>

                                    <dt class="col-sm-4">Email</dt>
                                    <dd class="col-sm-8">${not empty patient.user.email ? patient.user.email : 'Non renseigné'}</dd>
                                </dl>
                            </div>
                            <!-- Avatar or placeholder -->
                            <div class="col-lg-4 text-center">
                                <i class="fas fa-user-circle fa-8x text-secondary"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ░░ Allergies & Conditions ░░ -->
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-light border-0">
                        <h5 class="mb-0"><i class="fas fa-exclamation-triangle me-2 text-danger"></i>Allergies & Conditions médicales</h5>
                    </div>
                    <div class="card-body">
                        <div class="row g-4">
                            <div class="col-md-6">
                                <h6 class="fw-semibold">Allergies</h6>
                                <c:choose>
                                    <c:when test="${not empty currentRecord.allergies}">
                                        <span class="badge text-bg-danger-subtle text-danger-emphasis px-3 py-2">${currentRecord.allergies}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Aucune allergie connue</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="col-md-6">
                                <h6 class="fw-semibold">Conditions chroniques</h6>
                                <c:choose>
                                    <c:when test="${not empty currentRecord.diagnosis}">
                                        <ul class="list-unstyled mb-0 ps-3">
                                            <li>${currentRecord.diagnosis}</li>
                                        </ul>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Aucune condition chronique connue</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="col-12">
                                <h6 class="fw-semibold">Notes médicales</h6>
                                <c:choose>
                                    <c:when test="${not empty currentRecord.notes}">
                                        <p class="mb-0">${currentRecord.notes}</p>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Aucune note médicale</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ░░ Médicaments actuels ░░ -->
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-light border-0 d-flex align-items-center">
                        <h5 class="mb-0"><i class="fas fa-pills me-2 text-primary"></i>Médicaments actuels</h5>
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${not empty currentPrescriptions}">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0 align-middle">
                                        <thead class="table-light text-center small text-uppercase">
                                        <tr>
                                            <th scope="col">Titre</th>
                                            <th scope="col">Description</th>
                                            <th scope="col">Prescrite le</th>
                                            <th scope="col">Expire le</th>
                                            <th scope="col">Prescrit par</th>
                                        </tr>
                                        </thead>
                                        <tbody class="small">
                                        <c:forEach var="prescription" items="${currentPrescriptions}">
                                            <tr>
                                                <td><span class="badge text-bg-primary-subtle text-primary-emphasis px-2 py-1">${prescription.title}</span></td>
                                                <td>${not empty prescription.description ? prescription.description : 'Non spécifié'}</td>
                                                <td><fmt:formatDate value="${prescription.prescribedDate}" pattern="dd/MM/yyyy"/></td>
                                                <td><fmt:formatDate value="${prescription.expiryDate}" pattern="dd/MM/yyyy"/></td>
                                                <td>${not empty prescription.doctor.firstName ? prescription.doctor.firstName : 'Non spécifié'}</td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="p-3 text-muted">Aucun médicament actuel</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- ░░ Métriques de santé ░░ -->
                <c:if test="${not empty currentRecord}">
                    <div class="card border-0 shadow-sm mb-4">
                        <div class="card-header bg-light border-0 d-flex align-items-center">
                            <h5 class="mb-0"><i class="fas fa-chart-line me-2 text-success"></i>Métriques de santé</h5>
                        </div>
                        <div class="card-body">
                            <div class="row g-4">
                                <!-- Blood pressure -->
                                <div class="col-md-4">
                                    <div class="border rounded p-3 text-center h-100">
                                        <i class="fas fa-heartbeat fa-2x text-danger mb-2"></i>
                                        <h6 class="fw-semibold text-uppercase small">Tension artérielle</h6>
                                        <p class="display-6 fw-normal mb-1">
                                                ${not empty currentRecord.bloodPressure ? currentRecord.bloodPressure : '–'}
                                        </p>
                                        <small class="text-muted">Dernière mesure&nbsp;:
                                            <c:choose>
                                                <c:when test="${not empty currentRecord.lastUpdated}">
                                                    <fmt:formatDate value="${currentRecord.lastUpdated}" pattern="dd/MM/yyyy"/>
                                                </c:when>
                                                <c:otherwise>Non disponible</c:otherwise>
                                            </c:choose>
                                        </small>
                                    </div>
                                </div>
                                <!-- Weight -->
                                <div class="col-md-4">
                                    <div class="border rounded p-3 text-center h-100">
                                        <i class="fas fa-weight fa-2x text-primary mb-2"></i>
                                        <h6 class="fw-semibold text-uppercase small">Poids</h6>
                                        <p class="display-6 fw-normal mb-1">
                                            <c:choose>
                                                <c:when test="${not empty currentRecord.weight}">
                                                    <fmt:formatNumber value="${currentRecord.weight}" maxFractionDigits="1"/> kg
                                                </c:when>
                                                <c:otherwise>–</c:otherwise>
                                            </c:choose>
                                        </p>
                                        <small class="text-muted">
                                            <c:if test="${not empty currentRecord.calculateBMI()}">
                                                IMC&nbsp;:
                                                <fmt:formatNumber value="${currentRecord.calculateBMI()}" maxFractionDigits="1"/>
                                                (${currentRecord.BMICategory})
                                            </c:if>
                                        </small>
                                    </div>
                                </div>
                                <!-- Temperature -->
                                <div class="col-md-4">
                                    <div class="border rounded p-3 text-center h-100">
                                        <i class="fas fa-thermometer-half fa-2x text-warning mb-2"></i>
                                        <h6 class="fw-semibold text-uppercase small">Température</h6>
                                        <p class="display-6 fw-normal mb-1">
                                            <c:choose>
                                                <c:when test="${not empty currentRecord.temperature}">
                                                    <fmt:formatNumber value="${currentRecord.temperature}" maxFractionDigits="1"/>°C
                                                </c:when>
                                                <c:otherwise>–</c:otherwise>
                                            </c:choose>
                                        </p>
                                        <small class="text-muted">Dernière mesure&nbsp;:
                                            <c:choose>
                                                <c:when test="${not empty currentRecord.lastUpdated}">
                                                    <fmt:formatDate value="${currentRecord.lastUpdated}" pattern="dd/MM/yyyy"/>
                                                </c:when>
                                                <c:otherwise>Non disponible</c:otherwise>
                                            </c:choose>
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- ░░ Historique médical ░░ -->
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-light border-0">
                        <h5 class="mb-0"><i class="fas fa-history me-2 text-secondary"></i>Historique médical</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty medicalRecords}">
                                <div class="timeline ps-4">
                                    <c:forEach var="record" items="${medicalRecords}" varStatus="status">
                                        <c:if test="${status.index < 5}">
                                            <div class="timeline-item mb-4">
                                                <h6 class="fw-semibold mb-1">
                                                    <c:choose>
                                                        <c:when test="${not empty record.diagnosis}">${record.diagnosis}</c:when>
                                                        <c:otherwise>Consultation médicale</c:otherwise>
                                                    </c:choose>
                                                </h6>
                                                <small class="text-muted d-block mb-2 small">
                                                    <fmt:formatDate value="${record.createdAt}" pattern="dd MMM yyyy"/>
                                                    · Statut&nbsp;: ${record.status}
                                                    <c:if test="${record.isRecent(30)}">
                                                        <span class="badge bg-info ms-1">Récent</span>
                                                    </c:if>
                                                </small>
                                                <c:if test="${not empty record.symptoms}">
                                                    <p class="mb-1 small"><strong>Symptômes&nbsp;:</strong> ${record.symptoms}</p>
                                                </c:if>
                                                <c:if test="${not empty record.treatmentPlan}">
                                                    <p class="mb-1 small"><strong>Plan de traitement&nbsp;:</strong> ${record.treatmentPlan}</p>
                                                </c:if>
                                                <c:if test="${not empty record.notes}">
                                                    <p class="mb-0 small">${record.notes}</p>
                                                </c:if>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted">Aucun historique médical disponible</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- ░░ Documents médicaux ░░ -->
                <c:if test="${not empty documents}">
                    <div class="card border-0 shadow-sm mb-4">
                        <div class="card-header bg-light border-0 d-flex align-items-center">
                            <h5 class="mb-0"><i class="fas fa-file-medical me-2 text-primary"></i>Documents médicaux</h5>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0 small">
                                    <thead class="table-light text-center text-uppercase small">
                                    <tr>
                                        <th scope="col">Document</th>
                                        <th scope="col">Description</th>
                                        <th scope="col">Ajouté le</th>
                                        <th scope="col">Actions</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="document" items="${documents}">
                                        <tr>
                                            <td>
                                                <i class="fas fa-file-${document.fileExtension == 'pdf' ? 'pdf' : 'alt'} fa-lg text-secondary me-2"></i>
                                                <span class="fw-semibold">${document.fileName}</span>
                                            </td>
                                            <td>${not empty document.description ? document.description : 'Aucune description'}</td>
                                            <td><fmt:formatDate value="${document.uploadedAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td class="text-center">
                                                <a href="medical-record/download?documentId=${document.id}" class="btn btn-sm btn-outline-primary">
                                                    <i class="fas fa-download me-1"></i>Télécharger
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </c:if>
            </c:if>
        </main>
    </div>
</div>

<!-- ===== Scripts ===== -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function downloadMedicalRecord() {
        alert('Fonctionnalité de téléchargement en cours de développement');
    }
    function printMedicalRecord() {
        window.print();
    }
    function shareMedicalRecord() {
        alert('Fonctionnalité de partage en cours de développement');
    }
</script>
</body>
</html>