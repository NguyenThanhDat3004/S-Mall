package com.service.ai.agent;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.entity.AiAgentHistory;
import com.entity.User;
import com.repository.AiAgentHistoryRepository;
import com.service.ai.agent.model.GameReasoning;
import com.service.ai.agent.model.Message;
import com.service.ai.infrastructure.LLM;
import com.service.ai.skills.CustomerInsightSkill;
import com.service.ai.skills.VoucherAgentSkill;
import com.dto.CustomerInsightDTO;
import com.entity.Shop;
import com.repository.ShopRepository;

@Service
public class SellerAgentService {

    @Autowired
    private AiAgentHistoryRepository historyRepository;

    @Autowired
    private LLM llm;

    @Autowired
    private CustomerInsightSkill customerInsightSkill;

    @Autowired
    private VoucherAgentSkill voucherAgentSkill;

    @Autowired
    private ShopRepository shopRepository;

    // SYSTEM PROMPT: Chuyên nghiệp, gọn gàng, không lan man
    private static final String SYSTEM_PROMPT = """
        Bạn là S-Mall AI Advisor - Cộng sự chuyên nghiệp và quyết đoán.
        
        PHONG CÁCH:
        - Chào hỏi cực ngắn gọn (ví dụ: 'Chào bạn!').
        - Không dùng từ ngữ văn chương, sến súa (bỏ qua thời tiết, mưa nắng).
        - Tập trung: Tên khách - Số đơn - Mức Voucher đề xuất.
        - Trả lời tối đa 2-3 câu.
        
        NHIỆM VỤ: Soi data khách hàng và đề xuất mức Voucher (50k, 100k, 200k, 500k) phù hợp.
        """;

    @Transactional
    public GameReasoning processRequest(User seller, String userMessage) {
        try {
            historyRepository.save(new AiAgentHistory(seller, "USER", userMessage));
            Shop shop = shopRepository.findByUser(seller).orElse(null);
            if (shop == null) return fallback("Lỗi: Không tìm thấy Shop.");

            // TỐI ƯU CONTEXT: Chỉ lấy những gì thực sự cần
            String dataContext = fetchBriefData(shop.getId());
            List<Message> messages = new ArrayList<>();
            messages.add(new Message("system", SYSTEM_PROMPT));
            
            // Chỉ nhét 3 tin nhắn lịch sử gần nhất để tiết kiệm Token và tránh nhiễu
            String historyStr = formatLimitedHistory(seller.getId(), 3);
            
            String prompt = String.format("SHOP: %s\nDATA: %s\nHISTORY: %s\nUSER: %s", 
                                          shop.getName(), dataContext, historyStr, userMessage);
            messages.add(new Message("user", prompt));

            GameReasoning reasoning = new GameReasoning();
            reasoning.setGoal(userMessage);

            String aiOutput = llm.generate(messages);
            parseAiOutputWithRegex(aiOutput, reasoning, shop.getId());

            historyRepository.save(new AiAgentHistory(seller, "ASSISTANT", reasoning.getFinalResponse()));
            return reasoning;
        } catch (Exception e) {
            return fallback("Sự cố kỹ thuật: " + e.getMessage());
        }
    }

    private String fetchBriefData(Long shopId) {
        List<CustomerInsightDTO> data = customerInsightSkill.getTopBuyersThisMonth(shopId);
        if (data.isEmpty()) return "Chưa có đơn hàng mới.";
        return data.stream()
            .limit(3) // Chỉ lấy Top 3 để tránh phình Prompt
            .map(d -> d.getFullName() + ":" + d.getTotalOrders() + "đơn")
            .collect(Collectors.joining(", "));
    }

    private String formatLimitedHistory(Long sellerId, int limit) {
        List<AiAgentHistory> history = historyRepository.findBySellerIdOrderByCreatedAtAsc(sellerId);
        if (history.isEmpty()) return "None";
        return history.stream().skip(Math.max(0, history.size() - limit))
            .map(h -> (h.getRole().equals("USER") ? "U:" : "A:") + h.getContent())
            .collect(Collectors.joining(" | "));
    }

    public List<AiAgentHistory> getHistory(Long sellerId) {
        return historyRepository.findBySellerIdOrderByCreatedAtAsc(sellerId);
    }

    private GameReasoning fallback(String error) {
        GameReasoning r = new GameReasoning();
        r.setFinalResponse(error);
        return r;
    }

    private void parseAiOutputWithRegex(String output, GameReasoning reasoning, Long shopId) {
        Pattern resPattern = Pattern.compile("(?s)RESPONSE:(.*)", Pattern.CASE_INSENSITIVE);
        Matcher m = resPattern.matcher(output);
        if (m.find()) {
            reasoning.setFinalResponse(m.group(1).trim());
        } else {
            reasoning.setFinalResponse(output.replaceAll("(?i)ANALYSIS:.*|EXECUTION:.*", "").trim());
        }
    }
}
