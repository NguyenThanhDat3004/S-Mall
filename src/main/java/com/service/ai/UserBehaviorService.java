package com.service.ai;

/**
 * Service ghi nhận hành vi người dùng (Click, Search, Add to Cart) để phục vụ AI gợi ý.
 */
public interface UserBehaviorService {
    
    /**
     * Ghi nhận khi người dùng xem một sản phẩm
     * @param identifier userId hoặc sessionId
     * @param categoryId ID danh mục của sản phẩm đó
     * @param productName Tên sản phẩm để trích xuất từ khóa
     */
    void logProductView(String identifier, Long categoryId, String productName);

    /**
     * Ghi nhận khi người dùng tìm kiếm từ khóa
     * @param identifier userId hoặc sessionId
     * @param keyword Từ khóa tìm kiếm
     */
    void logSearch(String identifier, String keyword);

    /**
     * Ghi nhận khi người dùng thêm sản phẩm vào giỏ hàng (Trọng số cao hơn xem)
     */
    void logAddToCart(String identifier, Long categoryId, String productName);

    /**
     * Ghi nhận khi người dùng mua hàng (Trọng số cao nhất)
     */
    void logPurchase(String identifier, Long categoryId);
}
