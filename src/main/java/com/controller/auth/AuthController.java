package com.controller.auth;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.dto.request.RegisterDTO;
import com.entity.User;
import com.service.AuthService;
import com.service.OtpService;

import jakarta.validation.Valid;

@Controller
public class AuthController {

    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);

    @Autowired
    private AuthService authService;

    @Autowired
    private OtpService otpService;

    @GetMapping("/login")
    public String getLoginPage(Model model) {
        return "client/auth/login";
    }

    @GetMapping("/register")
    public String getRegisterPage(Model model, 
                                @RequestParam(required = false) boolean otpSent,
                                @RequestParam(required = false) String email) {
        model.addAttribute("registerDTO", new RegisterDTO());
        if (otpSent) {
            model.addAttribute("otpSent", true);
            model.addAttribute("email", email);
        }
        return "client/auth/register";
    }

    @PostMapping("/register")
    public String handleRegister(@ModelAttribute("registerDTO") @Valid RegisterDTO registerDTO,
                               BindingResult bindingResult, 
                               Model model) {
        if (bindingResult.hasErrors()) {
            return "client/auth/register";
        }

        if (authService.checkEmailExists(registerDTO.getEmail())) {
            bindingResult.rejectValue("email", "error.registerDTO", "Email này đã được sử dụng");
            return "client/auth/register";
        }

        try {
            otpService.saveRegisterDTO(registerDTO.getEmail(), registerDTO);
            String otp = otpService.generateOtp(registerDTO.getEmail());
            otpService.sendOtpEmail(registerDTO.getEmail(), otp);
            
            // PRG Pattern: Redirect to GET to prevent resending on F5
            return "redirect:/register?otpSent=true&email=" + registerDTO.getEmail();
        } catch (Exception e) {
            e.printStackTrace(); 
            model.addAttribute("error", "Có lỗi xảy ra khi gửi mã OTP. Vui lòng thử lại.");
            return "client/auth/register";
        }
    }

    @PostMapping("/verify-otp")
    public String handleVerifyOtp(@RequestParam("email") String email, 
                                @RequestParam("otp") String otp, 
                                Model model) {
        if (otpService.verifyOtp(email, otp)) {
            RegisterDTO registerDTO = otpService.getRegisterDTO(email);
            if (registerDTO != null) {
                User savedUser = authService.register(registerDTO);
                
                // Logging success as requested by USER - RAISED VISIBILITY
                System.out.println("==================================================");
                System.out.println("[SUCCESS] REGISTRATION COMPLETED!");
                System.out.println("[INFO] Email: " + savedUser.getEmail());
                System.out.println("[INFO] User ID in Database: " + savedUser.getId());
                System.out.println("==================================================");
                
                logger.info("[SUCCESS] User registered successfully! Email: {}, ID: {}", 
                           savedUser.getEmail(), savedUser.getId());
                
                otpService.clearOtpData(email);
                return "redirect:/login?success=true";
            }
            model.addAttribute("error", "Dữ liệu đăng ký đã hết hạn. Vui lòng thử lại.");
        } else {
            model.addAttribute("error", "Mã OTP không chính xác hoặc đã hết hạn.");
        }
        
        model.addAttribute("email", email);
        model.addAttribute("otpSent", true);
        model.addAttribute("registerDTO", new RegisterDTO());
        return "client/auth/register";
    }
}
