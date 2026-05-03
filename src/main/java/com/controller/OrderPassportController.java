package com.controller;

import com.entity.Order;
import com.entity.User;
import com.service.OrderService;
import com.service.QRCodeService;
import com.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.security.Principal;

@Controller
public class OrderPassportController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private UserService userService;

    @Autowired
    private QRCodeService qrCodeService;

    @GetMapping("/order/passport/{orderCode}")
    public String getOrderPassport(@PathVariable String orderCode, Model model, Principal principal,
            jakarta.servlet.http.HttpServletRequest request) {
        Order order = orderService.getOrderDetails(orderCode);
        if (order == null)
            return "redirect:/";

        String userEmail = principal.getName();
        User currentUser = userService.getUserByEmail(userEmail).orElse(null);
        if (currentUser == null)
            return "redirect:/login";

        String role = "GUEST";
        boolean hasAccess = false;

        // Determine Role and Access
        if (order.getAccount().getEmail().equals(userEmail)) {
            role = "BUYER";
            hasAccess = true;
        } else if (order.getOrderDetails().stream()
                .anyMatch(d -> d.getProduct().getShop().getUser().getEmail().equals(userEmail))) {
            role = "SELLER";
            hasAccess = true;
        } else if (currentUser.getRole().getName().equals("ROLE_SHIPPER")) {
            role = "SHIPPER";
            hasAccess = true;
        } else if (currentUser.getRole().getName().equals("ROLE_ADMIN")) {
            role = "ADMIN";
            hasAccess = true;
        }

        if (!hasAccess) {
            model.addAttribute("message", "Bạn không có quyền truy cập thông tin đơn hàng này.");
            return "error/unauthorized";
        }

        // Generate QR for this passport URL
        String fullUrl = request.getRequestURL().toString();
        String qrBase64 = qrCodeService.generateQRCodeBase64(fullUrl, 300, 300);

        // Định dạng ngày tháng để hiển thị ở JSP (tránh lỗi LocalDateTime)
        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("HH:mm - dd/MM/yyyy");
        model.addAttribute("formattedCreatedAt", order.getCreatedAt().format(formatter));
        model.addAttribute("formattedUpdatedAt", order.getUpdatedAt().format(formatter));

        model.addAttribute("order", order);
        model.addAttribute("role", role);
        model.addAttribute("qrCode", qrBase64);
        return "order/passport";
    }

    @PostMapping("/api/orders/passport/update-status")
    public String updateOrderStatus(@RequestParam String orderCode,
            @RequestParam String action,
            Principal principal) {
        Order order = orderService.getOrderDetails(orderCode);
        if (order == null)
            return "redirect:/";

        User currentUser = userService.getUserByEmail(principal.getName()).orElse(null);
        if (currentUser == null)
            return "redirect:/login";

        String userEmail = principal.getName();
        boolean isSeller = order.getOrderDetails().stream()
                .anyMatch(d -> d.getProduct().getShop().getUser().getEmail().equals(userEmail));

        // Logic "Rào bảo mật" cho hành động
        if ("CONFIRM".equals(action)) {
            // Chỉ Người bán mới được xác nhận đơn hàng đang chờ
            if (isSeller && order.getStatus() == com.constant.OrderStatus.PENDING) {
                orderService.updateStatus(order.getId(), com.constant.OrderStatus.PREPARING,
                        "Người bán đã xác nhận đơn hàng (Passport Scan)");
            }
        } else if ("PREPARED".equals(action)) {
            // Người bán báo đã chuẩn bị xong hàng
            if (isSeller && order.getStatus() == com.constant.OrderStatus.PREPARING) {
                orderService.updateStatus(order.getId(), com.constant.OrderStatus.READY_FOR_PICKUP,
                        "Người bán đã chuẩn bị xong hàng, sẵn sàng bàn giao.");
            }
        } else if ("PICKUP".equals(action)) {
            // Chỉ Shipper được xác nhận lấy hàng khi hàng đã sẵn sàng
            if (currentUser.getRole().getName().equals("ROLE_SHIPPER") &&
                    order.getStatus() == com.constant.OrderStatus.READY_FOR_PICKUP) {
                orderService.updateStatus(order.getId(), com.constant.OrderStatus.SHIPPING,
                        "Shipper đã lấy hàng và đang vận chuyển.");
            }
        } else if ("DELIVERED".equals(action)) {
            // Chỉ Shipper được xác nhận giao hàng xong
            if (currentUser.getRole().getName().equals("ROLE_SHIPPER") &&
                    order.getStatus() == com.constant.OrderStatus.SHIPPING) {
                orderService.updateStatus(order.getId(), com.constant.OrderStatus.DELIVERED,
                        "Shipper đã giao hàng thành công (Passport Scan)");
            }
        } else if ("RECEIVED".equals(action)) {
            // Chỉ Người mua được xác nhận đã nhận hàng
            if (order.getAccount().getEmail().equals(principal.getName()) &&
                    order.getStatus() == com.constant.OrderStatus.DELIVERED) {
                orderService.updateStatus(order.getId(), com.constant.OrderStatus.REVIEWED,
                        "Khách hàng xác nhận đã nhận hàng (Passport Scan)");
            }
        }

        return "redirect:/order/passport/" + orderCode;
    }
}
