package com.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import com.entity.Category;
import com.entity.Role;
import com.repository.CategoryRepository;
import com.repository.RoleRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Component
public class DataInitializer implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(DataInitializer.class);
    private final CategoryRepository categoryRepository;
    private final RoleRepository roleRepository;

    public DataInitializer(CategoryRepository categoryRepository, RoleRepository roleRepository) {
        this.categoryRepository = categoryRepository;
        this.roleRepository = roleRepository;
    }

    @Override
    public void run(String... args) throws Exception {
        // 1. Khởi tạo Quyền hạn (Roles)
        System.out.println(">>> [SMALL-INIT] Checking Roles...");
        saveRole("USER", "Ng\u01B0\u1EDDi d\u00F9ng th\u00F4ng th\u01B0\u1EDDng"); // Người dùng thông thường
        saveRole("SELLER", "Ng\u01B0\u1EDDi b\u00E1n h\u00E0ng"); // Người bán hàng
        saveRole("ADMIN", "Qu\u1EA3n tr\u1ECB vi\u00EAn h\u1EC7 th\u1ED1ng"); // Quản trị viên hệ thống
        saveRole("SUPER_ADMIN", "Qu\u1EA3n tr\u1ECB vi\u00EAn c\u1EA5p cao"); // Quản trị viên cấp cao

        // 2. Khởi tạo Danh mục (Categories)
        // PHƯƠNG ÁN QUYẾT LIỆT: Xóa sạch dữ liệu cũ để đảm bảo không còn dấu hỏi chấm
        categoryRepository.deleteAll();
        
        System.out.println(">>> [SMALL-INIT] Refreshed with Unicode Escape Seeding...");
        
        // Dùng mã Unicode Escape để đảm bảo không bị lỗi font dù biên dịch ở bất kỳ đâu
        saveCategory("Th\u1EDDi Trang", "thoi-trang", "FASH"); // Thời Trang
        saveCategory("\u0110i\u1EC7n T\u1EED", "dien-tu", "ELEC"); // Điện Tử
        saveCategory("Nh\u00E0 C\u1EEDa & \u0110\u1EDDi S\u1ED1ng", "nha-cua-doi-song", "HOME"); // Nhà Cửa & Đời Sống
        saveCategory("S\u1EE9c Kh\u1ECFe & S\u1EAFc \u0110\u1EB9p", "suc-khoe-sac-dep", "BEAU"); // Sức Khỏe & Sắc Đẹp
        saveCategory("M\u1EB9 & B\u00E9", "me-va-be", "KIDS"); // Mẹ & Bé

        System.out.println(">>> [SMALL-SUCCESS] Data Seeding complete using Escape Codes!");
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

    private void saveCategory(String name, String slug, String code) {
        Category category = new Category();
        category.setName(name);
        category.setSlug(slug);
        category.setCode(code);
        category.setActive(true);
        categoryRepository.save(category);
    }
}
