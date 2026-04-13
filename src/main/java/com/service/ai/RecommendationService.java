package com.service.ai;

import java.util.List;
import com.entity.Product;

/**
 * Service xử lý các thuật toán gợi ý sản phẩm (AI & Behavior Tracking)
 */
public interface RecommendationService {
    
    /**
     * Lấy danh sách sản phẩm gợi ý cho trang chủ
     * @param identifier (UserId hoặc SessionId)
     * @return List sản phẩm đã qua lọc/sắp xếp
     */
    List<Product> getHomepageRecommendations(String identifier);
}
