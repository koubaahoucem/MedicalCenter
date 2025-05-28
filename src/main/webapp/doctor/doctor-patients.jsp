<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ page import="com.medicalcenter.dao.PatientDAO" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Patients - Centre Médical</title>    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome pour les icônes -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">



    <%@ include file="../css/doctor/doctor-styles.jsp" %>
</head>
<body>
<!-- Navbar supérieure -->
<%@ include file="../doctor-header.jsp" %>

<div class="container-fluid">
    <div class="row">
        <c:set var="activePage" value="patients" scope="request"/>
        <%@ include file="../doctor-sidebar.jsp" %>

        <!-- Main content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">
                    <i class="fas fa-users me-2"></i>Mes Patients
                </h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <button type="button" class="btn btn-primary">
                        <i class="fas fa-user-plus me-1"></i> Nouveau Patient
                    </button>
                </div>
            </div>

            <!-- Success/Error Messages -->
            <c:if test="${param.updated == 'true'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>Patient mis à jour avec succès !
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Statistics Cards -->
            <div class="row mb-4">
                <div class="col-md-6 col-lg-3">
                    <div class="card card-stats border-start border-primary border-4">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-8">
                                    <h5 class="card-title text-muted mb-0">Total Patients</h5>
                                    <p class="h3 fw-bold mb-0 text-primary">${totalPatients}</p>
                                </div>
                                <div class="col-4 text-end">
                                    <i class="fas fa-users fa-2x text-primary opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="card card-stats border-start border-success border-4">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-8">
                                    <h5 class="card-title text-muted mb-0">Nouveaux (7j)</h5>
                                    <p class="h3 fw-bold mb-0 text-success">${newPatientsThisWeek}</p>
                                </div>
                                <div class="col-4 text-end">
                                    <i class="fas fa-user-plus fa-2x text-success opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Search and Filters -->
            <div class="card mb-4">
                <div class="card-body">
                    <form method="GET" action="${pageContext.request.contextPath}/doctor/patients" class="row g-3">
                        <div class="col-md-4">
                            <label for="search" class="form-label">Rechercher</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-search"></i></span>
                                <input type="text" class="form-control" id="search" name="search"
                                       placeholder="Nom, téléphone..." value="${searchQuery}">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label for="ageFilter" class="form-label">Tranche d'âge</label>
                            <select class="form-select" id="ageFilter" name="ageFilter">
                                <option value="">Tous les âges</option>
                                <option value="0-18" ${ageFilter == '0-18' ? 'selected' : ''}>0-18 ans</option>
                                <option value="19-35" ${ageFilter == '19-35' ? 'selected' : ''}>19-35 ans</option>
                                <option value="36-50" ${ageFilter == '36-50' ? 'selected' : ''}>36-50 ans</option>
                                <option value="51-65" ${ageFilter == '51-65' ? 'selected' : ''}>51-65 ans</option>
                                <option value="65+" ${ageFilter == '65+' ? 'selected' : ''}>65+ ans</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="sortBy" class="form-label">Trier par</label>
                            <select class="form-select" id="sortBy" name="sortBy">
                                <option value="name" ${sortBy == 'name' ? 'selected' : ''}>Nom</option>
                                <option value="age" ${sortBy == 'age' ? 'selected' : ''}>Âge</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">&nbsp;</label>
                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-filter me-1"></i>Filtrer
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Patients List -->
            <div class="row">
                <c:choose>
                    <c:when test="${empty patients}">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-body text-center py-5">
                                    <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">Aucun patient trouvé</h5>
                                    <p class="text-muted">
                                        <c:choose>
                                            <c:when test="${not empty searchQuery}">
                                                Aucun patient ne correspond à votre recherche.
                                            </c:when>
                                            <c:otherwise>
                                                Vous n'avez pas encore de patients.
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="patient" items="${patients}">
                            <div class="col-lg-6 col-xl-4 mb-4">
                                <div class="card h-100 patient-card">
                                    <div class="card-body">
                                        <div class="d-flex align-items-center mb-3">
                                            <div class="patient-avatar me-3">
                                                <div class="avatar-circle bg-primary text-white">
                                                        ${fn:substring(patient.firstName, 0, 1)}${fn:substring(patient.lastName, 0, 1)}
                                                </div>
                                            </div>
                                            <div class="flex-grow-1">
                                                <h5 class="card-title mb-1">${patient.firstName} ${patient.lastName}</h5>
                                                <c:if test="${patient.birthDate != null}">
                                                    <small class="text-muted">
                                                        <%
                                                            com.medicalcenter.model.Patient currentPatient = (com.medicalcenter.model.Patient) pageContext.getAttribute("patient");
                                                            if (currentPatient != null && currentPatient.getBirthDate() != null) {
                                                                int age = PatientDAO.getAge(currentPatient.getBirthDate());
                                                                out.print(age + " ans");
                                                            }
                                                        %>
                                                    </small>
                                                </c:if>
                                            </div>
                                        </div>

                                        <div class="patient-info">
                                            <c:if test="${not empty patient.phone}">
                                                <div class="info-item mb-2">
                                                    <i class="fas fa-phone text-muted me-2"></i>
                                                    <span>${patient.phone}</span>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty patient.user.email}">
                                                <div class="info-item mb-2">
                                                    <i class="fas fa-envelope text-muted me-2"></i>
                                                    <span>${patient.user.email}</span>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty patient.address}">
                                                <div class="info-item mb-2">
                                                    <i class="fas fa-map-marker-alt text-muted me-2"></i>
                                                    <span>${patient.address}</span>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="card-footer bg-transparent">
                                        <div class="btn-group w-100" role="group">
                                            <a href="${pageContext.request.contextPath}/doctor/patients/edit?id=${patient.id}"
                                               class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-edit me-1"></i>Modifier
                                            </a>
                                            <a href="${pageContext.request.contextPath}/doctor/medical-records?patientId=${patient.id}"
                                               class="btn btn-outline-success btn-sm">
                                                <i class="fas fa-file-medical me-1"></i>Dossier
                                            </a>
                                            <a href="${pageContext.request.contextPath}/doctor/appointments/new?patientId=${patient.id}"
                                               class="btn btn-outline-info btn-sm">
                                                <i class="fas fa-calendar-plus me-1"></i>RDV
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</div>


