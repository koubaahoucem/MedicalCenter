<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Ordonnances - Centre Médical</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome pour les icônes -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <jsp:include page="../css/patient/style.jsp" />
</head>
<body>
<!-- Navbar supérieure -->
<jsp:include page="../header.jsp" />


<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <c:set var="activePage" value="prescriptions" scope="request" />
        <jsp:include page="../sidebar.jsp" />

        <!-- Contenu principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Mes ordonnances</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <div class="btn-group me-2">
                        <button type="button" class="btn btn-sm btn-outline-secondary">
                            <i class="fas fa-download me-1"></i> Télécharger tout
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-secondary">
                            <i class="fas fa-print me-1"></i> Imprimer
                        </button>
                    </div>
                    <button type="button" class="btn btn-sm btn-outline-primary">
                        <i class="fas fa-share-alt me-1"></i> Partager
                    </button>
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

            <!-- Filtres -->
            <div class="row mb-4">
                <div class="col-md-8">
                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-outline-secondary filter-btn active" data-filter="all">Toutes</button>
                        <button type="button" class="btn btn-outline-secondary filter-btn" data-filter="active">En cours</button>
                        <button type="button" class="btn btn-outline-secondary filter-btn" data-filter="renew">À renouveler</button>
                        <button type="button" class="btn btn-outline-secondary filter-btn" data-filter="expired">Expirées</button>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="input-group">
                        <input type="text" id="searchInput" class="form-control" placeholder="Rechercher...">
                        <button class="btn btn-outline-secondary" type="button" id="searchButton">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Liste des ordonnances et aperçu -->
            <div class="row">
                <!-- Liste des ordonnances -->
                <div class="col-md-5">
                    <c:choose>
                        <c:when test="${empty prescriptions}">
                            <div class="alert alert-info">
                                Aucune ordonnance disponible.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="prescription" items="${prescriptions}" varStatus="status">
                                <div class="card prescription-card 
                                    <c:choose>
                                        <c:when test="${prescription.isExpired()}">expired</c:when>
                                        <c:when test="${prescription.isExpiringSoon()}">renew</c:when>
                                        <c:otherwise>active</c:otherwise>
                                    </c:choose>
                                    <c:if test="${selectedPrescription.id == prescription.id}">selected</c:if>
                                " data-prescription-id="${prescription.id}" data-status="
                                    <c:choose>
                                        <c:when test="${prescription.isExpired()}">expired</c:when>
                                        <c:when test="${prescription.isExpiringSoon()}">renew</c:when>
                                        <c:otherwise>active</c:otherwise>
                                    </c:choose>
                                ">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <h5 class="card-title mb-0">${not empty prescription.title ? prescription.title : prescription.description}</h5>
                                            <span class="badge 
                                                <c:choose>
                                                    <c:when test="${prescription.isExpired()}">bg-secondary</c:when>
                                                    <c:when test="${prescription.isExpiringSoon()}">bg-danger</c:when>
                                                    <c:otherwise>bg-success</c:otherwise>
                                                </c:choose>
                                            ">
                                                <c:choose>
                                                    <c:when test="${prescription.isExpired()}">Expirée</c:when>
                                                    <c:when test="${prescription.isExpiringSoon()}">À renouveler</c:when>
                                                    <c:otherwise>En cours</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="d-flex align-items-center mb-2">
                                            <div>
                                                <p class="mb-0">Dr. ${prescription.doctor.lastName}</p>
                                                <small class="text-muted">
                                                    <c:if test="${not empty prescription.doctor.specialty.name}">
                                                        ${prescription.doctor.specialty.name}
                                                    </c:if>
                                                </small>
                                            </div>
                                        </div>
                                        <p class="card-text">
                                            <i class="fas fa-calendar-day me-2"></i> <fmt:formatDate value="${prescription.prescribedDate}" pattern="dd/MM/yyyy" />
                                            <span class="ms-3">
                                                <i class="fas fa-hourglass-
                                                    <c:choose>
                                                        <c:when test="${prescription.isExpired()}">end</c:when>
                                                        <c:when test="${prescription.isExpiringSoon()}">half</c:when>
                                                        <c:otherwise>start</c:otherwise>
                                                    </c:choose>
                                                 me-2"></i> 
                                                <c:choose>
                                                    <c:when test="${prescription.isExpired()}">Expirée le</c:when>
                                                    <c:otherwise>Expire le</c:otherwise>
                                                </c:choose>
                                                <fmt:formatDate value="${prescription.expiryDate}" pattern="dd/MM/yyyy" />
                                            </span>
                                        </p>
                                        <div class="mt-2">
                                            <span class="medication-badge p-2 me-1">${prescription.description}</span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Aperçu de l'ordonnance -->
                <div class="col-md-7">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Aperçu de l'ordonnance</h5>
                            <c:if test="${not empty selectedPrescription}">
                                <div>
                                    <c:if test="${not empty selectedPrescription.filePath}">
                                        <a href="${pageContext.request.contextPath}/patient/prescriptions/download/${selectedPrescription.id}" class="btn btn-sm btn-outline-primary me-2">
                                            <i class="fas fa-download me-1"></i> Télécharger
                                        </a>
                                    </c:if>
                                    <c:if test="${selectedPrescription.isExpired() || selectedPrescription.isExpiringSoon()}">
                                        <button class="btn btn-sm btn-outline-success" id="renewButton" data-prescription-id="${selectedPrescription.id}">
                                            <i class="fas fa-sync-alt me-1"></i> Demander renouvellement
                                        </button>
                                    </c:if>
                                </div>
                            </c:if>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty selectedPrescription}">
                                    <div class="alert alert-info">
                                        Sélectionnez une ordonnance pour voir les détails.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="prescription-preview">
                                        <div class="prescription-header">
                                            <h4>CENTRE MÉDICAL</h4>
                                            <p>123 Avenue de la Santé, 75000 Paris</p>
                                            <p>Tél: 01 23 45 67 89 - Email: contact@centremedical.fr</p>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="prescription-doctor">
                                                    <p><strong>Dr. ${selectedPrescription.doctor.lastName} ${selectedPrescription.doctor.firstName}</strong><br>
                                                        <c:if test="${not empty selectedPrescription.doctor.specialty.name}">
                                                            ${selectedPrescription.doctor.specialty.name}<br>
                                                        </c:if>
                                                        N° RPPS: ${selectedPrescription.doctor.licenseNumber}</p>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="prescription-patient">
                                                    <p>Patient: ${patient.firstName} ${patient.lastName}<br>
                                                        <c:if test="${not empty patient.birthDate}">
                                                            Né(e) le: <fmt:formatDate value="${patient.birthDate}" pattern="dd/MM/yyyy" /><br>
                                                        </c:if>
                                                    </p>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="prescription-content">
                                            <p><strong>Date:</strong> <fmt:formatDate value="${selectedPrescription.prescribedDate}" pattern="dd/MM/yyyy" /></p>
                                            <hr>
                                            <p><strong>${not empty selectedPrescription.title ? selectedPrescription.title : selectedPrescription.description}</strong><br>
                                                ${selectedPrescription.description}</p>
                                            <hr>
                                        </div>

                                        <div class="prescription-footer">
                                            <div>
                                                <p>Ordonnance valable jusqu'au: <strong><fmt:formatDate value="${selectedPrescription.expiryDate}" pattern="dd/MM/yyyy" /></strong></p>
                                            </div>
                                            <div class="prescription-signature">
                                                <p>Dr. ${selectedPrescription.doctor.lastName} ${selectedPrescription.doctor.firstName}<br>
                                                    Signature</p>
                                            </div>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Modal Demande de Renouvellement -->
