package com.config;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import com.service.LoginAttemptService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class CustomAuthenticationFailureHandler extends SimpleUrlAuthenticationFailureHandler {

    @Autowired
    private LoginAttemptService loginAttemptService;

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
            AuthenticationException exception) throws IOException, ServletException {

        // Lấy email từ form đăng nhập (tên trường mặc định là username)
        String email = request.getParameter("username");
        String errorMessage = exception.getMessage();
        boolean isLocked = false;

        // CÁCH FOOLPROOF: Nếu thông báo chỉ toàn số, chắc chắn là số giây còn lại (Tài khoản đang bị khóa)
        if (errorMessage != null && errorMessage.matches("\\d+")) {
            try {
                long seconds = Long.parseLong(errorMessage);
                request.getSession().setAttribute("lockExpirySeconds", seconds);
                errorMessage = "Tài khoản đã bị khóa do nhập sai quá nhiều lần.";
                isLocked = true;
            } catch (Exception e) {
                // Giữ nguyên errorMessage nếu có lỗi parse
            }
        } else if (errorMessage != null && errorMessage.equalsIgnoreCase("Bad credentials")) {
            errorMessage = "Email hoặc mật khẩu không chính xác.";
        }

        // CHỈ xử lý đếm lỗi và gửi mail nếu tài khoản CHƯA bị khóa
        if (email != null && !isLocked) {
            System.out.println(">>> [DEBUG] Đăng nhập sai lần kế tiếp cho email: " + email);
            loginAttemptService.loginFailed(email);
            // Gọi hàm gửi mail (Hàm này sẽ tự check ngưỡng > 4 của bạn để gửi mail đúng lúc)
            loginAttemptService.sendLockEmail(email);
        }

        HttpSession session = request.getSession();
        session.setAttribute("message", errorMessage);
        session.setAttribute("messageType", "error");

        // Chuyển hướng về trang login
        setDefaultFailureUrl("/login?error");
        super.onAuthenticationFailure(request, response, exception);
    }
}
