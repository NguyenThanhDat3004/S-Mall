package com.repository;

import com.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByAccountEmailOrderByCreatedAtDesc(String email);
    Optional<Order> findByOrderCode(String orderCode);

    @org.springframework.data.jpa.repository.Query("SELECT DISTINCT o FROM Order o JOIN o.orderDetails od WHERE od.product.shop.id = :shopId ORDER BY o.createdAt DESC")
    List<Order> findAllByShopId(Long shopId);

    @org.springframework.data.jpa.repository.Query("SELECT new com.dto.CustomerInsightDTO(u.id, u.email, up.fullName, up.avatarUrl, " +
            "COUNT(DISTINCT o.id), SUM(od.priceAtPurchase * od.quantity), MAX(o.createdAt)) " +
            "FROM Order o " +
            "JOIN o.account u " +
            "JOIN u.profile up " +
            "JOIN o.orderDetails od " +
            "WHERE od.product.shop.id = :shopId AND o.createdAt >= :since AND o.status != com.constant.OrderStatus.CANCELLED " +
            "GROUP BY u.id, u.email, up.fullName, up.avatarUrl " +
            "ORDER BY SUM(od.priceAtPurchase * od.quantity) DESC")
    List<com.dto.CustomerInsightDTO> findCustomerInsightsByShopIdAndDate(Long shopId, java.time.LocalDateTime since);

    @org.springframework.data.jpa.repository.Query("SELECT new com.dto.CustomerInsightDTO(u.id, u.email, up.fullName, up.avatarUrl, " +
            "COUNT(DISTINCT o.id), SUM(od.priceAtPurchase * od.quantity), MAX(o.createdAt)) " +
            "FROM Order o " +
            "JOIN o.account u " +
            "JOIN u.profile up " +
            "JOIN o.orderDetails od " +
            "WHERE od.product.shop.id = :shopId AND o.status != com.constant.OrderStatus.CANCELLED " +
            "GROUP BY u.id, u.email, up.fullName, up.avatarUrl " +
            "ORDER BY SUM(od.priceAtPurchase * od.quantity) DESC")
    List<com.dto.CustomerInsightDTO> findCustomerInsightsByShopId(Long shopId);
}
