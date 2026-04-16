package com.config;

import java.io.IOException;
import java.util.Collection;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.entity.User;
import com.repository.UserRepository;
import com.service.LoginAttemptService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    private static final Logger logger = LoggerFactory.getLogger(CustomAuthenticationSuccessHandler.class);

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private com.repository.ShopRepository shopRepository;

    @Autowired
    private LoginAttemptService loginAttemptService;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {

        HttpSession session = request.getSession();
        String email = authentication.getName();
        loginAttemptService.loginSucceeded(email);

        userRepository.findByEmail(email).ifPresent(user -> {
            session.setAttribute("userId", user.getId());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("roleId", user.getRole().getId());
            
            // Nếu là SELLER (hoặc bất kỳ ai có Shop), hãy lưu thông tin Shop vào session
            shopRepository.findByUser(user).ifPresent(shop -> {
                session.setAttribute("shopId", shop.getId());
                session.setAttribute("shopName", shop.getName());
                logger.info("Shop associated with user: {} is {}", user.getEmail(), shop.getName());
            });

            logger.info("user with id {} login system", user.getId());
        });

        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();

        String redirectUrl = "/";

        for (GrantedAuthority authority : authorities) {
            String role = authority.getAuthority();
            
            // Lưu quyền vào session để hiển thị header (bỏ tiền tố ROLE_)
            session.setAttribute("userRole", role.replace("ROLE_", ""));

            if (role.equals("ROLE_ADMIN") || role.equals("ROLE_SUPER_ADMIN")) {
                redirectUrl = "/admin/dashboard";
                break;
            }
        }

        response.sendRedirect(request.getContextPath() + redirectUrl);
    }
}
