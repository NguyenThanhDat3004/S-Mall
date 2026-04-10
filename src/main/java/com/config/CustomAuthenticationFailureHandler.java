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

        if (email != null) {
            System.out.println(">>> [DEBUG] Đăng nhập thất bại cho email: " + email);
            loginAttemptService.loginFailed(email);
        }

        // Đẩy thông báo lỗi qua session truyền thống để component msg-response.jsp hiển
        // thị
        String errorMessage = exception.getMessage();

        // Nếu là lỗi mặc định của Spring, chúng ta dịch sang tiếng Việt
        if (errorMessage != null && errorMessage.equalsIgnoreCase("Bad credentials")) {
            errorMessage = "Email hoặc mật khẩu không chính xác.";
        }

        HttpSession session = request.getSession();
        System.out.println(">>> [DEBUG] Đang lưu lỗi vào Session: " + session.getId());
        session.setAttribute("message", errorMessage);
        session.setAttribute("messageType", "error");

        // Chuyển hướng về trang login
        setDefaultFailureUrl("/login?error");
        super.onAuthenticationFailure(request, response, exception);
    }
}
