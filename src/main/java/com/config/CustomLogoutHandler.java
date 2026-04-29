package com.config;

import com.service.CartService;
import com.service.UserAddressRedisService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutHandler;
import org.springframework.stereotype.Component;

@Component
public class CustomLogoutHandler implements LogoutHandler {

    @Autowired
    private CartService cartService;

    @Autowired
    private UserAddressRedisService addressService;

    @Override
    public void logout(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
        if (authentication != null && authentication.getName() != null) {
            String email = authentication.getName();
            
            // Xóa Redis để giải phóng RAM khi logout (Dữ liệu vẫn còn trong SQL)
            String cartKey = "cart:user:" + email;
            cartService.clearCart(cartKey);
            addressService.deleteAddress(email);
            
            System.out.println(">>> LOGOUT SUCCESS: Cleared Redis for user: " + email);
        }
    }
}
