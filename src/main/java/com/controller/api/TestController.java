package com.controller.api;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
public class TestController {
    @RequestMapping("/test")
    public String requestMethodName(Model model) {
        return "admin/product/test";
    }
    
    
}
