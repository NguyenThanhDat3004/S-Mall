package com.service.ai.skills;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.service.VoucherService;
import com.service.MailService;
import com.entity.User;
import com.repository.UserRepository;

/**
 * Skill: Quản lý Voucher và Thông báo cho Agent
 */
@Component
public class VoucherAgentSkill {

    @Autowired
    private VoucherService voucherService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private MailService mailService;

    /**
     * Tool: Tạo voucher định danh 1-1 cho một User
     */
    public String createUniqueVoucher(Long shopId, Long userId, double discount, int expiryDays) {
        try {
            voucherService.createAndAssignVoucher(shopId, userId, discount, expiryDays);
            return "SUCCESS: Đã tạo và gán voucher giảm " + discount + " cho người dùng ID " + userId;
        } catch (Exception e) {
            return "ERROR: Không thể tạo voucher: " + e.getMessage();
        }
    }

    /**
     * Tool: Gửi thông báo cho khách hàng qua Email (Nội dung do AI soạn)
     */
    public String sendVoucherNotification(Long userId, String aiGeneratedMessage) {
        User user = userRepository.findById(userId).orElse(null);
        if (user == null) return "ERROR: Không tìm thấy người dùng ID " + userId;

        try {
            // Gửi mail thông báo
            mailService.sendMail(user.getEmail(), "Ưu đãi đặc biệt từ S-Mall", aiGeneratedMessage);
            return "SUCCESS: Đã gửi thông báo tới " + user.getEmail();
        } catch (Exception e) {
            return "ERROR: Lỗi khi gửi thông báo: " + e.getMessage();
        }
    }
}
