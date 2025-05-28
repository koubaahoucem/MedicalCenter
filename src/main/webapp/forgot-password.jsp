<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - Medical Center</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            background-color: #f8f9fa;
        }
        .form-container {
            max-width: 450px;
            margin: 0 auto;
            padding: 30px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            margin-top: 80px;
        }
        .form-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .form-header img {
            max-width: 80px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-md-12">
            <div class="form-container">
                <div class="form-header">
                    <img src="${pageContext.request.contextPath}/resources/images/medical-logo.svg"
                         alt="Medical Center Logo"
                         onerror="this.onerror=null; this.src='https://cdn-icons-png.flaticon.com/512/4320/4320371.png';">
                    <h2>Forgot Password</h2>
                    <p class="text-muted">Enter your email to reset your password</p>
                </div>

                <form action="${pageContext.request.contextPath}/auth/forgot-password" method="post">
                    <div class="mb-3">
                        <label for="email" class="form-label">Email address</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                        <div class="form-text">We'll send a password reset link to this email.</div>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary">Reset Password</button>
                        <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-secondary">
                            Back to Login
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>