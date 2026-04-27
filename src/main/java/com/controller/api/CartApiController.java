package com.controller.api;

import com.dto.CartDTO;
import com.service.CartService;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/cart")
public class CartApiController {

    private final CartService cartService;

    public CartApiController(CartService cartService) {
        this.cartService = cartService;
    }

    private String getCartKey(Principal principal, HttpSession session) {
        if (principal != null) {
            return "cart:user:" + principal.getName();
        }
        return "cart:guest:" + session.getId();
    }

    @PostMapping("/add")
    public ResponseEntity<?> addToCart(
            @RequestParam Long variantId,
            @RequestParam(defaultValue = "1") int quantity,
            Principal principal,
            HttpSession session) {
        
        try {
            String cartKey = getCartKey(principal, session);
            String buyerEmail = (principal != null) ? principal.getName() : null;
            System.out.println(">>> [CART-DEBUG] Adding to cart. Key: " + cartKey + ", VariantId: " + variantId + ", Buyer: " + buyerEmail);
            
            cartService.addToCart(cartKey, variantId, quantity, buyerEmail);
            
            int count = cartService.getCartCount(cartKey);
            System.out.println(">>> [CART-DEBUG] Success. New Count: " + count);
            
            Map<String, Object> response = new HashMap<>();
            response.put("status", "success");
            response.put("message", "Đã thêm sản phẩm vào giỏ hàng");
            response.put("cartCount", count);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            System.err.println(">>> [CART-ERROR] Error adding to cart: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).body(Map.of("status", "error", "message", e.getMessage()));
        }
    }

    @GetMapping("/count")
    public ResponseEntity<?> getCartCount(Principal principal, HttpSession session) {
        String cartKey = getCartKey(principal, session);
        int count = cartService.getCartCount(cartKey);
        
        Map<String, Object> response = new HashMap<>();
        response.put("cartCount", count);
        
        return ResponseEntity.ok(response);
    }

    @GetMapping
    public ResponseEntity<CartDTO> getCart(Principal principal, HttpSession session) {
        String cartKey = getCartKey(principal, session);
        return ResponseEntity.ok(cartService.getCart(cartKey));
    }

    @PostMapping("/update")
    public ResponseEntity<?> updateQuantity(
            @RequestParam Long variantId,
            @RequestParam int quantity,
            Principal principal,
            HttpSession session) {
        
        String cartKey = getCartKey(principal, session);
        cartService.updateQuantity(cartKey, variantId, quantity);
        
        return ResponseEntity.ok(Map.of("status", "success"));
    }

    @DeleteMapping("/remove")
    public ResponseEntity<?> removeFromCart(
            @RequestParam Long variantId,
            Principal principal,
            HttpSession session) {
        
        String cartKey = getCartKey(principal, session);
        cartService.removeFromCart(cartKey, variantId);
        
        return ResponseEntity.ok(Map.of("status", "success"));
    }
}
