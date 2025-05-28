<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouvelle Ordonnance - ${patient.fullName} - Centre Médical</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome pour les icônes -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <%@ include file="../css/doctor/doctor-styles.jsp" %>
    <style>
        .prescription-preview {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            padding: 20px;
            font-family: 'Times New Roman', Times, serif;
        }
        .prescription-header {
            text-align: center;
            margin-bottom: 20px;
            border-bottom: 1px solid #dee2e6;
            padding-bottom: 10px;
        }
        .prescription-doctor {
            text-align: left;
            margin-bottom: 20px;
        }
        .prescription-patient {
            text-align: right;
            margin-bottom: 20px;
        }
        .prescription-content {
            margin-bottom: 20px;
            min-height: 200px;
        }
        .prescription-footer {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
            border-top: 1px solid #dee2e6;
            padding-top: 10px;
        }
        .prescription-signature {
            text-align: right;
            font-style: italic;
        }
    </style>
</head>
<body>
<!-- Navbar supérieure -->
<%@ include file="../doctor-header.jsp" %>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <c:set var="activePage" value="doctor-new-prescription" scope="request" />
        <%@ include file="../doctor-sidebar.jsp" %>
        <!-- Contenu principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Nouvelle ordonnance - ${patient.fullName}</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="${pageContext.request.contextPath}/doctor/appointments" class="btn btn-sm btn-outline-secondary">
                        <i class="fas fa-arrow-left me-1"></i> Retour aux rendez-vous
                    </a>
                </div>
            </div>

            <!-- Affichage des messages d'erreur ou de succès -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="row">
                <!-- Formulaire de création -->
                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Informations de l'ordonnance</h5>
                        </div>
                        <div class="card-body">
                            <form method="post" action="${pageContext.request.contextPath}/doctor/prescriptions/new">
                                <input type="hidden" name="patientId" value="${patient.id}">
                                
                                <!-- Informations patient (lecture seule) -->
                                <div class="mb-3">
                                    <label class="form-label">Patient</label>
                                    <input type="text" class="form-control" value="${patient.fullName}" readonly>
                                </div>

                                <!-- Titre de l'ordonnance -->
                                <div class="mb-3">
                                    <label for="title" class="form-label">Titre de l'ordonnance <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="title" name="title" required 
                                           placeholder="Ex: Traitement antibiotique, Suivi hypertension...">
                                </div>

                                <!-- Description/Médicaments -->
                                <div class="mb-3">
                                    <label for="description" class="form-label">Médicaments et posologie <span class="text-danger">*</span></label>
                                    <textarea class="form-control" id="description" name="description" rows="6" required
                                              placeholder="Ex: Amoxicilline 500mg - 1 comprimé 3 fois par jour pendant 7 jours&#10;Doliprane 1000mg - 1 comprimé si douleur, maximum 3 par jour"></textarea>
                                </div>

                                <!-- Date d'expiration -->
                                <div class="mb-3">
                                    <label for="expiryDate" class="form-label">Date d'expiration</label>
                                    <input type="date" class="form-control" id="expiryDate" name="expiryDate">
                                    <div class="form-text">Si non spécifiée, l'ordonnance expirera dans 30 jours</div>
                                </div>

                                <!-- Notes additionnelles -->
                                <div class="mb-3">
                                    <label for="notes" class="form-label">Notes additionnelles</label>
                                    <textarea class="form-control" id="notes" name="notes" rows="3"
                                              placeholder="Instructions particulières, recommandations..."></textarea>
                                </div>

                                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                    <a href="${pageContext.request.contextPath}/doctor/appointments" class="btn btn-secondary me-md-2">Annuler</a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-1"></i> Créer l'ordonnance
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Aperçu de l'ordonnance -->
                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Aperçu de l'ordonnance</h5>
                        </div>
                        <div class="card-body">
                            <div class="prescription-preview">
                                <div class="prescription-header">
                                    <h4>CENTRE MÉDICAL</h4>
                                    <p>123 Avenue de la Santé, 75000 Paris</p>
                                    <p>Tél: 01 23 45 67 89 - Email: contact@centremedical.fr</p>
                                </div>

                                <div class="row">
