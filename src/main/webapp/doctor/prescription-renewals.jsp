<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Demandes de Renouvellement - Dr. ${doctor.fullName}</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <%@ include file="../css/doctor/doctor-styles.jsp" %>
</head>
<body>
<!-- Navbar -->
<%@ include file="../doctor-header.jsp" %>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <c:set var="activePage" value="prescription-renewal" scope="request" />
        <%@ include file="../doctor-sidebar.jsp" %>

        <!-- Main content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">
                    <i class="fas fa-sync-alt me-2"></i>Demandes de Renouvellement
                </h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <button type="button" class="btn btn-outline-primary" onclick="refreshPage()">
                        <i class="fas fa-refresh me-1"></i>Actualiser
                    </button>
                </div>
            </div>

            <!-- Success/Error Messages -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="successMessage" scope="session" />
            </c:if>

            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>${sessionScope.errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>

            <!-- Statistics Cards -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card card-stats border-start border-warning border-4">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-8">
                                    <h5 class="card-title text-muted mb-0">En attente</h5>
                                    <p class="h3 fw-bold mb-0 text-warning">${pendingCount}</p>
                                </div>
                                <div class="col-4 text-end">
                                    <i class="fas fa-clock fa-2x text-warning opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card card-stats border-start border-danger border-4">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-8">
                                    <h5 class="card-title text-muted mb-0">Urgentes</h5>
                                    <p class="h3 fw-bold mb-0 text-danger">${urgentCount}</p>
                                </div>
                                <div class="col-4 text-end">
                                    <i class="fas fa-exclamation-triangle fa-2x text-danger opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card card-stats border-start border-info border-4">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-8">
                                    <h5 class="card-title text-muted mb-0">Aujourd'hui</h5>
                                    <p class="h3 fw-bold mb-0 text-info">${todayCount}</p>
                                </div>
                                <div class="col-4 text-end">
                                    <i class="fas fa-calendar-day fa-2x text-info opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filters -->
            <div class="card mb-4">
                <div class="card-body">
                    <form method="GET" action="${pageContext.request.contextPath}/doctor/prescription-renewals" class="row g-3">
                        <div class="col-md-3">
                            <label for="status" class="form-label">Statut</label>
                            <select class="form-select" id="status" name="status">
                                <option value="">Tous les statuts</option>
                                <option value="Pending" ${statusFilter == 'Pending' ? 'selected' : ''}>En attente</option>
                                <option value="Approved" ${statusFilter == 'Approved' ? 'selected' : ''}>Approuvées</option>
                                <option value="Rejected" ${statusFilter == 'Rejected' ? 'selected' : ''}>Rejetées</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="urgency" class="form-label">Urgence</label>
                            <select class="form-select" id="urgency" name="urgency">
                                <option value="">Toutes</option>
                                <option value="urgent" ${urgencyFilter == 'urgent' ? 'selected' : ''}>Urgentes uniquement</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="sortBy" class="form-label">Trier par</label>
                            <select class="form-select" id="sortBy" name="sortBy">
                                <option value="date" ${sortBy == 'date' ? 'selected' : ''}>Date</option>
                                <option value="urgency" ${sortBy == 'urgency' ? 'selected' : ''}>Urgence</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">&nbsp;</label>
                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-filter me-1"></i>Filtrer
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Renewal Requests List -->
            <div class="row">
                <c:choose>
                    <c:when test="${empty renewalRequests}">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-body text-center py-5">
                                    <i class="fas fa-sync-alt fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">Aucune demande de renouvellement</h5>
                                    <p class="text-muted">
                                        <c:choose>
                                            <c:when test="${not empty statusFilter or not empty urgencyFilter}">
                                                Aucune demande ne correspond aux filtres sélectionnés.
                                            </c:when>
                                            <c:otherwise>
                                                Vous n'avez pas encore reçu de demandes de renouvellement.
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="request" items="${renewalRequests}">
                            <div class="col-12 mb-3">
                                <div class="card renewal-request-card ${request.urgent ? 'border-danger' : ''}">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <div class="d-flex align-items-center">
                                            <h6 class="mb-0 me-3">${request.patient.fullName}</h6>
                                            <c:if test="${request.urgent}">
                                                <span class="badge bg-danger me-2">
                                                    <i class="fas fa-exclamation-triangle me-1"></i>URGENT
                                                </span>
                                            </c:if>
                                            <span class="badge ${request.status == 'Pending' ? 'bg-warning' : 
                                                               request.status == 'Approved' ? 'bg-success' : 'bg-danger'}">
                                                ${request.status == 'Pending' ? 'En attente' : 
                                                  request.status == 'Approved' ? 'Approuvée' : 'Rejetée'}
                                            </span>
                                        </div>
                                        <small class="text-muted">
                                            <i class="fas fa-calendar me-1"></i>
                                            <fmt:formatDate value="${request.requestDate}" pattern="dd/MM/yyyy HH:mm" />
                                        </small>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-8">
                                                <h6 class="fw-bold">Ordonnance originale:</h6>
                                                <p class="mb-2">${request.prescription.title}</p>
                                                <p class="text-muted small mb-2">${request.prescription.description}</p>
                                                <p class="text-muted small">
                                                    <i class="fas fa-calendar me-1"></i>
                                                    Prescrite le: <fmt:formatDate value="${request.prescription.prescribedDate}" pattern="dd/MM/yyyy" />
                                                </p>
                                                
                                                <c:if test="${not empty request.message}">
                                                    <div class="mt-3">
                                                        <h6 class="fw-bold">Message du patient:</h6>
                                                        <p class="border p-2 bg-light rounded">${request.message}</p>
                                                    </div>
                                                </c:if>
                                                
                                                <c:if test="${not empty request.responseMessage}">
                                                    <div class="mt-3">
                                                        <h6 class="fw-bold">Votre réponse:</h6>
                                                        <p class="border p-2 bg-light rounded">${request.responseMessage}</p>
                                                        <small class="text-muted">
                                                            Répondu le: <fmt:formatDate value="${request.responseDate}" pattern="dd/MM/yyyy HH:mm" />
                                                        </small>
                                                    </div>
                                                </c:if>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="patient-info">
                                                    <h6 class="fw-bold">Informations patient:</h6>
                                                    <p class="mb-1">
                                                        <i class="fas fa-phone me-1"></i>
                                                        ${not empty request.patient.phone ? request.patient.phone : 'Non renseigné'}
                                                    </p>
                                                    <p class="mb-1">
                                                        <i class="fas fa-envelope me-1"></i>
                                                        ${request.patient.user.email}
                                                    </p>
                                                </div>
                                                
                                                <c:if test="${request.status == 'Pending'}">
                                                    <div class="mt-3">
                                                        <button type="button" class="btn btn-success btn-sm me-2" 
                                                                onclick="showResponseModal(${request.id}, 'approve', '${request.patient.fullName}')">
                                                            <i class="fas fa-check me-1"></i>Approuver
                                                        </button>
                                                        <button type="button" class="btn btn-danger btn-sm" 
                                                                onclick="showResponseModal(${request.id}, 'reject', '${request.patient.fullName}')">
                                                            <i class="fas fa-times me-1"></i>Rejeter
                                                        </button>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</div>

