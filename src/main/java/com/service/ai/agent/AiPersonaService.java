package com.service.ai.agent;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.entity.AiChatMessage;
import com.entity.AiChatPersona;
import com.entity.User;
import com.repository.AiChatPersonaRepository;
import com.service.ai.infrastructure.LLM;

@Service
public class AiPersonaService {

    @Autowired
    private LLM llm;

    @Autowired
    private AiChatPersonaRepository personaRepository;

    @Async
    @Transactional
    public void summarizeAndUpdatePersona(User user, Long sessionId, List<AiChatMessage> allMessages) {
        if (allMessages.size() < 2) {
            System.err.println(">>> [ASYNC-AI] Hội thoại quá ngắn, bỏ qua đúc kết Persona cho Session: " + sessionId);
            return;
        }

        try {
            System.err.println(">>> [ASYNC-AI] Đang bắt đầu đúc kết Persona chạy ngầm cho Session: " + sessionId);
            
            String conversation = allMessages.stream()
                    .map(m -> m.getRole() + ": " + m.getContent())
                    .collect(Collectors.joining("\n"));

            String summarizePromptTemplate = """
                    Hãy phân tích cuộc hội thoại sau và trích xuất hồ sơ người dùng theo 3 mục:
                    1. TÍNH CÁCH
                    2. PHONG CÁCH
                    3. THÓI QUEN
                    
                    Viết kết quả dưới dạng: 'Tính cách: ... | Phong cách: ... | Thói quen: ...'
                    
                    CONVERSATION:
                    %s
                    """;

            String summary = llm.generate(summarizePromptTemplate.replace("%s", conversation));
            System.err.println(">>> [ASYNC-AI] Kết quả đúc kết chạy ngầm: " + summary);

            AiChatPersona persona = personaRepository.findByUser(user)
                    .orElse(new AiChatPersona(user, ""));

            String oldData = persona.getPersonaData() != null ? persona.getPersonaData() : "";
            persona.setPersonaData(oldData + "\n[Session-" + sessionId + "]: " + summary);
            persona.setUpdatedAt(LocalDateTime.now());
            personaRepository.save(persona);
            
            System.err.println(">>> [ASYNC-AI] Đã cập nhật Persona thành công (Chạy ngầm).");
        } catch (Exception e) {
            System.err.println(">>> [ASYNC-AI-ERROR] Lỗi đúc kết ngầm: " + e.getMessage());
        }
    }
}
