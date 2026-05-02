package com.controller.seller;

import com.constant.OrderStatus;
import com.entity.Order;
import com.service.OrderService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/seller/order")
public class SellerOrderController {

    @Autowired
    private OrderService orderService;

    @GetMapping("/list")
    public String getOrderListPage(Model model, HttpSession session) {
        Long shopId = (Long) session.getAttribute("shopId");
        if (shopId == null) {
            return "redirect:/login";
        }

        List<Order> orders = orderService.getOrdersByShop(shopId);
        model.addAttribute("orders", orders);
        model.addAttribute("statuses", OrderStatus.values());
        return "seller/order/list";
    }

    @PostMapping("/update-status")
    @ResponseBody
    public Map<String, Object> updateOrderStatus(
            @RequestParam Long orderId,
            @RequestParam OrderStatus status,
            @RequestParam(required = false) String note) {
        
        try {
            orderService.updateStatus(orderId, status, note);
            return Map.of("success", true, "message", "Cập nhật trạng thái thành công!");
        } catch (Exception e) {
            return Map.of("success", false, "message", "Lỗi: " + e.getMessage());
        }
    }
}
