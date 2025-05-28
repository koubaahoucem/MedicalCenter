<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier le Profil - Dr. ${doctor.fullName}</title>

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
                    <i class="fas fa-edit me-2"></i>Modifier le Profil
                </h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="${pageContext.request.contextPath}/doctor/profile" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-1"></i>Retour
                    </a>
                </div>
            </div>

            <!-- Error Message -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Edit Form -->
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Modifier les informations</h5>
                        </div>
                        <div class="card-body">
                            <form method="post" action="${pageContext.request.contextPath}/doctor/profile" id="profileForm">
                                <!-- Name Fields -->
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="firstName" class="form-label">Prénom <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="firstName" name="firstName" 
                                               value="${doctor.firstName}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="lastName" class="form-label">Nom <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="lastName" name="lastName" 
                                               value="${doctor.lastName}" required>
                                    </div>
                                </div>

                                <!-- Contact Information -->
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                        <input type="email" class="form-control" id="email" name="email" 
                                               value="${doctor.user.email}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="phone" class="form-label">Téléphone</label>
                                        <input type="tel" class="form-control" id="phone" name="phone" 
                                               value="${doctor.phone}" placeholder="Ex: 01 23 45 67 89">
                                    </div>
                                </div>

                                <!-- Professional Information -->
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="licenseNumber" class="form-label">Numéro de licence <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="licenseNumber" name="licenseNumber" 
                                               value="${doctor.licenseNumber}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="specialtyId" class="form-label">Spécialité <span class="text-danger">*</span></label>
                                        <select class="form-select" id="specialtyId" name="specialtyId" required>
                                            <option value="">Sélectionner une spécialité</option>
                                            <c:forEach var="specialty" items="${specialties}">
                                                <option value="${specialty.id}" 
                                                    ${doctor.specialty != null && doctor.specialty.id == specialty.id ? 'selected' : ''}>
                                                    ${specialty.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>

                                <!-- Submit Buttons -->
                                <div class="d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/doctor/profile" class="btn btn-secondary">
                                        <i class="fas fa-times me-1"></i>Annuler
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-1"></i>Enregistrer les modifications
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
    // Phone number formatting
    const phoneInput = document.getElementById('phone');
    phoneInput.addEventListener('input', function() {
        let value = this.value.replace(/\D/g, '');
        if (value.length >= 10) {
            value = value.replace(/(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1 $2 $3 $4 $5');
        }
        this.value = value;
    });

    // Form validation
    const form = document.getElementById('profileForm');
    form.addEventListener('submit', function(e) {
        const email = document.getElementById('email').value;
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        
        if (!emailRegex.test(email)) {
            e.preventDefault();
            alert('Veuillez entrer une adresse email valide.');
            return false;
        }
    });
});
</script>
</body>
</html>