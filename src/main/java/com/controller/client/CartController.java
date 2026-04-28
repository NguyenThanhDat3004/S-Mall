package com.controller.client;

import com.dto.CartDTO;
import com.entity.User;
import com.entity.UserProfile;
import com.service.CartService;
import com.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.security.Principal;
import java.util.Optional;

@Controller
public class CartController {

    private final CartService cartService;
    private final UserService userService;

    public CartController(CartService cartService, UserService userService) {
        this.cartService = cartService;
        this.userService = userService;
    }

    @GetMapping("/cart")
    public String getCartPage(Model model, Principal principal, HttpSession session) {
        String cartKey = getCartKey(principal, session);
        CartDTO cart = cartService.getCart(cartKey);
        
        if (principal != null) {
            Optional<User> userOpt = userService.getUserByEmail(principal.getName());
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                UserProfile profile = user.getProfile();
                model.addAttribute("userProfile", profile);
                
                boolean isProfileIncomplete = profile == null 
                        || profile.getFullName() == null || profile.getFullName().trim().isEmpty()
                        || profile.getPhoneNumber() == null || profile.getPhoneNumber().trim().isEmpty()
                        || profile.getAddress() == null || profile.getAddress().trim().isEmpty()
                        || profile.getDateOfBirth() == null
                        || profile.getAvatarUrl() == null || profile.getAvatarUrl().trim().isEmpty();
                model.addAttribute("isProfileIncomplete", isProfileIncomplete);
            }
        } else {
            model.addAttribute("isProfileIncomplete", true);
        }
        
        model.addAttribute("cart", cart);
        return "client/cart/index";
    }

    @Autowired
    private com.service.UserAddressRedisService addressRedisService;

    @GetMapping("/payment")
    public String getPaymentPage(
            @RequestParam("ids") String ids,
            Model model, 
            Principal principal, 
            HttpSession session) {
        if (principal == null) {
            return "redirect:/login";
        }

        Optional<User> userOpt = userService.getUserByEmail(principal.getName());
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            UserProfile profile = user.getProfile();
            
            // Re-verify profile is complete
            boolean isProfileIncomplete = profile == null 
                    || profile.getFullName() == null || profile.getFullName().trim().isEmpty()
                    || profile.getPhoneNumber() == null || profile.getPhoneNumber().trim().isEmpty()
                    || profile.getAddress() == null || profile.getAddress().trim().isEmpty()
                    || profile.getDateOfBirth() == null
                    || profile.getAvatarUrl() == null || profile.getAvatarUrl().trim().isEmpty();
            
            if (isProfileIncomplete) {
                return "redirect:/cart?error=profile_incomplete";
            }
            
            // Lấy địa chỉ từ Redis nếu có
            String redisAddress = addressRedisService.getAddress(user.getEmail());
            model.addAttribute("redisAddress", redisAddress);
            model.addAttribute("userProfile", profile);
            
            String cartKey = getCartKey(principal, session);
            CartDTO cart = cartService.getCart(cartKey);
            
            // LỌC SẢN PHẨM: Chỉ lấy các item được chọn từ params ids
            if (ids != null && !ids.isEmpty()) {
                java.util.List<Long> selectedIds = java.util.Arrays.stream(ids.split(","))
                        .map(Long::parseLong)
                        .collect(java.util.stream.Collectors.toList());
                
                java.util.List<com.dto.CartItemDTO> filteredItems = cart.getItems().stream()
                        .filter(item -> selectedIds.contains(item.getVariantId()))
                        .collect(java.util.stream.Collectors.toList());
                
                cart.setItems(filteredItems);
            }
            
            model.addAttribute("cart", cart);
        }

        return "client/cart/payment";
    }

    private String getCartKey(Principal principal, HttpSession session) {
        if (principal != null) {
            return "user:" + principal.getName();
        }
        return "session:" + session.getId();
    }
}
