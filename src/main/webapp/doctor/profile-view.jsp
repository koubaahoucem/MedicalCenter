<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Profil - Dr. ${doctor.fullName}</title>

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
        <c:set var="activePage" value="profile" scope="request" />
        <%@ include file="../doctor-sidebar.jsp" %>

        <!-- Main content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">
                    <i class="fas fa-user-md me-2"></i>Mon Profil
                </h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="${pageContext.request.contextPath}/doctor/profile?action=edit" class="btn btn-primary">
                        <i class="fas fa-edit me-1"></i>Modifier
                    </a>
                </div>
            </div>

            <!-- Success Message -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="successMessage" scope="session" />
            </c:if>

            <!-- Profile Information -->
            <div class="row">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Informations personnelles</h5>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-sm-3">
                                    <h6 class="mb-0">Nom complet</h6>
                                </div>
                                <div class="col-sm-9 text-secondary">
                                    Dr. ${doctor.firstName} ${doctor.lastName}
                                </div>
                            </div>
                            <hr>
                            <div class="row mb-3">
                                <div class="col-sm-3">
                                    <h6 class="mb-0">Email</h6>
                                </div>
                                <div class="col-sm-9 text-secondary">
                                    ${doctor.user.email}
                                </div>
                            </div>
                            <hr>
                            <div class="row mb-3">
                                <div class="col-sm-3">
                                    <h6 class="mb-0">Téléphone</h6>
                                </div>
                                <div class="col-sm-9 text-secondary">
                                    <c:choose>
                                        <c:when test="${not empty doctor.phone}">
                                            ${doctor.phone}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Non renseigné</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <hr>
                            <div class="row mb-3">
                                <div class="col-sm-3">
                                    <h6 class="mb-0">Numéro de licence</h6>
                                </div>
                                <div class="col-sm-9 text-secondary">
                                    ${doctor.licenseNumber}
                                </div>
                            </div>
                            <hr>
                            <div class="row mb-3">
                                <div class="col-sm-3">
                                    <h6 class="mb-0">Spécialité</h6>
                                </div>
                                <div class="col-sm-9 text-secondary">
                                    <c:choose>
                                        <c:when test="${not empty doctor.specialty}">
                                            ${doctor.specialty.name}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Non renseignée</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <!-- Profile Picture -->
                    <div class="card">
                        <div class="card-body text-center">
                            <div class="profile-picture mb-3">
                                <div class="avatar-circle bg-primary text-white mx-auto" style="width: 120px; height: 120px; font-size: 48px;">
                                    ${doctor.firstName.substring(0,1)}${doctor.lastName.substring(0,1)}
                                </div>
                            </div>
                            <h5 class="card-title">Dr. ${doctor.fullName}</h5>
                            <p class="text-muted">
                                <c:choose>
                                    <c:when test="${not empty doctor.specialty}">
                                        ${doctor.specialty.name}
                                    </c:when>
                                    <c:otherwise>
                                        Médecin
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>

                    <!-- Quick Stats -->
                    <div class="card mt-3">
                        <div class="card-header">
                            <h6 class="card-title mb-0">Statistiques</h6>
                        </div>
                        <div class="card-body">
                            <div class="d-flex justify-content-between mb-2">
                                <span>Patients totaux</span>
                                <strong>${totalPatients != null ? totalPatients : 0}</strong>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>RDV ce mois</span>
                                <strong>${appointmentsThisMonth != null ? appointmentsThisMonth : 0}</strong>
                            </div>
                            <div class="d-flex justify-content-between">
                                <span>Consultations</span>
                                <strong>${totalConsultations != null ? totalConsultations : 0}</strong>
                            </div>
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