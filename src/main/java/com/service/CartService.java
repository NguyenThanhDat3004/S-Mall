package com.service;

import com.dto.CartDTO;

public interface CartService {
    void addToCart(String cartKey, Long variantId, int quantity, String buyerEmail);
    CartDTO getCart(String cartKey);
    void removeFromCart(String cartKey, Long variantId);
    void updateQuantity(String cartKey, Long variantId, int quantity);
    void clearCart(String cartKey);
    int getCartCount(String cartKey);
}
