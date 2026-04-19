package com.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller("adminProductController")
public class ProductController {
    @RequestMapping("/admin/product/show")
    public String getHomepage(org.springframework.ui.Model model) {
        model.addAttribute("product", new com.entity.Product());
        return "admin/product/show";
    }

    @RequestMapping("/admin/product/")
    public String getProducPage(Model model) {

        return "admin/product/create";
    }
    // trang add san pham

}
