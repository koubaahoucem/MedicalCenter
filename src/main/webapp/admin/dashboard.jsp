<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord Administrateur - Centre Médical</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome pour les icônes -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Chart.js pour les graphiques -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        .sidebar {
            min-height: 100vh;
            background-color: #343a40;
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
            background-color: #1d1d1f;

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
        }

        .card {
            margin-bottom: 20px;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }

        .card-stats {
            border-left: 4px solid;
        }

        .card-stats-doctors {
            border-left-color: #4e73df;
        }

        .card-stats-patients {
            border-left-color: #fea68a;
        }

        .card-stats-appointments {
            border-left-color: #36b9cc;
        }

        .card-stats-revenue {
            border-left-color: #f6c23e;
        }

        .card-stats .icon {
            font-size: 2rem;
            opacity: 0.3;
        }

        .table-responsive {
            max-height: 400px;
            overflow-y: auto;
        }

        @media (max-width: 767.98px) {
            .sidebar {
                position: static;
                background-color: #1d1d1f;
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
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">
            <img src="${pageContext.request.contextPath}/resources/images/medical-logo.svg"
                 alt="Centre Médical" width="30" height="30" class="d-inline-block align-text-top me-2"
                 onerror="this.onerror=null; this.src='https://cdn-icons-png.flaticon.com/512/4320/4320371.png';">
            Centre Médical - Administration
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-bell"></i>
                        <span class="badge bg-danger">3</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><h6 class="dropdown-header">Notifications</h6></li>
                        <li><a class="dropdown-item" href="#">Nouveau médecin inscrit</a></li>
                        <li><a class="dropdown-item" href="#">Nouveau patient inscrit</a></li>
                        <li><a class="dropdown-item" href="#">Rapport mensuel disponible</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="#">Voir toutes les notifications</a></li>
                    </ul>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user-circle me-1"></i> ${sessionScope.username}
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="#"><i class="fas fa-user me-2"></i>Profil</a></li>
                        <li><a class="dropdown-item" href="#"><i class="fas fa-cog me-2"></i>Paramètres</a></li>
                        <li><a class="dropdown-item" href="#"><i class="fas fa-list-alt me-2"></i>Journal d'activité</a></li>
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                            <i class="fas fa-tachometer-alt"></i> Tableau de bord
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/doctors.jsp">
                            <i class="fas fa-user-md"></i> Médecins
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/patients.jsp">
                            <i class="fas fa-users"></i> Patients
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/specialties.jsp">
                            <i class="fas fa-stethoscope"></i> Spécialités
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/appointments.jsp">
                            <i class="fas fa-calendar-check"></i> Rendez-vous
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports.jsp">
                            <i class="fas fa-chart-bar"></i> Rapports
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/settings.jsp">
                            <i class="fas fa-cog"></i> Paramètres
                        </a>
                    </li>
                </ul>

                <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
                    <span>Rapports enregistrés</span>
                </h6>
                <ul class="nav flex-column mb-2">
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fas fa-file-alt"></i> Rapport mensuel
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fas fa-file-alt"></i> Rapport trimestriel
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Contenu principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Tableau de bord administrateur</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <div class="btn-group me-2">
                        <button type="button" class="btn btn-sm btn-outline-secondary">Partager</button>
                        <button type="button" class="btn btn-sm btn-outline-secondary">Exporter</button>
                    </div>
                    <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle">
                        <i class="fas fa-calendar"></i> Cette semaine
                    </button>
                </div>
            </div>

            <!-- Cartes statistiques -->
            <div class="row">
                <div class="col-xl-3 col-md-6">
                    <div class="card card-stats card-stats-doctors">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-9">
                                    <h5 class="card-title text-muted mb-0">Médecins</h5>
                                    <p class="h2 fw-bold mb-0">24</p>
                                </div>
                                <div class="col-3 text-end">
                                    <div class="icon text-primary">
                                        <i class="fas fa-user-md"></i>
                                    </div>
                                </div>
                            </div>
                            <p class="mt-3 mb-0 text-success">
                                <span class="me-2"><i class="fas fa-arrow-up"></i> 3.48%</span>
                                <span class="text-muted">Depuis le mois dernier</span>
                            </p>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6">
                    <div class="card card-stats card-stats-patients">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-9">
                                    <h5 class="card-title text-muted mb-0">Patients</h5>
                                    <p class="h2 fw-bold mb-0">156</p>
                                </div>
                                <div class="col-3 text-end">
                                    <div class="icon text-success">
                                        <i class="fas fa-users"></i>
                                    </div>
                                </div>
                            </div>
                            <p class="mt-3 mb-0 text-success">
                                <span class="me-2"><i class="fas fa-arrow-up"></i> 12.8%</span>
                                <span class="text-muted">Depuis le mois dernier</span>
                            </p>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6">
                    <div class="card card-stats card-stats-appointments">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-9">
                                    <h5 class="card-title text-muted mb-0">Rendez-vous</h5>
                                    <p class="h2 fw-bold mb-0">87</p>
                                </div>
                                <div class="col-3 text-end">
                                    <div class="icon text-info">
                                        <i class="fas fa-calendar-check"></i>
                                    </div>
                                </div>
                            </div>
                            <p class="mt-3 mb-0 text-success">
                                <span class="me-2"><i class="fas fa-arrow-up"></i> 5.38%</span>
                                <span class="text-muted">Depuis la semaine dernière</span>
                            </p>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6">
                    <div class="card card-stats card-stats-revenue">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-9">
                                    <h5 class="card-title text-muted mb-0">Revenus</h5>
                                    <p class="h2 fw-bold mb-0">€24,600</p>
                                </div>
                                <div class="col-3 text-end">
                                    <div class="icon text-warning">
                                        <i class="fas fa-euro-sign"></i>
                                    </div>
                                </div>
                            </div>
                            <p class="mt-3 mb-0 text-danger">
                                <span class="me-2"><i class="fas fa-arrow-down"></i> 1.10%</span>
                                <span class="text-muted">Depuis le mois dernier</span>
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Graphiques -->
            <div class="row mt-4">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title">Rendez-vous mensuels</h5>
                        </div>
                        <div class="card-body">
                            <canvas id="appointmentsChart" height="300"></canvas>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title">Répartition par spécialité</h5>
                        </div>
                        <div class="card-body">
                            <canvas id="specialtiesChart" height="300"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dernières activités et médecins récemment inscrits -->
            <div class="row mt-4">
                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="card-title">Dernières activités</h5>
                            <a href="#" class="btn btn-sm btn-primary">Voir tout</a>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                    <tr>
                                        <th>Utilisateur</th>
                                        <th>Action</th>
                                        <th>Date</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td>Dr. Martin</td>
                                        <td>A ajouté un nouveau patient</td>
                                        <td>Il y a 5 min</td>
                                    </tr>
                                    <tr>
                                        <td>Admin</td>
                                        <td>A modifié une spécialité</td>
                                        <td>Il y a 2 heures</td>
                                    </tr>
                                    <tr>
                                        <td>Dr. Dubois</td>
                                        <td>A annulé un rendez-vous</td>
                                        <td>Il y a 3 heures</td>
                                    </tr>
                                    <tr>
                                        <td>Patient Dupont</td>
                                        <td>S'est inscrit</td>
                                        <td>Il y a 5 heures</td>
                                    </tr>
                                    <tr>
                                        <td>Dr. Bernard</td>
                                        <td>A mis à jour son profil</td>
                                        <td>Il y a 1 jour</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="card-title">Médecins récemment inscrits</h5>
                            <a href="#" class="btn btn-sm btn-primary">Voir tout</a>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                    <tr>
                                        <th>Nom</th>
                                        <th>Spécialité</th>
                                        <th>Statut</th>
                                        <th>Actions</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td>Dr. Sophie Martin</td>
                                        <td>Cardiologie</td>
                                        <td><span class="badge bg-warning">En attente</span></td>
                                        <td>
                                            <div class="btn-group btn-group-sm">
                                                <button class="btn btn-success">Approuver</button>
                                                <button class="btn btn-danger">Refuser</button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Dr. Thomas Petit</td>
                                        <td>Dermatologie</td>
                                        <td><span class="badge bg-warning">En attente</span></td>
                                        <td>
                                            <div class="btn-group btn-group-sm">
                                                <button class="btn btn-success">Approuver</button>
                                                <button class="btn btn-danger">Refuser</button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Dr. Julie Moreau</td>
                                        <td>Pédiatrie</td>
                                        <td><span class="badge bg-success">Approuvé</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-info">Détails</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Dr. Nicolas Blanc</td>
                                        <td>Ophtalmologie</td>
                                        <td><span class="badge bg-success">Approuvé</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-info">Détails</button>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Bootstrap JS Bundle avec Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Scripts pour les graphiques -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Graphique des rendez-vous mensuels
        var appointmentsCtx = document.getElementById('appointmentsChart').getContext('2d');
        var appointmentsChart = new Chart(appointmentsCtx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'],
                datasets: [{
                    label: 'Rendez-vous',
                    data: [65, 59, 80, 81, 56, 55, 40, 45, 60, 70, 75, 87],
                    backgroundColor: 'rgba(54, 185, 204, 0.2)',
                    borderColor: 'rgba(54, 185, 204, 1)',
                    borderWidth: 2,
                    tension: 0.3
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        // Graphique des spécialités
        var specialtiesCtx = document.getElementById('specialtiesChart').getContext('2d');
        var specialtiesChart = new Chart(specialtiesCtx, {
            type: 'doughnut',
            data: {
                labels: ['Cardiologie', 'Dermatologie', 'Pédiatrie', 'Ophtalmologie', 'Autres'],
                datasets: [{
                    data: [12, 19, 8, 5, 14],
                    backgroundColor: [
                        'rgba(78, 115, 223, 0.8)',
                        'rgba(28, 200, 138, 0.8)',
                        'rgba(54, 185, 204, 0.8)',
                        'rgba(246, 194, 62, 0.8)',
                        'rgba(231, 74, 59, 0.8)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });
    });
</script>
</body>
</html>