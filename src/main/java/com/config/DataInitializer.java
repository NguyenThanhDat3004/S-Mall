package com.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import com.entity.*;
import com.repository.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Component
public class DataInitializer implements CommandLineRunner {

    private final CategoryRepository categoryRepository;
    private final RoleRepository roleRepository;
    private final ShopRepository shopRepository;
    private final ProductRepository productRepository;
    private final ProductVariantRepository productVariantRepository;
    private final ProductImageRepository productImageRepository;
    private final UserRepository userRepository;
    private final UserProfileRepository userProfileRepository;
    private final OrderRepository orderRepository;
    private final OrderDetailRepository orderDetailRepository;
    private final MembershipRankRepository membershipRankRepository;
    private final org.springframework.security.crypto.password.PasswordEncoder passwordEncoder;
    private final org.springframework.cache.CacheManager cacheManager;
    private final org.springframework.jdbc.core.JdbcTemplate jdbcTemplate;

    public DataInitializer(CategoryRepository categoryRepository, 
                           RoleRepository roleRepository,
                           ShopRepository shopRepository,
                           ProductRepository productRepository,
                           ProductVariantRepository productVariantRepository,
                           ProductImageRepository productImageRepository,
                           UserRepository userRepository,
                           UserProfileRepository userProfileRepository,
                           OrderRepository orderRepository,
                           OrderDetailRepository orderDetailRepository,
                           MembershipRankRepository membershipRankRepository,
                           org.springframework.security.crypto.password.PasswordEncoder passwordEncoder,
                           org.springframework.cache.CacheManager cacheManager,
                           org.springframework.jdbc.core.JdbcTemplate jdbcTemplate) {
        this.categoryRepository = categoryRepository;
        this.roleRepository = roleRepository;
        this.shopRepository = shopRepository;
        this.productRepository = productRepository;
        this.productVariantRepository = productVariantRepository;
        this.productImageRepository = productImageRepository;
        this.userRepository = userRepository;
        this.userProfileRepository = userProfileRepository;
        this.orderRepository = orderRepository;
        this.orderDetailRepository = orderDetailRepository;
        this.membershipRankRepository = membershipRankRepository;
        this.passwordEncoder = passwordEncoder;
        this.cacheManager = cacheManager;
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public void run(String... args) throws Exception {
        // 0. Sửa cấu trúc bảng để hỗ trợ Tiếng Việt (NVARCHAR)
        try {
            jdbcTemplate.execute("ALTER TABLE products ALTER COLUMN name NVARCHAR(255) NOT NULL");
            jdbcTemplate.execute("ALTER TABLE products ALTER COLUMN description NVARCHAR(MAX)");
            jdbcTemplate.execute("ALTER TABLE categories ALTER COLUMN name NVARCHAR(255) NOT NULL");
            jdbcTemplate.execute("ALTER TABLE shops ALTER COLUMN name NVARCHAR(255) NOT NULL");
            jdbcTemplate.execute("ALTER TABLE roles ALTER COLUMN name NVARCHAR(255) NOT NULL");
            jdbcTemplate.execute("ALTER TABLE user_profiles ALTER COLUMN full_name NVARCHAR(255)");
            jdbcTemplate.execute("ALTER TABLE addresses ALTER COLUMN full_address NVARCHAR(MAX)");
            // Đối với membership_ranks, do có constraint nên chúng ta sẽ xử lý cẩn thận hoặc bỏ qua nếu đã là NVARCHAR
        } catch (Exception e) {}

        // 1. Roles
        saveRole("USER", "Người dùng");
        saveRole("SELLER", "Người bán");
        saveRole("ADMIN", "Quản trị");
        saveRole("SHIPPER", "Đơn vị vận chuyển");

        // 2. Membership Ranks (NEW)
        System.out.println(">>> [SMALL-INIT] Cleaning and Seeding Membership Ranks...");
        membershipRankRepository.deleteAll(); // Xóa sạch để nạp lại chuẩn Unicode
        membershipRankRepository.flush();
        
        saveMembershipRank("ĐỒNG", 10);
        saveMembershipRank("BẠC", 1000);
        saveMembershipRank("VÀNG", 2000);
        saveMembershipRank("KIM CƯƠNG", 5000);

        // 3. Sample Users
        User nam = saveSampleUser("datnt@gmail.com", "123456", "USER", "Trần Hoàng Nam");
        User linh = saveSampleUser("linhltt@gmail.com", "123456", "USER", "Lê Thị Thùy Linh");
        User quan = saveSampleUser("quanpm@gmail.com", "123456", "USER", "Phạm Minh Quân");

        // 4. Categories & Products
        saveCategory("Điện Thoại", "dien-thoai", "PHONE", "https://img.icons8.com/color/96/smartphone.png");
        Shop defaultShop = shopRepository.findBySlug("s-mall-global");
        if (defaultShop == null) {
            defaultShop = new Shop();
            defaultShop.setName("S-Mall Global");
            defaultShop.setSlug("s-mall-global");
            defaultShop.setActive(true);
            defaultShop = shopRepository.save(defaultShop);
        }

        Product iphone = saveSampleProduct("iPhone 15 Pro Max", "iphone-15-pro-max", "IP15PM", "PHONE", defaultShop, 4.9, 32000000.0, 29500000.0, "https://images.unsplash.com/photo-1696446701796-da61225697cc?q=80&w=800");

        // 5. Orders for Ranking
        if (orderRepository.count() < 5) {
            saveSampleOrder(nam, iphone, 5);  
            saveSampleOrder(linh, iphone, 2); 
            saveSampleOrder(quan, iphone, 1); 
        }

        System.out.println(">>> [SMALL-SUCCESS] Seeding complete!");
    }

    private void saveMembershipRank(String name, long points) {
        if (membershipRankRepository.findByRankName(name).isEmpty()) {
            membershipRankRepository.save(new MembershipRank(name, points));
        }
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

    private Product saveSampleProduct(String name, String slug, String code, String catCode, Shop shop, Double rating, Double price, Double discountPrice, String imageUrl) {
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
        return product;
    }

    private User saveSampleUser(String email, String pass, String roleName, String fullName) {
        var existing = userRepository.findByEmail(email);
        if (existing.isPresent()) return existing.get();

        User user = new User();
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(pass));
        user.setRole(roleRepository.findByName(roleName));
        user.setActive(true);
        user = userRepository.save(user);

        UserProfile profile = new UserProfile();
        profile.setUser(user);
        profile.setFullName(fullName);
        profile.setPhoneNumber("0987654321");
        profile.setAddress("Hà Nội, Việt Nam");
        profile.setAvatarUrl("https://api.dicebear.com/7.x/avataaars/svg?seed=" + email);
        userProfileRepository.save(profile);
        return user;
    }

    private void saveSampleOrder(User user, Product product, int quantity) {
        ProductVariant variant = productVariantRepository.findByProductId(product.getId()).get(0);
        Order order = new Order();
        order.setAccount(user);
        order.setOrderCode("ORD-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        order.setStatus(com.constant.OrderStatus.DELIVERED);
        order.setTotalPrice(variant.getDiscountPrice() * quantity);
        order.setCreatedAt(LocalDateTime.now().minusDays(1));
        order = orderRepository.save(order);

        OrderDetail detail = new OrderDetail();
        detail.setOrder(order);
        detail.setProduct(product);
        detail.setProductVariant(variant);
        detail.setQuantity(quantity);
        detail.setPriceAtPurchase(variant.getDiscountPrice());
        orderDetailRepository.save(detail);
    }
}
