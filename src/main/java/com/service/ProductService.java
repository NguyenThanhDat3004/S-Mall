package com.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.entity.Category;
import com.entity.Product;
import com.entity.Shop;

public interface ProductService {
    
    // Lấy tất cả sản phẩm đang hoạt động với phân trang
    Page<Product> getAllActiveProducts(Pageable pageable);
    
    // Tìm sản phẩm theo danh mục
    Page<Product> getProductsByCategory(Category category, Pageable pageable);
    
    // Tìm sản phẩm theo Shop
    Page<Product> getProductsByShop(Shop shop, Pageable pageable);
    
    // Tìm sản phẩm theo Slug
    Product getBySlug(String slug);
    
    // Tìm sản phẩm theo ID
    Product findById(Long id);
    
    // Lưu sản phẩm
    Product handleSaveProduct(Product product);
    
    // Lưu sản phẩm mới từ DTO (bao gồm biến thể và ảnh)
    Product saveProduct(com.dto.request.ProductCreateDTO dto, org.springframework.web.multipart.MultipartFile[] images, com.entity.User user) throws Exception;

    // Xóa mềm (Soft Delete) bằng cách set isActive = false
    void softDelete(Long id);
}
