<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord Patient - Centre Médical</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome pour les icônes -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <jsp:include page="../css/patient/style.jsp" />
</head>
<body>
<jsp:include page="../header.jsp" />

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <c:set var="activePage" value="dashboard" scope="request" />
        <jsp:include page="../sidebar.jsp" />
        <!-- Contenu principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Bonjour, ${user.username}</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="${pageContext.request.contextPath}/patient/appointment-create" class="btn btn-success">
                        <i class="fas fa-calendar-plus me-1"></i> Prendre rendez-vous
                    </a>
                </div>
            </div>

            <!-- Cartes statistiques -->
            <div class="row">
                <div class="col-xl-6 col-md-6">
                    <div class="card card-stats card-stats-appointments" style="background-color: #5e6062">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-9">
                                    <h5 class="card-title text-muted mb-0">Rendez-vous</h5>
                                    <p class="h2 fw-bold mb-0">${appointmentCount}</p>
                                </div>
                                <div class="col-3 text-end">
                                    <div class="icon text-success">
                                        <i class="fas fa-calendar-check"></i>
                                    </div>
                                </div>
                            </div>
                            <p class="mt-3 mb-0">
                                <c:choose>
                                    <c:when test="${not empty nextAppointment}">
                                        <span class="text-muted">Prochain: <fmt:formatDate value="${nextAppointment.startTime}" pattern="dd MMM à HH:mm" /></span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Aucun rendez-vous à venir</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </div>

                <div class="col-xl-6 col-md-6">
                    <div class="card card-stats card-stats-prescriptions" style="background-color: #76787b">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-9">
                                    <h5 class="card-title text-muted mb-0">Ordonnances</h5>
                                    <p class="h2 fw-bold mb-0">${prescriptionCount}</p>
                                </div>
                                <div class="col-3 text-end">
                                    <div class="icon text-danger">
                                        <i class="fas fa-prescription"></i>
                                    </div>
                                </div>
                            </div>
                            <p class="mt-3 mb-0">
                                <c:choose>
                                    <c:when test="${prescriptionsToRenew > 0}">
                                        <span class="text-danger">${prescriptionsToRenew} à renouveler</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Toutes les ordonnances sont à jour</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Prochain rendez-vous et Mes médecins -->
            <div class="row mt-4">
                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center" style="background-color: #bfc2c6">
                            <h5 class="card-title">Mes prochains rendez-vous</h5>
                            <a href="${pageContext.request.contextPath}/patient/appointments" class="btn btn-sm btn-success">Voir tous</a>
                        </div>
                        <div class="card-body p-0">
                            <div class="list-group list-group-flush" >
                                <c:choose>
                                    <c:when test="${empty upcomingAppointments}">
                                        <div class="list-group-item">
                                            <p class="mb-0 text-center">Aucun rendez-vous à venir</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="appointment" items="${upcomingAppointments}" varStatus="status" end="2">
                                            <div class="list-group-item appointment-card
                                                <c:choose>
                                                    <c:when test="${appointment.isToday()}">today</c:when>
                                                    <c:when test="${appointment.isPast()}">past</c:when>
                                                    <c:otherwise>upcoming</c:otherwise>
                                                </c:choose>
                                            ">
                                                <div class="d-flex w-100 justify-content-between">
                                                    <h5 class="mb-1">Dr. ${appointment.doctor.lastName} </h5>
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
                                                            <a href="${pageContext.request.contextPath}/patient/appointments/new?doctorId=${appointment.doctor.id}" class="btn btn-sm btn-outline-primary">
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

                <div class="col-lg-6">
                    <div class="card" >
                        <div class="card-header" style="background-color: #ccd1d4">
                            <h5 class="card-title">Mes médecins</h5>
                        </div>
                        <div class="card-body" style="background-color: #ffffff">
                            <div class="row">
                                <c:choose>
                                    <c:when test="${empty doctors}">
                                        <div class="col-12">
                                            <p class="text-center">Aucun médecin associé à votre compte</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="doctor" items="${doctors}" varStatus="status" end="2">
                                            <div class="col-md-6 mb-4">
                                                <div class="card doctor-card h-100" style="background-color: #ffffff">
                                                    <div class="card-body text-center">
                                                        <h5 class="card-title">Dr. ${doctor.lastName}</h5>
                                                        <div class="d-grid gap-2">
                                                            <a href="${pageContext.request.contextPath}/patient/appointment-create" class="btn btn-sm btn-outline-success">
                                                                <i class="fas fa-calendar-plus me-1"></i> Rendez-vous
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/patient/messages/new?recipientId=${doctor.id}" class="btn btn-sm btn-outline-primary">
                                                                <i class="fas fa-envelope me-1"></i> Message
                                                            </a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                                <div class="col-md-6 mb-4">
                                    <div class="card doctor-card h-100">
                                        <div class="card-body text-center" style="background-color: #ffffff">
                                            <div class="d-flex justify-content-center align-items-center h-100">
                                                <a href="${pageContext.request.contextPath}/patient/doctors" class="btn btn-outline-success">
                                                    <i class="fas fa-plus-circle me-2"></i> Ajouter un médecin
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Mes ordonnances -->
            <div class="row mt-4" >
                <div class="col-12" >
                    <div class="card" >
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="card-title">Mes ordonnances</h5>
                            <a href="${pageContext.request.contextPath}/patient/prescriptions" class="btn btn-sm btn-success">Voir toutes</a>
                        </div>
                        <div class="card-body p-0">
                            <div class="list-group list-group-flush">
                                <c:choose>
                                    <c:when test="${empty prescriptions}">
                                        <div class="list-group-item">
                                            <p class="mb-0 text-center">Aucune ordonnance</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="prescription" items="${prescriptions}" varStatus="status" end="2">
                                            <div class="list-group-item">
                                                <div class="d-flex w-100 justify-content-between">
                                                    <h5 class="mb-1">${not empty prescription.title ? prescription.title : prescription.description}</h5>
                                                    <span class="badge
                                                        <c:choose>
                                                            <c:when test="${prescription.isExpired()}">bg-danger</c:when>
                                                            <c:when test="${prescription.isExpiringSoon()}">bg-warning</c:when>
                                                            <c:otherwise>bg-success</c:otherwise>
                                                        </c:choose>
                                                    ">
                                                        <c:choose>
                                                            <c:when test="${prescription.isExpired()}">À renouveler</c:when>
                                                            <c:when test="${prescription.isExpiringSoon()}">Expire bientôt</c:when>
                                                            <c:otherwise>En cours</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                                <p class="mb-1">
                                                    <i class="fas fa-user-md me-2"></i> Dr. ${prescription.doctor.lastName}
                                                    <c:if test="${not empty doctor.specialty}">
                                                        - ${doctor.specialty.name}
                                                    </c:if>
                                                    <i class="fas fa-calendar-day ms-3 me-2"></i> <fmt:formatDate value="${prescription.prescribedDate}" pattern="dd/MM/yyyy" />
                                                </p>
                                                <div class="mt-2">
                                                    <c:if test="${not empty prescription.filePath}">
                                                        <a href="${pageContext.request.contextPath}/patient/prescriptions/download/${prescription.id}" class="btn btn-sm btn-outline-primary me-2">
                                                            <i class="fas fa-download me-1"></i> Télécharger
                                                        </a>
                                                    </c:if>
                                                    <c:if test="${prescription.isExpired() || prescription.isExpiringSoon()}">
                                                        <a href="${pageContext.request.contextPath}/patient/prescriptions/renew/${prescription.id}" class="btn btn-sm btn-outline-success">
                                                            <i class="fas fa-sync-alt me-1"></i> Demander renouvellement
                                                        </a>
                                                    </c:if>
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
</body>
</html>