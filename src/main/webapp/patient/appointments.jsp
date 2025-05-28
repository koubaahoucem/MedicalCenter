<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Rendez-vous - Centre Médical</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome pour les icônes -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- FullCalendar pour l'agenda -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>

    <style>
        .sidebar {
            min-height: 100vh;
            background-color: #27ae60;
            color: #fff;
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            z-index: 100;
            padding: 0;
            box-shadow: inset -1px 0 0 rgba(0, 0, 0, .1);
        }

        .sidebar-sticky {
            position: sticky;
            top: 0;
            height: calc(100vh - 48px);
            padding-top: 1rem;
            overflow-x: hidden;
            overflow-y: auto;
        }

        .sidebar .nav-link {
            font-weight: 500;
            color: rgba(255, 255, 255, .75);
            padding: 0.75rem 1rem;
        }

        .sidebar .nav-link:hover {
            color: #fff;
        }

        .sidebar .nav-link.active {
            color: #fff;
            background-color: rgba(255, 255, 255, .1);
        }

        .sidebar .nav-link i {
            margin-right: 10px;
        }

        main {
            padding-top: 70px;
        }

        .navbar {
            box-shadow: 0 2px 4px rgba(0, 0, 0, .1);
            background-color: #2ecc71 !important;
        }

        .card {
            margin-bottom: 20px;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }

        .appointment-card {
            border-left: 4px solid #2ecc71;
            transition: transform 0.2s;
        }

        .appointment-card:hover {
            transform: translateY(-3px);
        }

        .appointment-card.past {
            border-left-color: #95a5a6;
        }

        .appointment-card.upcoming {
            border-left-color: #3498db;
        }

        .appointment-card.today {
            border-left-color: #f39c12;
        }

        .calendar-container {
            height: 600px;
        }

        .doctor-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }

        .specialty-badge {
            background-color: #e9f7ef;
            color: #27ae60;
            font-weight: 500;
        }

        .filter-btn.active {
            background-color: #2ecc71;
            color: white;
        }

        @media (max-width: 767.98px) {
            .sidebar {
                position: static;
                height: auto;
                min-height: auto;
            }

            main {
                padding-top: 20px;
            }
        }
    </style>
