package com.controller.auth;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.dto.request.RegisterDTO;
import com.service.AuthService;

@Controller
public class AuthController {

    @Autowired
    private AuthService authService;

    @GetMapping("/login")
    public String getLoginPage(Model model) {
        return "client/auth/login";
    }

    @GetMapping("/register")
    public String getRegisterPage(Model model) {
        model.addAttribute("registerDTO", new RegisterDTO());
        return "client/auth/register";
    }

    @PostMapping("/register")
    public String handleRegister(@ModelAttribute("registerDTO") RegisterDTO registerDTO, Model model) {
        
        // 0. Kiểm tra đồng ý điều khoản
        if (!registerDTO.isAcceptTerms()) {
            model.addAttribute("error", "Bạn vui lòng đồng ý với Điều khoản & Chính sách trước khi tiếp tục");
            return "client/auth/register";
        }

        // 1. Kiểm tra mật khẩu khớp nhau
        if (registerDTO.getPassword() != null && !registerDTO.getPassword().equals(registerDTO.getConfirmPassword())) {
            model.addAttribute("error", "Mật khẩu xác nhận không khớp");
            return "client/auth/register";
        }

        // 2. Kiểm tra email tồn tại
        if (authService.checkEmailExists(registerDTO.getEmail())) {
            model.addAttribute("error", "Email này đã được sử dụng");
            return "client/auth/register";
        }

        // 3. Thực hiện lưu người dùng
        authService.register(registerDTO);

        return "redirect:/login?success";
    }
}
