<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register · Medical Center</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            background-color: #f4f6f9;
            font-family: 'Segoe UI', sans-serif;
        }
        .register-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }
        .register-card {
            background: white;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: 0 0.75rem 1.5rem rgba(0, 0, 0, 0.1);
            max-width: 960px;
            width: 100%;
        }
        .register-image {
            background: url('https://cdn-icons-png.flaticon.com/512/4320/4320371.png') center/contain no-repeat;
            background-color: #0d6efd;
        }
        .form-section {
            padding: 2rem;
        }
        .hidden { display: none; }
    </style>
</head>
<body>
<div class="register-container">
    <div class="row register-card g-0">
        <!-- Illustration / Branding -->
        <div class="col-md-5 register-image d-none d-md-block"></div>

        <!-- Form Section -->
        <div class="col-md-7 form-section">
            <h3 class="mb-3">Create Your Account</h3>
            <form id="registrationForm" action="${pageContext.request.contextPath}/auth/register" method="post" class="row g-3 needs-validation" novalidate>

                <!-- Name -->
                <div class="col-md-6">
                    <label for="firstName" class="form-label">First Name</label>
                    <input type="text" class="form-control" id="firstName" name="firstName" required>
                    <div class="invalid-feedback">Please enter your first name.</div>
                </div>
                <div class="col-md-6">
                    <label for="lastName" class="form-label">Last Name</label>
                    <input type="text" class="form-control" id="lastName" name="lastName" required>
                    <div class="invalid-feedback">Please enter your last name.</div>
                </div>

                <!-- Username -->
                <div class="col-12">
                    <label for="username" class="form-label">Username</label>
                    <div class="input-group has-validation">
                        <span class="input-group-text"><i class="fas fa-user"></i></span>
                        <input type="text" class="form-control" id="username" name="username" required>
                        <div class="invalid-feedback">Please choose a username.</div>
                    </div>
                </div>

                <!-- Email -->
                <div class="col-12">
                    <label for="email" class="form-label">Email address</label>
                    <input type="email" class="form-control" id="email" name="email" required>
                    <div class="invalid-feedback">Please enter a valid email address.</div>
                </div>

                <!-- Password -->
                <div class="col-md-6">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password" minlength="8" required>
                    <div class="invalid-feedback">Minimum 8 characters.</div>
                </div>
                <div class="col-md-6">
                    <label for="confirmPassword" class="form-label">Confirm Password</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                    <div class="invalid-feedback">Passwords do not match.</div>
                </div>

                <!-- Role -->
                <div class="col-md-6">
                    <label for="role" class="form-label">Register as</label>
                    <select class="form-select" id="role" name="role" required>
                        <option value="" disabled selected>Select role</option>
                        <option value="patient">Patient</option>
                        <option value="doctor">Doctor</option>
                    </select>
                    <div class="invalid-feedback">Please select a role.</div>
                </div>

                <!-- Specialty -->
                <div id="specialtyField" class="col-md-6 hidden">
                    <label for="specialty" class="form-label">Specialty</label>
                    <select class="form-select" id="specialty" name="specialty">
                        <option value="" selected disabled>Select specialty</option>
                        <option value="cardiology">Cardiology</option>
                        <option value="neurology">Neurology</option>
                        <option value="pediatrics">Pediatrics</option>
                        <option value="orthopedics">Orthopedics</option>
                        <option value="dermatology">Dermatology</option>
                        <option value="general-practice">General Practice</option>
                    </select>
                    <div class="invalid-feedback">Please select a specialty.</div>
                </div>

                <!-- Terms -->
                <div class="col-12">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="terms" name="terms" required>
                        <label class="form-check-label" for="terms">I agree to the <a href="#">Terms</a> &amp; <a href="#">Privacy Policy</a></label>
                        <div class="invalid-feedback">You must agree before submitting.</div>
                    </div>
                </div>

                <!-- Buttons -->
                <div class="col-12 d-grid gap-2 mt-2">
                    <button class="btn btn-primary" type="submit">Register</button>
                    <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-secondary">Already have an account? Login</a>
                </div>

                <!-- Errors -->
                <c:if test="${not empty sessionScope.registrationErrors}">
                    <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
                        <strong>Registration failed!</strong>
                        <ul class="mb-0 mt-2">
                            <c:forEach var="error" items="${sessionScope.registrationErrors}">
                                <li>${error.value}</li>
                            </c:forEach>
                        </ul>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="registrationErrors" scope="session" />
                </c:if>

            </form>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", () => {
        const form = document.getElementById("registrationForm");
        const password = document.getElementById("password");
        const confirmPassword = document.getElementById("confirmPassword");
        const roleSelect = document.getElementById("role");
        const specialtyField = document.getElementById("specialtyField");
        const specialtySelect = document.getElementById("specialty");

        function validatePasswords() {
            confirmPassword.setCustomValidity(password.value !== confirmPassword.value ? "Passwords do not match" : "");
        }

        password.addEventListener("input", validatePasswords);
        confirmPassword.addEventListener("input", validatePasswords);

        roleSelect.addEventListener("change", () => {
            if (roleSelect.value === "doctor") {
                specialtyField.classList.remove("hidden");
                specialtySelect.setAttribute("required", "true");
            } else {
                specialtyField.classList.add("hidden");
                specialtySelect.removeAttribute("required");
                specialtySelect.value = "";
            }
        });

        form.addEventListener("submit", event => {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add("was-validated");
        });
    });
</script>
</body>
</html>
