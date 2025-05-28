<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Rendez-vous - Centre Médical</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome pour les icônes -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <%@ include file="../css/doctor/doctor-styles.jsp" %>
    <style>
        .appointment-card {
            border-left: 4px solid #3498db;
        }
        .appointment-card.completed {
            border-left-color: #2ecc71;
        }
        .appointment-card.cancelled {
            border-left-color: #e74c3c;
        }
        .appointment-card.pending {
            border-left-color: #f39c12;
        }
        .appointment-card.today {
            border-left-color: #9b59b6;
            background-color: #f8f9fa;
        }
        .patient-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #3498db;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
        .status-badge {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
        }
    </style>
</head>
<body>
<!-- Navbar supérieure -->

<%@ include file="../doctor-header.jsp" %>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <c:set var="activePage" value="appointments" scope="request" />
        <%@ include file="../doctor-sidebar.jsp" %>

        <!-- Contenu principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Mes rendez-vous</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="${pageContext.request.contextPath}/doctor/appointments/new" class="btn btn-primary">
                        <i class="fas fa-calendar-plus me-1"></i> Nouveau rendez-vous
                    </a>
                </div>
            </div>

            <!-- Affichage des messages d'erreur ou de succès -->
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${sessionScope.errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="successMessage" scope="session" />
            </c:if>

            <!-- Filtres et recherche -->
            <div class="row mb-4">
                <div class="col-md-6">
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                        <input type="text" id="appointmentSearch" class="form-control" placeholder="Rechercher un patient...">
                    </div>
                </div>
                <div class="col-md-3">
                    <select id="statusFilter" class="form-select">
                        <option value="">Tous les statuts</option>
                        <option value="Scheduled">Programmé</option>
                        <option value="Completed">Terminé</option>
                        <option value="Cancelled">Annulé</option>
                        <option value="Pending">En attente</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select id="dateFilter" class="form-select">
                        <option value="">Toutes les dates</option>
                        <option value="today">Aujourd'hui</option>
                        <option value="upcoming">À venir</option>
                        <option value="past">Passés</option>
                    </select>
                </div>
            </div>

            <!-- Liste des rendez-vous -->
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-body p-0">
                            <div class="list-group list-group-flush" id="appointmentsList">
                                <c:choose>
                                    <c:when test="${empty appointments}">
                                        <div class="list-group-item">
                                            <p class="mb-0 text-center">Aucun rendez-vous trouvé</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="appointment" items="${appointments}">
                                            <div class="list-group-item appointment-card
                                                <c:choose>
                                                    <c:when test="${appointment.status == 'Completed'}">completed</c:when>
                                                    <c:when test="${appointment.status == 'Cancelled'}">cancelled</c:when>
                                                    <c:when test="${appointment.status == 'Pending'}">pending</c:when>
                                                    <c:when test="${appointment.isToday()}">today</c:when>
                                                </c:choose>
                                            " data-status="${appointment.status}" data-date="<c:choose>
                                                    <c:when test="${appointment.isToday()}">today</c:when>
                                                    <c:when test="${appointment.isPast()}">past</c:when>
                                                    <c:otherwise>upcoming</c:otherwise>
                                                </c:choose>">
                                                <div class="d-flex align-items-start">
                                                    <div class="patient-avatar me-3">
                                                            ${appointment.patient.firstName.substring(0,1)}${appointment.patient.lastName.substring(0,1)}
                                                    </div>
                                                    <div class="flex-grow-1">
                                                        <div class="d-flex w-100 justify-content-between">
                                                            <h5 class="mb-1">${appointment.patient.fullName}</h5>
                                                            <span class="badge status-badge
                                                                <c:choose>
                                                                    <c:when test="${appointment.status == 'Completed'}">bg-success</c:when>
                                                                    <c:when test="${appointment.status == 'Cancelled'}">bg-danger</c:when>
                                                                    <c:when test="${appointment.status == 'Pending'}">bg-warning</c:when>
                                                                    <c:otherwise>bg-primary</c:otherwise>
                                                                </c:choose>
                                                            ">
                                                                <c:choose>
                                                                    <c:when test="${appointment.status == 'Completed'}">Terminé</c:when>
                                                                    <c:when test="${appointment.status == 'Cancelled'}">Annulé</c:when>
                                                                    <c:when test="${appointment.status == 'Pending'}">En attente</c:when>
                                                                    <c:otherwise>Programmé</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </div>
                                                        <p class="mb-1">
                                                            <i class="fas fa-calendar-day me-2"></i> <fmt:formatDate value="${appointment.startTime}" pattern="dd MMMM yyyy" />
                                                            <i class="fas fa-clock ms-3 me-2"></i> <fmt:formatDate value="${appointment.startTime}" pattern="HH:mm" /> - <fmt:formatDate value="${appointment.endTime}" pattern="HH:mm" />
                                                            <c:if test="${not empty appointment.location}">
                                                                <i class="fas fa-map-marker-alt ms-3 me-2"></i> ${appointment.location}
                                                            </c:if>
                                                        </p>
                                                        <c:if test="${not empty appointment.reason}">
                                                            <p class="mb-1 text-muted">${appointment.reason}</p>
                                                        </c:if>
                                                        <c:if test="${not empty appointment.notes}">
                                                            <p class="mb-1"><small class="text-muted">Notes: ${appointment.notes}</small></p>
                                                        </c:if>
                                                        <div class="mt-2">
                                                            <c:choose>
                                                                <c:when test="${appointment.status == 'Completed'}">
                                                                    <a href="${pageContext.request.contextPath}/doctor/medical-records?patientId=${appointment.patient.id}" class="btn btn-sm btn-outline-success me-2">
                                                                        <i class="fas fa-file-medical me-1"></i> Dossier médical
                                                                    </a>
                                                                    <a href="${pageContext.request.contextPath}/doctor/prescriptions/new?patientId=${appointment.patient.id}" class="btn btn-sm btn-outline-primary">
                                                                        <i class="fas fa-prescription me-1"></i> Nouvelle ordonnance
                                                                    </a>
                                                                </c:when>
                                                                <c:when test="${appointment.status == 'Cancelled'}">
                                                                    <span class="text-muted">Rendez-vous annulé</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <button class="btn btn-sm btn-success me-2" onclick="updateAppointmentStatus(${appointment.id}, 'Completed')">
                                                                        <i class="fas fa-check me-1"></i> Marquer terminé
                                                                    </button>
                                                                    <button class="btn btn-sm btn-warning me-2" onclick="updateAppointmentStatus(${appointment.id}, 'Pending')">
                                                                        <i class="fas fa-clock me-1"></i> En attente
                                                                    </button>
                                                                    <button class="btn btn-sm btn-danger" onclick="updateAppointmentStatus(${appointment.id}, 'Cancelled')">
                                                                        <i class="fas fa-times me-1"></i> Annuler
                                                                    </button>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Modal pour les notes -->
<div class="modal fade" id="notesModal" tabindex="-1" aria-labelledby="notesModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="notesModalLabel">Ajouter des notes</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="notesForm" method="post" action="${pageContext.request.contextPath}/doctor/appointments/update-status">
                <div class="modal-body">
                    <input type="hidden" id="modalAppointmentId" name="appointmentId">
                    <input type="hidden" id="modalStatus" name="status">
                    <div class="mb-3">
                        <label for="modalNotes" class="form-label">Notes (optionnel)</label>
                        <textarea class="form-control" id="modalNotes" name="notes" rows="3" placeholder="Ajouter des notes sur ce rendez-vous..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary">Confirmer</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle avec Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Filtrage des rendez-vous par recherche
        const appointmentSearch = document.getElementById('appointmentSearch');
        appointmentSearch.addEventListener('input', filterAppointments);

        // Filtrage des rendez-vous par statut
        const statusFilter = document.getElementById('statusFilter');
        statusFilter.addEventListener('change', filterAppointments);

        // Filtrage des rendez-vous par date
        const dateFilter = document.getElementById('dateFilter');
        dateFilter.addEventListener('change', filterAppointments);

        // Fonction de filtrage des rendez-vous
        function filterAppointments() {
            const searchTerm = appointmentSearch.value.toLowerCase();
            const statusValue = statusFilter.value;
            const dateValue = dateFilter.value;

            const appointmentItems = document.querySelectorAll('.appointment-card');
            appointmentItems.forEach(item => {
                const text = item.textContent.toLowerCase();
                const status = item.getAttribute('data-status');
                const date = item.getAttribute('data-date');

                const matchesSearch = text.includes(searchTerm);
                const matchesStatus = statusValue === '' || status === statusValue;
                const matchesDate = dateValue === '' || date === dateValue;

                if (matchesSearch && matchesStatus && matchesDate) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        }
    });

    // Fonction pour mettre à jour le statut d'un rendez-vous
    function updateAppointmentStatus(appointmentId, status) {
        document.getElementById('modalAppointmentId').value = appointmentId;
        document.getElementById('modalStatus').value = status;
        document.getElementById('modalNotes').value = '';

        // Changer le titre du modal selon le statut
        const modalTitle = document.getElementById('notesModalLabel');
        switch(status) {
            case 'Completed':
                modalTitle.textContent = 'Marquer comme terminé';
                break;
            case 'Cancelled':
                modalTitle.textContent = 'Annuler le rendez-vous';
                break;
            case 'Pending':
                modalTitle.textContent = 'Mettre en attente';
                break;
            default:
                modalTitle.textContent = 'Modifier le statut';
        }

        // Afficher le modal
        const modal = new bootstrap.Modal(document.getElementById('notesModal'));
        modal.show();
    }
</script>
</body>
</html>
