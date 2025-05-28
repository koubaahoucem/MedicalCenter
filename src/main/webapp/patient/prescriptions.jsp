<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Ordonnances - Centre Médical</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome pour les icônes -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        .sidebar {
            min-height: 100vh;
            background-color: #1d1d1f;
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
            background-color: #fea68a !important;
        }

        .card {
            margin-bottom: 20px;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }

        .prescription-card {
            transition: transform 0.2s;
            border-left: 4px solid;
        }

        .prescription-card:hover {
            transform: translateY(-3px);
        }

        .prescription-card.active {
            border-left-color: #fea68a;
        }

        .prescription-card.expired {
            border-left-color: #e74c3c;
        }

        .prescription-card.renew {
            border-left-color: #f39c12;
        }

        .doctor-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }

        .medication-badge {
            background-color: #e2f0d9;
            color: #fea68a;
            font-weight: 500;
        }

        .prescription-preview {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            padding: 20px;
            font-family: 'Times New Roman', Times, serif;
        }

        .prescription-header {
            text-align: center;
            margin-bottom: 20px;
            border-bottom: 1px solid #dee2e6;
            padding-bottom: 10px;
        }

        .prescription-doctor {
            text-align: left;
            margin-bottom: 20px;
        }

        .prescription-patient {
            text-align: right;
            margin-bottom: 20px;
        }

        .prescription-content {
            margin-bottom: 20px;
            min-height: 200px;
        }

        .prescription-footer {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
            border-top: 1px solid #dee2e6;
            padding-top: 10px;
        }

        .prescription-signature {
            text-align: right;
            font-style: italic;
        }

        .filter-btn.active {
            background-color: #fea68a;
            color: white;
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/patient/appointments-list.jsp">
                            <i class="fas fa-calendar-alt"></i> Mes rendez-vous
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/patient/medical-record.jsp">
                            <i class="fas fa-file-medical"></i> Mon dossier médical
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/patient/prescriptions-list.jsp">
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/patient/appointments-list.jsp">
                            <i class="fas fa-calendar-plus"></i> Prendre rendez-vous
                        </a>
                    </li>

                </ul>
            </div>
        </nav>

        <!-- Contenu principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Mes ordonnances</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <div class="btn-group me-2">
                        <button type="button" class="btn btn-sm btn-outline-secondary">
                            <i class="fas fa-download me-1"></i> Télécharger tout
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-secondary">
                            <i class="fas fa-print me-1"></i> Imprimer
                        </button>
                    </div>
                    <button type="button" class="btn btn-sm btn-outline-primary">
                        <i class="fas fa-share-alt me-1"></i> Partager
                    </button>
                </div>
            </div>

            <!-- Filtres -->
            <div class="row mb-4">
                <div class="col-md-8">
                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-outline-secondary filter-btn active" data-filter="all">Toutes</button>
                        <button type="button" class="btn btn-outline-secondary filter-btn" data-filter="active">En cours</button>
                        <button type="button" class="btn btn-outline-secondary filter-btn" data-filter="renew">À renouveler</button>
                        <button type="button" class="btn btn-outline-secondary filter-btn" data-filter="expired">Expirées</button>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="input-group">
                        <input type="text" class="form-control" placeholder="Rechercher...">
                        <button class="btn btn-outline-secondary" type="button">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Liste des ordonnances et aperçu -->
            <div class="row">
                <!-- Liste des ordonnances -->
                <div class="col-md-5">
                    <div class="card prescription-card renew mb-3" data-prescription-id="1">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <h5 class="card-title mb-0">Traitement hypertension</h5>
                                <span class="badge bg-danger">À renouveler</span>
                            </div>
                            <div class="d-flex align-items-center mb-2">
                                <img src="https://randomuser.me/api/portraits/men/41.jpg" alt="Dr. Dubois" class="doctor-avatar me-3">
                                <div>
                                    <p class="mb-0">Dr. Dubois</p>
                                    <small class="text-muted">Cardiologue</small>
                                </div>
                            </div>
                            <p class="card-text">
                                <i class="fas fa-calendar-day me-2"></i> 25/02/2023
                                <span class="ms-3"><i class="fas fa-hourglass-end me-2"></i> Expire le 25/05/2023</span>
                            </p>
                            <div class="mt-2">
                                <span class="medication-badge p-2 me-1">Amlodipine 5mg</span>
                            </div>
                        </div>
                    </div>

                    <div class="card prescription-card active mb-3" data-prescription-id="2">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <h5 class="card-title mb-0">Antibiotiques</h5>
                                <span class="badge bg-success">En cours</span>
                            </div>
                            <div class="d-flex align-items-center mb-2">
                                <img src="https://randomuser.me/api/portraits/men/36.jpg" alt="Dr. Martin" class="doctor-avatar me-3">
                                <div>
                                    <p class="mb-0">Dr. Martin</p>
                                    <small class="text-muted">Médecin généraliste</small>
                                </div>
                            </div>
                            <p class="card-text">
                                <i class="fas fa-calendar-day me-2"></i> 10/05/2023
                                <span class="ms-3"><i class="fas fa-hourglass-half me-2"></i> Expire le 10/06/2023</span>
                            </p>
                            <div class="mt-2">
                                <span class="medication-badge p-2 me-1">Amoxicilline 500mg</span>
                            </div>
                        </div>
                    </div>

                    <div class="card prescription-card active mb-3" data-prescription-id="3">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <h5 class="card-title mb-0">Collyre</h5>
                                <span class="badge bg-success">En cours</span>
                            </div>
                            <div class="d-flex align-items-center mb-2">
                                <img src="https://randomuser.me/api/portraits/men/22.jpg" alt="Dr. Petit" class="doctor-avatar me-3">
                                <div>
                                    <p class="mb-0">Dr. Petit</p>
                                    <small class="text-muted">Ophtalmologue</small>
                                </div>
                            </div>
                            <p class="card-text">
                                <i class="fas fa-calendar-day me-2"></i> 05/05/2023
                                <span class="ms-3"><i class="fas fa-hourglass-half me-2"></i> Expire le 05/08/2023</span>
                            </p>
                            <div class="mt-2">
                                <span class="medication-badge p-2 me-1">Collyre Vismed</span>
                            </div>
                        </div>
                    </div>

                    <div class="card prescription-card expired mb-3" data-prescription-id="4">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <h5 class="card-title mb-0">Anti-inflammatoires</h5>
                                <span class="badge bg-secondary">Expirée</span>
                            </div>
                            <div class="d-flex align-items-center mb-2">
                                <img src="https://randomuser.me/api/portraits/men/36.jpg" alt="Dr. Martin" class="doctor-avatar me-3">
                                <div>
                                    <p class="mb-0">Dr. Martin</p>
                                    <small class="text-muted">Médecin généraliste</small>
                                </div>
                            </div>
                            <p class="card-text">
                                <i class="fas fa-calendar-day me-2"></i> 15/01/2023
                                <span class="ms-3"><i class="fas fa-hourglass-end me-2"></i> Expirée le 15/02/2023</span>
                            </p>
                            <div class="mt-2">
                                <span class="medication-badge p-2 me-1">Ibuprofène 400mg</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Aperçu de l'ordonnance -->
                <div class="col-md-7">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Aperçu de l'ordonnance</h5>
                            <div>
                                <button class="btn btn-sm btn-outline-primary me-2">
                                    <i class="fas fa-download me-1"></i> Télécharger
                                </button>
                                <button class="btn btn-sm btn-outline-success">
                                    <i class="fas fa-sync-alt me-1"></i> Demander renouvellement
                                </button>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="prescription-preview">
                                <div class="prescription-header">
                                    <h4>CENTRE MÉDICAL</h4>
                                    <p>123 Avenue de la Santé, 75000 Paris</p>
                                    <p>Tél: 01 23 45 67 89 - Email: contact@centremedical.fr</p>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="prescription-doctor">
                                            <p><strong>Dr. Dubois Jean</strong><br>
                                                Cardiologue<br>
                                                N° RPPS: 10987654321</p>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="prescription-patient">
                                            <p>Patient: ${sessionScope.username}<br>
                                                Né(e) le: 15/07/1985<br>
                                                N° Sécurité Sociale: 1 85 07 15 123 456 78</p>
                                        </div>
                                    </div>
                                </div>

                                <div class="prescription-content">
                                    <p><strong>Date:</strong> 25/02/2023</p>
                                    <hr>
                                    <p><strong>Amlodipine 5mg</strong><br>
                                        1 comprimé par jour, le matin<br>
                                        Durée du traitement: 3 mois</p>
                                    <hr>
                                    <p>Contrôle de la tension artérielle régulièrement.<br>
                                        Rendez-vous de suivi dans 3 mois.</p>
                                </div>

                                <div class="prescription-footer">
                                    <div>
                                        <p>Ordonnance valable jusqu'au: <strong>25/05/2023</strong></p>
                                    </div>
                                    <div class="prescription-signature">
                                        <p>Dr. Dubois Jean<br>
                                            Signature</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Modal Demande de Renouvellement -->
<div class="modal fade" id="renewModal" tabindex="-1" aria-labelledby="renewModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="renewModalLabel">Demande de renouvellement d'ordonnance</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="renewForm">
                    <div class="mb-3">
                        <label for="doctorSelect" class="form-label">Médecin</label>
                        <select class="form-select" id="doctorSelect" required>
                            <option value="1" selected>Dr. Dubois (Cardiologue)</option>
                            <option value="2">Dr. Martin (Médecin généraliste)</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="renewMessage" class="form-label">Message (optionnel)</label>
                        <textarea class="form-control" id="renewMessage" rows="3" placeholder="Informations complémentaires pour le médecin..."></textarea>
                    </div>

                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="urgentCheck">
                        <label class="form-check-label" for="urgentCheck">Demande urgente</label>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                <button type="button" class="btn btn-success" id="sendRenewRequest">Envoyer la demande</button>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle avec Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Script pour les interactions -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
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

        // Sélection d'une ordonnance
        document.querySelectorAll('.prescription-card').forEach(function(card) {
            card.addEventListener('click', function() {
                document.querySelectorAll('.prescription-card').forEach(function(c) {
                    c.classList.remove('selected');
                });
                this.classList.add('selected');

                var prescriptionId = this.getAttribute('data-prescription-id');
                // Logique pour charger l'aperçu de l'ordonnance
                console.log('Ordonnance sélectionnée:', prescriptionId);
            });
        });

        // Demande de renouvellement
        document.querySelector('.btn-outline-success').addEventListener('click', function() {
            var modal = new bootstrap.Modal(document.getElementById('renewModal'));
            modal.show();
        });

        // Envoi de la demande de renouvellement
        document.getElementById('sendRenewRequest').addEventListener('click', function() {
            // Simuler l'envoi de la demande
            alert('Votre demande de renouvellement a été envoyée avec succès. Vous recevrez une notification lorsque votre médecin aura traité votre demande.');
            var modal = bootstrap.Modal.getInstance(document.getElementById('renewModal'));
            modal.hide();
        });
    });
</script>
</body>
</html>