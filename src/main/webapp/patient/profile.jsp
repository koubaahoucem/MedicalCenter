<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Profil - Centre Médical</title>

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
        <c:set var="activePage" value="profile" scope="request" />
        <jsp:include page="../sidebar.jsp" />

        <!-- Contenu principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">
                    <c:choose>
                        <c:when test="${userRole == 'patient'}">Mon profil</c:when>
                        <c:when test="${userRole == 'doctor'}">Profil médecin</c:when>
                        <c:when test="${userRole == 'admin'}">Profil administrateur</c:when>
                        <c:otherwise>Mon profil</c:otherwise>
                    </c:choose>
                </h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <button type="button" class="btn btn-success" id="saveProfileBtn">
                        <i class="fas fa-save me-1"></i> Enregistrer les modifications
                    </button>
                </div>
            </div>

            <!-- Messages d'alerte -->
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- En-tête du profil -->
            <div class="profile-header">
                <div class="row">
                    <div class="col-md-2 text-center">
                        <c:choose>
                            <c:when test="${userRole == 'patient'}">
                                <img src="https://cdn-icons-png.flaticon.com/512/1077/1077114.png"
                                     alt="${patient.firstName} ${patient.lastName}" class="profile-avatar" width="100" height="100">
                            </c:when>
                            <c:when test="${userRole == 'doctor'}">
                                <img src="https://cdn-icons-png.flaticon.com/512/2785/2785482.png"
                                     alt="Dr. ${doctor.firstName} ${doctor.lastName}" class="profile-avatar" width="100" height="100">
                            </c:when>
                            <c:when test="${userRole == 'admin'}">
                                <img src="https://cdn-icons-png.flaticon.com/512/1077/1077063.png"
                                     alt="${user.username}" class="profile-avatar" width="100" height="100">
                            </c:when>
                        </c:choose>
                        <div class="mt-2">
                            <button class="btn btn-sm btn-outline-secondary">
                                <i class="fas fa-camera me-1"></i> Modifier
                            </button>
                        </div>
                    </div>
                    <div class="col-md-10 profile-info">
                        <c:choose>
                            <c:when test="${userRole == 'patient'}">
                                <h3>${patient.firstName} ${patient.lastName}</h3>
                                <p class="text-muted">
                                    <i class="fas fa-id-card me-2"></i> Patient ID: ${patient.id}
                                    <span class="ms-3"><i class="fas fa-calendar-day me-2"></i>
                                        Inscrit depuis: <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy" />
                                    </span>
                                </p>
                                <p>
                                    <i class="fas fa-envelope me-2"></i> ${user.email}
                                    <c:if test="${not empty patient.phone}">
                                        <span class="ms-3"><i class="fas fa-phone me-2"></i> ${patient.phone}</span>
                                    </c:if>
                                </p>
                                <div class="row mt-3">
                                    <div class="col-md-3">
                                        <div class="stat-card">
                                            <div class="stat-number">${medicalRecordCount}</div>
                                            <div class="stat-label">Dossiers médicaux</div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="stat-card">
                                            <div class="stat-number">${upcomingAppointments}</div>
                                            <div class="stat-label">RDV à venir</div>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:when test="${userRole == 'doctor'}">
                                <h3>Dr. ${doctor.firstName} ${doctor.lastName}</h3>
                                <p class="text-muted">
                                    <i class="fas fa-id-card me-2"></i> Médecin ID: ${doctor.id}
                                    <span class="ms-3"><i class="fas fa-certificate me-2"></i> Licence: ${doctor.licenseNumber}</span>
                                </p>
                                <p>
                                    <i class="fas fa-envelope me-2"></i> ${user.email}
                                    <c:if test="${not empty doctor.phone}">
                                        <span class="ms-3"><i class="fas fa-phone me-2"></i> ${doctor.phone}</span>
                                    </c:if>
                                </p>
                                <p>
                                    <i class="fas fa-stethoscope me-2"></i> Spécialités:
                                    <c:forEach items="${doctor.specialties}" var="specialty" varStatus="status">
                                        ${specialty.name}<c:if test="${!status.last}">, </c:if>
                                    </c:forEach>
                                </p>
                                <div class="row mt-3">
                                    <div class="col-md-3">
                                        <div class="stat-card">
                                            <div class="stat-number">${totalAppointments}</div>
                                            <div class="stat-label">Total RDV</div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="stat-card">
                                            <div class="stat-number">${upcomingAppointments}</div>
                                            <div class="stat-label">RDV à venir</div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="stat-card">
                                            <div class="stat-number">${prescriptionCount}</div>
                                            <div class="stat-label">Prescriptions</div>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:when test="${userRole == 'admin'}">
                                <h3>${user.username}</h3>
                                <p class="text-muted">
                                    <i class="fas fa-shield-alt me-2"></i> Administrateur système
                                    <span class="ms-3"><i class="fas fa-calendar-day me-2"></i>
                                        Inscrit depuis: <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy" />
                                    </span>
                                </p>
                                <p>
                                    <i class="fas fa-envelope me-2"></i> ${user.email}
                                </p>
                                <div class="row mt-3">
                                    <div class="col-md-3">
                                        <div class="stat-card">
                                            <div class="stat-number">${totalUsers}</div>
                                            <div class="stat-label">Utilisateurs</div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="stat-card">
                                            <div class="stat-number">${totalPatients}</div>
                                            <div class="stat-label">Patients</div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="stat-card">
                                            <div class="stat-number">${totalDoctors}</div>
                                            <div class="stat-label">Médecins</div>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Formulaire de profil -->
            <form id="profileForm" method="post" action="${pageContext.request.contextPath}/profile">
                <!-- Informations de base -->
                <div class="profile-section">
                    <div class="profile-section-header d-flex justify-content-between align-items-center">
                        <h4>Informations de base</h4>
                        <button type="button" class="btn-edit" data-bs-toggle="collapse" data-bs-target="#basicInfoCollapse">
                            <i class="fas fa-edit"></i>
                        </button>
                    </div>
                    <div class="collapse show" id="basicInfoCollapse">
                        <div class="row">
                            <c:choose>
                                <c:when test="${userRole == 'admin'}">
                                    <div class="col-md-6 mb-3">
                                        <label for="username" class="form-label">Nom d'utilisateur</label>
                                        <input type="text" class="form-control" id="username" name="username"
                                               value="${user.username}" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="email" class="form-label">Email</label>
                                        <input type="email" class="form-control" id="emailA" name="email"
                                               value="${user.email}" required>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="col-md-6 mb-3">
                                        <label for="firstName" class="form-label">Prénom</label>
                                        <input type="text" class="form-control" id="firstName" name="firstName"
                                               value="${userRole == 'patient' ? patient.firstName : doctor.firstName}" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="lastName" class="form-label">Nom</label>
                                        <input type="text" class="form-control" id="lastName" name="lastName"
                                               value="${userRole == 'patient' ? patient.lastName : doctor.lastName}" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="email" class="form-label">Email</label>
                                        <input type="email" class="form-control" id="email" name="email"
                                               value="${user.email}" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="phone" class="form-label">Téléphone</label>
                                        <input type="tel" class="form-control" id="phone" name="phone"
                                               value="${userRole == 'patient' ? patient.phone : doctor.phone}">
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Informations spécifiques au rôle -->
                <c:if test="${userRole == 'patient'}">
                    <!-- Informations patient -->
                    <div class="profile-section">
                        <div class="profile-section-header d-flex justify-content-between align-items-center">
                            <h4>Informations personnelles</h4>
                            <button type="button" class="btn-edit" data-bs-toggle="collapse" data-bs-target="#patientInfoCollapse">
                                <i class="fas fa-edit"></i>
                            </button>
                        </div>
                        <div class="collapse show" id="patientInfoCollapse">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="birthDate" class="form-label">Date de naissance</label>
                                    <input type="date" class="form-control" id="birthDate" name="birthDate"
                                           value="${formattedBirthDate}">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="address" class="form-label">Adresse</label>
                                    <input type="text" class="form-control" id="address" name="address"
                                           value="${patient.address}">
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>

                <c:if test="${userRole == 'doctor'}">
                    <!-- Informations médecin -->
                    <div class="profile-section">
                        <div class="profile-section-header d-flex justify-content-between align-items-center">
                            <h4>Informations professionnelles</h4>
                            <button type="button" class="btn-edit" data-bs-toggle="collapse" data-bs-target="#doctorInfoCollapse">
                                <i class="fas fa-edit"></i>
                            </button>
                        </div>
                        <div class="collapse show" id="doctorInfoCollapse">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="licenseNumber" class="form-label">Numéro de licence</label>
                                    <input type="text" class="form-control" id="licenseNumber" name="licenseNumber"
                                           value="${doctor.licenseNumber}" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="specialties" class="form-label">Spécialités</label>
                                    <select class="form-select" id="specialties" name="specialties" multiple>
                                        <c:forEach items="${allSpecialties}" var="specialty">
                                            <option value="${specialty.id}"
                                                    <c:if test="${doctor.specialties.contains(specialty)}">selected</c:if>>
                                                    ${specialty.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <small class="form-text text-muted">Maintenez Ctrl pour sélectionner plusieurs spécialités.</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>

                <c:if test="${userRole == 'admin'}">
                    <!-- Informations système pour admin -->
                    <div class="profile-section">
                        <div class="profile-section-header">
                            <h4>Statistiques système</h4>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="table-responsive">
                                    <table class="table table-striped">
                                        <thead>
                                        <tr>
                                            <th>Métrique</th>
                                            <th>Valeur</th>
                                            <th>Description</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <tr>
                                            <td><i class="fas fa-users me-2"></i>Utilisateurs totaux</td>
                                            <td><span class="badge bg-primary">${totalUsers}</span></td>
                                            <td>Nombre total d'utilisateurs dans le système</td>
                                        </tr>
                                        <tr>
                                            <td><i class="fas fa-user-injured me-2"></i>Patients</td>
                                            <td><span class="badge bg-info">${totalPatients}</span></td>
                                            <td>Nombre de patients enregistrés</td>
                                        </tr>
                                        <tr>
                                            <td><i class="fas fa-user-md me-2"></i>Médecins</td>
                                            <td><span class="badge bg-success">${totalDoctors}</span></td>
                                            <td>Nombre de médecins actifs</td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
            </form>
        </main>
    </div>
</div>

<!-- Bootstrap JS Bundle avec Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Script pour les interactions -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Enregistrer les modifications
        document.getElementById('saveProfileBtn').addEventListener('click', function() {
            const form = document.getElementById('profileForm');
            if (form.checkValidity()) {
                form.submit();
            } else {
                form.reportValidity();
            }
        });
    });
</script>

</body>
</html>
