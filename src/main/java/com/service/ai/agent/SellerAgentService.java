package com.service.ai.agent;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.entity.*;
import com.repository.AiChatSessionRepository;
import com.repository.AiChatMessageRepository;
import com.repository.AiChatPlanRepository;
import com.repository.AiChatPersonaRepository;
import com.repository.ShopRepository;
import com.repository.UserRepository;
import com.service.ai.agent.model.GameReasoning;
import com.service.ai.agent.model.Message;
import com.service.ai.infrastructure.LLM;
import com.service.ai.skills.CustomerInsightSkill;
import com.service.ai.skills.VoucherAgentSkill;
import com.dto.CustomerInsightDTO;

@Service
public class SellerAgentService {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(SellerAgentService.class);

    @Autowired
    private AiChatSessionRepository sessionRepository;

    @Autowired
    private AiChatMessageRepository messageRepository;

    @Autowired
    private AiChatPlanRepository planRepository;

    @Autowired
    private AiChatPersonaRepository personaRepository;

    @Autowired
    private AiPersonaService aiPersonaService;

    @Autowired
    private LLM llm;

    @Autowired
    private CustomerInsightSkill customerInsightSkill;

    @Autowired
    private VoucherAgentSkill voucherAgentSkill;

    @Autowired
    private ShopRepository shopRepository;

    @Autowired
    private UserRepository userRepository;

    // Buffer để lưu tin nhắn tạm thời trước khi flush xuống DB (Tối ưu hiệu năng)
    private final java.util.concurrent.ConcurrentHashMap<Long, List<AiChatMessage>> chatBuffer = new java.util.concurrent.ConcurrentHashMap<>();

    private static final String SYSTEM_PROMPT_TEMPLATE = """
            Bạn là S-Mall AI Advisor - Một trợ lý ảo cực kỳ THÔNG MINH, KHÉO LÉO và THẢO MAI. 
            Nhiệm vụ của bạn là hỗ trợ chủ shop: %s (Tên: %s).
            
            [PHONG CÁCH GIAO TIẾP]:
            - Luôn ngọt ngào, lịch sự. Tuyệt đối không dùng 'anh/chị' chung chung. 
            - Hãy gọi chủ shop bằng tên riêng (%s) kèm theo kính ngữ (ví dụ: 'Dạ thưa anh Đạt', 'Dạ anh Đạt ơi').
            - Luôn khen ngợi chủ shop và đưa ra các lời khuyên mang tính xây dựng, tích cực.
            - Phải thật sự 'thảo mai' để làm hài lòng chủ shop nhưng vẫn đảm bảo tính chuyên nghiệp.

            [KIẾN THỨC HỆ THỐNG - NGUỒN SỰ THẬT DUY NHẤT]:
            Sử dụng bảng dưới đây để trả lời chính xác về số đơn, chi tiêu và HẠNG THÀNH VIÊN.
            %s

            [HỆ THỐNG PHÂN HẠNG]:
            - Kim cương: >= 5000 điểm
            - Vàng: >= 2000 điểm
            - Bạc: >= 1000 điểm
            - Đồng: >= 10 điểm
            (1000đ chi tiêu = 1 điểm)

            [HỒ SƠ NGƯỜI BÁN]:
            %s

            [CÔNG CỤ CÓ SẴN]:
            - createVoucher(userId, discount, type, expiryDays): Tạo voucher 1-1. 
              + type: 'PERCENTAGE' hoặc 'FIXED'. 
              + discount: số tiền hoặc %%.
            - sendEmail(userId, message): Gửi email thông báo cho khách.

            QUY TẮC: 
            1. Luôn ưu tiên KHÁCH KIM CƯƠNG và VÀNG khi đề xuất Voucher.
            2. BẠN ĐANG CHAT VỚI CHỦ SHOP. Tuyệt đối không tặng voucher cho chính chủ shop (%s). 
               Chỉ tặng cho các khách hàng có trong danh sách [KIẾN THỨC HỆ THỐNG] ở trên.
            3. KHÔNG ĐƯỢC TỰ Ý TẠO VOUCHER: Bạn phải đề xuất mức giảm giá và hỏi ý kiến chủ shop trước. 
               CHỈ KHI chủ shop đồng ý (ví dụ: 'Ok', 'Làm đi', 'Đồng ý'), bạn mới được viết lệnh EXECUTION.
            4. Luôn trình bày theo cấu trúc:
               ANALYSIS: (Suy luận khéo léo của bạn)
               EXECUTION: (Chỉ viết lệnh khi đã được xác nhận)
               RESPONSE: (Câu trả lời thảo mai và ngọt ngào cho chủ shop)
            """;

