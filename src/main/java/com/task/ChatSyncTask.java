package com.task;

import com.dto.ChatMessageBufferDTO;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.service.chat.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class ChatSyncTask {

    @Autowired
    private ChatService chatService;

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    @Autowired
    private ObjectMapper objectMapper;

    private static final String CHAT_BUFFER_KEY = "chat:buffer:messages";

    /**
     * Đồng bộ tin nhắn từ Redis vào MySQL mỗi 10 giây.
     */
    @Scheduled(fixedRate = 10000)
    public void syncMessagesToDb() {
        Long size = redisTemplate.opsForList().size(CHAT_BUFFER_KEY);
        if (size == null || size == 0) return;

        System.out.println("[ChatSync] Syncing " + size + " messages from Redis to MySQL...");

        // Lấy tất cả tin nhắn và xóa khỏi Redis
        List<Object> messages = new ArrayList<>();
        for (int i = 0; i < size; i++) {
            Object msg = redisTemplate.opsForList().leftPop(CHAT_BUFFER_KEY);
            if (msg != null) messages.add(msg);
        }

        // Lưu vào MySQL
        for (Object obj : messages) {
            try {
                ChatMessageBufferDTO dto = objectMapper.convertValue(obj, ChatMessageBufferDTO.class);
                chatService.saveMessage(dto.getRoomId(), dto.getSenderId(), dto.getContent(), dto.getShopId());
            } catch (Exception e) {
                System.err.println("[ChatSync] Error saving message from buffer: " + e.getMessage());
                e.printStackTrace();
                // Nếu lỗi, có thể đẩy ngược lại Redis hoặc log để xử lý sau
            }
        }
    }
}
