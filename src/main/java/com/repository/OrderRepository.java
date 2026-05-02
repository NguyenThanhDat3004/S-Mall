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
}
