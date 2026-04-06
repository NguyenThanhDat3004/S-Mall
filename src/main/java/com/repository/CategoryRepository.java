package com.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.entity.Category;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {
    
    // Lấy danh mục cha (top-level)
    List<Category> findByParentIsNull();
    
    // Tìm danh mục theo slug (cho SEO URL)
    Category findBySlug(String slug);
    
    // Tìm danh mục đang hoạt động
    List<Category> findByIsActiveTrue();
}
