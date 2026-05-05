package com.controller.api;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.service.ai.agent.SellerAgentService;
import com.service.ai.agent.model.GameReasoning;
import com.entity.AiAgentHistory;
import com.entity.User;
import com.repository.UserRepository;
import com.repository.AiAgentHistoryRepository;
import jakarta.servlet.http.HttpSession;
import java.security.Principal;
import org.springframework.transaction.annotation.Transactional;

@RestController
@RequestMapping("/api/seller/ai")
public class SellerAiApiController {

    @Autowired
    private SellerAgentService sellerAgentService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AiAgentHistoryRepository historyRepository;

    @PostMapping("/chat")
    public ResponseEntity<GameReasoning> chat(@RequestBody com.service.ai.agent.model.ChatRequest request, Principal principal) {
        if (principal == null) return ResponseEntity.status(403).build();
        User seller = userRepository.findByEmail(principal.getName()).orElse(null);
        if (seller == null) return ResponseEntity.status(403).build();

        GameReasoning response = sellerAgentService.processRequest(seller, request.getMessage());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/history")
    public ResponseEntity<List<AiAgentHistory>> getHistory(Principal principal) {
        if (principal == null) return ResponseEntity.status(403).build();
        User seller = userRepository.findByEmail(principal.getName()).orElse(null);
        List<AiAgentHistory> history = sellerAgentService.getHistory(seller.getId());
        return ResponseEntity.ok(history);
    }

    @DeleteMapping("/history")
    @Transactional
    public ResponseEntity<Void> clearHistory(Principal principal) {
        if (principal == null) return ResponseEntity.status(403).build();
        User seller = userRepository.findByEmail(principal.getName()).orElse(null);
        historyRepository.deleteBySellerId(seller.getId());
        return ResponseEntity.ok().build();
    }
}
