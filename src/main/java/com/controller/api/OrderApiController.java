package com.controller.api;

import com.entity.Order;
import com.entity.User;
import com.service.OrderService;
import com.service.UserAddressRedisService;
import com.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/orders")
public class OrderApiController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private UserService userService;

    @Autowired
    private UserAddressRedisService addressRedisService;

    @PostMapping("/place")
    public ResponseEntity<?> placeOrder(
            @RequestParam String ids, // variantIds separated by comma
            @RequestParam String shippingMethod,
            @RequestParam boolean insurance,
            @RequestParam String paymentMethod,
            @RequestParam String address,
            @RequestParam(defaultValue = "false") boolean saveAddress,
            @RequestParam(required = false) String note,
            Principal principal) {
        
        if (principal == null) {
            return ResponseEntity.status(401).body(Map.of("message", "Vui lòng đăng nhập"));
        }

        try {
            Optional<User> userOpt = userService.getUserByEmail(principal.getName());
            if (userOpt.isEmpty()) return ResponseEntity.badRequest().body(Map.of("message", "User not found"));
            User user = userOpt.get();

            List<Long> variantIds = Arrays.stream(ids.split(","))
                    .map(Long::parseLong)
                    .collect(Collectors.toList());

            // Map data to Order entity
            Order orderData = new Order();
            orderData.setShippingAddress(address);
            orderData.setShippingMethod(shippingMethod);
            orderData.setShippingInsurance(insurance);
            orderData.setPaymentMethod(paymentMethod);
            orderData.setNote(note);
            
            // Shipping fee calculation logic
            double shippingFee = 30000;
            if ("economy".equals(shippingMethod)) shippingFee = 15000;
            else if ("express".equals(shippingMethod)) shippingFee = 50000;
            orderData.setShippingFee(shippingFee);

            Order createdOrder = orderService.createOrder(user, orderData, variantIds);

            // Lưu địa chỉ vào Redis nếu người dùng yêu cầu
            if (saveAddress) {
                addressRedisService.saveAddress(user.getEmail(), address);
            }

            Map<String, Object> response = new HashMap<>();
            response.put("status", "success");
            response.put("orderCode", createdOrder.getOrderCode());
            response.put("message", "Đặt hàng thành công!");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.ok(Map.of("status", "error", "message", e.getMessage()));
        }
    }

    @GetMapping("/my-orders")
    public ResponseEntity<?> getMyOrders(Principal principal) {
        if (principal == null) return ResponseEntity.status(401).build();
        return ResponseEntity.ok(orderService.getOrdersByUser(principal.getName()));
    }
}
