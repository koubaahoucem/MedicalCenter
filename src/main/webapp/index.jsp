<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome · Medical Center</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            background: linear-gradient(120deg, #f0f4f8, #d9e2ec);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: "Segoe UI", Roboto, sans-serif;
        }

        .welcome-card {
            background: #ffffff;
            padding: 3rem;
            border-radius: 1.5rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            max-width: 600px;
            text-align: center;
        }

        .welcome-card .logo {
            width: 80px;
            margin-bottom: 1rem;
        }

        .welcome-card h1 {
            font-size: 2rem;
            font-weight: 700;
            color: #333;
        }

        .welcome-card p {
            color: #666;
            margin-bottom: 1.5rem;
        }

        .btn-primary, .btn-secondary {
            padding: 0.75rem 1.5rem;
            font-size: 1rem;
            border-radius: 0.5rem;
        }

        .btn-primary i, .btn-secondary i {
            margin-right: 8px;
        }

        .btn-primary {
            background-color: #0d6efd;
            border: none;
        }

        .btn-secondary {
            background-color: #6c757d;
            border: none;
        }

        .btn-primary:hover {
            background-color: #0b5ed7;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>

<div class="welcome-card">
    <img src="https://cdn-icons-png.flaticon.com/512/4320/4320371.png" alt="Medical Center Logo" class="logo">
    <h1>Welcome to Medical Center System</h1>
    <p>Manage patients, schedule appointments, and access medical records in one integrated platform.</p>

    <div class="d-flex justify-content-center gap-3 mt-4">
        <a href="login.jsp" class="btn btn-primary"><i class="fas fa-sign-in-alt"></i> Login</a>
        <a href="register.jsp" class="btn btn-secondary"><i class="fas fa-user-plus"></i> Register</a>
    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
