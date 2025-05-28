<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    /* Base Layout */
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        margin: 0;
        background-color: #f5f7fa;
        color: #342a7e;
    }

    /* Sidebar */
    .sidebar {
        position: fixed;
        top: 0;
        left: 0;
        bottom: 0;
        width: 240px;
        background-color: #a7abae;
        color: #fff;
        display: flex;
        flex-direction: column;
        box-shadow: inset -1px 0 0 rgba(0, 0, 0, 0.15);
        z-index: 1000;
    }

    .sidebar-sticky {
        position: sticky;
        top: 0;
        height: 100vh;
        overflow-y: auto;
        padding-top: 1.5rem;
    }

    .sidebar .nav-link {
        display: flex;
        align-items: center;
        font-weight: 500;
        color: rgba(255, 255, 255, 0.8);
        padding: 0.75rem 1.5rem;
        border-left: 4px solid transparent;
        transition: all 0.3s ease;
    }

    .sidebar .nav-link i {
        margin-right: 12px;
    }

    .sidebar .nav-link:hover {
        background-color: rgba(255, 255, 255, 0.1);
        color: #ffffff;
    }

    .sidebar .nav-link.active {
        background-color: rgba(255, 255, 255, 0.2);
        border-left-color: #ffffff;
        color: #ffffff;
    }

    .sidebar-heading {
        font-size: 0.85rem;
        text-transform: uppercase;
        padding: 0.75rem 1.5rem;
        color: rgba(255, 255, 255, 0.6);
        font-weight: bold;
        margin-top: 1.5rem;
    }

    /* Top Navbar */
    .navbar {
        background-color: #a7abae !important; /* Brighter green */
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
    }

    /* Main Content Area */
    main {
        margin-left: 240px;
        padding: 80px 30px 30px;
        min-height: 100vh;
        background-color: #f9fafb;
    }

    /* Card Component */
    .card {
        margin-bottom: 24px;
        border: none;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
        background-color: #a7abae;
    }

    /* Responsive Adjustments */
    @media (max-width: 767.98px) {
        .sidebar {
            position: relative;
            background-color: #1d1d1f;
            width: 100%;
            height: auto;
            box-shadow: none;
        }

        main {
            margin-left: 0;
            padding-top: 60px;
        }
    }
</style>
