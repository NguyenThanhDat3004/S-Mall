package com.repository;

import com.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByAccountEmailOrderByCreatedAtDesc(String email);
    Optional<Order> findByOrderCode(String orderCode);
}
