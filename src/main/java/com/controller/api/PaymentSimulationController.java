package com.controller.api;

import com.entity.User;
import com.service.MailService;
import com.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.ui.Model;
import jakarta.servlet.http.HttpServletRequest;

import java.util.Optional;

@Controller
@RequestMapping("/payment/simulation")
public class PaymentSimulationController {

    @Autowired
    private UserService userService;

    @Autowired
    private MailService mailService;

    @GetMapping
    public String simulateQrScan(
            @RequestParam Long userId,
            @RequestParam String amount,
            @RequestParam String ids,
            @RequestParam String ship,
            @RequestParam String addr,
            @RequestParam boolean ins,
            HttpServletRequest request,
            Model model) {
        
        User user = userService.findById(userId);
        if (user != null) {
            
            // Tự động lấy Base URL (ví dụ: http://localhost:8080/spring_mvc hoặc link ngrok)
            String scheme = request.getScheme();
            String serverName = request.getServerName();
            int serverPort = request.getServerPort();
            String contextPath = request.getContextPath();
            
            String baseUrl = scheme + "://" + serverName;
            if (serverPort != 80 && serverPort != 443) {
                baseUrl += ":" + serverPort;
            }
            baseUrl += contextPath;

            String confirmLink = baseUrl + "/cart/payment/confirm?ids=" + ids 
                               + "&ship=" + ship + "&addr=" + java.net.URLEncoder.encode(addr, java.nio.charset.StandardCharsets.UTF_8)
                               + "&ins=" + ins;
            
            mailService.sendPaymentSimulationEmail(user, amount, confirmLink);
            
            model.addAttribute("message", "Quét mã thành công! Một email xác nhận đã được gửi đến " + user.getEmail() + ". Vui lòng kiểm tra hộp thư để hoàn tất đơn hàng.");
            return "client/cart/simulation_success";
        }
        
        model.addAttribute("message", "Không tìm thấy thông tin người dùng.");
        return "client/cart/simulation_success";
    }
}
