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
        
        // Verify ownership (Buyer or Seller of the shop)
        boolean isBuyer = order.getAccount().getEmail().equals(principal.getName());
        boolean isSeller = order.getOrderDetails().stream()
                .anyMatch(detail -> detail.getProduct().getShop().getUser() != null && 
                          detail.getProduct().getShop().getUser().getEmail().equals(principal.getName()));
        
        if (!isBuyer && !isSeller) {
            return "redirect:/";
        }
        
        model.addAttribute("order", order);
        return "client/order/details";
    }
}
