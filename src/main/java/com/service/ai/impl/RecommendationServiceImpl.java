package com.service.ai.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import com.entity.Product;
import com.repository.ProductRepository;
import com.service.ai.RecommendationService;

@Service
public class RecommendationServiceImpl implements RecommendationService {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    @Override
    public List<Product> getHomepageRecommendations(String identifier) {
        // [PHASE 1] - Xử lý Case 1: Khách hàng mới/Guest
        // Lấy 8 sản phẩm có rating cao nhất để tạo ấn tượng tốt ban đầu
        List<Product> topRated = productRepository.findTop8ByIsActiveTrueOrderByAverageRatingDesc();

        // Nếu không có sản phẩm nào có rating (DB trống), fallback về sản phẩm mới nhất (8 items)
        if (topRated == null || topRated.isEmpty()) {
            return productRepository.findByIsActiveTrue(org.springframework.data.domain.PageRequest.of(0, 8)).getContent();
        }

        return topRated;

        // [FUTURE PHASE] - Sẽ xử lý Case 2 (Gender) và Case 3 (Search History) tại đây
        // logic: check redis for identifier -> if exists -> merge with behavior context
    }
}
