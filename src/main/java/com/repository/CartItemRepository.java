package com.repository;

import com.entity.CartItem;
import com.entity.User;
import com.entity.ProductVariant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CartItemRepository extends JpaRepository<CartItem, Long> {
    List<CartItem> findByUser(User user);
    Optional<CartItem> findByUserAndProductVariant(User user, ProductVariant productVariant);
    void deleteByUser(User user);
}
