package com.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import com.entity.Category;
import com.entity.Role;
import com.repository.CategoryRepository;
import com.repository.RoleRepository;
import com.service.CategoryService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Component
public class DataInitializer implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(DataInitializer.class);
    private final CategoryRepository categoryRepository;
    private final RoleRepository roleRepository;
    private final org.springframework.cache.CacheManager cacheManager;

    public DataInitializer(CategoryRepository categoryRepository, 
                           RoleRepository roleRepository,
                           org.springframework.cache.CacheManager cacheManager) {
        this.categoryRepository = categoryRepository;
        this.roleRepository = roleRepository;
        this.cacheManager = cacheManager;
    }

    @Override
    public void run(String... args) throws Exception {
        // 0. Xóa sạch cache cũ để đảm bảo dữ liệu mới được hiển thị ngay lập tức
        if (cacheManager.getCache("categories") != null) {
            cacheManager.getCache("categories").clear();
            System.out.println(">>> [SMALL-CACHE] Logic Cleared categories cache!");
        }

        // 1. Khởi tạo Quyền hạn (Roles)
        System.out.println(">>> [SMALL-INIT] Checking Roles...");
        saveRole("USER", "Ng\u01B0\u1EDDi d\u00F9ng th\u00F4ng th\u01B0\u1EDDng");
        saveRole("SELLER", "Ng\u01B0\u1EDDi b\u00E1n h\u00E0ng");
        saveRole("ADMIN", "Qu\u1EA3n tr\u1ECB vi\u00EAn h\u1EC7 th\u1ED1ng");
        saveRole("SUPER_ADMIN", "Qu\u1EA3n tr\u1ECB vi\u00EAn c\u1EA5p cao");

        // 2. Dọn dẹp danh mục rác bị lặp lại trước khi nạp mới
        Category oldCat = categoryRepository.findBySlug("tui-va-vi");
        if (oldCat != null) {
            System.out.println(">>> [SMALL-INIT] Deleting duplicate category: tui-va-vi");
            categoryRepository.delete(oldCat);
        }

        // 3. Khởi tạo Danh mục (Categories)
        System.out.println(">>> [SMALL-INIT] Seeding Categories...");
        
        saveCategory("Th\u1EDDi Trang Nam", "thoi-trang-nam", "FASH_MAN", "https://img.icons8.com/color/96/t-shirt.png");
        saveCategory("Th\u1EDDi Trang N\u1EEF", "thoi-trang-nu", "FASH_WOMAN", "https://img.icons8.com/color/96/wedding-dress.png");
        saveCategory("Gi\u00E0y D\u00E9p", "giay-dep", "SHOES", "https://img.icons8.com/color/96/trainers.png");
        saveCategory("Th\u1EDDi Trang", "thoi-trang", "FASH", "https://img.icons8.com/color/96/t-shirt.png");
        saveCategory("S\u1EE9c Kh\u1ECFe & S\u1EAFc \u0110\u1EB9p", "suc-khoe-sac-dep", "BEAU", "https://img.icons8.com/color/96/medical-heart.png");
        saveCategory("\u0110\u1ED3ng H\u1ED3", "dong-ho", "WATCH", "https://img.icons8.com/color/96/womens-watch.png");
        
        // Danh mục túi với icon shopping-bag cực kỳ ổn định
        saveCategory("T\u00FAi X\u00E1ch & V\u00ED", "tui-vi", "BAGS", "https://img.icons8.com/color/96/shopping-bag.png");
        
        saveCategory("\u0110i\u1EC7n Tho\u1EA1i & Ph\u1EE5 Ki\u1EC7n", "dien-thoai-phu-kien", "PHONE", "https://img.icons8.com/color/96/smartphone.png");
        saveCategory("M\u00E1y T\u00EDnh & Laptop", "may-tinh-laptop", "LAPTOP", "https://img.icons8.com/color/96/laptop.png");
        saveCategory("M\u00E1y \u1EA3nh & Quay Phim", "may-anh-quay-phim", "CAMERA", "https://img.icons8.com/color/96/compact-camera.png");
        saveCategory("\u0110i\u1EC7n T\u1EED", "dien-tu", "ELEC", "https://img.icons8.com/color/96/electronics.png");
        saveCategory("\u0110\u1ED3 Gia D\u1EE5ng", "do-gia-dung", "HOUSE", "https://img.icons8.com/color/96/washing-machine.png");
        saveCategory("Nh\u00E0 C\u1EEDa & \u0110\u1EDDi S\u1ED1ng", "nha-cua-doi-song", "HOME", "https://img.icons8.com/color/96/home.png");
        saveCategory("D\u1EE5ng C\u1EE5 Nh\u00E0 B\u1EBFp", "dung-cu-nha-bep", "KITCHEN", "https://img.icons8.com/color/96/blender.png");
        saveCategory("S\u1EAFc \u0110\u1EB9p", "sac-dep", "BEAUTY", "https://img.icons8.com/color/96/lipstick.png");
        saveCategory("S\u1EE9c Kh\u1ECFe", "suc-khoe", "HEALTH", "https://img.icons8.com/color/96/medical-heart.png");
        saveCategory("M\u1EB9 & B\u00E9", "me-va-be", "KIDS", "https://img.icons8.com/color/96/baby-bottle.png");
        saveCategory("\u0110\u1ED3 Ch\u01A1i", "do-choi", "TOYS", "https://img.icons8.com/color/96/teddy-bear.png");
        saveCategory("B\u00E1ch H\u00F3a Online", "bach-hoa-online", "GROCERY", "https://img.icons8.com/color/96/shopping-basket.png");
        saveCategory("V\u1EC7 Sinh Nh\u00E0 C\u1EEDa", "ve-sinh-nha-cua", "CLEAN", "https://img.icons8.com/color/96/broom.png");
        saveCategory("S\u00E1ch & V\u0103n Ph\u00F2ng Ph\u1EA9m", "sach-van-phong-pham", "BOOKS", "https://img.icons8.com/color/96/books.png");
        saveCategory("Th\u1EC3 Thao & Du L\u1ECBch", "the-thao-du-lich", "SPORT", "https://img.icons8.com/color/96/football.png");

        System.out.println(">>> [SMALL-SUCCESS] Data Seeding complete!");
    }

    private void saveRole(String name, String description) {
        if (roleRepository.findByName(name) == null) {
            Role role = new Role();
            role.setName(name);
            role.setDescription(description);
            roleRepository.save(role);
            System.out.println(">>> [ROLE-INIT] Created role: " + name);
        }
    }

    private void saveCategory(String name, String slug, String code, String iconUrl) {
        Category category = categoryRepository.findBySlug(slug);
        if (category == null) {
            category = new Category();
            category.setSlug(slug);
        }
        category.setName(name);
        category.setCode(code);
        category.setIconUrl(iconUrl);
        category.setActive(true);
        categoryRepository.save(category);
    }
}
