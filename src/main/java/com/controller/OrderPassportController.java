package com.controller;

import com.entity.Order;
import com.entity.User;
import com.service.OrderService;
import com.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.security.Principal;

@Controller
public class OrderPassportController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private UserService userService;

    @GetMapping("/order/passport/{orderCode}")
    public String getOrderPassport(@PathVariable String orderCode, Model model, Principal principal) {
        Order order = orderService.getOrderDetails(orderCode);
        if (order == null) return "redirect:/";

        String role = "GUEST";
        if (principal != null) {
            User currentUser = userService.getUserByEmail(principal.getName()).orElse(null);
            if (currentUser == null) return "redirect:/";
            
            // Determine Role for this specific order
            if (order.getAccount().getEmail().equals(principal.getName())) {
                role = "BUYER";
            } else if (order.getOrderDetails().stream().anyMatch(d -> 
                    d.getProduct().getShop().getUser().getEmail().equals(principal.getName()))) {
                role = "SELLER";
            } else if (currentUser.getRole().getName().equals("ROLE_SHIPPER")) {
                role = "SHIPPER";
            } else if (currentUser.getRole().getName().equals("ROLE_ADMIN")) {
                role = "ADMIN";
            }
        }

        model.addAttribute("order", order);
        model.addAttribute("role", role);
        return "order/passport";
    }
}
