<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!-- Barre de navigation supérieure -->
<nav class="navbar navbar-expand-lg navbar-dark bg-success fixed-top shadow-sm py-2" >
    <div class="container-fluid px-4" style="background-color: #a7abae">

        <!-- Logo & Titre -->
        <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/patient/dashboard">

            <span class="fw-semibold fs-10">Espace Patient</span>
        </a>

        <!-- Toggle (Mobile) -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Contenu Navbar -->
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center gap-3">


                <!-- Utilisateur -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle d-flex align-items-center gap-2" href="#" id="userDropdown"
                       role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-user-circle fa-lg"></i>
                        <span class="d-none d-md-inline">${user.email}</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm" aria-labelledby="userDropdown">
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                <i class="fas fa-user me-2"></i> Mon profil
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/patient/medical-record">
                                <i class="fas fa-file-medical me-2"></i> Mon dossier médical
                            </a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/auth/logout/">
                                <i class="fas fa-sign-out-alt me-2"></i> Déconnexion
                            </a>
                        </li>
                    </ul>
                </li>

            </ul>
        </div>
    </div>
</nav>
<style>
    /* Correction pour la navbar fixe */
    body {
        padding-top: 56px; /* Hauteur standard de la navbar Bootstrap */
    }

    /* Correction pour le contenu principal */
    main {
        margin-left: 250px; /* Largeur de la sidebar */
        padding: 20px;
        margin-top: 56px; /* Compensation pour la navbar */
    }

    /* Responsive adjustments */
    @media (max-width: 900px) {
        #sidebar {
            margin-top: 56px;
            width: 100%;
            position: relative;
            height: auto;
        }

        main {
            margin-left: 0;
        }
    }
</style>
