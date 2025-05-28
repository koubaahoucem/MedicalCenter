<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login · Medical Center</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            background-color: #f1f5f9;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif;
        }
        .login-box {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            padding: 2.5rem 2rem;
            max-width: 400px;
            width: 100%;
        }
        .login-box .logo {
            width: 60px;
            height: 60px;
            margin-bottom: 1rem;
        }
        .login-box h2 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }
        .login-box .form-control {
            border-radius: 0.5rem;
        }
        .password-toggle {
            cursor: pointer;
        }
    </style>
</head>
<body>
<div class="login-box text-center">
    <img src="${pageContext.request.contextPath}/resources/images/medical-logo.svg" alt="Logo"
         class="logo mx-auto d-block"
         onerror="this.onerror=null; this.src='https://cdn-icons-png.flaticon.com/512/4320/4320371.png';">
    <h2 class="mb-2">Medical Center</h2>
    <p class="text-muted">Please sign in to continue</p>

    <!-- Alerts -->
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>
            <c:choose>
                <c:when test="${param.error eq 'invalid'}">Invalid username or password.</c:when>
                <c:when test="${param.error eq 'expired'}">Session expired. Please login again.</c:when>
                <c:otherwise>An error occurred during login.</c:otherwise>
            </c:choose>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty param.success}">
        <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
            <i class="fas fa-check-circle me-2"></i>
            <c:choose>
                <c:when test="${param.success eq 'logout'}">You have been logged out.</c:when>
                <c:when test="${param.success eq 'registered'}">Registration complete. Please login.</c:when>
                <c:when test="${param.success eq 'reset'}">Password reset successful.</c:when>
                <c:otherwise>Operation successful.</c:otherwise>
            </c:choose>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Login Form -->
    <form id="loginForm" action="${pageContext.request.contextPath}/auth/login" method="post" class="needs-validation mt-4 text-start" novalidate>
        <div class="mb-3">
            <label for="username" class="form-label">Username</label>
            <div class="input-group">
                <span class="input-group-text"><i class="fas fa-user"></i></span>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            <div class="invalid-feedback">Username is required.</div>
        </div>

        <div class="mb-3">
            <label for="password" class="form-label">Password</label>
            <div class="input-group">
                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                <input type="password" class="form-control" id="password" name="password" required>
                <span class="input-group-text password-toggle" id="togglePassword"><i class="fas fa-eye"></i></span>
            </div>
            <div class="invalid-feedback">Password is required.</div>
        </div>

        <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe">
            <label class="form-check-label" for="rememberMe">Remember me</label>
        </div>

        <div class="d-grid mb-3">
            <button type="submit" class="btn btn-primary"><i class="fas fa-sign-in-alt me-2"></i>Login</button>
        </div>

        <div class="text-center">
            <a href="${pageContext.request.contextPath}/forgot-password.jsp" class="text-decoration-none small">Forgot password?</a>
        </div>
    </form>

    <hr class="my-4">

    <div class="text-center small">
        <a href="${pageContext.request.contextPath}/register.jsp" class="text-decoration-none">Don't have an account? Sign up</a><br>
        <a href="${pageContext.request.contextPath}/" class="text-muted"><i class="fas fa-home me-1"></i>Back to Home</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        const form = document.getElementById('loginForm');
        const togglePassword = document.getElementById('togglePassword');
        const passwordField = document.getElementById('password');

        form.addEventListener('submit', event => {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        });

        togglePassword.addEventListener('click', () => {
            const type = passwordField.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordField.setAttribute('type', type);
            togglePassword.firstElementChild.classList.toggle('fa-eye');
            togglePassword.firstElementChild.classList.toggle('fa-eye-slash');
        });
    });
</script>
</body>
</html>
