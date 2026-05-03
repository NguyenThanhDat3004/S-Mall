package com.service.impl;

import com.constant.OrderStatus;
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
import com.repository.OrderStatusLogRepository;
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
    private OrderStatusLogRepository orderStatusLogRepository;

    @Autowired
    private CartService cartService;

    @Autowired
    private ProductVariantRepository productVariantRepository;

    @Autowired
    private com.service.MailService mailService;

    @Autowired
    private NotificationRepository notificationRepository;

    @Autowired
    private org.springframework.messaging.simp.SimpMessagingTemplate messagingTemplate;

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
            throw new RuntimeException("Không tìm thấy sản phẩm hợp lệ để thanh toán. Giỏ hàng hiện có IDs: ["
                    + cartItemsInfo + "], Đang yêu cầu IDs: ["
                    + variantIds.stream().map(Object::toString).collect(Collectors.joining(", ")) + "]. Key: "
                    + cartKey);
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
            order.setStatus(OrderStatus.CONFIRMED);
        } else {
            order.setStatus(OrderStatus.PENDING);
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

        // Tự động tạo Invoice ngay nếu thanh toán bằng QR (Prepaid)
        if ("QR".equalsIgnoreCase(order.getPaymentMethod())) {
            createInvoiceForOrder(order);
        }

        // Tạo thông báo cho người dùng
        Notification notification = new Notification();
        notification.setRecipient(user);
        notification.setType("ORDER_STATUS");
        notification.setContent(
                "Chúc mừng! Đơn hàng " + order.getOrderCode() + " đã được đặt thành công. Hệ thống đang xử lý.");
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

    @Override
    public List<Order> getOrdersByShop(Long shopId) {
        return orderRepository.findAllByShopId(shopId);
    }

    @Autowired
    private com.repository.InvoiceRepository invoiceRepository;

    @Override
    @Transactional
    public void updateStatus(Long orderId, OrderStatus newStatus, String note) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng ID: " + orderId));

        order.setStatus(newStatus);
        orderRepository.save(order);

        // Tự động tạo Invoice khi đơn hàng bắt đầu được xử lý (PREPARING)
        if (newStatus == OrderStatus.PREPARING) {
            createInvoiceForOrder(order);
        }

        // Lưu lịch sử
        com.entity.OrderStatusLog log = new com.entity.OrderStatusLog();
        log.setOrder(order);
        log.setStatus(newStatus);
        log.setNote(note);
        orderStatusLogRepository.save(log);

        // Tự động tạo thông báo cho người mua khi có thay đổi trạng thái
        Notification notification = new Notification();
        notification.setRecipient(order.getAccount());
        notification.setType("ORDER_STATUS");
        
        String statusDesc = switch (newStatus) {
            case CONFIRMED -> "đã được xác nhận thành công.";
            case PREPARING -> "đang được Shop chuẩn bị và đóng gói.";
            case READY_FOR_PICKUP -> "đã đóng gói xong và đang chờ Shipper tới lấy.";
            case SHIPPING -> "đang trên đường giao tới bạn.";
            case DELIVERED -> "đã được giao thành công. Hãy kiểm tra sản phẩm nhé!";
            case REVIEWED -> "đã hoàn tất (Khách hàng đã đánh giá).";
            case CANCELLED -> "đã bị hủy.";
            case RETURNED -> "đã được yêu cầu trả hàng/hoàn tiền.";
            default -> "vừa được cập nhật sang trạng thái: " + newStatus.getDisplayName();
        };
        
        notification.setContent("Đơn hàng " + order.getOrderCode() + " " + statusDesc);
        notification.setLinkUrl("/order/passport/" + order.getOrderCode());
        notificationRepository.save(notification);

        // BẮN THÔNG BÁO REAL-TIME QUA WEBSOCKET
        try {
            messagingTemplate.convertAndSendToUser(
                order.getAccount().getEmail(), 
                "/topic/notifications", 
                notification
            );
        } catch (Exception e) {
            System.err.println("WebSocket Error: " + e.getMessage());
        }
    }

    private void createInvoiceForOrder(Order order) {
        // Kiểm tra xem đã có hóa đơn chưa để tránh tạo trùng
        if (invoiceRepository.findByOrderOrderCode(order.getOrderCode()).isPresent()) {
            return;
        }

        com.entity.Invoice invoice = new com.entity.Invoice();
        invoice.setOrder(order);
        invoice.setInvoiceCode("INV-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        invoice.setTotalAmount(order.getTotalPrice());
        invoice.setPaymentMethod(order.getPaymentMethod());
        invoice.setCreatedAt(java.time.LocalDateTime.now());

        invoiceRepository.save(invoice);
    }
}
