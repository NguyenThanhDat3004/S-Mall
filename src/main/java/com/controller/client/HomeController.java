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

    @GetMapping("/")
    public String index(Model model) {
        // [CASE 1] Sử dụng RecommendationService để lấy sản phẩm dựa trên thuật toán (Rating cao nhất cho khách lạ)
        List<Product> featuredProducts = recommendationService.getHomepageRecommendations(null);
        
        model.addAttribute("featuredProducts", featuredProducts);
        
        // Trả về view: WEB-INF/view/client/home/index.jsp
        return "client/home/index";
    }
}
