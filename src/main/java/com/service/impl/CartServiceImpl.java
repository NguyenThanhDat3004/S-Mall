package com.service.impl;

import com.dto.CartDTO;
import com.dto.CartItemDTO;
import com.entity.ProductVariant;
import com.entity.ProductImage;
import com.repository.ProductVariantRepository;
import com.service.CartService;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@Transactional
public class CartServiceImpl implements CartService {

    private final RedisTemplate<String, Object> redisTemplate;
    private final ProductVariantRepository variantRepository;
    private static final String PREFIX = "cart_v2:";

    public CartServiceImpl(RedisTemplate<String, Object> redisTemplate, ProductVariantRepository variantRepository) {
        this.redisTemplate = redisTemplate;
        this.variantRepository = variantRepository;
    }

    private String getNewKey(String cartKey) {
        if (cartKey.startsWith(PREFIX))
            return cartKey;
        return PREFIX + cartKey.substring(cartKey.lastIndexOf(":") + 1);
    }

    @Override
    public void addToCart(String cartKey, Long variantId, int quantity, String buyerEmail) {
        String key = getNewKey(cartKey);

        ProductVariant variant = variantRepository.findById(variantId)
                .orElseThrow(() -> new RuntimeException("Product variant không tồn tại"));

        // Kiểm tra xem người mua có phải là chủ shop không
        if (buyerEmail != null && variant.getProduct().getShop() != null
                && variant.getProduct().getShop().getUser() != null) {
            String shopOwnerEmail = variant.getProduct().getShop().getUser().getEmail();
            if (buyerEmail.equalsIgnoreCase(shopOwnerEmail)) {
                throw new RuntimeException("Bạn không thể mua sản phẩm của chính shop mình!");
            }
        }

        CartDTO cart = getCart(key);

        Optional<CartItemDTO> existingItem = cart.getItems().stream()
                .filter(item -> item.getVariantId().equals(variantId))
                .findFirst();

        if (existingItem.isPresent()) {
            existingItem.get().setQuantity(existingItem.get().getQuantity() + quantity);
        } else {
            CartItemDTO newItem = new CartItemDTO();
            newItem.setVariantId(variant.getId());
            newItem.setProductName(variant.getProduct().getName());
            newItem.setSku(variant.getSku());
            newItem.setPrice(variant.getDiscountPrice() != null ? variant.getDiscountPrice() : variant.getPrice());
            
            // Lấy ảnh: Ưu tiên ảnh biến thể -> Ảnh chính sản phẩm -> Ảnh đầu tiên -> null
            String finalImageUrl = variant.getImageUrl();
            if (finalImageUrl == null || finalImageUrl.isEmpty()) {
                finalImageUrl = variant.getProduct().getImages().stream()
                        .filter(ProductImage::isMain)
                        .map(ProductImage::getUrl)
                        .findFirst()
                        .orElse(variant.getProduct().getImages().isEmpty() ? null : variant.getProduct().getImages().get(0).getUrl());
            }
            newItem.setImageUrl(finalImageUrl);
            
            newItem.setQuantity(quantity);

            cart.getItems().add(newItem);
        }

        saveCart(key, cart);
    }

    @Override
    public CartDTO getCart(String cartKey) {
        String key = getNewKey(cartKey);
        Object obj = redisTemplate.opsForValue().get(key);
        if (obj == null)
            return new CartDTO();

        if (obj instanceof CartDTO)
            return (CartDTO) obj;

        try {
            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
            mapper.configure(com.fasterxml.jackson.databind.DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
            return mapper.convertValue(obj, CartDTO.class);
        } catch (Exception e) {
            return new CartDTO();
        }
    }

    @Override
    public void removeFromCart(String cartKey, Long variantId) {
        String key = getNewKey(cartKey);
        CartDTO cart = getCart(key);
        cart.getItems().removeIf(item -> item.getVariantId().equals(variantId));
        saveCart(key, cart);
    }

    @Override
    public void updateQuantity(String cartKey, Long variantId, int quantity) {
        String key = getNewKey(cartKey);
        CartDTO cart = getCart(key);
        cart.getItems().stream()
                .filter(item -> item.getVariantId().equals(variantId))
                .findFirst()
                .ifPresent(item -> item.setQuantity(quantity));
        saveCart(key, cart);
    }

    @Override
    public void clearCart(String cartKey) {
        redisTemplate.delete(getNewKey(cartKey));
    }

    @Override
    public int getCartCount(String cartKey) {
        return getCart(getNewKey(cartKey)).getTotalItems();
    }

    private void saveCart(String cartKey, CartDTO cart) {
        redisTemplate.opsForValue().set(getNewKey(cartKey), cart);
    }
}
