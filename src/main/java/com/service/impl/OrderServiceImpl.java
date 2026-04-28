package com.service.impl;

import com.dto.CartDTO;
import com.dto.CartItemDTO;
import com.entity.Order;
import com.entity.Notification;
import com.entity.OrderDetail;
import com.entity.ProductVariant;
import com.entity.User;
import com.repository.OrderDetailRepository;
import com.repository.NotificationRepository;
import com.repository.OrderRepository;
import com.repository.ProductVariantRepository;
import com.service.CartService;
import com.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderDetailRepository orderDetailRepository;

    @Autowired
    private CartService cartService;

    @Autowired
    private ProductVariantRepository productVariantRepository;

    @Autowired
    private com.service.MailService mailService;

    @Autowired
    private NotificationRepository notificationRepository;

    @Override
    @Transactional
    public Order createOrder(User user, Order orderData, List<Long> variantIds) {
        String cartKey = "cart:user:" + user.getEmail();
        CartDTO cart = cartService.getCart(cartKey);
        
        // Lấy danh sách các item được chọn
        List<CartItemDTO> selectedItems = cart.getItems().stream()
                .filter(item -> variantIds.contains(item.getVariantId()))
                .collect(Collectors.toList());

        if (selectedItems.isEmpty()) {
            String cartItemsInfo = cart.getItems().stream()
                    .map(item -> item.getVariantId().toString())
                    .collect(Collectors.joining(", "));
            throw new RuntimeException("Không tìm thấy sản phẩm hợp lệ để thanh toán. Giỏ hàng hiện có IDs: [" + cartItemsInfo + "], Đang yêu cầu IDs: [" + variantIds.stream().map(Object::toString).collect(Collectors.joining(", ")) + "]. Key: " + cartKey);
        }

        // Tạo Order cơ bản
        Order order = new Order();
        order.setAccount(user);
        order.setOrderCode("SM-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        order.setShippingAddress(orderData.getShippingAddress());
        order.setShippingMethod(orderData.getShippingMethod());
        order.setShippingFee(orderData.getShippingFee());
        order.setShippingInsurance(orderData.isShippingInsurance());
        order.setPaymentMethod(orderData.getPaymentMethod());
        order.setNote(orderData.getNote());
        if ("QR".equalsIgnoreCase(orderData.getPaymentMethod())) {
            order.setStatus("CONFIRMED");
        } else {
            order.setStatus("PENDING");
        }
        
        double subtotal = selectedItems.stream().mapToDouble(item -> item.getPrice() * item.getQuantity()).sum();
        order.setTotalPrice(subtotal + order.getShippingFee() + (order.isShippingInsurance() ? 10000 : 0));

        // Lưu Order trước để có ID
        order = orderRepository.save(order);

        // Tạo các OrderDetail
        List<OrderDetail> details = new ArrayList<>();
        for (CartItemDTO item : selectedItems) {
            OrderDetail detail = new OrderDetail();
            detail.setOrder(order);
            detail.setQuantity(item.getQuantity());
            detail.setPriceAtPurchase(item.getPrice());
            
            ProductVariant variant = productVariantRepository.findById(item.getVariantId())
                    .orElseThrow(() -> new RuntimeException("Sản phẩm không tồn tại: " + item.getVariantId()));
            detail.setProductVariant(variant);
            detail.setProduct(variant.getProduct());
            
            details.add(detail);
            
            // Xóa khỏi giỏ hàng
            cartService.removeFromCart(cartKey, item.getVariantId());
        }
        
        orderDetailRepository.saveAll(details);
        order.setOrderDetails(details);

        // Tạo thông báo cho người dùng
        Notification notification = new Notification();
        notification.setRecipient(user);
        notification.setType("ORDER_STATUS");
        notification.setContent("Chúc mừng! Đơn hàng " + order.getOrderCode() + " đã được đặt thành công. Hệ thống đang xử lý.");
        notification.setLinkUrl("/order-details/" + order.getOrderCode());
        notificationRepository.save(notification);

        // Gửi mail xác nhận (với QR code)
        mailService.sendOrderConfirmation(order);

        return order;
    }

    @Override
    public List<Order> getOrdersByUser(String email) {
        return orderRepository.findByAccountEmailOrderByCreatedAtDesc(email);
    }

    @Override
    public Order getOrderDetails(String orderCode) {
        return orderRepository.findByOrderCode(orderCode)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng: " + orderCode));
    }
}
