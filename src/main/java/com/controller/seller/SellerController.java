package com.controller.seller;

import com.dto.request.ProductCreateDTO;
import com.entity.User;
import com.service.CategoryService;
import com.service.ProductService;
import com.service.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/seller")
public class SellerController {

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private ProductService productService;

    @Autowired
    private UserService userService;

    @GetMapping("/dashboard")
    public String getDashboard() {
        return "seller/dashboard";
    }

    @GetMapping("/product/create")
    public String getCreateProductPage(Model model, jakarta.servlet.http.HttpServletRequest request) {
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        if (session != null) {
            String message = (String) session.getAttribute("message");
            String messageType = (String) session.getAttribute("messageType");
            if (message != null) {
                model.addAttribute("message", message);
                model.addAttribute("messageType", messageType);
                session.removeAttribute("message");
                session.removeAttribute("messageType");
            }
        }

        if (!model.containsAttribute("productDTO")) {
            model.addAttribute("productDTO", new ProductCreateDTO());
        }
        model.addAttribute("categories", categoryService.getAllCategories());
        return "seller/product/create";
    }

    @PostMapping("/product/create")
    public String handleCreateProduct(
            @ModelAttribute("productDTO") @Valid ProductCreateDTO productDTO,
            BindingResult bindingResult,
            @RequestParam("images") MultipartFile[] images,
            Authentication authentication,
            jakarta.servlet.http.HttpSession session,
            Model model) {

        // 1. Kiểm tra lỗi Validation từ DTO
        if (bindingResult.hasErrors()) {
            model.addAttribute("categories", categoryService.getAllCategories());
            return "seller/product/create";
        }

        try {
            String email = authentication.getName();
            User currentUser = userService.getUserByEmail(email)
                    .orElseThrow(() -> new Exception("Người dùng không tồn tại!"));

            // 2. Thực hiện lưu
            productService.saveProduct(productDTO, images, currentUser);

            // 3. Dùng Flash Session pattern của bạn
            session.setAttribute("message", "Sản phẩm đã được đăng thành công!");
            session.setAttribute("messageType", "success");
            return "redirect:/seller/product/create"; // Quay lại trang tạo hoặc trang danh sách

        } catch (Exception e) {
            e.printStackTrace();
            // Lỗi cũng đẩy vào Session để hiển thị nhất quán
            session.setAttribute("message", "Có lỗi xảy ra: " + e.getMessage());
            session.setAttribute("messageType", "error");
            return "redirect:/seller/product/create";
        }
    }
}
