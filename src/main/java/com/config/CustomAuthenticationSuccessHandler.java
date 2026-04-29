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

    @Autowired
    private org.springframework.data.redis.core.RedisTemplate<String, Object> redisTemplate;

    @Autowired
    private com.service.CartService cartService;

    @Autowired
    private com.service.UserAddressRedisService addressService;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {

        HttpSession session = request.getSession();
        String email = authentication.getName();
        loginAttemptService.loginSucceeded(email);

        // Đổ dữ liệu từ SQL lên Redis khi login thành công
        cartService.syncCartFromDbToRedis(email);
        addressService.syncAddressFromDbToRedis(email);

        userRepository.findByEmail(email).ifPresent(user -> {
            session.setAttribute("userId", user.getId());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("roleId", user.getRole().getId());

            logger.info(">>> LOGIN SUCCESS: Processing user ID: {}, Email: {}, Role: {}", user.getId(), user.getEmail(),
                    user.getRole().getName());

            // 1. Lưu thông tin Shop vào session và Redis Cache (để lấy nhanh bên ngoài)
            shopRepository.findByUser(user).ifPresentOrElse(shop -> {
                session.setAttribute("shopId", shop.getId());
                session.setAttribute("shopName", shop.getName());
                session.setAttribute("shopLogoUrl", shop.getLogoUrl());
                
                // Lưu thủ công vào Redis một bản nữa như yêu cầu của bạn
                redisTemplate.opsForValue().set("USER_LOGO:" + email, shop.getLogoUrl());
                
                logger.info(">>> SHOP & REDIS CACHE UPDATED: ID={}, Name={}", shop.getId(), shop.getName());
            }, () -> {
                session.removeAttribute("shopId");
                session.removeAttribute("shopName");
                session.removeAttribute("shopLogoUrl");
                redisTemplate.delete("USER_LOGO:" + email);
                logger.warn(">>> NO SHOP FOUND for user: {}", user.getEmail());
            });

            // 2. Lưu Avatar của người dùng vào session và Redis Cache
            if (user.getProfile() != null && user.getProfile().getAvatarUrl() != null) {
                String avatarUrl = user.getProfile().getAvatarUrl();
                session.setAttribute("userAvatarUrl", avatarUrl);
                redisTemplate.opsForValue().set("USER_AVATAR:" + email, avatarUrl);
            } else {
                session.removeAttribute("userAvatarUrl");
                redisTemplate.delete("USER_AVATAR:" + email);
            }
        });

        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();

        String redirectUrl = "/";

        for (GrantedAuthority authority : authorities) {
            String role = authority.getAuthority();
            String roleName = role.replace("ROLE_", "");

            // Ưu tiên lưu quyền cao nhất vào session (ADMIN > SELLER > USER)
            String currentRoleInSession = (String) session.getAttribute("userRole");
            if (currentRoleInSession == null || currentRoleInSession.equals("USER") ||
                    roleName.equals("ADMIN") || roleName.equals("SUPER_ADMIN")) {
                session.setAttribute("userRole", roleName);
            }

            if (roleName.equals("ADMIN") || roleName.equals("SUPER_ADMIN")) {
                redirectUrl = "/admin/dashboard";
            } else if (roleName.equals("SELLER") && !redirectUrl.startsWith("/admin")) {
                redirectUrl = "/seller/dashboard";
            }
        }

        response.sendRedirect(request.getContextPath() + redirectUrl);
    }
}
