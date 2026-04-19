package com.service.ai;

import com.dto.ProductDTO;
import com.dto.RecommendationResponse;
import com.entity.Product;
import java.util.List;

/**
 * Service xử lý các thuật toán gợi ý sản phẩm (AI & Behavior Tracking)
 */
public interface RecommendationService {

    
    /**
     * Lấy danh sách sản phẩm gợi ý cho trang chủ (Lần đầu nạp)
     */
    List<Product> getHomepageRecommendations(String identifier);

    /**
     * Lấy danh sách sản phẩm gợi ý có phân trang (AJAX Load More)
     */
    RecommendationResponse getPaginatedRecommendations(String identifier, int page, int size);
}


