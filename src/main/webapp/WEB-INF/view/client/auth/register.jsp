<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản | S-Mall - Shopping Smart</title>
    
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

    <div class="auth-card" style="max-width: 600px;">
        <a href="${pageContext.request.contextPath}/" class="auth-logo">S-Mall</a>
        <h2 class="auth-title">Tham gia cùng chúng tôi!</h2>
        <p class="text-center text-muted mb-4">Điền đầy đủ thông tin bên dưới để bắt đầu mua sắm.</p>

        <form action="${pageContext.request.contextPath}/register" method="POST" modelAttribute="registerDTO">
            
            <!-- Alert for Errors -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Group 1: Basic Info -->
            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <label for="fullName" class="form-label font-600">Họ và tên</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0"><i class="bi bi-person text-muted"></i></span>
                        <input type="text" name="fullName" value="<c:out value='${registerDTO.fullName}'/>" class="form-control border-start-0 ps-0" id="fullName" placeholder="Nguyễn Văn A" required autofocus>
                    </div>
                </div>
                <div class="col-md-6">
                    <label for="email" class="form-label font-600">Email của bạn</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0"><i class="bi bi-envelope text-muted"></i></span>
                        <input type="email" name="email" value="<c:out value='${registerDTO.email}'/>" class="form-control border-start-0 ps-0" id="email" placeholder="name@example.com" required>
                    </div>
                </div>
            </div>

            <!-- Group 2: Contact Info -->
            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <label for="phoneNumber" class="form-label font-600">Số điện thoại</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0"><i class="bi bi-phone text-muted"></i></span>
                        <input type="tel" name="phoneNumber" value="<c:out value='${registerDTO.phoneNumber}'/>" class="form-control border-start-0 ps-0" id="phoneNumber" placeholder="03XXXXXXXX" required>
                    </div>
                </div>
                <div class="col-md-6">
                    <label for="address" class="form-label font-600">Địa chỉ nhận hàng</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0"><i class="bi bi-geo-alt text-muted"></i></span>
                        <input type="text" name="address" value="<c:out value='${registerDTO.address}'/>" class="form-control border-start-0 ps-0" id="address" placeholder="Quận/Huyện, Tỉnh/TP" required>
                    </div>
                </div>
            </div>

            <!-- Group 3: Password -->
            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <label for="password" class="form-label font-600">Mật khẩu</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0"><i class="bi bi-shield-lock text-muted"></i></span>
                        <input type="password" name="password" class="form-control border-start-0 ps-0" id="password" placeholder="••••••••" required>
                    </div>
                </div>
                <div class="col-md-6">
                    <label for="confirmPassword" class="form-label font-600">Xác nhận mật khẩu</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0"><i class="bi bi-shield-check text-muted"></i></span>
                        <input type="password" name="confirmPassword" class="form-control border-start-0 ps-0" id="confirmPassword" placeholder="••••••••" required>
                    </div>
                </div>
            </div>

            <div class="mb-4 form-check">
                <input type="checkbox" class="form-check-input" id="terms" name="acceptTerms" ${registerDTO.acceptTerms ? 'checked' : ''}>
                <label class="form-check-label small text-muted" for="terms">
                    Tôi đồng ý với các <a href="#" class="text-success fw-600 text-decoration-none">Điều khoản & Chính sách</a> của S-Mall.
                </label>
            </div>

            <button type="submit" class="btn btn-auth w-100 py-3 mb-4">Đăng ký tài khoản ngay</button>

            <div class="auth-footer text-center">
                Đã có tài khoản? <a href="${pageContext.request.contextPath}/login" class="text-success fw-600 text-decoration-none">Đăng nhập ngay</a>
            </div>
        </form>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Auto-save Form Script (Diamond Version - RAM Session) -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const STORAGE_KEY = 's-mall-register-data';
            const fields = ['fullName', 'email', 'phoneNumber', 'address'];
            const form = document.querySelector('form');

            // 1. Recover all data with Error Protection (from RAM Session)
            try {
                const rawData = sessionStorage.getItem(STORAGE_KEY);
                if (rawData) {
                    const savedData = JSON.parse(rawData);
                    fields.forEach(id => {
                        const element = document.getElementById(id);
                        if (element && savedData[id]) {
                            // Trim to check if it's truly empty or just whitespace
                            const currentValue = element.value ? element.value.trim() : '';
                            if (currentValue === '') {
                                element.value = savedData[id];
                            }
                        }
                    });
                    console.log('S-Mall: Data recovered from SessionStorage.');
                }
            } catch (e) {
                console.error('S-Mall: Recovery failed, clearing data.', e);
                sessionStorage.removeItem(STORAGE_KEY);
            }

            // 2. Optimized Save using Delegation on Document
            document.addEventListener('input', function(e) {
                if (fields.includes(e.target.id)) {
                    try {
                        const currentData = JSON.parse(sessionStorage.getItem(STORAGE_KEY) || '{}');
                        currentData[e.target.id] = e.target.value;
                        sessionStorage.setItem(STORAGE_KEY, JSON.stringify(currentData));
                    } catch (err) {
                        const newData = {};
                        newData[e.target.id] = e.target.value;
                        sessionStorage.setItem(STORAGE_KEY, JSON.stringify(newData));
                    }
                }
            });
        });
    </script>
</body>
</html>
