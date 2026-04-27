package com.exception;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.NoHandlerFoundException;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(Exception.class)
    public Object handleAllExceptions(Exception ex, jakarta.servlet.http.HttpServletRequest request, org.springframework.ui.Model model) {
        // Kiểm tra nếu là request AJAX hoặc API (bắt đầu bằng /api)
        String requestUri = request.getRequestURI();
        if (requestUri.contains("/api/")) {
            java.util.Map<String, Object> response = new java.util.HashMap<>();
            response.put("status", "error");
            response.put("message", ex.getMessage());
            return org.springframework.http.ResponseEntity.status(500).body(response);
        }
        
        model.addAttribute("errorMessage", ex.getMessage());
        return "error/generic";
    }

    @ExceptionHandler(NoHandlerFoundException.class)
    public String handle404(NoHandlerFoundException ex, Model model) {
        model.addAttribute("errorMessage", "Trang bạn tìm kiếm không tồn tại.");
        return "error/404";
    }

    // Bạn có thể thêm các Exception tùy chỉnh ở đây (ví dụ: ProductNotFoundException)
}
