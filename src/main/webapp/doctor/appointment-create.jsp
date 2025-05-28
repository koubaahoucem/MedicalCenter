<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouveau Rendez-vous - Centre Médical</title>

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
        <c:set var="activePage" value="appointments-new" scope="request" />
        <%@ include file="../doctor-sidebar.jsp" %>

        <!-- Main content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">
                    <i class="fas fa-calendar-plus me-2"></i>Nouveau Rendez-vous
                </h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="${pageContext.request.contextPath}/doctor/appointments" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-1"></i>Retour
                    </a>
                </div>
            </div>

            <!-- Error/Success Messages -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Appointment Form -->
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Informations du rendez-vous</h5>
                        </div>
                        <div class="card-body">
                            <form method="post" action="${pageContext.request.contextPath}/doctor/appointments/new" id="appointmentForm">
                                <!-- Patient Selection -->
                                <div class="row mb-3">
                                    <div class="col-md-12">
                                        <label for="patientId" class="form-label">Patient <span class="text-danger">*</span></label>
                                        <select class="form-select" id="patientId" name="patientId" required>
                                            <option value="">Sélectionner un patient</option>
                                            <c:forEach var="patient" items="${patients}">
                                                <option value="${patient.id}"
                                                    ${selectedPatient != null && selectedPatient.id == patient.id ? 'selected' : ''}>
                                                        ${patient.fullName}
                                                    <c:if test="${not empty patient.phone}"> - ${patient.phone}</c:if>
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>

                                <!-- Date and Time -->
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="appointmentDate" class="form-label">Date <span class="text-danger">*</span></label>
                                        <input type="date" class="form-control" id="appointmentDate" name="appointmentDate"
                                               min="<fmt:formatDate value='${currentDate}' pattern='yyyy-MM-dd'/>" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="appointmentTime" class="form-label">Heure <span class="text-danger">*</span></label>
                                        <input type="time" class="form-control" id="appointmentTime" name="appointmentTime"
                                               min="08:00" max="18:00" required>
                                    </div>
                                </div>

                                <!-- Reason and Location -->
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="reason" class="form-label">Motif <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="reason" name="reason"
                                               placeholder="Ex: Consultation de suivi" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="location" class="form-label">Lieu <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="location" name="location"
                                               placeholder="Ex: Cabinet médical" required>
                                    </div>
                                </div>

                                <!-- Notes -->
                                <div class="mb-3">
                                    <label for="notes" class="form-label">Notes</label>
                                    <textarea class="form-control" id="notes" name="notes" rows="3"
                                              placeholder="Notes additionnelles (optionnel)"></textarea>
                                </div>

                                <!-- Teleconsultation -->
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="teleconsultation" name="teleconsultation">
                                        <label class="form-check-label" for="teleconsultation">
                                            <i class="fas fa-video me-1"></i>Téléconsultation
                                        </label>
                                    </div>
                                </div>

                                <!-- Submit Buttons -->
                                <div class="d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/doctor/appointments" class="btn btn-secondary">
                                        <i class="fas fa-times me-1"></i>Annuler
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-1"></i>Créer le rendez-vous
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

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Set minimum date to today
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('appointmentDate').min = today;

        // Form validation
        const form = document.getElementById('appointmentForm');
        form.addEventListener('submit', function(e) {
            const date = document.getElementById('appointmentDate').value;
            const time = document.getElementById('appointmentTime').value;

            if (date && time) {
                const appointmentDateTime = new Date(date + 'T' + time);
                const now = new Date();

                if (appointmentDateTime <= now) {
                    e.preventDefault();
                    alert('La date et l\'heure du rendez-vous doivent être dans le futur.');
                    return false;
                }
            }
        });

        // Auto-fill location based on teleconsultation
        const teleconsultationCheckbox = document.getElementById('teleconsultation');
        const locationInput = document.getElementById('location');

        teleconsultationCheckbox.addEventListener('change', function() {
            if (this.checked) {
                locationInput.value = 'Téléconsultation';
            } else {
                locationInput.value = '';
            }
        });
    });
</script>
</body>
</html>