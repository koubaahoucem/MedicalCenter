<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ajouter un Médecin - Centre Médical</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <jsp:include page="../css/patient/style.jsp" />
</head>
<body>
<jsp:include page="../header.jsp" />

<div class="container-fluid">
    <div class="row">
        <c:set var="activePage" value="doctors" scope="request" />
        <jsp:include page="../sidebar.jsp" />
        
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Gérer mes médecins</h1>
                <a href="${pageContext.request.contextPath}/patient/dashboard" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-1"></i> Retour au tableau de bord
                </a>
            </div>

            <!-- Messages -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="successMessage" scope="session" />
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Search and Filter -->
            <div class="card mb-4">
                <div class="card-body">
                    <form method="GET" action="${pageContext.request.contextPath}/patient/doctors">
                        <div class="row">
                            <div class="col-md-8">
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                                    <input type="text" class="form-control" name="search" 
                                           placeholder="Rechercher par nom, prénom ou spécialité..." 
                                           value="${searchTerm}">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="d-grid gap-2 d-md-flex">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-search me-1"></i> Rechercher
                                    </button>
                                    <a href="${pageContext.request.contextPath}/patient/doctors" class="btn btn-outline-secondary">
                                        <i class="fas fa-times me-1"></i> Effacer
                                    </a>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Current Doctors -->
            <c:if test="${not empty patientDoctors}">
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-user-md me-2"></i> Mes médecins actuels (${patientDoctors.size()})
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <c:forEach var="doctor" items="${patientDoctors}">
                                <div class="col-md-6 col-lg-4 mb-3">
                                    <div class="card doctor-card h-100">
                                        <div class="card-body text-center">
                                            <div class="doctor-avatar mx-auto mb-3">
                                                <i class="fas fa-user-md"></i>
                                            </div>
                                            <h6 class="card-title">Dr. ${doctor.firstName} ${doctor.lastName}</h6>
                                            <c:if test="${not empty doctor.specialty.name}">
                                                <p class="card-text text-muted small">
                                                        ${doctor.specialty.name}

                                                </p>
                                            </c:if>
                                            <div class="d-grid gap-2">
                                                <a href="${pageContext.request.contextPath}/patient/appointment-create"
                                                   class="btn btn-sm btn-success">
                                                    <i class="fas fa-calendar-plus me-1"></i> Rendez-vous
                                                </a>
                                                <form method="POST" action="${pageContext.request.contextPath}/patient/doctors" 
                                                      onsubmit="return confirm('Êtes-vous sûr de vouloir retirer ce médecin ?')">
                                                    <input type="hidden" name="action" value="remove">
                                                    <input type="hidden" name="doctorId" value="${doctor.id}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger w-100">
                                                        <i class="fas fa-times me-1"></i> Retirer
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Available Doctors -->
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-plus-circle me-2"></i> Médecins disponibles
                        <c:if test="${not empty availableDoctors}">
                            (${availableDoctors.size()})
                        </c:if>
                    </h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty availableDoctors}">
                            <div class="text-center py-4">
                                <i class="fas fa-search fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">Aucun médecin trouvé</h5>
                                <p class="text-muted">
                                    <c:choose>
                                        <c:when test="${not empty searchTerm}">
                                            Aucun médecin ne correspond à votre recherche "${searchTerm}".
                                        </c:when>
                                        <c:otherwise>
                                            Tous les médecins sont déjà dans votre liste.
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="row">
                                <c:forEach var="doctor" items="${availableDoctors}">
                                    <div class="col-md-6 col-lg-4 mb-3">
                                        <div class="card doctor-card h-100">
                                            <div class="card-body text-center">
                                                <div class="doctor-avatar mx-auto mb-3">
                                                    <i class="fas fa-user-md"></i>
                                                </div>
                                                <h6 class="card-title">Dr. ${doctor.firstName} ${doctor.lastName}</h6>
                                                <c:if test="${not empty doctor.specialty.name}">
                                                    <p class="card-text text-muted small">
                                                            ${doctor.specialty.name}
                                                    </p>
                                                </c:if>
                                                <c:if test="${not empty doctor.phone}">
                                                    <p class="card-text small">
                                                        <i class="fas fa-phone me-1"></i> ${doctor.phone}
                                                    </p>
                                                </c:if>
                                                <form method="POST" action="${pageContext.request.contextPath}/patient/doctors">
                                                    <input type="hidden" name="action" value="add">
                                                    <input type="hidden" name="doctorId" value="${doctor.id}">
                                                    <button type="submit" class="btn btn-primary w-100">
                                                        <i class="fas fa-plus me-1"></i> Ajouter à ma liste
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
