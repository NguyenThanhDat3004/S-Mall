package com.service.ai.agent;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
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

    private final Map<Long, List<AiChatMessage>> chatBuffer = new ConcurrentHashMap<>();

    private static final String SYSTEM_PROMPT_TEMPLATE = """
            Bạn là S-Mall AI Advisor - Chuyên gia phân tích dữ liệu của shop: %s.

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

            QUY TẮC: Luôn ưu tiên KHÁCH KIM CƯƠNG và VÀNG khi đề xuất Voucher.
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

            String shopName = shop.getName();
            String personaContext = getRichPersona(seller);
            String dataContext = fetchBriefData(shop.getId());
            String historyStr = formatLimitedHistory(session, 5);

            String systemPrompt = String.format(SYSTEM_PROMPT_TEMPLATE, shopName, dataContext, personaContext);

            List<Message> messages = new ArrayList<>();
            messages.add(new Message("system", systemPrompt));

            String prompt = "[HISTORY]: " + historyStr + "\nUSER: " + userMessage;
            messages.add(new Message("user", prompt));

            chatBuffer.computeIfAbsent(sessionId, k -> new ArrayList<>())
                    .add(new AiChatMessage(session, "USER", userMessage));

            String aiOutput = llm.generate(messages);
            GameReasoning reasoning = new GameReasoning();
            reasoning.setGoal(userMessage);
            parseAiOutputWithRegex(aiOutput, reasoning, shop.getId());

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
        if (session == null || !session.isActive())
            return;

        List<AiChatMessage> bufferedMessages = chatBuffer.getOrDefault(sessionId, new ArrayList<>());
        List<AiChatMessage> dbMessages = messageRepository.findBySessionOrderByCreatedAtAsc(session);
        List<AiChatMessage> allMessages = new ArrayList<>(dbMessages);
        allMessages.addAll(bufferedMessages);

        if (!bufferedMessages.isEmpty()) {
            messageRepository.saveAll(bufferedMessages);
            chatBuffer.remove(sessionId);
        }

        // Đảm bảo cập nhật Persona ngay cả khi tắt tab
        aiPersonaService.summarizeAndUpdatePersona(session.getUser(), sessionId, allMessages);

        session.setActive(false);
        sessionRepository.save(session);
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
        return personaRepository.findByUser(user)
                .map(p -> {
                    String raw = p.getPersonaData();
                    if (raw == null || raw.isBlank())
                        return "Mới.";
                    String[] lines = raw.split("\n");
                    int start = Math.max(0, lines.length - 3);
                    StringBuilder sb = new StringBuilder();
                    for (int i = start; i < lines.length; i++) {
                        sb.append(lines[i]).append("\n");
                    }
                    return sb.toString();
                })
                .orElse("Mới.");
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
        List<AiChatMessage> history = messageRepository.findBySessionOrderByCreatedAtAsc(session);
        List<AiChatMessage> buffered = chatBuffer.getOrDefault(session.getId(), new ArrayList<>());
        List<AiChatMessage> combined = new ArrayList<>(history);
        combined.addAll(buffered);

        if (combined.isEmpty())
            return "Trống";
        return combined.stream().skip(Math.max(0, combined.size() - limit))
                .map(h -> (h.getRole().equals("USER") ? "U" : "A") + ": " + h.getContent())
                .collect(Collectors.joining(" | "));
    }

    public List<AiChatMessage> getHistory(Long sessionId) {
        AiChatSession session = sessionRepository.findById(sessionId).orElse(null);
        if (session == null)
            return new ArrayList<>();
        List<AiChatMessage> dbHistory = messageRepository.findBySessionOrderByCreatedAtAsc(session);
        List<AiChatMessage> bufferHistory = chatBuffer.getOrDefault(sessionId, new ArrayList<>());
        List<AiChatMessage> combined = new ArrayList<>(dbHistory);
        combined.addAll(bufferHistory);
        return combined;
    }

    private GameReasoning fallback(String error) {
        GameReasoning r = new GameReasoning();
        r.setFinalResponse(error);
        return r;
    }

    private void parseAiOutputWithRegex(String output, GameReasoning reasoning, Long shopId) {
        Pattern anaPattern = Pattern.compile("(?s)ANALYSIS:(.*?)(?=RESPONSE:|$)", Pattern.CASE_INSENSITIVE);
        Matcher ma = anaPattern.matcher(output);
        if (ma.find())
            reasoning.addThought(ma.group(1).trim());

        Pattern resPattern = Pattern.compile("(?s)RESPONSE:(.*)", Pattern.CASE_INSENSITIVE);
        Matcher mr = resPattern.matcher(output);
        if (mr.find())
            reasoning.setFinalResponse(mr.group(1).trim());
        else
            reasoning.setFinalResponse(output.replaceAll("(?i)ANALYSIS:.*", "").trim());
    }
}
