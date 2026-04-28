package com.controller.client;

import com.entity.Order;
import com.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.security.Principal;
import java.util.List;

@Controller("clientOrderController")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @GetMapping("/my-orders")
    public String getMyOrdersPage(Model model, Principal principal) {
        if (principal == null) return "redirect:/login";
        
        List<Order> orders = orderService.getOrdersByUser(principal.getName());
        model.addAttribute("orders", orders);
        return "client/order/index";
    }

    @GetMapping("/order-details/{orderCode}")
    public String getOrderDetailPage(@PathVariable String orderCode, Model model, Principal principal) {
        if (principal == null) return "redirect:/login";
        
        Order order = orderService.getOrderDetails(orderCode);
        // Verify ownership
        if (!order.getAccount().getEmail().equals(principal.getName())) {
            return "redirect:/my-orders";
        }
        
        model.addAttribute("order", order);
        return "client/order/details";
    }
}
