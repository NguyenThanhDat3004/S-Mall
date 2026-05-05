package com.controller.seller;

import com.dto.request.ProductCreateDTO;
import com.dto.request.ProductVariantDTO;
import com.entity.Product;
import com.entity.ProductVariant;
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

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

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

    @GetMapping("/product/show")
    public String getShowProductsPage(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            jakarta.servlet.http.HttpSession session,
            Model model) {
        
        Long shopId = (Long) session.getAttribute("shopId");
        if (shopId == null) {
            return "redirect:/login";
        }

        org.springframework.data.domain.Page<com.entity.Product> productPage = 
            productService.getProductsByShopId(shopId, org.springframework.data.domain.PageRequest.of(page, size));
        
        model.addAttribute("products", productPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", productPage.getTotalPages());
        model.addAttribute("totalElements", productPage.getTotalElements());
        
        return "seller/product/show";
    }

    @GetMapping("/product/load-more")
    public String getLoadMoreProducts(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            jakarta.servlet.http.HttpSession session,
            Model model) {
        
        Long shopId = (Long) session.getAttribute("shopId");
        if (shopId == null) return null;

        org.springframework.data.domain.Page<com.entity.Product> productPage = 
            productService.getProductsByShopId(shopId, org.springframework.data.domain.PageRequest.of(page, size));
        
        model.addAttribute("products", productPage.getContent());
        return "seller/product/product_items";
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
    @GetMapping("/product/edit/{id}")
    public String getEditProductPage(@PathVariable Long id, Model model, Authentication authentication) {
        com.entity.Product product = productService.findById(id);
        if (product == null) return "redirect:/seller/product/show";

        // Chuyển đổi Product sang ProductCreateDTO
        ProductCreateDTO dto = new ProductCreateDTO();
        dto.setId(product.getId());
        dto.setName(product.getName());
        dto.setSlug(product.getSlug());
        dto.setDescription(product.getDescription());
        dto.setCategoryId(product.getCategory().getId());

        java.util.List<ProductVariantDTO> variantDTOs = new ArrayList<>();
        for (com.entity.ProductVariant v : product.getVariants()) {
            ProductVariantDTO vDto = new ProductVariantDTO();
            vDto.setId(v.getId());
            vDto.setPrice(v.getPrice());
            vDto.setStock(v.getStock());
            vDto.setSku(v.getSku());
            
            // Lấy name từ attributesJson (giả định định dạng {"name": "..."})
            try {
                String json = v.getAttributesJson();
                if (json != null && json.contains("\"name\":")) {
                    String name = json.split("\"name\":")[1].split("\"")[1];
                    vDto.setName(name);
                }
            } catch (Exception e) {
                vDto.setName("Biến thể");
            }
            variantDTOs.add(vDto);
        }
        dto.setVariants(variantDTOs);

        model.addAttribute("productDTO", dto);
        model.addAttribute("categories", categoryService.getAllCategories());
        model.addAttribute("isEdit", true);
        return "seller/product/create"; // Dùng chung giao diện với create
    }

    @PostMapping("/product/edit/{id}")
    public String handleUpdateProduct(
            @PathVariable Long id,
            @ModelAttribute("productDTO") @Valid ProductCreateDTO productDTO,
            BindingResult bindingResult,
            @RequestParam(value = "images", required = false) MultipartFile[] images,
            Authentication authentication,
            jakarta.servlet.http.HttpSession session,
            Model model) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("categories", categoryService.getAllCategories());
            model.addAttribute("isEdit", true);
            return "seller/product/create";
        }

        try {
            productDTO.setId(id);
            User currentUser = userService.getUserByEmail(authentication.getName()).get();
            productService.saveProduct(productDTO, images, currentUser);

            session.setAttribute("message", "Cập nhật sản phẩm thành công!");
            session.setAttribute("messageType", "success");
            return "redirect:/seller/product/show";
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "Lỗi cập nhật: " + e.getMessage());
            session.setAttribute("messageType", "error");
            return "redirect:/seller/product/edit/" + id;
        }
    }
    @PostMapping("/product/delete/{id}")
    @ResponseBody
    public java.util.Map<String, Object> handleSoftDelete(@PathVariable Long id) {
        java.util.Map<String, Object> response = new java.util.HashMap<>();
        try {
            productService.softDelete(id);
            response.put("success", true);
            response.put("message", "Đã xóa sản phẩm thành công!");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi: " + e.getMessage());
        }
        return response;
    }

    @GetMapping("/ai/agent")
    public String getAiAgentPage() {
        return "seller/ai/agent";
    }
}


