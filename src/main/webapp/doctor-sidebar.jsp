<aside class="bg-white border-end shadow-sm position-fixed h-100" style="top: 70px; width: 250px;">
    <div class="p-3">
        <ul class="nav flex-column">
            <li class="nav-item mb-2">
                <a class="nav-link d-flex align-items-center gap-2 ${activePage == 'dashboard' ? 'active text-primary fw-bold' : 'text-dark'}"
                   href="${pageContext.request.contextPath}/doctor/dashboard">
                    <i class="fas fa-tachometer-alt"></i> Tableau de bord
                </a>
            </li>
            <li class="nav-item mb-2">
                <a class="nav-link d-flex align-items-center gap-2 ${activePage == 'appointments' ? 'active text-primary fw-bold' : 'text-dark'}"
                   href="${pageContext.request.contextPath}/doctor/appointments">
                    <i class="fas fa-calendar-alt"></i> Rendez-vous
                </a>
            </li>
            <li class="nav-item mb-2">
                <a class="nav-link d-flex align-items-center gap-2 ${activePage == 'patients' ? 'active text-primary fw-bold' : 'text-dark'}"
                   href="${pageContext.request.contextPath}/doctor/patients">
                    <i class="fas fa-users"></i> Mes patients
                </a>
            </li>
            <li class="nav-item mb-2">
                <a class="nav-link d-flex align-items-center gap-2 ${activePage == 'prescription-renewal' ? 'active text-primary fw-bold' : 'text-dark'}"
                   href="${pageContext.request.contextPath}/doctor/prescription-renewals">
                    <i class="fas fa-sync-alt"></i> Renouvellements
                </a>
            </li>
            <li class="nav-item mb-2">
                <a class="nav-link d-flex align-items-center gap-2 ${activePage == 'profile' ? 'active text-primary fw-bold' : 'text-dark'}"
                   href="${pageContext.request.contextPath}/doctor/profile">
                    <i class="fas fa-user-md"></i> Mon profil
                </a>
            </li>
        </ul>

        <hr>

        <div class="px-1 text-muted text-uppercase small fw-semibold mb-2">Acces rapide</div>
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center gap-2 ${activePage == 'appointments-new' ? 'active text-primary fw-bold' : 'text-dark'}"
                   href="${pageContext.request.contextPath}/doctor/appointments/new">
                    <i class="fas fa-calendar-plus"></i> Nouveau rendez-vous
                </a>
            </li>
        </ul>
    </div>
</aside>

<style>
    @media (max-width: 991.98px) {
        aside {
            display: none;
        }
    }

    main {
        margin-left: 250px;
    }

    @media (max-width: 991.98px) {
        main {
            margin-left: 0;
        }
    }
</style>