<div class="modal fade" id="renewModal" tabindex="-1" aria-labelledby="renewModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="renewModalLabel">Demande de renouvellement d'ordonnance</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="renewForm">
                    <input type="hidden" id="prescriptionId" name="prescriptionId">
                    
                    <div class="mb-3">
                        <label for="doctorSelect" class="form-label">Médecin</label>
                        <select class="form-select" id="doctorSelect" name="doctorId" required>
                            <c:if test="${not empty selectedPrescription}">
                                <option value="${selectedPrescription.doctor.id}" selected>Dr. ${selectedPrescription.doctor.lastName} 
                                    <c:if test="${not empty selectedPrescription.doctor.specialty}">
                                        (${selectedPrescription.doctor.specialty.name})
                                    </c:if>
                                </option>
                            </c:if>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="renewMessage" class="form-label">Message (optionnel)</label>
                        <textarea class="form-control" id="renewMessage" name="message" rows="3" placeholder="Informations complémentaires pour le médecin..."></textarea>
                    </div>

                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="urgentCheck" name="isUrgent">
                        <label class="form-check-label" for="urgentCheck">Demande urgente</label>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                <button type="button" class="btn btn-success" id="sendRenewRequest">Envoyer la demande</button>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle avec Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Script pour les interactions -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Gestion des filtres
        document.querySelectorAll('.filter-btn').forEach(function(btn) {
            btn.addEventListener('click', function() {
                document.querySelectorAll('.filter-btn').forEach(function(b) {
                    b.classList.remove('active');
                });
                this.classList.add('active');

                var filter = this.getAttribute('data-filter');
                filterPrescriptions(filter);
            });
        });

        // Fonction de filtrage des ordonnances
        function filterPrescriptions(filter) {
            document.querySelectorAll('.prescription-card').forEach(function(card) {
                var status = card.getAttribute('data-status');
                
                if (filter === 'all' || status === filter) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }

        // Recherche d'ordonnances
        document.getElementById('searchButton').addEventListener('click', function() {
            var searchTerm = document.getElementById('searchInput').value.toLowerCase();
            searchPrescriptions(searchTerm);
        });

        document.getElementById('searchInput').addEventListener('keyup', function(event) {
            if (event.key === 'Enter') {
                var searchTerm = this.value.toLowerCase();
                searchPrescriptions(searchTerm);
            }
        });

        function searchPrescriptions(searchTerm) {
            document.querySelectorAll('.prescription-card').forEach(function(card) {
                var text = card.textContent.toLowerCase();
                
                if (text.includes(searchTerm)) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }

        // Sélection d'une ordonnance
        document.querySelectorAll('.prescription-card').forEach(function(card) {
            card.addEventListener('click', function() {
                var prescriptionId = this.getAttribute('data-prescription-id');
                window.location.href = '${pageContext.request.contextPath}/patient/prescriptions?id=' + prescriptionId;
            });
        });

        // Demande de renouvellement
        var renewButton = document.getElementById('renewButton');
        if (renewButton) {
            renewButton.addEventListener('click', function() {
                var prescriptionId = this.getAttribute('data-prescription-id');
                document.getElementById('prescriptionId').value = prescriptionId;
                
                var modal = new bootstrap.Modal(document.getElementById('renewModal'));
                modal.show();
            });
        }

        // Envoi de la demande de renouvellement
        document.getElementById('sendRenewRequest').addEventListener('click', function() {
            var form = document.getElementById('renewForm');
            var formData = new FormData(form);
            
            // Convertir FormData en objet pour l'envoi AJAX
            var data = {};
            formData.forEach(function(value, key) {
                data[key] = value;
            });
            
            // Ajouter isUrgent comme booléen
            data.isUrgent = document.getElementById('urgentCheck').checked;
            
            // Envoi de la demande via AJAX
            fetch('${pageContext.request.contextPath}/patient/prescriptions/renew', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams(data)
            })
            .then(data => {

                    // Fermer le modal
                    var modal = bootstrap.Modal.getInstance(document.getElementById('renewModal'));
                    modal.hide();
                    
                    // Recharger la page pour voir les mises à jour
                    window.location.reload();

            })
            .catch(error => {
                console.error('Erreur:', error);
                alert('Une erreur est survenue lors de l\'envoi de la demande.');
            });
        });
    });
</script>
</body>
</html>
