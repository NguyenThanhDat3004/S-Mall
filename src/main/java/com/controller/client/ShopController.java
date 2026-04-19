package com.controller.client;

import com.dto.request.ShopRegistrationDTO;
import com.entity.User;
import com.service.ShopService;
import com.service.UserService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/shop")
public class ShopController {

    @Autowired
    private ShopService shopService;

    @Autowired
    private UserService userService;

    @Autowired
    private com.repository.ShopRepository shopRepository;

    @Autowired
    private org.springframework.data.redis.core.RedisTemplate<String, Object> redisTemplate;

    @GetMapping("/register")
    public String getRegisterPage(Model model, Authentication authentication) {
        String email = authentication.getName();
        User user = userService.getUserByEmail(email).orElse(null);

        // 1. Chỉ kiểm tra sô hồ sơ Shop trong DB (phòng trường hợp Role chưa cập nhật)
        if (user != null && shopRepository.findByUser(user).isPresent()) {
            return "redirect:/seller/dashboard";
        }

        if (!model.containsAttribute("shopDTO")) {
            model.addAttribute("shopDTO", new ShopRegistrationDTO());
        }
        return "client/seller/register";
    }

    @PostMapping("/register")
    public String handleRegister(
            @ModelAttribute("shopDTO") @Valid ShopRegistrationDTO shopDTO,
            BindingResult bindingResult,
            Authentication authentication,
            jakarta.servlet.http.HttpServletRequest request,
            jakarta.servlet.http.HttpServletResponse response,
            HttpSession session,
            Model model) {

        if (bindingResult.hasErrors()) {
            return "client/seller/register";
        }

        try {
            String email = authentication.getName();
            User currentUser = userService.getUserByEmail(email)
                    .orElseThrow(() -> new Exception("Người dùng không tồn tại!"));

            // 1. Thực hiện đăng ký Shop và nâng cấp Role trong DB
            com.entity.Shop savedShop = shopService.registerShop(shopDTO, currentUser);

            // 2. Cập nhật Session ngay lập tức cho Giao diện
            session.setAttribute("userRole", "SELLER");
            session.setAttribute("roleId", 2L);
            session.setAttribute("shopId", savedShop.getId());
            session.setAttribute("shopName", savedShop.getName());
            session.setAttribute("shopLogoUrl", savedShop.getLogoUrl());
            if (currentUser.getProfile() != null) {
                String avatarUrl = currentUser.getProfile().getAvatarUrl();
                session.setAttribute("userAvatarUrl", avatarUrl);
                
                // Lưu thủ công vào Redis cho đồng bộ
                if (avatarUrl != null) {
                    redisTemplate.opsForValue().set("USER_AVATAR:" + email, avatarUrl);
                }
            }
            
            // Lưu logo vào Redis
            if (savedShop.getLogoUrl() != null) {
                redisTemplate.opsForValue().set("USER_LOGO:" + email, savedShop.getLogoUrl());
            }

            // 3. LOGIC QUYẾT ĐỊNH: Nâng cấp Authority trong SecurityContext
            // Thêm quyền ROLE_SELLER vào danh sách quyền hiện tại của User
            java.util.List<org.springframework.security.core.GrantedAuthority> currentAuthorities = 
                new java.util.ArrayList<>(authentication.getAuthorities());
            
            if (currentAuthorities.stream().noneMatch(a -> a.getAuthority().equals("ROLE_SELLER"))) {
                currentAuthorities.add(new org.springframework.security.core.authority.SimpleGrantedAuthority("ROLE_SELLER"));
            }
            
            org.springframework.security.authentication.UsernamePasswordAuthenticationToken newAuth = 
                new org.springframework.security.authentication.UsernamePasswordAuthenticationToken(
                    authentication.getPrincipal(), 
                    authentication.getCredentials(), 
                    currentAuthorities);
            
            org.springframework.security.core.context.SecurityContext context = org.springframework.security.core.context.SecurityContextHolder.createEmptyContext();
            context.setAuthentication(newAuth);
            org.springframework.security.core.context.SecurityContextHolder.setContext(context);
            
            // Lưu Context vào Session để duy trì quyền cho các request sau
            org.springframework.security.web.context.HttpSessionSecurityContextRepository repository = 
                new org.springframework.security.web.context.HttpSessionSecurityContextRepository();
            repository.saveContext(context, request, response);

            return "redirect:/seller/dashboard";

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "client/seller/register";
        }
    }
}
