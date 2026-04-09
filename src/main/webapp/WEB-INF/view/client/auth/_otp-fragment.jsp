<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- OTP Verification Fragment -->
<h2 class="auth-title">Xác thực Email</h2>
<p class="text-center text-muted mb-4">
    Chúng tôi đã gửi mã xác thực đến email:<br>
    <strong class="text-dark">${email}</strong>
</p>

<form action="${pageContext.request.contextPath}/verify-otp" method="POST">
    <input type="hidden" name="email" value="${email}">
    
    <!-- Alert for Errors -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="mb-4">
        <label for="otp" class="form-label font-600 text-center d-block">Nhập mã 6 chữ số</label>
        <input type="text" name="otp" class="form-control text-center fw-bold fs-3" id="otp" 
               maxlength="6" autocomplete="one-time-code" style="letter-spacing: 0.5rem;" required autofocus>
        <div class="form-text text-center mt-2">
            Mã có hiệu lực trong: <span id="timer" class="text-danger fw-bold">05:00</span>
        </div>
    </div>

    <button type="submit" class="btn btn-auth w-100 py-3 mb-4">Xác minh tài khoản</button>

    <div class="auth-footer text-center">
        <a href="${pageContext.request.contextPath}/register" class="text-muted small text-decoration-none">
            <i class="bi bi-arrow-left"></i> Quay lại sửa thông tin
        </a>
    </div>
</form>

<script>
    (function() {
        let time = 300; // 5 minutes
        const timerElement = document.getElementById('timer');
        
        if (!timerElement) return;

        const countdown = setInterval(() => {
            let minutes = Math.floor(time / 60);
            let seconds = time % 60;
            
            seconds = seconds < 10 ? '0' + seconds : seconds;
            minutes = minutes < 10 ? '0' + minutes : minutes;
            
            timerElement.textContent = minutes + ":" + seconds;
            
            if (time <= 0) {
                clearInterval(countdown);
                timerElement.textContent = "Hết hạn";
            } else {
                time--;
            }
        }, 1000);
    })();
</script>
