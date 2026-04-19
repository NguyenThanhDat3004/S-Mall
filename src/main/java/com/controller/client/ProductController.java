package com.controller.client;

import com.entity.Product;
import com.service.ProductService;
import com.service.ai.UserBehaviorService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.security.Principal;

@Controller("clientProductController")
public class ProductController {

    @Autowired
    private ProductService productService;

    @Autowired
    private UserBehaviorService userBehaviorService;

    @GetMapping("/product/{slug}")
    public String getProductDetail(@PathVariable String slug, Model model, HttpSession session, Principal principal) {
        Product product = productService.getBySlug(slug);
        
        if (product != null) {
            // [AI TRACKING] Ghi nhận hành vi click của khách hàng
            // Nếu đã login dùng username, nếu chưa login dùng Session ID
            String identifier = (principal != null) ? principal.getName() : session.getId();
            
            if (product.getCategory() != null) {
                userBehaviorService.logProductView(identifier, product.getCategory().getId());
            }
            
            model.addAttribute("product", product);
            return "client/product/detail";
        }
        
        return "redirect:/"; // Fallback nếu không tìm thấy sản phẩm
    }
}
