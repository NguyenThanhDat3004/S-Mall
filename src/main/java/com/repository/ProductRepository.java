package com.repository;

import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.entity.Category;
import com.entity.Product;
import com.entity.Shop;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    
    // Tìm sản phẩm theo danh mục có phân trang
    Page<Product> findByCategoryAndIsActiveTrue(Category category, Pageable pageable);
    
    // Tìm sản phẩm của Shop có phân trang
    Page<Product> findByShopAndIsActiveTrue(Shop shop, Pageable pageable);
    
    // Tìm sản phẩm theo tên (Like) có phân trang
    Page<Product> findByNameContainingAndIsActiveTrue(String name, Pageable pageable);
    
    // Tìm sản phẩm theo slug (cho SEO URL)
    Product findBySlug(String slug);
    
    // Lấy tất cả sản phẩm đang hoạt động có phân trang
    Page<Product> findByIsActiveTrue(Pageable pageable);

    // [CASE 1] Lấy 8 sản phẩm đánh giá cao nhất đang hoạt động
    List<Product> findTop8ByIsActiveTrueOrderByAverageRatingDesc();
}