<!-- Response Modal -->
<div class="modal fade" id="responseModal" tabindex="-1" aria-labelledby="responseModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="responseModalLabel">Répondre à la demande</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/doctor/prescription-renewals">
                <div class="modal-body">
                    <input type="hidden" id="requestId" name="requestId">
                    <input type="hidden" id="action" name="action">
                    
                    <div class="mb-3">
                        <p id="actionText"></p>
                    </div>
                    
                    <div class="mb-3">
                        <label for="responseMessage" class="form-label">Message (optionnel)</label>
                        <textarea class="form-control" id="responseMessage" name="responseMessage" rows="3" 
                                  placeholder="Ajoutez un message pour le patient..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn" id="confirmBtn">Confirmer</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
let responseModal;

document.addEventListener('DOMContentLoaded', function() {
    responseModal = new bootstrap.Modal(document.getElementById('responseModal'));
    
    // Auto-submit form on filter change
    const filterSelects = document.querySelectorAll('#status, #urgency, #sortBy');
    filterSelects.forEach(select => {
        select.addEventListener('change', function() {
            this.closest('form').submit();
        });
    });
});

function showResponseModal(requestId, action, patientName) {
    document.getElementById('requestId').value = requestId;
    document.getElementById('action').value = action;
    
    const actionText = document.getElementById('actionText');
    const confirmBtn = document.getElementById('confirmBtn');
    
    if (action === 'approve') {
        actionText.textContent = `Êtes-vous sûr de vouloir approuver la demande de renouvellement de ${patientName} ?`;
        confirmBtn.textContent = 'Approuver';
        confirmBtn.className = 'btn btn-success';
    } else {
        actionText.textContent = `Êtes-vous sûr de vouloir rejeter la demande de renouvellement de ${patientName} ?`;
        confirmBtn.textContent = 'Rejeter';
        confirmBtn.className = 'btn btn-danger';
    }
    
    document.getElementById('responseMessage').value = '';
    responseModal.show();
}

function refreshPage() {
    window.location.reload();
}
</script>
</body>
</html>