    @Transactional
    public AiChatSession startNewSession(User user) {
        sessionRepository.findTopByUserAndIsActiveTrueOrderByCreatedAtDesc(user)
                .ifPresent(s -> summarizeAndCloseSession(s.getId()));

        AiChatSession session = new AiChatSession(user);
        return sessionRepository.save(session);
    }

    public AiChatSession getActiveSession(User user) {
        return sessionRepository.findTopByUserAndIsActiveTrueOrderByCreatedAtDesc(user).orElse(null);
    }

    @Transactional
    public GameReasoning processRequest(User seller, Long sessionId, String userMessage) {
        try {
            AiChatSession session = sessionRepository.findById(sessionId)
                    .orElseThrow(() -> new RuntimeException("Session không tồn tại"));

            if (!session.isActive())
                return fallback("Phiên làm việc đã kết thúc.");

            Shop shop = shopRepository.findByUser(seller).orElse(null);
            if (shop == null)
                return fallback("Lỗi: Không tìm thấy Shop.");

            // Lưu vào buffer (Tối ưu hiệu năng - Không lưu DB mỗi tin nhắn)
            chatBuffer.computeIfAbsent(sessionId, k -> new java.util.ArrayList<>())
                      .add(new AiChatMessage(session, "USER", userMessage));
            
            String shopName = shop.getName();
            String ownerName = (seller.getProfile() != null) ? seller.getProfile().getFullName() : "Chủ shop";
            String personaContext = getRichPersona(seller);
            String dataContext = fetchBriefData(shop.getId());
            String historyStr = formatLimitedHistory(session, 5);

            String systemPrompt = String.format(SYSTEM_PROMPT_TEMPLATE, shopName, ownerName, ownerName, dataContext, personaContext, ownerName);

            List<Message> messages = new ArrayList<>();
            messages.add(new Message("system", systemPrompt));

            String prompt = "[HISTORY]: " + historyStr + "\nUSER: " + userMessage;
            messages.add(new Message("user", prompt));

            messageRepository.save(new AiChatMessage(session, "USER", userMessage));

            String aiOutput = llm.generate(messages);
            GameReasoning reasoning = new GameReasoning();
            reasoning.setGoal(userMessage);
            parseAiOutputWithRegex(aiOutput, reasoning, shop.getId());
            
            // Lưu phản hồi của AI vào buffer
            chatBuffer.get(sessionId).add(new AiChatMessage(session, "ASSISTANT", reasoning.getFinalResponse()));

            if (reasoning.getAnalysis() != null && !reasoning.getAnalysis().isEmpty()) {
                planRepository.save(new AiChatPlan(session, String.join("\n", reasoning.getAnalysis())));
            }

            return reasoning;
        } catch (Exception e) {
            log.error(">>> [AI-ERROR] processRequest: {}", e.getMessage());
            return fallback("Sự cố: " + e.getMessage());
        }
    }

