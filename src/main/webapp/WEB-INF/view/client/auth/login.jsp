<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập | S-Mall - Hệ thống mua sắm thông minh</title>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/client/auth.css">
</head>
<body class="auth-body">

    <div class="auth-card">
        <a href="${pageContext.request.contextPath}/" class="auth-logo">S-Mall</a>
        <h2 class="auth-title">Chào mừng bạn quay lại!</h2>

        <form action="${pageContext.request.contextPath}/perform_login" method="POST">
            <!-- Alert for Login Errors (Spring Security default param: error) -->
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                    <i class="bi bi-exclamation-triangle-fill"></i> Email hoặc mật khẩu không đúng.
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Alert for Logout Success -->
            <c:if test="${not empty param.logout}">
                <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                    <i class="bi bi-check-circle-fill"></i> Đã đăng xuất thành công.
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="mb-3">
                <label for="username" class="form-label">Email đăng nhập</label>
                <input type="email" name="username" class="form-control" id="username" placeholder="name@example.com" required autofocus>
            </div>

            <div class="mb-3">
                <div class="d-flex justify-content-between">
                    <label for="password" class="form-label">Mật khẩu</label>
                    <a href="#" class="text-success text-decoration-none fw-600 small">Quên mật khẩu?</a>
                </div>
                <input type="password" name="password" class="form-control" id="password" placeholder="••••••••" required>
            </div>

            <div class="mb-4 form-check">
                <input type="checkbox" class="form-check-input" id="rememberMe" name="remember-me">
                <label class="form-check-label small text-muted" for="rememberMe">Ghi nhớ đăng nhập</label>
            </div>

            <button type="submit" class="btn btn-auth">Đăng nhập ngay</button>

            <!-- Social Login Divider -->
            <div class="auth-footer">
                <div class="d-flex align-items-center mb-3">
                    <hr class="flex-grow-1">
                    <span class="px-3 text-muted small">hoặc tiếp tục với</span>
                    <hr class="flex-grow-1">
                </div>
                <div class="social-login">
                    <a href="#" class="social-btn"><i class="bi bi-google text-danger"></i></a>
                    <a href="#" class="social-btn"><i class="bi bi-facebook text-primary"></i></a>
                    <a href="#" class="social-btn"><i class="bi bi-github text-dark"></i></a>
                </div>
            </div>

            <div class="auth-footer">
                Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
            </div>
        </form>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