<%--                                    <div class="col-md-6">--%>
<%--                                        <div class="prescription-doctor">--%>
<%--                                            <p><strong>Dr. ${doctor.lastName} ${doctor.firstName}</strong><br>--%>
<%--                                                <c:if test="${not empty doctor.specialties}">--%>
<%--                                                    <c:forEach var="specialty" items="${doctor.specialties}" varStatus="status">--%>
<%--                                                        ${specialty.name}<c:if test="${!status.last}">, </c:if>--%>
<%--                                                    </c:forEach><br>--%>
<%--                                                </c:if>--%>
<%--                                                N° RPPS: ${doctor.licenseNumber}</p>--%>
<%--                                        </div>--%>
<%--                                    </div>--%>
                                    <div class="col-md-6">
                                        <div class="prescription-patient">
                                            <p>Patient: ${patient.fullName}<br>
                                                <c:if test="${not empty patient.birthDate}">
                                                    Né(e) le: <fmt:formatDate value="${patient.birthDate}" pattern="dd/MM/yyyy" /><br>
                                                </c:if>
                                                <c:if test="${not empty patient.phone}">
                                                    Tél: ${patient.phone}
                                                </c:if>
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                <div class="prescription-content">
                                    <p><strong>Date:</strong> <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy" /></p>
                                    <hr>
                                    <div id="preview-title">
                                        <p><strong id="preview-title-text">Titre de l'ordonnance</strong></p>
                                    </div>
                                    <div id="preview-description">
                                        <p id="preview-description-text">Les médicaments et posologies apparaîtront ici...</p>
                                    </div>
                                    <div id="preview-notes" style="display: none;">
                                        <hr>
                                        <p><strong>Notes:</strong> <span id="preview-notes-text"></span></p>
                                    </div>
                                </div>

                                <div class="prescription-footer">
                                    <div>
                                        <p>Ordonnance valable jusqu'au: <strong id="preview-expiry">
                                            <fmt:formatDate value="<%= new java.util.Date(System.currentTimeMillis() + 30L * 24 * 60 * 60 * 1000) %>" pattern="dd/MM/yyyy" />
                                        </strong></p>
                                    </div>
                                    <div class="prescription-signature">
                                        <p>Dr. ${doctor.lastName} ${doctor.firstName}<br>
                                            Signature</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Bootstrap JS Bundle avec Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Script pour l'aperçu en temps réel -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Éléments du formulaire
        const titleInput = document.getElementById('title');
        const descriptionInput = document.getElementById('description');
        const expiryDateInput = document.getElementById('expiryDate');
        const notesInput = document.getElementById('notes');

        // Éléments de l'aperçu
        const previewTitle = document.getElementById('preview-title-text');
        const previewDescription = document.getElementById('preview-description-text');
        const previewExpiry = document.getElementById('preview-expiry');
        const previewNotesDiv = document.getElementById('preview-notes');
        const previewNotesText = document.getElementById('preview-notes-text');

        // Mise à jour en temps réel du titre
        titleInput.addEventListener('input', function() {
            previewTitle.textContent = this.value || 'Titre de l\'ordonnance';
        });

        // Mise à jour en temps réel de la description
        descriptionInput.addEventListener('input', function() {
            const text = this.value || 'Les médicaments et posologies apparaîtront ici...';
            previewDescription.innerHTML = text.replace(/\n/g, '<br>');
        });

        // Mise à jour en temps réel de la date d'expiration
        expiryDateInput.addEventListener('change', function() {
            if (this.value) {
                const date = new Date(this.value);
                const formattedDate = date.toLocaleDateString('fr-FR');
                previewExpiry.textContent = formattedDate;
            } else {
                // Date par défaut (30 jours)
                const defaultDate = new Date();
                defaultDate.setDate(defaultDate.getDate() + 30);
                previewExpiry.textContent = defaultDate.toLocaleDateString('fr-FR');
            }
        });

        // Mise à jour en temps réel des notes
        notesInput.addEventListener('input', function() {
            if (this.value.trim()) {
                previewNotesText.textContent = this.value;
                previewNotesDiv.style.display = 'block';
            } else {
                previewNotesDiv.style.display = 'none';
            }
        });

        // Définir la date minimale à aujourd'hui
        const today = new Date().toISOString().split('T')[0];
        expiryDateInput.setAttribute('min', today);
    });
</script>
</body>
</html>
