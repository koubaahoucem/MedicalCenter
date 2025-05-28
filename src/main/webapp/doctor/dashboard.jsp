<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord - Dr. ${doctor.fullName}</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <%@ include file="../css/doctor/doctor-styles.jsp" %>
</head>
<body>
<!-- Navbar -->
<%@ include file="../doctor-header.jsp" %>

<div class="container-fluid" style="margin-top: 56px;">
    <div class="row">
        <!-- Sidebar -->
        <c:set var="activePage" value="dashboard" scope="request" />
        <%@ include file="../doctor-sidebar.jsp" %>
        <!-- Main content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <!-- Error handling -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger mt-3" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>${error}
                </div>
            </c:if>

            <!-- Header -->
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Bonjour, Dr. ${doctor.fullName}</h1>
                <div class="btn-toolbar">
                    <button type="button" class="btn btn-sm btn-outline-primary">
                        <a href="${pageContext.request.contextPath}/doctor/appointments/new?patientId=${patient.id}">
                            <i class="fas fa-calendar-plus me-1"></i>Nouveau RDV
                        </a>
                    </button>
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="row mb-4" >
                <div class="col-xl-3 col-md-6 mb-3" >
                    <div class="card card-stats card-stats-appointments" style="background-color: #c2dbfe">
                        <div class="card-body" >
                            <div class="row">
                                <div class="col-8">
                                    <h5 class="card-title text-muted mb-0">Aujourd'hui</h5>
                                    <p class="h2 fw-bold mb-0">${todayAppointmentsCount}</p>
                                </div>
                                <div class="col-4 text-end">
                                    <i class="fas fa-calendar-day fa-2x text-primary opacity-25"></i>
                                </div>
                            </div>
                            <p class="mt-2 mb-0 text-muted">Rendez-vous</p>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-3">
                    <div class="card card-stats card-stats-patients" style="background-color: #97c6d3">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-8">
                                    <h5 class="card-title text-muted mb-0">Patients</h5>
                                    <p class="h2 fw-bold mb-0">${totalPatients}</p>
                                </div>
                                <div class="col-4 text-end">
                                    <i class="fas fa-users fa-2x text-success opacity-25"></i>
                                </div>
                            </div>
                            <p class="mt-2 mb-0 text-muted">Total</p>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-3">
                    <div class="card card-stats card-stats-pending" style="background-color: #ffefc1">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-8">
                                    <h5 class="card-title text-muted mb-0">En attente</h5>
                                    <p class="h2 fw-bold mb-0">${pendingAppointments}</p>
                                </div>
                                <div class="col-4 text-end">
                                    <i class="fas fa-clock fa-2x text-warning opacity-25"></i>
                                </div>
                            </div>
                            <p class="mt-2 mb-0 text-muted">Demandes</p>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-3">
                    <div class="card card-stats card-stats-completed" style="background-color: #c7c8c9">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-8">
                                    <h5 class="card-title text-muted mb-0">Ce mois</h5>
                                    <p class="h2 fw-bold mb-0">${completedThisMonth}</p>
                                </div>
                                <div class="col-4 text-end">
                                    <i class="fas fa-check-circle fa-2x text-purple opacity-25"></i>
                                </div>
                            </div>
                            <p class="mt-2 mb-0 text-muted">Consultations</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Today's Appointments and Recent Patients -->
            <div class="row">
                <!-- Today's Appointments -->
                <div class="col-lg-8" >
                    <div class="card" >
                        <div class="card-header d-flex justify-content-between align-items-center" style="background-color: #a87fca">
                            <h5 class="card-title mb-0">Rendez-vous d'aujourd'hui</h5>
                            <span class="badge bg-primary">${todayAppointmentsCount}</span>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty todayAppointments}">
                                    <div class="list-group list-group-flush">
                                        <c:forEach var="appointment" items="${todayAppointments}">
                                            <div class="list-group-item">
                                                <div class="d-flex w-100 justify-content-between">
                                                    <h6 class="mb-1">
                                                        <fmt:formatDate value="${appointment.startTime}" pattern="HH:mm"/> -
                                                            ${appointment.patient.fullName}
                                                    </h6>
                                                    <span class="badge ${appointment.status == 'Completed' ? 'bg-success' :
                                                                       appointment.status == 'Pending' ? 'bg-warning' : 'bg-secondary'}">
                                                            ${appointment.status}
                                                    </span>
                                                </div>
                                                <p class="mb-1">${not empty appointment.reason ? appointment.reason : 'Consultation'}</p>
                                                <c:if test="${not empty appointment.notes}">
                                                    <small class="text-muted">${appointment.notes}</small>
                                                </c:if>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-4">
                                        <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                                        <p class="text-muted">Aucun rendez-vous aujourd'hui</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Recent Patients -->
                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Patients récents</h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty recentPatients}">
                                    <c:forEach var="patient" items="${recentPatients}">
                                        <div class="d-flex align-items-center mb-3">
                                            <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3"
                                                 style="width: 40px; height: 40px;">
                                                <i class="fas fa-user"></i>
                                            </div>
                                            <div class="flex-grow-1">
                                                <h6 class="mb-0">${patient.fullName}</h6>
                                                <small class="text-muted">
                                                    <c:if test="${not empty patient.phone}">
                                                        <i class="fas fa-phone me-1"></i>${patient.phone}
                                                    </c:if>
                                                </small>
                                            </div>
                                            <div class="btn-group btn-group-sm">
                                                <button class="btn btn-outline-primary btn-sm">
                                                    <a href="${pageContext.request.contextPath}/doctor/patients/edit?id=${patient.id}">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-3">
                                        <i class="fas fa-users fa-2x text-muted mb-2"></i>
                                        <p class="text-muted mb-0">Aucun patient</p>
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

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
