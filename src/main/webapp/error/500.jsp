<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Server Error | Medical Center</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            padding-top: 50px;
        }
        .error-template {
            padding: 40px 15px;
            text-align: center;
        }
        .error-actions {
            margin-top: 15px;
            margin-bottom: 15px;
        }
        .error-actions .btn {
            margin-right: 10px;
        }
        .error-image {
            max-width: 300px;
            margin: 0 auto 30px;
        }
        .error-details {
            max-width: 600px;
            margin: 0 auto 20px;
        }
        .technical-details {
            text-align: left;
            background-color: #f1f1f1;
            border-radius: 5px;
            padding: 15px;
            max-width: 800px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-md-12">
            <div class="error-template">
                <img src="${pageContext.request.contextPath}/resources/images/500.svg"
                     alt="500 Illustration" class="error-image"
                     onerror="this.onerror=null; this.src='https://cdn-icons-png.flaticon.com/512/6195/6195700.png';">
                <h1 class="display-4">Oops!</h1>
                <h2>500 - Internal Server Error</h2>
                <div class="error-details mb-4">
                    Sorry, something went wrong on our end. Our team has been notified and we're working to fix the issue.
                </div>
                <div class="error-actions">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-house-door me-1" viewBox="0 0 16 16">
                            <path d="M8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4.5a.5.5 0 0 0 .5-.5v-4h2v4a.5.5 0 0 0 .5.5H14a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146zM2.5 14V7.707l5.5-5.5 5.5 5.5V14H10v-4a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5v4H2.5z"></path>
                        </svg>
                        Home
                    </a>
                    <a href="javascript:history.back()" class="btn btn-secondary">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-left me-1" viewBox="0 0 16 16">
                            <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"></path>
                        </svg>
                        Go Back
                    </a>
                    <a href="${pageContext.request.contextPath}/contact.jsp" class="btn btn-outline-primary">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-envelope me-1" viewBox="0 0 16 16">
                            <path d="M0 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V4Zm2-1a1 1 0 0 0-1 1v.217l7 4.2 7-4.2V4a1 1 0 0 0-1-1H2Zm13 2.383-4.708 2.825L15 11.105V5.383Zm-.034 6.876-5.64-3.471L8 9.583l-1.326-.795-5.64 3.47A1 1 0 0 0 2 13h12a1 1 0 0 0 .966-.741ZM1 11.105l4.708-2.897L1 5.383v5.722Z"></path>
                        </svg>
                        Contact Support
                    </a>
                </div>

                <c:if test="${pageContext.request.isUserInRole('admin')}">
                    <div class="technical-details">
                        <h5>Technical Details (Admin Only):</h5>
                        <c:if test="${not empty pageContext.exception}">
                            <div class="alert alert-danger">
                                <strong>Error Type:</strong> ${pageContext.exception.class.name}<br>
                                <strong>Message:</strong> ${pageContext.exception.message}
                            </div>
                            <div class="mt-3">
                                <strong>Stack Trace:</strong>
                                <pre class="bg-light p-3 mt-2" style="max-height: 200px; overflow-y: auto; font-size: 12px;">
                                        <c:forEach var="stackTraceElement" items="${pageContext.exception.stackTrace}">
                                            ${stackTraceElement}
                                        </c:forEach>
                                    </pre>
                            </div>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>