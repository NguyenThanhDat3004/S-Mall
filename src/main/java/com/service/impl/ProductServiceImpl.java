package com.service.impl;

import com.dto.request.ProductCreateDTO;
import com.dto.request.ProductVariantDTO;
import com.entity.*;
import com.repository.*;
import com.service.ProductService;
import com.service.UploadService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class ProductServiceImpl implements ProductService {

    private static final Logger logger = LoggerFactory.getLogger(ProductServiceImpl.class);

    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;
    private final ShopRepository shopRepository;
    private final UploadService uploadService;

    public ProductServiceImpl(ProductRepository productRepository, 
                              CategoryRepository categoryRepository,
                              ShopRepository shopRepository,
                              UploadService uploadService) {
        this.productRepository = productRepository;
        this.categoryRepository = categoryRepository;
        this.shopRepository = shopRepository;
        this.uploadService = uploadService;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Product saveProduct(ProductCreateDTO dto, MultipartFile[] images, User user) throws Exception {
        // 1. Lấy Shop của User hiện tại
        Shop shop = shopRepository.findByUser(user)
                .orElseThrow(() -> new Exception("Bạn không có quyền đăng sản phẩm cho shop này!"));

        // 2. Lấy Category
        Category category = categoryRepository.findById(dto.getCategoryId())
                .orElseThrow(() -> new Exception("Danh mục không tồn tại!"));

        // 3. Khởi tạo Product
        Product product = new Product();
        product.setName(dto.getName());
        product.setSlug(dto.getSlug());
        product.setDescription(dto.getDescription());
        product.setCategory(category);
        product.setShop(shop);
        product.setCreatedAt(LocalDateTime.now());
        product.setUpdatedAt(LocalDateTime.now());
        product.setActive(true);
        product.setStatus("PUBLISHED");

        // 4. Xử lý Variants (Biến thể)
        List<ProductVariant> variants = new ArrayList<>();
        for (ProductVariantDTO varDto : dto.getVariants()) {
            ProductVariant variant = new ProductVariant();
            variant.setSku(varDto.getSku());
            variant.setPrice(varDto.getPrice());
            variant.setStock(varDto.getStock());
            variant.setProduct(product);
            
            // Xử lý ảnh riêng cho biến thể
            if (varDto.getVariantImage() != null && !varDto.getVariantImage().isEmpty()) {
                String varImgUrl = uploadService.saveImage(varDto.getVariantImage());
                variant.setImageUrl(varImgUrl);
            }
            
            variant.setAttributesJson("{\"name\": \"" + varDto.getName() + "\"}");
            variants.add(variant);
        }
        product.setVariants(variants);

        // 5. Xử lý Images (Hình ảnh)
        List<ProductImage> productImages = new ArrayList<>();
        if (images != null) {
            for (MultipartFile imgFile : images) {
                if (!imgFile.isEmpty()) {
                    String imageUrl = uploadService.saveImage(imgFile);
                    ProductImage productImage = new ProductImage();
                    productImage.setUrl(imageUrl);
                    productImage.setProduct(product);
                    productImage.setMain(productImages.isEmpty());
                    productImages.add(productImage);
                }
            }
        }
        product.setImages(productImages);

        // 6. Lưu tất cả (Cascade sẽ lưu cả Variants và Images)
        Product savedProduct = productRepository.save(product);

        // 7. Logging chi tiết theo yêu cầu (Liệt kê toàn bộ ID Biến thể và Ảnh)
        List<Long> variantIds = savedProduct.getVariants().stream()
                .map(ProductVariant::getId)
                .toList();
        
        List<Long> imageIds = savedProduct.getImages().stream()
                .map(ProductImage::getId)
                .toList();

        logger.info(">>> [SUCCESS] Shop {} (ID: {}) đã thêm mặt hàng (ID: {})", 
                shop.getName(), shop.getId(), savedProduct.getId());
        logger.info(">>> Chi tiết: {} biến thể (IDs: {}) | {} ảnh (IDs: {})",
                variantIds.size(), variantIds, imageIds.size(), imageIds);

        return savedProduct;
    }

    @Override
    public Page<Product> getAllActiveProducts(Pageable pageable) {
        return this.productRepository.findByIsActiveTrue(pageable);
    }

    @Override
    public Page<Product> getProductsByCategory(Category category, Pageable pageable) {
        return this.productRepository.findByCategoryAndIsActiveTrue(category, pageable);
    }

    @Override
    public Page<Product> getProductsByShop(Shop shop, Pageable pageable) {
        return this.productRepository.findByShopAndIsActiveTrue(shop, pageable);
    }

    @Override
    public Product getBySlug(String slug) {
        return this.productRepository.findBySlug(slug);
    }

    @Override
    public Product findById(Long id) {
        return this.productRepository.findById(id).orElse(null);
    }

    @Override
    public Product handleSaveProduct(Product product) {
        return this.productRepository.save(product);
    }

    @Override
    public void softDelete(Long id) {
        Product product = this.findById(id);
        if (product != null) {
            product.setActive(false);
            this.productRepository.save(product);
        }
    }
}
