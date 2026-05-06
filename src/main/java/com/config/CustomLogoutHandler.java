package com.config;

import com.service.CartService;
import com.service.UserAddressRedisService;
import com.service.ai.agent.SellerAgentService;
import com.entity.User;
import com.entity.AiChatSession;
import com.repository.UserRepository;
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

    @Autowired
    private SellerAgentService sellerAgentService;

    @Autowired
    private UserRepository userRepository;

    @Override
    public void logout(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
        if (authentication != null && authentication.getName() != null) {
            String email = authentication.getName();
            
            // Xóa Redis để giải phóng RAM khi logout (Dữ liệu vẫn còn trong SQL)
            String cartKey = "cart:user:" + email;
            cartService.clearCart(cartKey);
            addressService.deleteAddress(email);

            // Flush AI chat buffer xuống DB khi logout
            try {
                User user = userRepository.findByEmail(email).orElse(null);
                if (user != null) {
                    AiChatSession activeSession = sellerAgentService.getActiveSession(user);
                    if (activeSession != null) {
                        sellerAgentService.summarizeAndCloseSession(activeSession.getId());
                        System.out.println(">>> LOGOUT: Flushed AI session " + activeSession.getId() + " to DB.");
                    }
                }
            } catch (Exception e) {
                System.err.println(">>> LOGOUT: Error flushing AI session: " + e.getMessage());
            }
            
            System.out.println(">>> LOGOUT SUCCESS: Cleared Redis for user: " + email);
        }
    }
}
