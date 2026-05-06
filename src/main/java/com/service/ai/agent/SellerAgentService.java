package com.service.ai.agent;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.entity.*;
import com.repository.*;
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
            Bạn là S-Mall AI Advisor - Cộng sự thông minh, thấu hiểu người dùng.

            HỒ SƠ NGƯỜI DÙNG (Dựa trên các cuộc trò chuyện trước):
            %s

            NHIỆM VỤ CỦA BẠN:
            1. Phân tích dữ liệu khách hàng hiện tại.
            2. Dựa vào TÍNH CÁCH và THÓI QUEN của Seller để đưa ra đề xuất Voucher phù hợp nhất với gu của họ.
            3. Dự đoán nhu cầu tiếp theo của Seller dựa trên PHONG CÁCH làm việc của họ.

            QUY TẮC PHẢN HỒI:
            - ANALYSIS: Phân tích ngắn gọn dựa trên dữ liệu và hồ sơ người dùng.
            - RESPONSE: Câu trả lời quyết đoán, cá nhân hóa cao.
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
        System.err.println(">>> [DEBUG-AI] BẮT ĐẦU XỬ LÝ - Session: " + sessionId);
        try {
            AiChatSession session = sessionRepository.findById(sessionId)
                    .orElseThrow(() -> new RuntimeException("Session không tồn tại"));

            if (!session.isActive())
                return fallback("Phiên làm việc đã kết thúc.");

            Shop shop = shopRepository.findByUser(seller).orElse(null);
            if (shop == null)
                return fallback("Lỗi: Không tìm thấy Shop.");

            String historyStr = formatLimitedHistory(session, 3);
            String personaContext = getRichPersona(seller);
            String systemPrompt = SYSTEM_PROMPT_TEMPLATE.replace("%s", personaContext);
            String dataContext = fetchBriefData(shop.getId());

            List<Message> messages = new ArrayList<>();
            messages.add(new Message("system", systemPrompt));

            String prompt = "SHOP: " + shop.getName() +
                    "\nDATA: " + dataContext +
                    "\nHISTORY: " + historyStr +
                    "\nUSER: " + userMessage;
            messages.add(new Message("user", prompt));

            System.err.println(">>> [DEBUG-AI] PROMPT GỬI AI:\n" + prompt);

            chatBuffer.computeIfAbsent(sessionId, k -> new ArrayList<>())
                    .add(new AiChatMessage(session, "USER", userMessage));

            System.err.println(">>> [DEBUG-AI] ĐANG CHỜ PHẢN HỒI TỪ GROQ...");
            String aiOutput = llm.generate(messages);
            System.err.println(">>> [DEBUG-AI] PHẢN HỒI THÔ:\n" + aiOutput);

            GameReasoning reasoning = new GameReasoning();
            reasoning.setGoal(userMessage);
            parseAiOutputWithRegex(aiOutput, reasoning, shop.getId());

            System.err.println(">>> [DEBUG-AI] PHÂN TÍCH XONG: " + reasoning.getFinalResponse());

            chatBuffer.get(sessionId).add(new AiChatMessage(session, "ASSISTANT", reasoning.getFinalResponse()));

            if (reasoning.getAnalysis() != null && !reasoning.getAnalysis().isEmpty()) {
                planRepository.save(new AiChatPlan(session, String.join("\n", reasoning.getAnalysis())));
            }

            log.info(">>> [DEBUG-AI] Xử lý hoàn tất thành công.");
            return reasoning;
        } catch (Exception e) {
            log.error(">>> [DEBUG-AI-ERROR] Lỗi tại processRequest: {}", e.getMessage(), e);
            return fallback("Sự cố kỹ thuật: " + e.getMessage());
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

        if (!allMessages.isEmpty()) {
            if (!bufferedMessages.isEmpty()) {
                messageRepository.saveAll(bufferedMessages);
                chatBuffer.remove(sessionId);
            }

            try {
                String conversation = allMessages.stream()
                        .map(m -> m.getRole() + ": " + m.getContent())
                        .collect(Collectors.joining("\n"));

                String summarizePromptTemplate = """
                        Hãy phân tích cuộc hội thoại sau và trích xuất hồ sơ người dùng theo 3 mục:
                        1. TÍNH CÁCH (Vd: Quyết đoán, tỉ mỉ, hay nóng vội...)
                        2. PHONG CÁCH (Vd: Ưu tiên lợi nhuận, thích tặng quà khách, hay dùng số liệu...)
                        3. THÓI QUEN (Vd: Hay hỏi về Voucher vào cuối tuần, thích kiểm tra đơn hàng VIP...)

                        Viết kết quả dưới dạng: 'Tính cách: ... | Phong cách: ... | Thói quen: ...'

                        CONVERSATION:
                        %s
                        """;

                String finalSummarizePrompt = summarizePromptTemplate.replace("%s", conversation);
                String summary = llm.generate(finalSummarizePrompt);

                AiChatPersona persona = personaRepository.findByUser(session.getUser())
                        .orElse(new AiChatPersona(session.getUser(), ""));

                String oldData = persona.getPersonaData() != null ? persona.getPersonaData() : "";
                persona.setPersonaData(oldData + "\n[Session-" + sessionId + "]: " + summary);
                persona.setUpdatedAt(java.time.LocalDateTime.now());
                personaRepository.save(persona);
            } catch (Exception e) {
                log.error(">>> [AI-ERROR] summarize failed: {}", e.getMessage());
            }
        }

        session.setActive(false);
        sessionRepository.save(session);
    }

    public String getRichPersona(User user) {
        return personaRepository.findByUser(user)
                .map(p -> {
                    String raw = p.getPersonaData();
                    if (raw == null || raw.isBlank())
                        return "Người dùng mới.";
                    String[] lines = raw.split("\n");
                    int start = Math.max(0, lines.length - 3);
                    StringBuilder sb = new StringBuilder();
                    for (int i = start; i < lines.length; i++) {
                        sb.append(lines[i]).append("\n");
                    }
                    return sb.toString();
                })
                .orElse("Người dùng mới.");
    }

    public String getPersona(User user) {
        return personaRepository.findByUser(user)
                .map(AiChatPersona::getPersonaData)
                .orElse("Đây là người dùng mới, hãy phục vụ theo phong cách mặc định.");
    }

    private String fetchBriefData(Long shopId) {
        List<CustomerInsightDTO> data = customerInsightSkill.getTopBuyersThisMonth(shopId);
        if (data.isEmpty())
            return "Chưa có đơn hàng mới.";
        return data.stream()
                .limit(3)
                .map(d -> d.getFullName() + ":" + d.getTotalOrders() + " đơn")
                .collect(Collectors.joining(", "));
    }

    private String formatLimitedHistory(AiChatSession session, int limit) {
        List<AiChatMessage> dbHistory = messageRepository.findBySessionOrderByCreatedAtAsc(session);
        List<AiChatMessage> bufferHistory = chatBuffer.getOrDefault(session.getId(), new ArrayList<>());

        List<AiChatMessage> combined = new ArrayList<>(dbHistory);
        combined.addAll(bufferHistory);

        if (combined.isEmpty())
            return "None";
        return combined.stream().skip(Math.max(0, combined.size() - limit))
                .map(h -> (h.getRole().equals("USER") ? "U:" : "A:") + h.getContent())
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
        if (ma.find()) {
            reasoning.addThought(ma.group(1).trim());
        }

        Pattern resPattern = Pattern.compile("(?s)RESPONSE:(.*)", Pattern.CASE_INSENSITIVE);
        Matcher mr = resPattern.matcher(output);
        if (mr.find()) {
            reasoning.setFinalResponse(mr.group(1).trim());
        } else {
            reasoning.setFinalResponse(output.replaceAll("(?i)ANALYSIS:.*", "").trim());
        }
    }
}
