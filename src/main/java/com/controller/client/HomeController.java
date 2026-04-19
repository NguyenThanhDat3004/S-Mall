package com.controller.client;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import com.entity.Product;
import com.service.ai.RecommendationService;

@Controller
public class HomeController {

    @Autowired
    private RecommendationService recommendationService;

    @Autowired
    private com.service.CategoryService categoryService;

    @GetMapping("/")
    public String index(Model model) {
        // 1. Lấy sản phẩm gợi ý
        List<Product> featuredProducts = recommendationService.getHomepageRecommendations(null);
        
        // 2. Lấy toàn bộ danh mục để hiển thị thanh điều hướng động
        List<com.entity.Category> categories = categoryService.getAllCategories();
        
        model.addAttribute("featuredProducts", featuredProducts);
        model.addAttribute("categories", categories);
        
        return "client/home/index";
    }
}
