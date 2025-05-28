<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prendre un rendez-vous - Centre Médical</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome pour les icônes -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Flatpickr pour le sélecteur de date/heure -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">

    <jsp:include page="../css/patient/style.jsp" />
</head>
<body>
<!-- Navbar supérieure -->
<jsp:include page="../header.jsp" />

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <c:set var="activePage" value="appointment-form" scope="request" />
        <jsp:include page="../sidebar.jsp" />

        <!-- Contenu principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Prendre un rendez-vous</h1>
            </div>

            <!-- Affichage des messages d'erreur ou de succès -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Formulaire de prise de rendez-vous -->
            <form id="appointmentForm" action="${pageContext.request.contextPath}/patient/appointment-create"
                  method="post" class="needs-validation" novalidate>
                <div class="row">
                    <!-- Sélection du médecin et spécialité -->
                    <div class="col-md-6 mb-4">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title">Médecin et spécialité</h5>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label for="specialtyId" class="form-label">Spécialité</label>
                                    <select class="form-select" id="specialtyId" name="specialtyId" required>
                                        <option value="" selected disabled>Choisir une spécialité</option>
                                        <c:forEach var="specialty" items="${specialties}">
                                            <option value="${specialty.id}">${specialty.name}</option>
                                        </c:forEach>
                                    </select>
                                    <div class="invalid-feedback">
                                        Veuillez sélectionner une spécialité.
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="doctorId" class="form-label">Médecin</label>
                                    <select class="form-select" id="doctorId" name="doctorId" required>
                                        <option value="" selected disabled>Choisir un médecin</option>
                                        <c:forEach var="doctor" items="${doctors}">
                                            <option value="${doctor.id}">${doctor.firstName}</option>
                                        </c:forEach>
                                    </select>
                                    <div class="invalid-feedback">
                                        Veuillez sélectionner un médecin.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Date et heure -->
                    <div class="col-md-6 mb-4">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title">Date et heure</h5>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label for="appointmentDate" class="form-label">Date du rendez-vous</label>
                                    <input type="text" class="form-control" id="appointmentDate" name="appointmentDate"
                                           placeholder="Sélectionnez une date" required>
                                    <div class="invalid-feedback">
                                        Veuillez sélectionner une date.
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="appointmentTime" class="form-label">Heure du rendez-vous</label>
                                    <select class="form-select" id="appointmentTime" name="appointmentTime" required>
                                        <option value="" selected disabled>Choisir une heure</option>
                                    </select>
                                    <div class="invalid-feedback">
                                        Veuillez sélectionner une heure.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Informations complémentaires -->
                    <div class="col-12 mb-4">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title">Informations complémentaires</h5>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label for="reason" class="form-label">Motif du rendez-vous</label>
                                    <textarea class="form-control" id="reason" name="reason" rows="2"
                                              required></textarea>
                                    <div class="invalid-feedback">
                                        Veuillez indiquer le motif de votre rendez-vous.
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="location" class="form-label">Lieu</label>
                                    <select class="form-select" id="location" name="location" required>
                                        <option value="" selected disabled>Choisir un lieu</option>
                                        <option value="Cabinet principal">Cabinet principal</option>
                                        <option value="Centre médical">Centre médical</option>
                                    </select>
                                    <div class="invalid-feedback">
                                        Veuillez sélectionner un lieu.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Bouton de soumission -->
                    <div class="col-12 mb-4">
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-success btn-lg">
                                <i class="fas fa-calendar-check me-2"></i> Confirmer le rendez-vous
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </main>
    </div>
</div>

<!-- Bootstrap JS Bundle avec Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- Flatpickr pour le sélecteur de date -->
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/fr.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Initialisation de Flatpickr (sélecteur de date)
        flatpickr("#appointmentDate", {
            locale: "fr",
            dateFormat: "d/m/Y",
            minDate: "today",
            disable: [
                function (date) {
                    // Désactiver les dimanches
                    return date.getDay() === 0;
                }
            ],
            onChange: function (selectedDates, dateStr) {
                updateAvailableTimes();
            }
        });

        // Gestion de la sélection de spécialité
        document.getElementById('specialtyId').addEventListener('change', function () {
            const specialtyId = this.value;
            if (specialtyId) {
                fetchDoctorsBySpecialty(specialtyId);
            } else {
                resetDoctorSelect();
            }
        });

        // Gestion de la sélection de médecin
        document.getElementById('doctorId').addEventListener('change', function () {
            updateAvailableTimes();
        });


        // Validation du formulaire
        const form = document.getElementById('appointmentForm');
        form.addEventListener('submit', function (event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        });

        // Fonction pour récupérer les médecins par spécialité
        function fetchDoctorsBySpecialty(specialtyId) {
            fetch('${pageContext.request.contextPath}/api/doctors?specialtyId=' + specialtyId)
                .then(response => response.json())
                .then(data => {
                    const doctorSelect = document.getElementById('doctorId');
                    doctorSelect.innerHTML = '<option value="" selected disabled>Choisir un médecin</option>';

                    data.forEach(doctor => {
                        const option = document.createElement('option');
                        option.value = doctor.id;
                        option.textContent = 'Dr. ' + doctor.lastName + ' ' + doctor.firstName;
                        doctorSelect.appendChild(option);
                    });
                })
                .catch(error => {
                    console.error('Erreur lors de la récupération des médecins:', error);
                });
        }

        // Fonction pour réinitialiser le sélecteur de médecin
        function resetDoctorSelect() {
            const doctorSelect = document.getElementById('doctorId');
            doctorSelect.innerHTML = '<option value="" selected disabled>Choisir un médecin</option>';
        }

        // Fonction pour mettre à jour les heures disponibles
        function updateAvailableTimes() {
            const doctorId = document.getElementById('doctorId').value;
            const dateStr = document.getElementById('appointmentDate').value;

            if (!doctorId || !dateStr) {
                resetTimeSelect();
                return;
            }

            fetch('${pageContext.request.contextPath}/api/available-times?doctorId=' + doctorId + '&date=' + dateStr)
                .then(response => response.json())
                .then(data => {
                    const timeSelect = document.getElementById('appointmentTime');
                    timeSelect.innerHTML = '<option value="" selected disabled>Choisir une heure</option>';

                    data.forEach(time => {
                        const option = document.createElement('option');
                        option.value = time;
                        option.textContent = time;
                        timeSelect.appendChild(option);
                    });
                })
                .catch(error => {
                    console.error('Erreur lors de la récupération des horaires:', error);
                });
        }

        // Fonction pour réinitialiser le sélecteur d'heure
        function resetTimeSelect() {
            const timeSelect = document.getElementById('appointmentTime');
            timeSelect.innerHTML = '<option value="" selected disabled>Choisir une heure</option>';
        }
    });
</script>
</body>
</html>
