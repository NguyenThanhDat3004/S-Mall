package com.service.impl;

import java.util.concurrent.TimeUnit;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.service.LoginAttemptService;

import jakarta.mail.internet.MimeMessage;

@Service
public class LoginAttemptServiceImpl implements LoginAttemptService {

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    @Autowired
    private JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    private static final int MAX_ATTEMPT = 5;
    private static final long LOCK_TIME = 30; // Chỉnh xuống 30 giây để test cho nhanh
    private static final String BLOCK_PREFIX = "BLOCK_";
    private static final String ATTEMPT_PREFIX = "ATTEMPT_";

    @Override
    public void loginSucceeded(String key) {
        redisTemplate.delete(ATTEMPT_PREFIX + key);
        redisTemplate.delete(BLOCK_PREFIX + key);
    }

    @Override
    public void loginFailed(String key) {
        int attempts = 0;
        Object cachedAttempts = redisTemplate.opsForValue().get(ATTEMPT_PREFIX + key);
        if (cachedAttempts != null) {
            attempts = (Integer) cachedAttempts;
        }
        attempts++;
        // Đổi TimeUnit.MINUTES thành TimeUnit.SECONDS
        redisTemplate.opsForValue().set(ATTEMPT_PREFIX + key, attempts, LOCK_TIME, TimeUnit.SECONDS);

        if (attempts >= MAX_ATTEMPT) {
            // Đổi TimeUnit.MINUTES thành TimeUnit.SECONDS
            redisTemplate.opsForValue().set(BLOCK_PREFIX + key, "blocked", LOCK_TIME, TimeUnit.SECONDS);
        }
    }

    @Override
    public boolean isBlocked(String key) {
        return redisTemplate.hasKey(BLOCK_PREFIX + key);
    }

    @Override
    public long getLockExpiry(String key) {
        Long expire = redisTemplate.getExpire(BLOCK_PREFIX + key, TimeUnit.SECONDS);
        return (expire != null) ? expire : 0;
    }

    @Override
    public void sendLockEmail(String email) {
        Object cachedAttempts = redisTemplate.opsForValue().get(ATTEMPT_PREFIX + email);
        if (cachedAttempts == null)
            return;

        int countFail = (Integer) cachedAttempts;
        // Nếu sai quá 4 lần thì gửi mail cảnh báo
        if (countFail > 4) {
            try {
                MimeMessage mimeMessage = mailSender.createMimeMessage();
                MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, "utf-8");

                helper.setTo(email);
                helper.setSubject("S-Mall cảnh báo đăng nhập");
                helper.setFrom(fromEmail, "S-Mall");

                String content = "Chào bạn,<br><br>"
                        + "<b style='color: red;'>Hệ thống S-Mall phát hiện tài khoản của bạn đang có dấu hiệu bị xâm nhập.</b><br>"
                        + "Tài khoản của bạn đã nhập sai mật khẩu " + countFail + " lần liên tiếp.<br>"
                        + "Nếu bạn không phải là người thực hiện hành động này, vui lòng thay đổi mật khẩu ngay lập tức để bảo vệ tài khoản.";

                helper.setText(content, true);

                // QUAN TRỌNG: Phải có dòng này thì mail mới được gửi đi!
                mailSender.send(mimeMessage);

                System.out.println(">>> [OK] Đã gửi mail bảo mật tới: " + email);
            } catch (Exception e) {
                System.out.println(">>> [LỖI] Không thể gửi mail bảo mật: " + e.getMessage());
            }
        }
    }
}
