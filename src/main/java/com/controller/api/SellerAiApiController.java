package com.controller.api;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.service.ai.agent.SellerAgentService;
import com.service.ai.agent.model.GameReasoning;
import com.service.ai.agent.model.ChatRequest;
import com.entity.AiChatMessage;
import com.entity.AiChatSession;
import com.entity.User;
import com.repository.UserRepository;
import java.security.Principal;

@RestController
@RequestMapping("/api/seller/ai")
public class SellerAiApiController {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(SellerAiApiController.class);

    @Autowired
    private SellerAgentService sellerAgentService;

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/session")
    public ResponseEntity<AiChatSession> startSession(Principal principal, jakarta.servlet.http.HttpSession httpSession) {
        if (principal == null) return ResponseEntity.status(403).build();
        User seller = userRepository.findByEmail(principal.getName()).orElse(null);
        if (seller == null) return ResponseEntity.status(403).build();

        AiChatSession session = sellerAgentService.startNewSession(seller);
        
        // Lưu sessionId vào Redis Session
        httpSession.setAttribute("ACTIVE_AI_SESSION_ID", session.getId());
        System.err.println(">>> [CONTROLLER] Đã lưu SessionID " + session.getId() + " vào Redis.");
        
        return ResponseEntity.ok(session);
    }

    @PostMapping("/chat")
    public ResponseEntity<?> chat(@RequestBody ChatRequest request, Principal principal, jakarta.servlet.http.HttpSession httpSession) {
        System.err.println(">>> [CONTROLLER] NHẬN REQUEST CHAT - Msg: " + request.getMessage());
        if (principal == null) return ResponseEntity.status(403).build();
        User seller = userRepository.findByEmail(principal.getName()).orElse(null);
        if (seller == null) return ResponseEntity.status(403).build();

        Long sessionId = request.getSessionId();
        
        // 1. Ưu tiên lấy sessionId từ Request
        // 2. Nếu null, thử lấy từ Redis Session
        if (sessionId == null) {
            sessionId = (Long) httpSession.getAttribute("ACTIVE_AI_SESSION_ID");
            if (sessionId != null) {
                System.err.println(">>> [CONTROLLER] Lấy được SessionID từ Redis: " + sessionId);
            }
        }
        
        // 3. Nếu vẫn null, tự động tìm session active trong DB
        if (sessionId == null) {
            System.err.println(">>> [CONTROLLER] Redis trống, đang tìm session active trong DB...");
            AiChatSession activeSession = sellerAgentService.getActiveSession(seller);
            if (activeSession != null) {
                sessionId = activeSession.getId();
                httpSession.setAttribute("ACTIVE_AI_SESSION_ID", sessionId); // Cập nhật ngược lại Redis
            } else {
                System.err.println(">>> [CONTROLLER] Không có session nào, đang tạo mới...");
                AiChatSession newSession = sellerAgentService.startNewSession(seller);
                sessionId = newSession.getId();
                httpSession.setAttribute("ACTIVE_AI_SESSION_ID", sessionId);
            }
        }

        GameReasoning response = sellerAgentService.processRequest(seller, sessionId, request.getMessage());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/history/{sessionId}")
    public ResponseEntity<List<AiChatMessage>> getHistory(@PathVariable Long sessionId, Principal principal) {
        if (principal == null) return ResponseEntity.status(403).build();
        List<AiChatMessage> history = sellerAgentService.getHistory(sessionId);
        return ResponseEntity.ok(history);
    }

    // Xử lý trường hợp gọi /history mà quên sessionId
    @GetMapping("/history")
    public ResponseEntity<?> getHistoryMissingId() {
        return ResponseEntity.badRequest().body(java.util.Map.of("error", "Vui lòng cung cấp Session ID. Ví dụ: /api/seller/ai/history/1", "status", 400));
    }

    @PostMapping("/session/{sessionId}/summarize")
    public ResponseEntity<?> summarizeSession(@PathVariable Long sessionId, Principal principal, jakarta.servlet.http.HttpSession httpSession) {
        if (principal == null) return ResponseEntity.status(403).build();
        
        sellerAgentService.summarizeAndCloseSession(sessionId);
        
        // Xóa khỏi Redis sau khi đã đóng và đúc kết xong để giải phóng bộ nhớ
        Long activeIdInRedis = (Long) httpSession.getAttribute("ACTIVE_AI_SESSION_ID");
        if (sessionId.equals(activeIdInRedis)) {
            httpSession.removeAttribute("ACTIVE_AI_SESSION_ID");
            System.err.println(">>> [CONTROLLER] Đã xóa SessionID " + sessionId + " khỏi Redis.");
        }
        
        return ResponseEntity.ok(java.util.Map.of("status", "success", "message", "Session closed and persona updated"));
    }
}

