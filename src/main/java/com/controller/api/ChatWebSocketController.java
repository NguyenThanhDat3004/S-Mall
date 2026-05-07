package com.controller.api;

import com.entity.ChatMessage;
import com.entity.ChatRoom;
import com.entity.Shop;
import com.entity.User;
import com.repository.ShopRepository;
import com.service.UserService;
import com.service.chat.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import java.security.Principal;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

/**
 * WebSocket STOMP Controller
 * Nhận tin nhắn từ Client qua /app/chat.send → Lưu DB → Đẩy cho người nhận
 */
@Controller
public class ChatWebSocketController {

    @Autowired
    private ChatService chatService;

    @Autowired
    private UserService userService;

    @Autowired
    private ShopRepository shopRepository;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    /**
     * Client gửi tin nhắn qua STOMP tới /app/chat.send
     * Payload: { "roomId": 1, "content": "Hello" }
     */
    @MessageMapping("/chat.send")
    public void sendMessage(@Payload Map<String, Object> payload, Principal principal) {
        if (principal == null) return;

        Long roomId = Long.valueOf(payload.get("roomId").toString());
        String content = payload.get("content").toString();

        // Lấy sender
        User sender = userService.getUserByEmail(principal.getName()).orElse(null);
        if (sender == null) return;

        // Lưu tin nhắn vào DB
        ChatMessage saved = chatService.saveMessage(roomId, sender.getId(), content);

        // Build DTO để gửi qua WebSocket
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
        Map<String, Object> messageDto = new HashMap<>();
        messageDto.put("id", saved.getId());
        messageDto.put("roomId", roomId);
        messageDto.put("content", saved.getContent());
        messageDto.put("senderId", sender.getId());
        messageDto.put("senderName", sender.getProfile() != null && sender.getProfile().getFullName() != null
                ? sender.getProfile().getFullName() : sender.getEmail());
        messageDto.put("senderAvatar", sender.getProfile() != null
                ? sender.getProfile().getAvatarUrl() : null);
        messageDto.put("time", saved.getCreatedAt().format(formatter));

        // Xác định người nhận từ room info
        ChatRoom chatRoom = saved.getChatRoom();
        User customer = chatRoom.getCustomer();
        Shop shop = chatRoom.getShop();
        User shopOwner = shop.getUser();

        // Gửi cho cả 2 bên
        // 1. Gửi cho Customer
        Map<String, Object> customerMsg = new HashMap<>(messageDto);
        customerMsg.put("isOwn", sender.getId().equals(customer.getId()));
        messagingTemplate.convertAndSendToUser(
                customer.getEmail(), "/queue/messages", customerMsg);

        // 2. Gửi cho Shop Owner
        Map<String, Object> sellerMsg = new HashMap<>(messageDto);
        sellerMsg.put("isOwn", sender.getId().equals(shopOwner.getId()));
        messagingTemplate.convertAndSendToUser(
                shopOwner.getEmail(), "/queue/messages", sellerMsg);
    }
}