    @Transactional
    public void summarizeAndCloseSession(Long sessionId) {
        AiChatSession session = sessionRepository.findById(sessionId).orElse(null);
        if (session == null || !session.isActive()) {
            log.info(">>> [FLUSH] Session {} is null or inactive, skipping.", sessionId);
            return;
        }

        // 1. Flush buffer xuống DB trước khi đóng
        List<AiChatMessage> bufferedMessages = chatBuffer.getOrDefault(sessionId, new java.util.ArrayList<>());
        if (!bufferedMessages.isEmpty()) {
            messageRepository.saveAll(bufferedMessages);
            chatBuffer.remove(sessionId);
            log.info(">>> [FLUSH] Đã lưu {} tin nhắn từ buffer xuống DB cho Session {}", bufferedMessages.size(), sessionId);
        }

        List<AiChatMessage> allMessages = messageRepository.findBySessionOrderByCreatedAtAsc(session);
        log.info(">>> [FLUSH] Tổng cộng Session {}: {} tin nhắn", sessionId, allMessages.size());

        // Cập nhật Persona chỉ khi Refresh/Logout
        log.info(">>> [AI-SESSION] Đang yêu cầu đúc kết Persona cho Session {}...", sessionId);
        aiPersonaService.summarizeAndUpdatePersona(session.getUser(), sessionId, allMessages);

        session.setActive(false);
        sessionRepository.save(session);
        log.info(">>> [FLUSH] Session {} closed successfully.", sessionId);
    }

    /**
     * Tự động dọn dẹp và học Persona cho các session bị bỏ quên (ví dụ: tắt trình
     * duyệt, mất điện)
     * Chạy mỗi 10 phút, kiểm tra các session active > 30 phút
     */
    @org.springframework.scheduling.annotation.Scheduled(fixedDelay = 600000) // 10 phút
    @Transactional
    public void autoCleanupSessions() {
        LocalDateTime thirtyMinsAgo = LocalDateTime.now().minusMinutes(30);
        List<AiChatSession> idleSessions = sessionRepository.findAllByIsActiveTrueAndCreatedAtBefore(thirtyMinsAgo);

        if (!idleSessions.isEmpty()) {
            log.info(">>> [AI-CLEANUP] Tự động đóng {} phiên chat bị bỏ quên...", idleSessions.size());
            for (AiChatSession s : idleSessions) {
                summarizeAndCloseSession(s.getId());
            }
        }
    }

    public String getRichPersona(User user) {
        List<AiChatPersona> personas = personaRepository.findTop3ByUserOrderByUpdatedAtDesc(user);
        if (personas.isEmpty()) return "Mới.";

        return personas.stream()
                .map(AiChatPersona::getPersonaData)
                .collect(Collectors.joining(" | "));
    }

    private String fetchBriefData(Long shopId) {
        List<CustomerInsightDTO> data = customerInsightSkill.getTopBuyersThisYear(shopId);
        if (data.isEmpty())
            return "Chưa có dữ liệu năm nay.";

        int currentYear = java.time.LocalDate.now().getYear();
        StringBuilder sb = new StringBuilder();
        sb.append(String.format("### BẢNG XẾP HẠNG VÀ HẠNG THÀNH VIÊN %d:\n", currentYear));
        sb.append("| Hạng | Tên khách hàng | Điểm | Hạng TV | Số đơn | Chi tiêu |\n");
        sb.append("|------|----------------|------|---------|--------|----------|\n");
        for (int i = 0; i < Math.min(data.size(), 5); i++) {
            CustomerInsightDTO d = data.get(i);
            sb.append(String.format("| %d | %s | %d | **%s** | %d đơn | %,.0f đ |\n",
                    (i + 1), d.getFullName(), d.getPoints(), d.getMembershipRank(), d.getTotalOrders(),
                    d.getTotalSpent()));
        }
        return sb.toString();
    }

    private String formatLimitedHistory(AiChatSession session, int limit) {
        List<AiChatMessage> dbHistory = messageRepository.findBySessionOrderByCreatedAtAsc(session);
        List<AiChatMessage> buffered = chatBuffer.getOrDefault(session.getId(), new java.util.ArrayList<>());
        
        java.util.List<AiChatMessage> combined = new java.util.ArrayList<>(dbHistory);
        combined.addAll(buffered);

        if (combined.isEmpty()) return "Trống";
        return combined.stream().skip(Math.max(0, combined.size() - limit))
                .map(h -> (h.getRole().equals("USER") ? "U" : "A") + ": " + h.getContent())
                .collect(Collectors.joining(" | "));
    }

