package com.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import com.entity.Category;
import com.entity.Role;
import com.entity.Product;
import com.entity.ProductVariant;
import com.entity.ProductImage;
import com.entity.Shop;
import com.repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Component
public class DataInitializer implements CommandLineRunner {

    private final CategoryRepository categoryRepository;
    private final RoleRepository roleRepository;
    private final ShopRepository shopRepository;
    private final ProductRepository productRepository;
    private final ProductVariantRepository productVariantRepository;
    private final ProductImageRepository productImageRepository;
    private final org.springframework.cache.CacheManager cacheManager;
    private final org.springframework.jdbc.core.JdbcTemplate jdbcTemplate;

    public DataInitializer(CategoryRepository categoryRepository, 
                           RoleRepository roleRepository,
                           ShopRepository shopRepository,
                           ProductRepository productRepository,
                           ProductVariantRepository productVariantRepository,
                           ProductImageRepository productImageRepository,
                           org.springframework.cache.CacheManager cacheManager,
                           org.springframework.jdbc.core.JdbcTemplate jdbcTemplate) {
        this.categoryRepository = categoryRepository;
        this.roleRepository = roleRepository;
        this.shopRepository = shopRepository;
        this.productRepository = productRepository;
        this.productVariantRepository = productVariantRepository;
        this.productImageRepository = productImageRepository;
        this.cacheManager = cacheManager;
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public void run(String... args) throws Exception {
        // 0. Sửa cấu trúc bảng và xóa dữ liệu lỗi (Chạy 1 lần để fix font)
        try {
            System.out.println(">>> [SMALL-FIX] Altering products table to NVARCHAR...");
            jdbcTemplate.execute("ALTER TABLE products ALTER COLUMN name NVARCHAR(255) NOT NULL");
            
            System.out.println(">>> [SMALL-FIX] Wiping corrupted product data...");
            productImageRepository.deleteAll();
            productVariantRepository.deleteAll();
            productRepository.deleteAll();
        } catch (Exception e) {
            System.err.println(">>> [SMALL-FIX] Schema already correct or error: " + e.getMessage());
        }

        // 0.1 Xóa cache
        if (cacheManager.getCache("categories") != null) {
            cacheManager.getCache("categories").clear();
        }

        // 1. Roles
        saveRole("USER", "Ng\u01B0\u1EDDi d\u00F9ng");
        saveRole("SELLER", "Ng\u01B0\u1EDDi b\u00E1n");
        saveRole("ADMIN", "Qu\u1EA3n tr\u1ECB");

        // 2. Categories
        saveCategory("Th\u1EDDi Trang Nam", "thoi-trang-nam", "FASH_MAN", "https://img.icons8.com/color/96/t-shirt.png");
        saveCategory("Th\u1EDDi Trang N\u1EEF", "thoi-trang-nu", "FASH_WOMAN", "https://img.icons8.com/color/96/wedding-dress.png");
        saveCategory("Gi\u00E0y D\u00E9p", "giay-dep", "SHOES", "https://img.icons8.com/color/96/trainers.png");
        saveCategory("\u0110i\u1EC7n Tho\u1EA1i", "dien-thoai", "PHONE", "https://img.icons8.com/color/96/smartphone.png");
        saveCategory("Laptop", "laptop", "LAPTOP", "https://img.icons8.com/color/96/laptop.png");
        saveCategory("M\u00E1y \u1EA3nh", "may-anh", "CAMERA", "https://img.icons8.com/color/96/compact-camera.png");
        saveCategory("T\u00FAi X\u00E1ch", "tui-xach", "BAGS", "https://img.icons8.com/color/96/shopping-bag.png");
        saveCategory("M\u1EF9 Ph\u1EA9m", "my-pham", "BEAUTY", "https://img.icons8.com/color/96/lipstick.png");

        // 3. Shop
        Shop defaultShop = shopRepository.findBySlug("s-mall-global");
        if (defaultShop == null) {
            defaultShop = new Shop();
            defaultShop.setName("S-Mall Global");
            defaultShop.setSlug("s-mall-global");
            defaultShop.setActive(true);
            defaultShop = shopRepository.save(defaultShop);
        }

        // 4. Seeding 30 Products
        System.out.println(">>> [SMALL-INIT] Seeding 30 Products...");

        // PHONE (6)
        saveSampleProduct("iPhone 15 Pro Max", "iphone-15-pro-max", "IP15PM", "PHONE", defaultShop, 4.9, 32000000.0, 29500000.0, "https://images.unsplash.com/photo-1696446701796-da61225697cc?q=80&w=800");
        saveSampleProduct("Samsung S24 Ultra", "samsung-s24-ultra", "S24U", "PHONE", defaultShop, 4.8, 30000000.0, 26000000.0, "https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?q=80&w=800");
        saveSampleProduct("Xiaomi 14 Ultra", "xiaomi-14-ultra", "XI14U", "PHONE", defaultShop, 4.5, 25000000.0, 22000000.0, "https://images.unsplash.com/photo-1598327105666-5b89351aff97?q=80&w=800");
        saveSampleProduct("Google Pixel 8 Pro", "google-pixel-8-pro", "GP8P", "PHONE", defaultShop, 4.7, 22000000.0, 19500000.0, "https://images.unsplash.com/photo-1696429130002-86105f2fa619?q=80&w=800");
        saveSampleProduct("OnePlus 12 5G", "oneplus-12", "OP12", "PHONE", defaultShop, 4.6, 18000000.0, 16500000.0, "https://images.unsplash.com/photo-1612441304231-a9d08310ba5c?q=80&w=800");
        saveSampleProduct("Oppo Find X7 Ultra", "oppo-find-x7", "OPX7U", "PHONE", defaultShop, 4.4, 21000000.0, 19000000.0, "https://images.unsplash.com/photo-1541807084-5c52b6b3adef?q=80&w=800");

        // LAPTOP (6)
        saveSampleProduct("MacBook Air M3", "macbook-air-m3", "MBA-M3", "LAPTOP", defaultShop, 5.0, 28000000.0, 26900000.0, "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=800");
        saveSampleProduct("Dell XPS 13", "dell-xps-13", "XPS13", "LAPTOP", defaultShop, 4.7, 45000000.0, 42000000.0, "https://images.unsplash.com/photo-1593642632823-8f785ba67e45?q=80&w=800");
        saveSampleProduct("ASUS ROG G14", "asus-rog-g14", "G14", "LAPTOP", defaultShop, 4.6, 38000000.0, 35000000.0, "https://images.unsplash.com/photo-1603302576837-37561b2e2302?q=80&w=800");
        saveSampleProduct("Lenovo Legion 5", "lenovo-legion-5", "LEG5", "LAPTOP", defaultShop, 4.8, 32000000.0, 30500000.0, "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?q=80&w=800");
        saveSampleProduct("HP Spectre x360", "hp-spectre-x360", "HPSX", "LAPTOP", defaultShop, 4.5, 40000000.0, 38500000.0, "https://images.unsplash.com/photo-1544006659-f0b21f04cb1d?q=80&w=800");
        saveSampleProduct("Acer Predator 16", "acer-predator-16", "ACPH", "LAPTOP", defaultShop, 4.3, 29000000.0, 27000000.0, "https://images.unsplash.com/photo-1517694712202-14dd9538aa97?q=80&w=800");

        // FASHION (6)
        saveSampleProduct("\u00C1o Thun Unisex", "ao-thun-unisex", "TEE-01", "FASH_MAN", defaultShop, 4.2, 250000.0, 199000.0, "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=800");
        saveSampleProduct("Qu\u1EA7n Jean Nam", "quan-jean-nam", "JEAN-01", "FASH_MAN", defaultShop, 4.0, 450000.0, 350000.0, "https://images.unsplash.com/photo-1542272604-787c3835535d?q=80&w=800");
        saveSampleProduct("V\u00E1y Hoa Nh\u00ED", "vay-hoa-nhi", "DRESS-01", "FASH_WOMAN", defaultShop, 4.4, 350000.0, 280000.0, "https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?q=80&w=800");
        saveSampleProduct("Blazer N\u1EEF", "blazer-nu", "BLZ-01", "FASH_WOMAN", defaultShop, 4.6, 650000.0, 550000.0, "https://images.unsplash.com/photo-1591047139829-d91aecb6caea?q=80&w=800");
        saveSampleProduct("Qu\u1EA7n Short Th\u1EC3 Thao", "short-sport", "SH-01", "FASH_MAN", defaultShop, 4.1, 150000.0, 120000.0, "https://images.unsplash.com/photo-1591195853828-11db59a44f6b?q=80&w=800");
        saveSampleProduct("Ch\u00E2n V\u00E1y X\u1EBFp Ly", "chan-vay-xep-ly", "SK-01", "FASH_WOMAN", defaultShop, 4.3, 220000.0, 180000.0, "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?q=80&w=800");

        // SHOES (4)
        saveSampleProduct("Adidas Samba", "adidas-samba", "AD-SAM", "SHOES", defaultShop, 4.8, 2800000.0, 2500000.0, "https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=800");
        saveSampleProduct("Nike Pegasus", "nike-pegasus", "NIKE-PEG", "SHOES", defaultShop, 4.7, 3500000.0, 2900000.0, "https://images.unsplash.com/photo-1549298916-b41d501d3772?q=80&w=800");
        saveSampleProduct("D\u00E9p Unisex", "dep-unisex", "SLIDE-01", "SHOES", defaultShop, 3.9, 250000.0, 180000.0, "https://images.unsplash.com/photo-1603808033192-082d6f74b301?q=80&w=800");
        saveSampleProduct("Gi\u00E0y Cao G\u00F3t", "heels-7cm", "HEEL-01", "SHOES", defaultShop, 4.5, 550000.0, 450000.0, "https://images.unsplash.com/photo-1543163521-1bf539c55dd2?q=80&w=800");

        // BAGS (4)
        saveSampleProduct("T\u00FAi Tote", "tui-tote", "BAG-01", "BAGS", defaultShop, 3.8, 120000.0, 89000.0, "https://images.unsplash.com/photo-1544816155-12df9643f363?q=80&w=800");
        saveSampleProduct("V\u00ED Da N\u1EEF", "vi-da-nu", "WALLET-01", "BAGS", defaultShop, 4.6, 550000.0, 450000.0, "https://images.unsplash.com/photo-1627123424574-724758594e93?q=80&w=800");
        saveSampleProduct("Ba L\u00F4 Laptop", "balo-laptop", "BP-01", "BAGS", defaultShop, 4.3, 450000.0, 380000.0, "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?q=80&w=800");
        saveSampleProduct("T\u00FAi \u0110eo Ch\u00E9o Nam", "cross-body", "CB-01", "BAGS", defaultShop, 4.1, 280000.0, 220000.0, "https://images.unsplash.com/photo-1547949003-9792a18a2601?q=80&w=800");

        // BEAUTY (4)
        saveSampleProduct("Son MAC Powder", "mac-powder", "MAC-01", "BEAUTY", defaultShop, 4.9, 650000.0, 580000.0, "https://images.unsplash.com/photo-1586790170083-2f9ceadc732d?q=80&w=800");
        saveSampleProduct("Kem Neutrogena", "neutrogena", "NTG-01", "BEAUTY", defaultShop, 4.7, 450000.0, 380000.0, "https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=800");
        saveSampleProduct("T\u1EA9y Trang Bioderma", "bioderma", "BIO-01", "BEAUTY", defaultShop, 5.0, 420000.0, 350000.0, "https://images.unsplash.com/photo-1556228578-0d85b1a4d571?q=80&w=800");
        saveSampleProduct("Kem LRP Anthelios", "lrp-anthelios", "LRP-01", "BEAUTY", defaultShop, 4.8, 520000.0, 460000.0, "https://images.unsplash.com/photo-1556229167-da31d9393799?q=80&w=800");

        System.out.println(">>> [SMALL-SUCCESS] Seeding complete!");
    }

    private void saveRole(String name, String description) {
        if (roleRepository.findByName(name) == null) {
            Role role = new Role();
            role.setName(name);
            role.setDescription(description);
            roleRepository.save(role);
        }
    }

    private void saveCategory(String name, String slug, String code, String iconUrl) {
        Category category = categoryRepository.findByCode(code);
        if (category == null) {
            category = new Category();
            category.setCode(code);
        }
        category.setName(name);
        category.setSlug(slug);
        category.setIconUrl(iconUrl);
        category.setActive(true);
        categoryRepository.save(category);
    }

    private void saveSampleProduct(String name, String slug, String code, String catCode, Shop shop, Double rating, Double price, Double discountPrice, String imageUrl) {
        Product product = productRepository.findBySlug(slug);
        boolean isNew = false;
        if (product == null) {
            product = new Product();
            product.setSlug(slug);
            product.setShop(shop);
            isNew = true;
        }
        
        Category cat = categoryRepository.findByCode(catCode);
        product.setCategory(cat != null ? cat : categoryRepository.findAll().get(0));
        product.setName(name);
        product.setActive(true);
        product.setStatus("PUBLISHED");
        product.setAverageRating(rating);
        product.setDescription("M\u00F4 t\u1EA3 cho " + name);
        product = productRepository.save(product);

        if (isNew) {
            ProductImage pImage = new ProductImage();
            pImage.setUrl(imageUrl);
            pImage.setMain(true);
            pImage.setProduct(product);
            productImageRepository.save(pImage);
            
            ProductVariant variant = new ProductVariant();
            variant.setProduct(product);
            variant.setSku(code + "-DEF");
            variant.setPrice(price);
            variant.setDiscountPrice(discountPrice);
            variant.setStock(100);
            productVariantRepository.save(variant);
        }
    }

}