<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Real-time search functionality
        const searchInput = document.getElementById('search');
        const patientCards = document.querySelectorAll('.patient-card');

        if (searchInput) {
            searchInput.addEventListener('input', function () {
                const searchTerm = this.value.toLowerCase();

                patientCards.forEach(card => {
                    const patientName = card.querySelector('.card-title').textContent.toLowerCase();
                    const patientPhone = card.querySelector('.fa-phone')?.nextElementSibling?.textContent || '';
                    const patientEmail = card.querySelector('.fa-envelope')?.nextElementSibling?.textContent || '';

                    const matches = patientName.includes(searchTerm) ||
                        patientPhone.includes(searchTerm) ||
                        patientEmail.includes(searchTerm);

                    card.closest('.col-lg-6').style.display = matches ? 'block' : 'none';
                });

                // Update results count
                updateResultsCount();
            });
        }

        // Auto-submit form on filter change
        const filterSelects = document.querySelectorAll('#ageFilter, #sortBy');
        filterSelects.forEach(select => {
            select.addEventListener('change', function () {
                this.closest('form').submit();
            });
        });

        // Animate statistics cards on load
        const statsCards = document.querySelectorAll('.card-stats');
        statsCards.forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';

            setTimeout(() => {
                card.style.transition = 'all 0.5s ease';
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, index * 100);
        });

        // Animate patient cards on load
        const patientCardsElements = document.querySelectorAll('.patient-card');
        patientCardsElements.forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(30px)';

            setTimeout(() => {
                card.style.transition = 'all 0.6s ease';
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, 200 + (index * 50));
        });

        // Phone number formatting
        const phoneInputs = document.querySelectorAll('input[type="tel"]');
        phoneInputs.forEach(input => {
            input.addEventListener('input', function () {
                let value = this.value.replace(/\D/g, '');
                if (value.length >= 10) {
                    value = value.replace(/(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1 $2 $3 $4 $5');
                }
                this.value = value;
            });
        });

        // Tooltip initialization
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });

        // Auto-hide alerts
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => {
            setTimeout(() => {
                if (alert && alert.classList.contains('show')) {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }
            }, 5000);
        });

        // Smooth scroll to top
        function scrollToTop() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        }

        // Add scroll to top button
        const scrollButton = document.createElement('button');
        scrollButton.innerHTML = '<i class="fas fa-arrow-up"></i>';
        scrollButton.className = 'btn btn-primary position-fixed';
        scrollButton.style.cssText = `
        bottom: 20px;
        right: 20px;
        z-index: 1000;
        border-radius: 50%;
        width: 50px;
        height: 50px;
        display: none;
        box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
    `;
        scrollButton.onclick = scrollToTop;
        document.body.appendChild(scrollButton);

        // Show/hide scroll button
        window.addEventListener('scroll', function () {
            if (window.pageYOffset > 300) {
                scrollButton.style.display = 'block';
            } else {
                scrollButton.style.display = 'none';
            }
        });

        // Update results count
        function updateResultsCount() {
            const visibleCards = document.querySelectorAll('.patient-card:not([style*="display: none"])').length;
            const totalCards = patientCards.length;

            let countElement = document.getElementById('results-count');
            if (!countElement) {
                countElement = document.createElement('small');
                countElement.id = 'results-count';
                countElement.className = 'text-muted ms-2';
                document.querySelector('h1.h2').appendChild(countElement);
            }

            if (searchInput.value) {
                countElement.textContent = `(${visibleCards} sur ${totalCards})`;
            } else {
                countElement.textContent = '';
            }
        }

        // Loading state for buttons
        document.querySelectorAll('form').forEach(form => {
            form.addEventListener('submit', function () {
                const submitBtn = this.querySelector('button[type="submit"]');
                if (submitBtn) {
                    const originalText = submitBtn.innerHTML;
                    submitBtn.innerHTML = '<span class="loading"></span> Chargement...';
                    submitBtn.disabled = true;

                    // Re-enable after 3 seconds (fallback)
                    setTimeout(() => {
                        submitBtn.innerHTML = originalText;
                        submitBtn.disabled = false;
                    }, 3000);
                }
            });
        });

        // Enhanced hover effects
        patientCardsElements.forEach(card => {
            card.addEventListener('mouseenter', function () {
                this.style.transform = 'translateY(-5px) scale(1.02)';
            });

            card.addEventListener('mouseleave', function () {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
