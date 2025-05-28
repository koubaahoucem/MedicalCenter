<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Annuler le Rendez-vous - Centre Médical</title>

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
                <h1 class="h2">Annuler le rendez-vous</h1>
            </div>

            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header bg-warning text-dark">
                            <h5 class="mb-0">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                Confirmation d'annulation
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="alert alert-warning" role="alert">
                                <strong>Attention !</strong> Vous êtes sur le point d'annuler le rendez-vous suivant. Cette action est irréversible.
                            </div>

                            <!-- Détails du rendez-vous -->
                            <div class="row mb-4">
                                <div class="col-12">
                                    <h6 class="text-muted mb-3">Détails du rendez-vous :</h6>
                                    <div class="card bg-light">
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <p class="mb-2">
                                                        <strong>Médecin :</strong> Dr. ${appointment.doctor.lastName} ${appointment.doctor.firstName}
                                                    </p>
                                                    <p class="mb-2">
                                                        <strong>Date :</strong> <fmt:formatDate value="${appointment.startTime}" pattern="dd MMMM yyyy" />
                                                    </p>
                                                    <p class="mb-2">
                                                        <strong>Heure :</strong> <fmt:formatDate value="${appointment.startTime}" pattern="HH:mm" />
                                                    </p>
                                                </div>
                                                <div class="col-md-6">
                                                    <p class="mb-2">
                                                        <strong>Lieu :</strong> ${appointment.location}
                                                    </p>
                                                    <p class="mb-2">
                                                        <strong>Motif :</strong> ${appointment.reason}
                                                    </p>
                                                    <c:if test="${appointment.teleconsultation}">
                                                        <p class="mb-2">
                                                            <span class="badge bg-info">
                                                                <i class="fas fa-video me-1"></i>Téléconsultation
                                                            </span>
                                                        </p>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Formulaire de confirmation -->
                            <form method="post" action="${pageContext.request.contextPath}/patient/appointments/cancel/${appointment.id}">
                                <input type="hidden" name="appointmentId" value="${appointment.id}">

                                <div class="d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/patient/appointments" class="btn btn-secondary">
                                        <i class="fas fa-arrow-left me-1"></i>
                                        Retour
                                    </a>

                                    <button type="submit" class="btn btn-danger">
                                        <i class="fas fa-times me-1"></i>
                                        Confirmer l'annulation
                                    </button>
                                </div>
                            </form>
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