package com.service.impl;

import java.util.Random;
import java.util.concurrent.TimeUnit;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.dto.request.RegisterDTO;
import com.service.OtpService;

import jakarta.mail.internet.MimeMessage;

@Service
public class OtpServiceImpl implements OtpService {

    @Value("${spring.mail.username}")
    private String fromEmail;

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    @Autowired
    private JavaMailSender mailSender;

    private static final String OTP_PREFIX = "OTP_";
    private static final String REG_PREFIX = "REG_";
    private static final long OTP_EXPIRY = 5; // 5 minutes

    @Override
    public String generateOtp(String email) {
        String otp = String.format("%06d", new Random().nextInt(1000000));
        redisTemplate.opsForValue().set(OTP_PREFIX + email, otp, OTP_EXPIRY, TimeUnit.MINUTES);
        return otp;
    }

    @Override
    public void sendOtpEmail(String email, String otp) {
        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, "utf-8");
            
            helper.setTo(email);
            helper.setSubject("Mã xác thực đăng ký S-Mall");
            helper.setFrom(fromEmail, "S-Mall");
            
            String content = "Chào bạn,<br><br>"
                           + "Mã OTP của bạn là: <b style='color: #28a745; font-size: 1.5rem; letter-spacing: 2px;'>" + otp + "</b><br>"
                           + "Mã này có hiệu lực trong <b>5 phút</b>.<br><br>"
                           + "Trân trọng,<br>"
                           + "<b>S-Mall Team</b>";
            
            helper.setText(content, true); // true = gửi dưới dạng HTML
            mailSender.send(mimeMessage);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean verifyOtp(String email, String otp) {
        String savedOtp = (String) redisTemplate.opsForValue().get(OTP_PREFIX + email);
        return otp != null && otp.equals(savedOtp);
    }

    @Override
    public void saveRegisterDTO(String email, RegisterDTO registerDTO) {
        redisTemplate.opsForValue().set(REG_PREFIX + email, registerDTO, OTP_EXPIRY, TimeUnit.MINUTES);
    }

    @Override
    public RegisterDTO getRegisterDTO(String email) {
        return (RegisterDTO) redisTemplate.opsForValue().get(REG_PREFIX + email);
    }

    @Override
    public void clearOtpData(String email) {
        redisTemplate.delete(OTP_PREFIX + email);
        redisTemplate.delete(REG_PREFIX + email);
    }
}
