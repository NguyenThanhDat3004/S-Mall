<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản | S-Mall</title>
    
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

    <div class="auth-card" style="max-width: 550px;">
        <a href="${pageContext.request.contextPath}/" class="auth-logo">S-Mall</a>
        <h2 class="auth-title">Tham gia cùng chúng tôi!</h2>

        <form action="${pageContext.request.contextPath}/register" method="POST" modelAttribute="registerDTO">
            
            <!-- Hiển thị thông báo lỗi nếu có -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                    <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <div class="row">
                <div class="col-md-12 mb-3">
                    <label for="fullName" class="form-label">Họ và tên</label>
                    <input type="text" name="fullName" class="form-control" id="fullName" placeholder="Nguyễn Văn A" required autofocus>
                </div>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">Email của bạn</label>
                <input type="email" name="email" class="form-control" id="email" placeholder="name@example.com" required>
                <div id="emailHelp" class="form-text">Chúng tôi không bao giờ chia sẻ email của bạn.</div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="password" class="form-label">Mật khẩu</label>
                    <input type="password" name="password" class="form-control" id="password" placeholder="••••••••" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="confirmPassword" class="form-label">Xác nhận</label>
                    <input type="password" name="confirmPassword" class="form-control" id="confirmPassword" placeholder="••••••••" required>
                </div>
            </div>

            <div class="mb-4 form-check">
                <input type="checkbox" class="form-check-input" id="terms" required>
                <label class="form-check-label small text-muted" for="terms">
                    Tôi đồng ý với các <a href="#" class="text-success fw-600">Điều khoản & Chính sách</a> của S-Mall.
                </label>
            </div>

            <button type="submit" class="btn btn-auth">Tạo tài khoản ngay</button>

            <div class="auth-footer">
                Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
            </div>
        </form>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
