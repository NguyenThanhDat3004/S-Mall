package com.controller.client;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import com.entity.Product;
import com.service.ProductService;

@Controller
public class HomeController {

    @Autowired
    private ProductService productService;

    @GetMapping("/")
    public String index(Model model) {
        // Lấy 8 sản phẩm mới nhất để hiển thị ra trang chủ (Featured Products)
        // Đây là cách trình bày chuyên nghiệp thay vì lấy toàn bộ
        Page<Product> productPage = productService.getAllActiveProducts(PageRequest.of(0, 8));
        List<Product> featuredProducts = productPage.getContent();
        
        model.addAttribute("featuredProducts", featuredProducts);
        
        // Trả về view: WEB-INF/view/client/home/index.jsp
        return "client/home/index";
    }
}
