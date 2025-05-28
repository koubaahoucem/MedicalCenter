<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier Patient - Centre Médical</title>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome pour les icônes -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <%@ include file="../css/doctor/doctor-styles.jsp" %>
</head>
<body>
    <%@ include file="../doctor-header.jsp" %>

    <div class="container-fluid">
        <div class="row">
            <c:set var="activePage" value="medical-records-edit" scope="request" />

            <%@ include file="../doctor-sidebar.jsp" %>

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">
                        <i class="fas fa-user-edit me-2"></i>Modifier Patient
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/doctor/patients" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Retour à la liste
                        </a>
                    </div>
                </div>

                <!-- Error/Success Messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Patient Edit Form -->
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-user me-2"></i>Informations du Patient
                                </h5>
                            </div>
                            <div class="card-body">
                                <form method="POST" action="${pageContext.request.contextPath}/doctor/patients/edit" id="patientForm">
                                    <input type="hidden" name="patientId" value="${patient.id}">

                                    <div class="row">
                                        <!-- Personal Information -->
                                        <div class="col-md-6">
                                            <h6 class="text-muted mb-3">Informations personnelles</h6>
                                            
                                            <div class="mb-3">
                                                <label for="firstName" class="form-label">Prénom <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="firstName" name="firstName" 
                                                       value="${patient.firstName}" required>
                                            </div>

                                            <div class="mb-3">
                                                <label for="lastName" class="form-label">Nom <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="lastName" name="lastName" 
                                                       value="${patient.lastName}" required>
                                            </div>

                                            <div class="mb-3">
                                                <label for="birthDate" class="form-label">Date de naissance</label>
                                                <input type="date" class="form-control" id="birthDate" name="birthDate" 
                                                       value="<fmt:formatDate value='${patient.birthDate}' pattern='yyyy-MM-dd'/>">
                                                <div class="form-text" id="ageDisplay"></div>
                                            </div>
                                        </div>

                                        <!-- Contact Information -->
                                        <div class="col-md-6">
                                            <h6 class="text-muted mb-3">Coordonnées</h6>
                                            
                                            <div class="mb-3">
                                                <label for="phone" class="form-label">Téléphone</label>
                                                <input type="tel" class="form-control" id="phone" name="phone" 
                                                       value="${patient.phone}" placeholder="Ex: 01 23 45 67 89">
                                            </div>

                                            <div class="mb-3">
                                                <label for="email" class="form-label">Email</label>
                                                <input type="email" class="form-control" id="email" name="email" 
                                                       value="${patient.user.email}" readonly>
                                                <div class="form-text">L'email ne peut pas être modifié depuis cette page.</div>
                                            </div>

                                            <div class="mb-3">
                                                <label for="address" class="form-label">Adresse</label>
                                                <textarea class="form-control" id="address" name="address" rows="3" 
                                                          placeholder="Adresse complète">${patient.address}</textarea>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Form Actions -->
                                    <div class="row mt-4">
                                        <div class="col-12">
                                            <hr>
                                            <div class="d-flex justify-content-between">
                                                <a href="${pageContext.request.contextPath}/doctor/patients" 
                                                   class="btn btn-outline-secondary">
                                                    <i class="fas fa-times me-1"></i>Annuler
                                                </a>
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="fas fa-save me-1"></i>Enregistrer les modifications
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Quick Actions Card -->
                        <div class="card mt-4">
                            <div class="card-header">
                                <h6 class="card-title mb-0">Actions rapides</h6>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-4">
                                        <a href="${pageContext.request.contextPath}/doctor/medical-records?patientId=${patient.id}" 
                                           class="btn btn-outline-success w-100 mb-2">
                                            <i class="fas fa-file-medical me-2"></i>Voir le dossier médical
                                        </a>
                                    </div>
                                    <div class="col-md-4">
                                        <a href="${pageContext.request.contextPath}/doctor/appointments/new?patientId=${patient.id}" 
                                           class="btn btn-outline-primary w-100 mb-2">
                                            <i class="fas fa-calendar-plus me-2"></i>Nouveau rendez-vous
                                        </a>
                                    </div>
                                    <div class="col-md-4">
                                        <a href="${pageContext.request.contextPath}/doctor/prescriptions/new?patientId=${patient.id}" 
                                           class="btn btn-outline-info w-100 mb-2">
                                            <i class="fas fa-prescription me-2"></i>Nouvelle ordonnance
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    <script>
        // Calculate and display age when birth date changes
        document.getElementById('birthDate').addEventListener('change', function() {
            const birthDate = new Date(this.value);
            const today = new Date();

            if (birthDate && birthDate <= today) {
                let age = today.getFullYear() - birthDate.getFullYear();
                const monthDiff = today.getMonth() - birthDate.getMonth();

                if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
                    age--;
                }

                document.getElementById('ageDisplay').textContent = age + ' ans';
                document.getElementById('ageDisplay').className = 'form-text text-success';
            } else {
                document.getElementById('ageDisplay').textContent = '';
            }
        });

        // Trigger age calculation on page load
        document.getElementById('birthDate').dispatchEvent(new Event('change'));

        // Form validation
        document.getElementById('patientForm').addEventListener('submit', function(e) {
            const firstName = document.getElementById('firstName').value.trim();
            const lastName = document.getElementById('lastName').value.trim();

            if (!firstName || !lastName) {
                e.preventDefault();
                alert('Le prénom et le nom sont obligatoires.');
                return false;
            }
        });

        // Phone number formatting
        document.getElementById('phone').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length >= 10) {
                value = value.substring(0, 10);
                value = value.replace(/(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1 $2 $3 $4 $5');
            }
            e.target.value = value;
        });
    </script>
</body>
</html>
