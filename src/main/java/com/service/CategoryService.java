package com.service;

import java.util.List;
import com.entity.Category;

public interface CategoryService {
    
    // Lấy toàn bộ thực thể đang hoạt động (Có Caching)
    List<Category> getAllCategories();
    
    // Lấy danh mục trà (Top-level)
    List<Category> getTopLevelCategories();
    
    // Tìm theo Slug (Có Caching)
    Category getBySlug(String slug);
    
    // Lưu và đồng thời Clear Cache (@CacheEvict)
    Category handleSaveCategory(Category category);
    
    // Xóa và Clear Cache
    void deleteById(Long id);
    
    // Tìm theo Id
    Category findById(Long id);
}
