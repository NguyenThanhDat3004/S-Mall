package com.controller.client;

import com.entity.User;
import com.entity.UserProfile;
import com.service.UploadService;
import com.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.security.Principal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/profile")
public class ProfileApiController {

    @Autowired
    private UserService userService;

    @Autowired
    private UploadService uploadService;

    @PostMapping("/update-fast")
    public ResponseEntity<Map<String, Object>> updateFastProfile(
            @RequestParam("fullName") String fullName,
            @RequestParam("phoneNumber") String phoneNumber,
            @RequestParam("gender") Boolean gender,
            @RequestParam(value = "dateOfBirth", required = false) String dateOfBirthStr,
            @RequestParam("address") String address,
            @RequestParam(value = "avatarFile", required = false) MultipartFile avatarFile,
            Principal principal) {

        Map<String, Object> response = new HashMap<>();

        if (principal == null) {
            response.put("success", false);
            response.put("message", "Vui lòng đăng nhập để thực hiện chức năng này.");
            return ResponseEntity.status(401).body(response);
        }



        try {
            LocalDate dateOfBirth = null;
            if (dateOfBirthStr == null || dateOfBirthStr.trim().isEmpty() || dateOfBirthStr.equals("--")) {
                response.put("success", false);
                response.put("message", "Vui lòng nhập Ngày sinh hợp lệ.");
                return ResponseEntity.badRequest().body(response);
            }
            try {
                dateOfBirth = LocalDate.parse(dateOfBirthStr);
            } catch (Exception e) {
                response.put("success", false);
                response.put("message", "Định dạng Ngày sinh không hợp lệ.");
                return ResponseEntity.badRequest().body(response);
            }

            Optional<User> userOpt = userService.getUserByEmail(principal.getName());
            if (userOpt.isEmpty()) {
                response.put("success", false);
                response.put("message", "Không tìm thấy người dùng.");
                return ResponseEntity.badRequest().body(response);
            }

            User user = userOpt.get();
            UserProfile profile = user.getProfile();
            
            if (profile == null) {
                profile = new UserProfile();
                profile.setUser(user);
                user.setProfile(profile);
            }

            // Cập nhật thông tin text
            profile.setFullName(fullName);
            profile.setPhoneNumber(phoneNumber);
            profile.setGender(gender);
            profile.setDateOfBirth(dateOfBirth);
            profile.setAddress(address);

            // Xử lý upload ảnh (nếu có)
            if (avatarFile != null && !avatarFile.isEmpty()) {
                String avatarUrl = uploadService.saveImage(avatarFile);
                if (avatarUrl != null) {
                    profile.setAvatarUrl(avatarUrl);
                }
            }

            // Lưu thay đổi vào DB
            userService.handleSaveUser(user);

            // [LOG] Ghi nhận người dùng hoàn tất thông tin
            System.out.println(">>> User with ID [" + user.getId() + "] đã fill đầy đủ thông tin cá nhân.");

            response.put("success", true);
            response.put("message", "Cập nhật thông tin thành công!");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }
}
