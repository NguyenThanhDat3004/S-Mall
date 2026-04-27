package com.controller.client;

import com.dto.CartDTO;
import com.service.CartService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.security.Principal;

@Controller
public class CartController {

    private final CartService cartService;

    public CartController(CartService cartService) {
        this.cartService = cartService;
    }

    @GetMapping("/cart")
    public String getCartPage(Model model, Principal principal, HttpSession session) {
        String cartKey = getCartKey(principal, session);
        CartDTO cart = cartService.getCart(cartKey);
        
        model.addAttribute("cart", cart);
        return "client/cart/index";
    }

    private String getCartKey(Principal principal, HttpSession session) {
        if (principal != null) {
            return "user:" + principal.getName();
        }
        return "session:" + session.getId();
    }
}
