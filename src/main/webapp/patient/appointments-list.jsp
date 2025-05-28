<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
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

    <jsp:include page="../css/patient/style.jsp" />
</head>
<body>
<!-- Navbar supérieure -->
<jsp:include page="../header.jsp" />


<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <c:set var="activePage" value="appointments" scope="request" />
        <jsp:include page="../sidebar.jsp" />

        <!-- Contenu principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Mes rendez-vous</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="${pageContext.request.contextPath}/patient/appointment-create" class="btn btn-success">
                        <i class="fas fa-calendar-plus me-1"></i> Nouveau rendez-vous
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

            <!-- Filtres -->
            <div class="row mb-4">
                <div class="col-md-6">
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                        <input type="text" id="appointmentSearch" class="form-control" placeholder="Rechercher un rendez-vous...">
                    </div>
                </div>
                <div class="col-md-6">
                    <select id="statusFilter" class="form-select">
                        <option value="">Tous les rendez-vous</option>
                        <option value="upcoming">À venir</option>
                        <option value="today">Aujourd'hui</option>
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
                                            <p class="mb-0 text-center">Aucun rendez-vous</p>
                                        </div>
                                    </c:when>

                                    <c:otherwise>
                                        <c:forEach var="appointment" items="${appointments}">
                                            <div class="list-group-item appointment-card
                                                <c:choose>
                                                    <c:when test="${appointment.isToday()}">today</c:when>
                                                    <c:when test="${appointment.isPast()}">past</c:when>
                                                    <c:otherwise>upcoming</c:otherwise>
                                                </c:choose>
                                            " data-status="<c:choose>
                                                    <c:when test="${appointment.isToday()}">today</c:when>
                                                    <c:when test="${appointment.isPast()}">past</c:when>
                                                    <c:otherwise>upcoming</c:otherwise>
                                                </c:choose>">
                                                <div class="d-flex w-100 justify-content-between">
                                                    <h5 class="mb-1">Dr. ${appointment.doctor.lastName}</h5>
                                                    <span class="badge
                                                        <c:choose>
                                                            <c:when test="${appointment.isToday()}">bg-warning</c:when>
                                                            <c:when test="${appointment.isPast()}">bg-secondary</c:when>
                                                            <c:otherwise>bg-primary</c:otherwise>
                                                        </c:choose>
                                                    ">
                                                        <c:choose>
                                                            <c:when test="${appointment.isToday()}">Aujourd'hui</c:when>
                                                            <c:when test="${appointment.isPast()}">Passé</c:when>
                                                            <c:otherwise>À venir</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                                <p class="mb-1">
                                                    <i class="fas fa-calendar-day me-2"></i> <fmt:formatDate value="${appointment.startTime}" pattern="dd MMMM yyyy" />
                                                    <i class="fas fa-clock ms-3 me-2"></i> <fmt:formatDate value="${appointment.startTime}" pattern="HH:mm" />
                                                    <i class="fas fa-map-marker-alt ms-3 me-2"></i> ${appointment.location}
                                                </p>
                                                <p class="mb-1">${appointment.reason}</p>
                                                <div class="mt-2">
                                                    <c:choose>
                                                        <c:when test="${appointment.isPast()}">
                                                            <a href="${pageContext.request.contextPath}/patient/medical-record" class="btn btn-sm btn-outline-success me-2">
                                                                <i class="fas fa-file-medical me-1"></i> Voir compte-rendu
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/patient/appointment-create" class="btn btn-sm btn-outline-primary">
                                                                <i class="fas fa-calendar-plus me-1"></i> Reprendre RDV
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:if test="${appointment.isTeleconsultation()}">
                                                                <a href="${pageContext.request.contextPath}/patient/teleconsultation/${appointment.id}" class="btn btn-sm btn-outline-primary me-2">
                                                                    <i class="fas fa-video me-1"></i> Téléconsultation
                                                                </a>
                                                            </c:if>
                                                            <c:if test="${appointment.status != 'Cancelled'}">
                                                                <a href="${pageContext.request.contextPath}/patient/appointments/cancel/${appointment.id}" class="btn btn-sm btn-outline-danger">
                                                                    <i class="fas fa-times me-1"></i> Annuler
                                                                </a>
                                                            </c:if>
                                                        </c:otherwise>
                                                    </c:choose>
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

<!-- Bootstrap JS Bundle avec Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    let appointments = '<%= request.getAttribute("appointments") %>';
    console.log("Appointments:", appointments);

    document.addEventListener('DOMContentLoaded', function() {
        // Filtrage des rendez-vous par recherche
        const appointmentSearch = document.getElementById('appointmentSearch');
        appointmentSearch.addEventListener('input', filterAppointments);

        // Filtrage des rendez-vous par statut
        const statusFilter = document.getElementById('statusFilter');
        statusFilter.addEventListener('change', filterAppointments);

        // Fonction de filtrage des rendez-vous
        function filterAppointments() {
            const searchTerm = appointmentSearch.value.toLowerCase();
            const statusValue = statusFilter.value;

            const appointmentItems = document.querySelectorAll('.appointment-card');
            appointmentItems.forEach(item => {
                const text = item.textContent.toLowerCase();
                const status = item.getAttribute('data-status');

                const matchesSearch = text.includes(searchTerm);
                const matchesStatus = statusValue === '' || status === statusValue;

                if (matchesSearch && matchesStatus) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        }


        // Vérifier s'il y a un message de succès dans la session
        const successMessage = '${sessionScope.successMessage}';
        if (successMessage) {
            // Afficher le message
            const alertDiv = document.createElement('div');
            alertDiv.className = 'alert alert-success alert-dismissible fade show';
            alertDiv.setAttribute('role', 'alert');
            alertDiv.innerHTML = `
                ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            `;

            document.querySelector('main').insertBefore(alertDiv, document.querySelector('.row.mb-4'));

            // Supprimer le message de la session
            <% session.removeAttribute("successMessage"); %>
        }
    });
</script>
</body>
</html>
