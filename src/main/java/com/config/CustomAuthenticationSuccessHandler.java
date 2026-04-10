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

<<<<<<< HEAD
import com.dto.CustomUserDetails;
=======
import com.entity.User;
import com.repository.UserRepository;
import com.service.LoginAttemptService;
>>>>>>> feature/login

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
    private LoginAttemptService loginAttemptService;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
<<<<<<< HEAD
        
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        HttpSession session = request.getSession();
        
        session.setAttribute("userId", userDetails.getId());
        session.setAttribute("fullName", userDetails.getFullName());
        
=======

        String email = authentication.getName();
        loginAttemptService.loginSucceeded(email);

        userRepository.findByEmail(email).ifPresent(user -> {
            logger.info("user with id {} login system", user.getId());
        });

>>>>>>> feature/login
        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();

        String redirectUrl = "/";

        for (GrantedAuthority authority : authorities) {
            String role = authority.getAuthority();
            if (role.equals("ROLE_ADMIN") || role.equals("ROLE_SUPER_ADMIN")) {
                redirectUrl = "/admin/dashboard";
                break;
            }
        }

        response.sendRedirect(request.getContextPath() + redirectUrl);
    }
}
