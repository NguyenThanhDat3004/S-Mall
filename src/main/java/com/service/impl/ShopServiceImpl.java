package com.service.impl;

import com.dto.request.ShopRegistrationDTO;
import com.entity.Role;
import com.entity.Shop;
import com.entity.User;
import com.repository.RoleRepository;
import com.repository.ShopRepository;
import com.repository.UserRepository;
import com.service.ShopService;
import com.service.UploadService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.text.Normalizer;
import java.util.regex.Pattern;

@Service
public class ShopServiceImpl implements ShopService {

    @Autowired
    private ShopRepository shopRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private UploadService uploadService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Shop registerShop(ShopRegistrationDTO dto, User user) throws IOException {
        // 0. Kiểm tra xem người dùng đã có Shop chưa
        if (shopRepository.findByUser(user).isPresent()) {
            throw new RuntimeException("Bạn đã có một cửa hàng trên hệ thống. Mỗi tài khoản chỉ được phép sở hữu một cửa hàng.");
        }

        Shop shop = new Shop();
        shop.setName(dto.getName());
        shop.setDescription(dto.getDescription());
        shop.setUser(user);

        shop.setActive(true);

        // 1. Tạo Slug
        String slug = slugify(dto.getName());
        shop.setSlug(slug);

        // 2. Xử lý Logo
        if (dto.getLogoFile() != null && !dto.getLogoFile().isEmpty()) {
            String logoUrl = uploadService.saveImage(dto.getLogoFile());
            shop.setLogoUrl(logoUrl);
        }

        // 3. Cập nhật Role người dùng thành SELLER
        // Đổi thành "SELLER" để khớp với "USER", "ADMIN" trong DB của bạn
        Role sellerRole = roleRepository.findByName("SELLER");
        if (sellerRole == null) {
            sellerRole = new Role();
            sellerRole.setName("SELLER");
            sellerRole.setDescription("Quyền người bán hàng");
            roleRepository.save(sellerRole);
        }
        
        user.setRole(sellerRole);
        userRepository.save(user);

        return shopRepository.save(shop);
    }

    private String slugify(String input) {
        if (input == null || input.isEmpty()) return "";
        String normalized = Normalizer.normalize(input, Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        String slug = pattern.matcher(normalized).replaceAll("").toLowerCase();
        slug = slug.replace('đ', 'd').replace('Đ', 'd');
        slug = slug.replaceAll("[^a-z0-9\\s-]", "");
        slug = slug.replaceAll("\\s+", "-");
        slug = slug.replaceAll("-+", "-");
        return slug.replaceAll("^-|-$", "");
    }
}
