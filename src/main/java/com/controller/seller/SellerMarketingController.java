package com.controller.seller;

import com.dto.CustomerInsightDTO;
import com.service.MarketingService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/seller/marketing")
public class SellerMarketingController {

    @Autowired
    private MarketingService marketingService;

    @GetMapping("/customers")
    public String getCustomerInsightsPage(Model model, HttpSession session) {
        Long shopId = (Long) session.getAttribute("shopId");
        if (shopId == null) {
            return "redirect:/login";
        }

        List<CustomerInsightDTO> customers = marketingService.getCustomerInsights(shopId);
        model.addAttribute("customers", customers);
        return "seller/marketing/customers";
    }
}
