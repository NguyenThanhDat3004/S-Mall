package com.controller.seller;

import com.dto.CustomerInsightDTO;
import com.entity.Voucher;
import com.service.MarketingService;
import com.service.VoucherService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/seller/marketing")
public class SellerMarketingController {

    @Autowired
    private MarketingService marketingService;

    @Autowired
    private VoucherService voucherService;

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

    @GetMapping("/vouchers")
    public String getVoucherListPage(Model model, HttpSession session) {
        Long shopId = (Long) session.getAttribute("shopId");
        if (shopId == null) return "redirect:/login";

        List<Voucher> vouchers = voucherService.getVouchersByShop(shopId);
        model.addAttribute("vouchers", vouchers);
        return "seller/marketing/voucher_list";
    }

    @PostMapping("/vouchers/create")
    public String createVoucher(Voucher voucher, 
                               @RequestParam("expiryDateStr") String expiryDateStr,
                               HttpSession session, 
                               RedirectAttributes redirectAttributes) {
        Long shopId = (Long) session.getAttribute("shopId");
        if (shopId == null) return "redirect:/login";

        try {
            voucher.setExpiryDate(LocalDateTime.parse(expiryDateStr));
            voucher.setPublicVoucher(true); // Mặc định tạo thủ công là công khai
            Voucher created = voucherService.createVoucher(voucher, shopId);
            redirectAttributes.addFlashAttribute("success", "Tạo Voucher thành công!");
            redirectAttributes.addFlashAttribute("generatedCode", created.getCode());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/seller/marketing/vouchers";
    }
}
