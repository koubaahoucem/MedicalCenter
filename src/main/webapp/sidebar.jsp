<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!-- Sidebar -->
<nav id="sidebar" class="col-md-3 col-lg-2 d-md-block sidebar collapse  text-white" >
    <div class="sidebar-sticky pt-5" style="background-color: #a7abae">
        <ul class="nav flex-column" >
            <li class="nav-item">
                <a class="nav-link ${activePage == 'dashboard' ? 'active text-white fw-bold' : 'text-white-50'}"
                   href="${pageContext.request.contextPath}/patient/dashboard">
                    <i class="fas fa-tachometer-alt me-2"></i> Tableau de bord
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link ${activePage == 'appointments' ? 'active text-white fw-bold' : 'text-white-50'}"
                   href="${pageContext.request.contextPath}/patient/appointments">
                    <i class="fas fa-calendar-alt me-2"></i> Mes rendez-vous
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link ${activePage == 'medical-record' ? 'active text-white fw-bold' : 'text-white-50'}"
                   href="${pageContext.request.contextPath}/patient/medical-record">
                    <i class="fas fa-file-medical me-2"></i> Mon dossier médical
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link ${activePage == 'prescriptions' ? 'active text-white fw-bold' : 'text-white-50'}"
                   href="${pageContext.request.contextPath}/patient/prescriptions">
                    <i class="fas fa-prescription me-2"></i> Mes ordonnances
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link ${activePage == 'profile' ? 'active text-white fw-bold' : 'text-white-50'}"
                   href="${pageContext.request.contextPath}/profile">
                    <i class="fas fa-user me-2"></i> Mon profil
                </a>
            </li>
        </ul>

        <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-uppercase text-white-50">
            <span>Accès rapide</span>
        </h6>

        <ul class="nav flex-column mb-2">
            <li class="nav-item">
                <a class="nav-link text-white-50" href="${pageContext.request.contextPath}/patient/appointment-create">
                    <i class="fas fa-calendar-plus me-2"></i> Prendre rendez-vous
                </a>
            </li>
        </ul>
    </div>
</nav>
<style>
    /* Ajustement pour la sidebar */
    #sidebar {
        margin-top: 56px; /* Même valeur que le padding-top du body */
        height: calc(100vh - 56px); /* Hauteur totale moins la navbar */
        position: fixed;
        overflow-y: auto; /* Permet le défilement si le contenu est trop long */
        width: 300px;
    }
</style>