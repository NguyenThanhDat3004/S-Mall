package com.service.impl;

import com.dto.CartDTO;
import com.dto.CartItemDTO;
import com.entity.ProductImage;
import com.entity.ProductVariant;
import com.repository.ProductVariantRepository;
import com.service.CartService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@Transactional
public class CartServiceImpl implements CartService {

    @Autowired
    private ObjectMapper objectMapper;

    private final RedisTemplate<String, Object> redisTemplate;
    private final ProductVariantRepository variantRepository;
    
    @Autowired
    private com.service.ai.UserBehaviorService userBehaviorService;
    
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

        // Ghi nhận hành vi cho AI (Top 5 loại sản phẩm)
        if (variant.getProduct() != null && variant.getProduct().getCategory() != null) {
            String cleanIdentifier = cartKey.replace("cart_v2:", "");
            userBehaviorService.logAddToCart(cleanIdentifier, 
                                            variant.getProduct().getCategory().getId(), 
                                            variant.getProduct().getName());
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

        redisTemplate.opsForValue().set(key, cart);
    }

    @Override
    public CartDTO getCart(String cartKey) {
        String key = getNewKey(cartKey);
        Object obj = redisTemplate.opsForValue().get(key);
        
        if (obj == null) {
            return new CartDTO();
        }
        
        if (obj instanceof CartDTO) {
            return (CartDTO) obj;
        }
        
        // Nếu là LinkedHashMap (trường hợp lỗi cũ hoặc phân giải không khớp)
        return objectMapper.convertValue(obj, CartDTO.class);
    }

    @Override
    public void updateQuantity(String cartKey, Long variantId, int quantity) {
        String key = getNewKey(cartKey);
        CartDTO cart = getCart(key);
        cart.getItems().stream()
                .filter(item -> item.getVariantId().equals(variantId))
                .findFirst()
                .ifPresent(item -> item.setQuantity(quantity));
        redisTemplate.opsForValue().set(key, cart);
    }

    @Override
    public void removeFromCart(String cartKey, Long variantId) {
        String key = getNewKey(cartKey);
        CartDTO cart = getCart(key);
        cart.getItems().removeIf(item -> item.getVariantId().equals(variantId));
        redisTemplate.opsForValue().set(key, cart);
    }

    @Override
    public void clearCart(String cartKey) {
        String key = getNewKey(cartKey);
        redisTemplate.delete(key);
    }

    @Override
    public int getCartCount(String cartKey) {
        return getCart(cartKey).getTotalItems();
    }
}
