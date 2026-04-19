package com.service.ai;

/**
 * Service ghi nhận hành vi người dùng (Click, Search) để phục vụ AI gợi ý.
 */
public interface UserBehaviorService {
    
    /**
     * Ghi nhận khi người dùng xem một sản phẩm
     * @param identifier userId hoặc sessionId
     * @param categoryId ID danh mục của sản phẩm đó
     */
    void logProductView(String identifier, Long categoryId);

    /**
     * Ghi nhận khi người dùng tìm kiếm từ khóa
     * @param identifier userId hoặc sessionId
     * @param keyword Từ khóa tìm kiếm
     */
    void logSearch(String identifier, String keyword);
}
