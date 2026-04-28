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

    public void sendPaymentSimulationEmail(com.entity.User user, String amount, String confirmLink) {
        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, "utf-8");

            helper.setTo(user.getEmail());
            helper.setSubject("Xác nhận chuyển khoản cho đơn hàng mới | S-Mall");
            helper.setFrom(fromEmail, "S-Mall Simulation");

            String content = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e2e8f0; border-radius: 16px;'>"
                           + "  <div style='text-align: center; margin-bottom: 20px;'>"
                           + "    <h2 style='color: #EE4D2D;'>Xác nhận thanh toán S-Mall</h2>"
                           + "  </div>"
                           + "  <p>Chào <b>" + user.getProfile().getFullName() + "</b>,</p>"
                           + "  <p>Bạn vừa thực hiện quét mã QR giả lập cho đơn hàng trị giá: <b style='color: #EE4D2D; font-size: 1.2rem;'>" + amount + "</b></p>"
                           + "  <p>Vui lòng nhấn vào nút bên dưới để hoàn tất quá trình thanh toán và đặt hàng:</p>"
                           + "  <div style='text-align: center; margin: 30px 0;'>"
                           + "    <a href='" + confirmLink + "' "
                           + "       style='background: #EE4D2D; color: white; padding: 14px 40px; text-decoration: none; border-radius: 10px; font-weight: bold; display: inline-block; shadow: 0 4px 6px rgba(0,0,0,0.1);'>"
                           + "       XÁC NHẬN THANH TOÁN & ĐẶT HÀNG"
                           + "    </a>"
                           + "  </div>"
                           + "  <p style='color: #64748b; font-size: 0.85rem; line-height: 1.5;'>"
                           + "    <i>Lưu ý: Đây là quy trình giả lập phục vụ mục đích phát triển. Việc nhấn xác nhận sẽ tạo đơn hàng thật trên hệ thống với trạng thái đã thanh toán.</i>"
                           + "  </p>"
                           + "  <hr style='border: 0; border-top: 1px solid #e2e8f0; margin: 20px 0;'>"
                           + "  <p style='text-align: center; color: #94a3b8; font-size: 0.75rem;'>S-Mall Team - Hệ thống bán lẻ điện tử hàng đầu</p>"
                           + "</div>";

            helper.setText(content, true);
            mailSender.send(mimeMessage);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
