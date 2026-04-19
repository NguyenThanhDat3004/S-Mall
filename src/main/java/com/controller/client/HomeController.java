package com.controller.client;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.data.domain.PageRequest;
import com.entity.Product;
import com.service.ai.RecommendationService;

@Controller
public class HomeController {

    @Autowired
    private RecommendationService recommendationService;

    @Autowired
    private com.service.CategoryService categoryService;

    @Autowired
    private com.repository.ProductRepository productRepository;

    @Autowired
    private com.service.ai.UserBehaviorService userBehaviorService;


    @GetMapping("/")
    public String index(Model model, jakarta.servlet.http.HttpSession session, java.security.Principal principal) {
        // [AI INTEGRATION] Lấy định danh người dùng (Session hoặc Username)
        String identifier = (principal != null) ? principal.getName() : session.getId();
        
        // 1. Lấy sản phẩm gợi ý cá nhân hóa
        List<Product> featuredProducts = recommendationService.getHomepageRecommendations(identifier);

        // 1.1 Kiểm tra xem Database còn hàng sau lô 18 cái đầu không
        boolean hasNext = productRepository.findByIsActiveTrueOrderByAverageRatingDesc(PageRequest.of(0, 18)).hasNext();
        
        // 2. Lấy toàn bộ danh mục để hiển thị thanh điều hướng động
        List<com.entity.Category> categories = categoryService.getAllCategories();
        
        model.addAttribute("featuredProducts", featuredProducts);
        model.addAttribute("categories", categories);
        model.addAttribute("hasNextInitial", hasNext);
        
        return "client/home/index";
    }


    @GetMapping("/search")
    public String search(@org.springframework.web.bind.annotation.RequestParam String query, 
                         Model model, 
                         jakarta.servlet.http.HttpSession session, 
                         java.security.Principal principal) {
        // [AI TRACKING] Lưu từ khóa tìm kiếm vào Redis
        String identifier = (principal != null) ? principal.getName() : session.getId();
        userBehaviorService.logSearch(identifier, query);
        
        // Tìm kiếm sản phẩm (Lấy 20 kết quả đầu tiên)
        org.springframework.data.domain.Page<com.entity.Product> searchResults = 
            productRepository.findByNameContainingAndIsActiveTrue(query, org.springframework.data.domain.PageRequest.of(0, 20));
            
        model.addAttribute("products", searchResults.getContent());
        model.addAttribute("query", query);
        model.addAttribute("categories", categoryService.getAllCategories());
        
        return "client/home/search";
    }

}
