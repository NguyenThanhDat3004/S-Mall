package com.service;

import com.entity.Order;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
public class MailService {

    @Value("${spring.mail.username}")
    private String fromEmail;

    @Autowired
    private JavaMailSender mailSender;

    public void sendOrderConfirmation(Order order) {
        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, "utf-8");

            helper.setTo(order.getAccount().getEmail());
            helper.setSubject("Xác nhận đơn hàng " + order.getOrderCode() + " | S-Mall");
            helper.setFrom(fromEmail, "S-Mall");

            String qrUrl = "https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=" + order.getOrderCode();

            String content = "<h2>Cảm ơn bạn đã đặt hàng tại S-Mall!</h2>"
                           + "<p>Đơn hàng <b>" + order.getOrderCode() + "</b> đã được tiếp nhận và đang được xử lý.</p>"
                           + "<h3>Thông tin đơn hàng:</h3>"
                           + "<ul>"
                           + "<li>Người nhận: " + order.getAccount().getProfile().getFullName() + "</li>"
                           + "<li>Địa chỉ: " + order.getShippingAddress() + "</li>"
                           + "<li>Phương thức: " + order.getShippingMethod() + "</li>"
                           + "<li>Tổng tiền: <b>" + String.format("%,.0f", order.getTotalPrice()) + "đ</b></li>"
                           + "</ul>"
                           + "<p>Quét mã QR dưới đây để theo dõi đơn hàng nhanh chóng:</p>"
                           + "<img src='" + qrUrl + "' alt='Order QR Code' />"
                           + "<br><br>"
                           + "<p>Trân trọng,<br><b>S-Mall Team</b></p>";

            helper.setText(content, true);
            mailSender.send(mimeMessage);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
