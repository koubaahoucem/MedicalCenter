<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    /* ───────────────────────────
       THEME VARIABLES
       ─────────────────────────── */
    :root {
        /* Colours */
        --clr-bg:            #f8f9fa;
        --clr-bg-dark:       #2c3e50;
        --clr-primary:       #3498db;
        --clr-primary-dark:  #2980b9;
        --clr-success:       #2ecc71;
        --clr-info:          #17a2b8;
        --clr-muted:         #6c757d;
        --clr-border:        #e3e6f0;

        /* Radii & Shadows */
        --radius-sm:  .5rem;
        --radius-lg:  .75rem;
        --shadow-sm:  0 0.125rem 0.25rem rgba(0,0,0,.075);
        --shadow-md:  0 2px 10px rgba(0,0,0,.05);

        /* Misc */
        --trans-fast: all .2s ease;
        --trans-med:  all .3s ease;
    }

    /* ───────────────────────────
       PAGE LAYOUT
       ─────────────────────────── */
    html { scroll-behavior: smooth; }
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: var(--clr-bg);
        margin: 0;
    }

    /* ── Sidebar ─────────────────*/
    .sidebar {
        position: fixed; inset: 0 auto 0 0;
        z-index: 100; width: 250px; min-height: 100vh;
        background: var(--clr-bg-dark); color: #fff;
        box-shadow: 2px 0 5px rgba(0,0,0,.1);
    }
    .sidebar-sticky {
        position: sticky; top: 0;
        height: calc(100vh - 48px);
        padding-top: 1rem;
        overflow-y: auto;
    }
    .sidebar .nav-link {
        display: flex; align-items: center;
        gap: .625rem;
        padding: .75rem 1rem;
        font-weight: 500;
        color: rgba(255,255,255,.75);
        transition: var(--trans-med);
    }
    .sidebar .nav-link:hover,
    .sidebar .nav-link.active {
        color: #fff;
    }
    .sidebar .nav-link:hover   { background: rgba(255,255,255,.10); }
    .sidebar .nav-link.active  { background: rgba(255,255,255,.20); }

    .sidebar-heading {
        font-size: .75rem; text-transform: uppercase; letter-spacing: .1rem;
        color: rgba(255,255,255,.5);
        padding: .5rem 1rem; margin: 1rem 0 .5rem;
    }

    /* ── Navbar ───────────────── */
    .navbar {
        position: fixed; top: 0; left: 250px; right: 0;
        z-index: 1030;
        height: 70px;
        background: var(--clr-primary) !important;
        box-shadow: 0 2px 4px rgba(0,0,0,.1);
        padding: 0 1rem;
    }
    .navbar-brand         { color:#fff !important; font-weight:600; }
    .navbar-nav .nav-link { color:rgba(255,255,255,.9)!important; }
    .navbar-nav .nav-link:hover { color:#fff !important; }

    /* dropdown */
    .navbar .dropdown-menu{
        position:absolute; top:100%; right:0;
        min-width:300px;
        padding:.5rem 0;
        background:#fff; border:1px solid rgba(0,0,0,.15);
        border-radius:var(--radius-lg); box-shadow:var(--shadow-sm);
    }
    .navbar .dropdown-item{
        padding:.5rem 1rem; font-size:.9rem;
        color:#212529; transition:var(--trans-fast);
    }
    .navbar .dropdown-item:hover{ background:var(--clr-bg); color:var(--clr-primary); }
    .navbar .dropdown-header{ font-size:.875rem;color:var(--clr-muted);background:var(--clr-bg);border-bottom:1px solid #dee2e6;}
    .navbar .dropdown-divider{ border-top:1px solid #dee2e6; }

    /* ── Main content ─────────── */
    main{
        margin-left:250px;
        padding:90px 1rem 0;            /* top accounts for navbar */
        background:var(--clr-bg);
        min-height:100vh;
    }

    /* ───────────────────────────
       COMPONENTS
       ─────────────────────────── */
    /* Cards */
    .card{
        margin-bottom:1.25rem;
        border:1px solid var(--clr-border);
        border-radius:var(--radius-lg);
        box-shadow:var(--shadow-sm);
    }
    .card-header{ background:var(--clr-bg); border-bottom:1px solid var(--clr-border); }

    .card-stats{
        position:relative; overflow:hidden;
        padding:1.5rem;
        border:none; border-radius:var(--radius-lg);
        background:#fff; box-shadow:var(--shadow-md);
        transition:var(--trans-med);
    }
    .card-stats::before{
        content:''; position:absolute; inset:0 auto 0 0; width:4px;
        background:var(--accent-color,var(--clr-primary));
    }
    .card-stats.border-primary{ --accent-color:var(--clr-primary); }
    .card-stats.border-success{ --accent-color:var(--clr-success); }
    .card-stats:hover{ transform:translateY(-2px); box-shadow:0 8px 25px rgba(0,0,0,.1); }

    /* Patient card */
    .patient-card{
        margin-bottom:1.5rem;
        background:#fff; border:1px solid var(--clr-border);
        border-radius:var(--radius-lg); transition:var(--trans-med);
    }
    .patient-card:hover{ transform:translateY(-2px); box-shadow:0 8px 25px rgba(0,0,0,.1); border-color:var(--clr-primary); }
    .patient-card .card-body { padding:1.5rem; }
    .patient-card .card-footer{
        background:var(--clr-bg); border-top:1px solid var(--clr-border);
        padding:1rem 1.5rem;
    }

    /* Avatar */
    .avatar-circle{
        width:60px;height:60px;border-radius:50%;
        display:flex;align-items:center;justify-content:center;
        font-weight:bold;font-size:1.5rem;color:#fff;
        background:linear-gradient(135deg,var(--clr-primary),var(--clr-primary-dark));
        box-shadow:0 4px 12px rgba(52,152,219,.3);
    }

    /* Forms */
    input.form-control,
    select.form-select{
        width:100%;
        padding:.75rem 1rem;
        font-size:.9rem;
        border:1px solid var(--clr-border); border-radius:var(--radius-sm);
        transition:var(--trans-fast);
    }
    input.form-control:focus,
    select.form-select:focus{
        border-color:var(--clr-primary);
        box-shadow:0 0 0 .2rem rgba(52,152,219,.15);
    }
    .input-group-text{
        background:var(--clr-bg); border:1px solid var(--clr-border);
        color:var(--clr-muted);
    }

    /* Buttons */
    .btn{
        padding:.5rem 1rem; font-weight:500; border-radius:var(--radius-sm);
        transition:var(--trans-fast);
    }
    .btn-primary{
        background:linear-gradient(135deg,var(--clr-primary),var(--clr-primary-dark));
        border:none; box-shadow:0 2px 8px rgba(52,152,219,.3);
    }
    .btn-primary:hover{
        background:linear-gradient(135deg,var(--clr-primary-dark),#1f5f8b);
        box-shadow:0 4px 15px rgba(52,152,219,.4);
        transform:translateY(-1px);
    }
    /* outline variants */
    .btn-outline-primary{ border:2px solid var(--clr-primary); color:var(--clr-primary); }
    .btn-outline-success{ border:2px solid var(--clr-success); color:var(--clr-success); }
    .btn-outline-info   { border:2px solid var(--clr-info);    color:var(--clr-info); }

    /* hover for all outline buttons */
    .btn-outline-primary:hover,
    .btn-outline-success:hover,
    .btn-outline-info:hover{
        color:#fff; transform:translateY(-1px);
    }
    .btn-outline-primary:hover{ background:var(--clr-primary); }
    .btn-outline-success:hover{ background:var(--clr-success); }
    .btn-outline-info:hover   { background:var(--clr-info); }

    /* Alerts */
    .alert{
        border:none; border-radius:var(--radius-lg);
        padding:1rem 1.5rem; margin-bottom:1.5rem;
    }
    .alert-success{
        background:linear-gradient(135deg,#d4edda,#c3e6cb);
        color:#155724; border-left:4px solid #28a745;
    }

    /* Info list */
    .patient-info{ margin-top:1rem; }
    .info-item{
        display:flex; align-items:center;
        padding:.5rem 0; border-bottom:1px solid #f1f3f4;
        font-size:.9rem; color:var(--clr-muted);
    }
    .info-item:last-child{ border-bottom:none; }
    .info-item i{
        width:20px; text-align:center; margin-right:.75rem;
        color:var(--clr-primary);
    }
    .info-item span{ color:#495057; font-weight:500; }

    /* Search / Filters & Page header */
    .search-filters,
    .page-header{
        background:#fff; border:1px solid var(--clr-border);
        border-radius:var(--radius-lg);
        padding:1.5rem; margin-bottom:2rem; box-shadow:var(--shadow-md);
    }
    .page-header h1{ margin:0; color:var(--clr-bg-dark); font-weight:600; }

    /* Empty state */
    .empty-state{
        text-align:center; padding:3rem 1rem;
        background:#fff; border-radius:var(--radius-lg); box-shadow:var(--shadow-md);
    }
    .empty-state i{ font-size:4rem; color:var(--clr-border); margin-bottom:1rem; }

    /* Loading spinner */
    .loading{
        display:inline-block; width:20px; height:20px;
        border:3px solid rgba(255,255,255,.3);
        border-top-color:#fff; border-radius:50%;
        animation:spin 1s linear infinite;
    }
    @keyframes spin{ to{ transform:rotate(360deg); }}

    /* Custom scrollbar */
    ::-webkit-scrollbar{ width:8px; }
    ::-webkit-scrollbar-track{
        background:#f1f1f1; border-radius:4px;
    }
    ::-webkit-scrollbar-thumb{
        background:linear-gradient(135deg,var(--clr-primary),var(--clr-primary-dark));
        border-radius:4px;
    }
    ::-webkit-scrollbar-thumb:hover{
        background:linear-gradient(135deg,var(--clr-primary-dark),#1f5f8b);
    }

    /* ───────────────────────────
       UTILITIES & RESPONSIVE
       ─────────────────────────── */
    .btn-group .btn{
        border-radius:0; font-size:.875rem; font-weight:500;
    }
    .btn-group .btn:first-child { border-radius:var(--radius-sm) 0 0 var(--radius-sm); }
    .btn-group .btn:last-child  { border-radius:0 var(--radius-sm) var(--radius-sm) 0; }
    .btn-group .btn:not(:first-child){ border-left:1px solid rgba(255,255,255,.2); }

    @media (max-width: 768px){
        main{ margin-left:0; padding-top:20px; }
        .navbar{ left:0; }
        .navbar .dropdown-menu{ min-width:250px; right:1rem; }

        .avatar-circle{ width:50px; height:50px; font-size:1.2rem; }
        .patient-card .card-body{ padding:1rem; }

        .btn-group{ flex-direction:column; width:100%; }
        .btn-group .btn{
            border-radius:var(--radius-sm)!important;
            margin-bottom:.25rem;
            border-left:2px solid var(--clr-primary)!important;
        }
        .btn-group .btn:last-child{ margin-bottom:0; }
    }
</style>
