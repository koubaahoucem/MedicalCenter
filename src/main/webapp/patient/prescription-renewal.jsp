<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Demande de Renouvellement - Centre Médical</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <jsp:include page="../css/patient/style.jsp" />
</head>
<body>
<jsp:include page="../header.jsp" />

<div class="container-fluid">
    <div class="row">
        <c:set var="activePage" value="prescriptions" scope="request" />
        <jsp:include page="../sidebar.jsp" />
        
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Demande de renouvellement d'ordonnance</h1>
                <a href="${pageContext.request.contextPath}/patient/prescriptions" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-1"></i> Retour aux ordonnances
                </a>
            </div>

            <!-- Messages -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="row">
                <!-- Prescription Details -->
                <div class="col-lg-6">
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-prescription me-2"></i> Détails de l'ordonnance
                            </h5>
                        </div>
                        <div class="card-body">
                            <h6 class="fw-bold">${not empty prescription.title ? prescription.title : 'Ordonnance'}</h6>
                            <p class="text-muted mb-2">
                                <i class="fas fa-user-md me-2"></i> 
                                Prescrite par Dr. ${prescription.doctor.firstName} ${prescription.doctor.lastName}
                            </p>
                            <p class="text-muted mb-2">
                                <i class="fas fa-calendar me-2"></i> 
                                Date de prescription: <fmt:formatDate value="${prescription.prescribedDate}" pattern="dd/MM/yyyy" />
                            </p>
                            <c:if test="${not empty prescription.expiryDate}">
                                <p class="text-muted mb-2">
                                    <i class="fas fa-clock me-2"></i> 
                                    Date d'expiration: <fmt:formatDate value="${prescription.expiryDate}" pattern="dd/MM/yyyy" />
                                    <c:choose>
                                        <c:when test="${prescription.isExpired()}">
                                            <span class="badge bg-danger ms-2">Expirée</span>
                                        </c:when>
                                        <c:when test="${prescription.isExpiringSoon()}">
                                            <span class="badge bg-warning ms-2">Expire bientôt</span>
                                        </c:when>
                                    </c:choose>
                                </p>
                            </c:if>
                            <div class="mt-3">
                                <h6>Description:</h6>
                                <p class="border p-3 bg-light rounded">${prescription.description}</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Renewal Request Form -->
                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-sync-alt me-2"></i> Demande de renouvellement
                            </h5>
                        </div>
                        <div class="card-body">
                            <form method="POST" action="${pageContext.request.contextPath}/patient/prescriptions/renew/${prescription.id}">
                                <input type="hidden" name="prescriptionId" value="${prescription.id}">
                                
                                <!-- Doctor Selection -->
                                <div class="mb-3">
                                    <label for="doctorId" class="form-label">
                                        <i class="fas fa-user-md me-1"></i> Médecin destinataire *
                                    </label>
                                    <select class="form-select" id="doctorId" name="doctorId" required disabled>
                                        <option value="">Sélectionnez un médecin</option>
                                            <option value="${prescription.doctor.id}" selected>
                                                    Dr. ${prescription.doctor.firstName} ${prescription.doctor.lastName}
                                            </option>
                                    </select>
                                    <div class="form-text">
                                        Le médecin qui a prescrit l'ordonnance originale est sélectionné par défaut.
                                    </div>
                                </div>

                                <!-- Urgency -->
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="isUrgent" name="isUrgent" value="true">
                                        <label class="form-check-label" for="isUrgent">
                                            <i class="fas fa-exclamation-triangle text-warning me-1"></i>
                                            Demande urgente
                                        </label>
                                    </div>
                                    <div class="form-text">
                                        Cochez cette case si vous avez besoin du renouvellement en urgence.
                                    </div>
                                </div>

                                <!-- Message -->
                                <div class="mb-3">
                                    <label for="message" class="form-label">
                                        <i class="fas fa-comment me-1"></i> Message (optionnel)
                                    </label>
                                    <textarea class="form-control" id="message" name="message" rows="4" 
                                              placeholder="Ajoutez un message pour le médecin (symptômes, raisons du renouvellement, etc.)"></textarea>
                                </div>

                                <!-- Submit Buttons -->
                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-success">
                                        <i class="fas fa-paper-plane me-1"></i> Envoyer la demande
                                    </button>
                                    <a href="${pageContext.request.contextPath}/patient/prescriptions" class="btn btn-outline-secondary">
                                        <i class="fas fa-times me-1"></i> Annuler
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Information Card -->
                    <div class="card mt-4">
                        <div class="card-body">
                            <h6 class="card-title">
                                <i class="fas fa-info-circle text-info me-2"></i> Information
                            </h6>
                            <p class="card-text small text-muted mb-0">
                                Votre demande sera envoyée au médecin sélectionné. Vous recevrez une notification 
                                dès que le médecin aura traité votre demande. Les demandes urgentes sont traitées 
                                en priorité.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