    public List<AiChatMessage> getHistory(Long sessionId) {
        AiChatSession session = sessionRepository.findById(sessionId).orElse(null);
        if (session == null) return new ArrayList<>();
        
        List<AiChatMessage> dbHistory = messageRepository.findBySessionOrderByCreatedAtAsc(session);
        List<AiChatMessage> buffered = chatBuffer.getOrDefault(sessionId, new java.util.ArrayList<>());
        
        java.util.List<AiChatMessage> combined = new java.util.ArrayList<>(dbHistory);
        combined.addAll(buffered);
        return combined;
    }

    private GameReasoning fallback(String error) {
        GameReasoning r = new GameReasoning();
        r.setFinalResponse(error);
        return r;
    }

    private void parseAiOutputWithRegex(String output, GameReasoning reasoning, Long shopId) {
        Pattern anaPattern = Pattern.compile("(?s)ANALYSIS:(.*?)(?=EXECUTION:|RESPONSE:|$)", Pattern.CASE_INSENSITIVE);
        Matcher ma = anaPattern.matcher(output);
        if (ma.find())
            reasoning.addThought(ma.group(1).trim());

        // Parse Tool Execution
        Pattern exePattern = Pattern.compile("(?s)EXECUTION:(.*?)(?=RESPONSE:|$)", Pattern.CASE_INSENSITIVE);
        Matcher me = exePattern.matcher(output);
        if (me.find()) {
            String exeLine = me.group(1).trim();
            executeTool(exeLine, reasoning, shopId);
        }

        Pattern resPattern = Pattern.compile("(?s)RESPONSE:(.*)", Pattern.CASE_INSENSITIVE);
        Matcher mr = resPattern.matcher(output);
        if (mr.find())
            reasoning.setFinalResponse(mr.group(1).trim());
        else
            reasoning.setFinalResponse(output.replaceAll("(?i)ANALYSIS:.*|(?i)EXECUTION:.*", "").trim());
    }

    private void executeTool(String exeLine, GameReasoning reasoning, Long shopId) {
        if (exeLine.isEmpty()) return;

        // Ví dụ: createVoucher(1, 10, 'PERCENTAGE', 7)
        if (exeLine.startsWith("createVoucher")) {
            try {
                String params = exeLine.substring(exeLine.indexOf("(") + 1, exeLine.lastIndexOf(")"));
                String[] p = params.split(",");
                Long userId = Long.parseLong(p[0].trim());
                double discount = Double.parseDouble(p[1].trim());
                Voucher.DiscountType type = Voucher.DiscountType.valueOf(p[2].trim().replace("'", ""));
                int expiry = Integer.parseInt(p[3].trim());

                String result = voucherAgentSkill.createUniqueVoucher(shopId, userId, discount, type, expiry);
                reasoning.addExecution(result);
            } catch (Exception e) {
                reasoning.addExecution("ERROR: Lệnh sai cú pháp: " + e.getMessage());
            }
        } else if (exeLine.startsWith("sendEmail")) {
            try {
                String params = exeLine.substring(exeLine.indexOf("(") + 1, exeLine.lastIndexOf(")"));
                int firstComma = params.indexOf(",");
                Long userId = Long.parseLong(params.substring(0, firstComma).trim());
                String msg = params.substring(firstComma + 1).trim().replace("'", "");

                String result = voucherAgentSkill.sendVoucherNotification(userId, msg);
                reasoning.addExecution(result);
            } catch (Exception e) {
                reasoning.addExecution("ERROR: Lệnh sai cú pháp: " + e.getMessage());
            }
        }
    }
}