</head>
<body>
<!-- Navbar supérieure -->
<nav class="navbar navbar-expand-lg navbar-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/patient/dashboard.jsp">
            <img src="${pageContext.request.contextPath}/resources/images/medical-logo.svg"
                 alt="Centre Médical" width="30" height="30" class="d-inline-block align-text-top me-2"
                 onerror="this.onerror=null; this.src='https://cdn-icons-png.flaticon.com/512/4320/4320371.png';">
            Centre Médical - Espace Patient
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-bell"></i>
                        <span class="badge bg-danger">2</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><h6 class="dropdown-header">Notifications</h6></li>
                        <li><a class="dropdown-item" href="#">Rappel: RDV demain à 14h00</a></li>
                        <li><a class="dropdown-item" href="#">Résultats d'analyses disponibles</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="#">Voir toutes les notifications</a></li>
                    </ul>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user-circle me-1"></i> ${sessionScope.username}
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/patient/profile.jsp"><i class="fas fa-user me-2"></i>Mon profil</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/patient/medical-record.jsp"><i class="fas fa-file-medical me-2"></i>Mon dossier médical</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/auth/logout"><i class="fas fa-sign-out-alt me-2"></i>Déconnexion</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav id="sidebar" class="col-md-3 col-lg-2 d-md-block sidebar collapse">
            <div class="sidebar-sticky">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/patient/dashboard.jsp">
                            <i class="fas fa-tachometer-alt"></i> Tableau de bord
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/patient/appointments-list.jsp">
                            <i class="fas fa-calendar-alt"></i> Mes rendez-vous
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/patient/medical-record.jsp">
                            <i class="fas fa-file-medical"></i> Mon dossier médical
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/patient/prescriptions-list.jsp">
                            <i class="fas fa-prescription"></i> Mes ordonnances
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/patient/profile.jsp">
                            <i class="fas fa-user"></i> Mon profil
                        </a>
                    </li>
                </ul>

                <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
                    <span>Accès rapide</span>
                </h6>
                <ul class="nav flex-column mb-2">
                    <li class="nav-item">
                        <a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#newAppointmentModal">
                            <i class="fas fa-calendar-plus"></i> Prendre rendez-vous
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Contenu principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Mes rendez-vous</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#newAppointmentModal">
                        <i class="fas fa-calendar-plus me-1"></i> Nouveau rendez-vous
                    </button>
                </div>
            </div>

            <!-- Filtres et vue -->
            <div class="row mb-4">
                <div class="col-md-8">
                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-outline-secondary filter-btn active" data-filter="all">Tous</button>
                        <button type="button" class="btn btn-outline-secondary filter-btn" data-filter="upcoming">À venir</button>
                        <button type="button" class="btn btn-outline-secondary filter-btn" data-filter="past">Passés</button>
                        <button type="button" class="btn btn-outline-secondary filter-btn" data-filter="canceled">Annulés</button>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="btn-group float-end" role="group">
                        <button type="button" class="btn btn-outline-secondary active" id="listViewBtn">
                            <i class="fas fa-list"></i> Liste
                        </button>
                        <button type="button" class="btn btn-outline-secondary" id="calendarViewBtn">
                            <i class="fas fa-calendar-alt"></i> Calendrier
                        </button>
                    </div>
                </div>
            </div>

            <!-- Vue Liste -->
            <div id="listView">
                <div class="row">
                    <div class="col-12">
                        <!-- Rendez-vous d'aujourd'hui -->
                        <h5 class="mb-3">Aujourd'hui</h5>
                        <div class="card appointment-card today mb-4">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-2 col-sm-3 text-center mb-3 mb-md-0">
                                        <div class="h4 mb-0">14:30</div>
                                        <div class="text-muted">19 mai 2023</div>
                                    </div>
                                    <div class="col-md-7 col-sm-9">
                                        <div class="d-flex align-items-center mb-2">
                                            <img src="https://randomuser.me/api/portraits/men/36.jpg" alt="Dr. Martin" class="doctor-avatar me-3">
                                            <div>
                                                <h5 class="mb-0">Dr. Martin</h5>
                                                <span class="badge specialty-badge">Médecin généraliste</span>
                                            </div>
                                        </div>
                                        <p class="mb-1"><i class="fas fa-map-marker-alt me-2"></i> Cabinet 3, 2ème étage</p>
                                        <p class="mb-0"><i class="fas fa-info-circle me-2"></i> Consultation de routine</p>
                                    </div>
                                    <div class="col-md-3 mt-3 mt-md-0">
                                        <div class="d-grid gap-2">
                                            <button class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-video me-1"></i> Téléconsultation
                                            </button>
                                            <button class="btn btn-outline-danger btn-sm">
                                                <i class="fas fa-times me-1"></i> Annuler
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Rendez-vous à venir -->
                        <h5 class="mb-3">À venir</h5>
                        <div class="card appointment-card upcoming mb-3">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-2 col-sm-3 text-center mb-3 mb-md-0">
                                        <div class="h4 mb-0">10:15</div>
                                        <div class="text-muted">25 mai 2023</div>
                                    </div>
                                    <div class="col-md-7 col-sm-9">
                                        <div class="d-flex align-items-center mb-2">
                                            <img src="https://randomuser.me/api/portraits/men/41.jpg" alt="Dr. Dubois" class="doctor-avatar me-3">
                                            <div>
                                                <h5 class="mb-0">Dr. Dubois</h5>
                                                <span class="badge specialty-badge">Cardiologue</span>
                                            </div>
                                        </div>
                                        <p class="mb-1"><i class="fas fa-map-marker-alt me-2"></i> Cabinet 7, 3ème étage</p>
                                        <p class="mb-0"><i class="fas fa-info-circle me-2"></i> Suivi annuel</p>
                                    </div>
                                    <div class="col-md-3 mt-3 mt-md-0">
                                        <div class="d-grid gap-2">
                                            <button class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-video me-1"></i> Téléconsultation
                                            </button>
                                            <button class="btn btn-outline-danger btn-sm">
                                                <i class="fas fa-times me-1"></i> Annuler
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card appointment-card upcoming mb-4">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-2 col-sm-3 text-center mb-3 mb-md-0">
                                        <div class="h4 mb-0">15:45</div>
                                        <div class="text-muted">10 juin 2023</div>
                                    </div>
                                    <div class="col-md-7 col-sm-9">
                                        <div class="d-flex align-items-center mb-2">
                                            <img src="https://randomuser.me/api/portraits/women/65.jpg" alt="Dr. Moreau" class="doctor-avatar me-3">
                                            <div>
                                                <h5 class="mb-0">Dr. Moreau</h5>
                                                <span class="badge specialty-badge">Dermatologue</span>
                                            </div>
                                        </div>
                                        <p class="mb-1"><i class="fas fa-map-marker-alt me-2"></i> Cabinet 5, 2ème étage</p>
                                        <p class="mb-0"><i class="fas fa-info-circle me-2"></i> Consultation</p>
                                    </div>
                                    <div class="col-md-3 mt-3 mt-md-0">
                                        <div class="d-grid gap-2">
                                            <button class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-video me-1"></i> Téléconsultation
                                            </button>
                                            <button class="btn btn-outline-danger btn-sm">
                                                <i class="fas fa-times me-1"></i> Annuler
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Rendez-vous passés -->
                        <h5 class="mb-3">Passés</h5>
                        <div class="card appointment-card past mb-3">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-2 col-sm-3 text-center mb-3 mb-md-0">
                                        <div class="h4 mb-0">09:00</div>
                                        <div class="text-muted">5 mai 2023</div>
                                    </div>
                                    <div class="col-md-7 col-sm-9">
                                        <div class="d-flex align-items-center mb-2">
                                            <img src="https://randomuser.me/api/portraits/men/22.jpg" alt="Dr. Petit" class="doctor-avatar me-3">
                                            <div>
                                                <h5 class="mb-0">Dr. Petit</h5>
                                                <span class="badge specialty-badge">Ophtalmologue</span>
                                            </div>
                                        </div>
                                        <p class="mb-1"><i class="fas fa-map-marker-alt me-2"></i> Cabinet 12, 4ème étage</p>
                                        <p class="mb-0"><i class="fas fa-info-circle me-2"></i> Contrôle de la vue</p>
                                    </div>
                                    <div class="col-md-3 mt-3 mt-md-0">
                                        <div class="d-grid gap-2">
                                            <button class="btn btn-outline-success btn-sm">
                                                <i class="fas fa-file-medical me-1"></i> Voir compte-rendu
                                            </button>
                                            <button class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-calendar-plus me-1"></i> Reprendre RDV
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card appointment-card past mb-3">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-2 col-sm-3 text-center mb-3 mb-md-0">
                                        <div class="h4 mb-0">11:30</div>
                                        <div class="text-muted">20 avril 2023</div>
                                    </div>
                                    <div class="col-md-7 col-sm-9">
                                        <div class="d-flex align-items-center mb-2">
                                            <img src="https://randomuser.me/api/portraits/men/36.jpg" alt="Dr. Martin" class="doctor-avatar me-3">
                                            <div>
                                                <h5 class="mb-0">Dr. Martin</h5>
                                                <span class="badge specialty-badge">Médecin généraliste</span>
                                            </div>
                                        </div>
                                        <p class="mb-1"><i class="fas fa-map-marker-alt me-2"></i> Cabinet 3, 2ème étage</p>
                                        <p class="mb-0"><i class="fas fa-info-circle me-2"></i> Consultation pour grippe</p>
                                    </div>
                                    <div class="col-md-3 mt-3 mt-md-0">
                                        <div class="d-grid gap-2">
                                            <button class="btn btn-outline-success btn-sm">
                                                <i class="fas fa-file-medical me-1"></i> Voir compte-rendu
                                            </button>
                                            <button class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-calendar-plus me-1"></i> Reprendre RDV
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Vue Calendrier -->
            <div id="calendarView" style="display: none;">
                <div class="card">
                    <div class="card-body">
                        <div id="calendar" class="calendar-container"></div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Modal Nouveau Rendez-vous -->
