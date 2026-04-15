package com.controller.seller;

import com.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/seller")
public class SellerController {

    @Autowired
    private CategoryService categoryService;

    @GetMapping("/dashboard")
    public String getDashboard() {
        return "seller/dashboard";
    }

    @GetMapping("/product/create")
    public String getCreateProductPage(Model model) {
        model.addAttribute("categories", categoryService.getAllCategories());
        return "seller/product/create";
    }
}