<div class="modal fade" id="newAppointmentModal" tabindex="-1" aria-labelledby="newAppointmentModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="newAppointmentModalLabel">Prendre un rendez-vous</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="appointmentForm">
                    <div class="mb-3">
                        <label for="specialtySelect" class="form-label">Spécialité</label>
                        <select class="form-select" id="specialtySelect" required>
                            <option value="" selected disabled>Choisir une spécialité</option>
                            <option value="generaliste">Médecine générale</option>
                            <option value="cardiologue">Cardiologie</option>
                            <option value="dermatologue">Dermatologie</option>
                            <option value="ophtalmologue">Ophtalmologie</option>
                            <option value="pediatre">Pédiatrie</option>
                            <option value="gynecologie">Gynécologie</option>
                            <option value="orthopediste">Orthopédie</option>
                            <option value="orl">ORL</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="doctorSelect" class="form-label">Médecin</label>
                        <select class="form-select" id="doctorSelect" required>
                            <option value="" selected disabled>Choisir un médecin</option>
                            <option value="1">Dr. Martin</option>
                            <option value="2">Dr. Dubois</option>
                            <option value="3">Dr. Petit</option>
                            <option value="4">Dr. Moreau</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="reasonSelect" class="form-label">Motif de consultation</label>
                        <select class="form-select" id="reasonSelect" required>
                            <option value="" selected disabled>Choisir un motif</option>
                            <option value="consultation">Consultation de routine</option>
                            <option value="suivi">Suivi de traitement</option>
                            <option value="urgence">Consultation urgente</option>
                            <option value="resultat">Résultats d'examens</option>
                            <option value="autre">Autre</option>
                        </select>
                    </div>

                    <div class="mb-3" id="otherReasonDiv" style="display: none;">
                        <label for="otherReason" class="form-label">Précisez le motif</label>
                        <textarea class="form-control" id="otherReason" rows="2"></textarea>
                    </div>

                    <div class="mb-3">
                        <label for="appointmentDate" class="form-label">Date souhaitée</label>
                        <input type="date" class="form-control" id="appointmentDate" required min="2023-05-19">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Horaires disponibles</label>
                        <div class="btn-group-vertical w-100" role="group" id="timeSlots">
                            <div class="alert alert-info">
                                Veuillez d'abord sélectionner une date pour voir les horaires disponibles.
                            </div>
                        </div>
                    </div>

                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="telehealthCheck">
                        <label class="form-check-label" for="telehealthCheck">Je souhaite une téléconsultation</label>
                    </div>

                    <div class="mb-3">
                        <label for="appointmentNotes" class="form-label">Notes supplémentaires (optionnel)</label>
                        <textarea class="form-control" id="appointmentNotes" rows="3"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                <button type="button" class="btn btn-success" id="saveAppointment">Confirmer le rendez-vous</button>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle avec Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Script pour le calendrier et les interactions -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Initialisation du calendrier
        var calendarEl = document.getElementById('calendar');
        var calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'dayGridMonth,timeGridWeek,timeGridDay'
            },
            locale: 'fr',
            timeZone: 'local',
            events: [
                {
                    title: 'Dr. Martin - Consultation',
                    start: '2023-05-19T14:30:00',
                    end: '2023-05-19T15:00:00',
                    backgroundColor: '#f39c12',
                    borderColor: '#f39c12'
                },
                {
                    title: 'Dr. Dubois - Suivi annuel',
                    start: '2023-05-25T10:15:00',
                    end: '2023-05-25T10:45:00',
                    backgroundColor: '#3498db',
                    borderColor: '#3498db'
                },
                {
                    title: 'Dr. Moreau - Consultation',
                    start: '2023-06-10T15:45:00',
                    end: '2023-06-10T16:15:00',
                    backgroundColor: '#3498db',
                    borderColor: '#3498db'
                },
                {
                    title: 'Dr. Petit - Contrôle vue',
                    start: '2023-05-05T09:00:00',
                    end: '2023-05-05T09:30:00',
                    backgroundColor: '#95a5a6',
                    borderColor: '#95a5a6'
                },
                {
                    title: 'Dr. Martin - Consultation grippe',
                    start: '2023-04-20T11:30:00',
                    end: '2023-04-20T12:00:00',
                    backgroundColor: '#95a5a6',
                    borderColor: '#95a5a6'
                }
            ],
            eventClick: function(info) {
                alert('Rendez-vous: ' + info.event.title);
            }
        });
        calendar.render();

        // Gestion des vues liste/calendrier
        document.getElementById('listViewBtn').addEventListener('click', function() {
            document.getElementById('listView').style.display = 'block';
            document.getElementById('calendarView').style.display = 'none';
            this.classList.add('active');
            document.getElementById('calendarViewBtn').classList.remove('active');
        });

        document.getElementById('calendarViewBtn').addEventListener('click', function() {
            document.getElementById('listView').style.display = 'none';
            document.getElementById('calendarView').style.display = 'block';
            this.classList.add('active');
            document.getElementById('listViewBtn').classList.remove('active');
            calendar.updateSize(); // Nécessaire pour que le calendrier s'affiche correctement
        });

        // Gestion des filtres
        document.querySelectorAll('.filter-btn').forEach(function(btn) {
            btn.addEventListener('click', function() {
                document.querySelectorAll('.filter-btn').forEach(function(b) {
                    b.classList.remove('active');
                });
                this.classList.add('active');

                var filter = this.getAttribute('data-filter');
                // Logique de filtrage à implémenter
                console.log('Filtre sélectionné:', filter);
            });
        });

        // Gestion du formulaire de rendez-vous
        document.getElementById('reasonSelect').addEventListener('change', function() {
            if (this.value === 'autre') {
                document.getElementById('otherReasonDiv').style.display = 'block';
            } else {
                document.getElementById('otherReasonDiv').style.display = 'none';
            }
        });

        document.getElementById('appointmentDate').addEventListener('change', function() {
            // Simuler le chargement des horaires disponibles
            var timeSlotsContainer = document.getElementById('timeSlots');
            timeSlotsContainer.innerHTML = '';

            var timeSlots = ['09:00', '09:30', '10:00', '10:30', '11:00', '11:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30'];

            // Créer les boutons pour chaque horaire
            timeSlots.forEach(function(time) {
                var label = document.createElement('label');
                label.className = 'btn btn-outline-secondary mb-1';

                var input = document.createElement('input');
                input.type = 'radio';
                input.name = 'timeSlot';
                input.value = time;
                input.className = 'btn-check';

                label.appendChild(input);
                label.appendChild(document.createTextNode(time));

                timeSlotsContainer.appendChild(label);
            });
        });

        document.getElementById('saveAppointment').addEventListener('click', function() {
            // Simuler la sauvegarde du rendez-vous
            alert('Rendez-vous confirmé ! Vous recevrez un email de confirmation.');
            var modal = bootstrap.Modal.getInstance(document.getElementById('newAppointmentModal'));
            modal.hide();
        });
    });
</script>
</body>
</html>