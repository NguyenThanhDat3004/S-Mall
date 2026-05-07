package com.controller.api;

import com.dto.ChatMessageBufferDTO;
import com.dto.CustomUserDetails;
import com.entity.ChatMessage;
import com.entity.ChatRoom;
import com.entity.Shop;
import com.entity.User;
import com.repository.ShopRepository;
import com.service.UserService;
import com.service.chat.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.time.format.DateTimeFormatter;
import java.util.*;

@RestController
@RequestMapping("/api/chat")
public class ChatApiController {

    @Autowired
    private ChatService chatService;

    @Autowired
    private UserService userService;

    @Autowired
    private ShopRepository shopRepository;

    /**
     * Lấy danh sách phòng chat.
     * Nếu có param shopId → lấy phòng theo Shop (Seller view)
     * Nếu không → lấy phòng theo Customer (Buyer view)
     */
    @GetMapping("/rooms")
    public ResponseEntity<?> getRooms(Principal principal,
            @RequestParam(required = false) Long shopId) {
        if (principal == null)
            return ResponseEntity.status(401).build();

        User user = userService.getUserByEmail(principal.getName()).orElse(null);
        if (user == null)
            return ResponseEntity.badRequest().build();

        List<ChatRoom> rooms;
        Long currentUserId = user.getId();

        if (shopId != null) {
            // Seller đang xem danh sách chat của shop mình
            rooms = chatService.getRoomsByShop(shopId);
        } else {
            // Buyer đang xem danh sách chat
            rooms = chatService.getRoomsByCustomer(user.getId());
        }

        // Map sang DTO để tránh lazy loading / JSON recursion
        List<Map<String, Object>> result = new ArrayList<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm dd/MM");

        for (ChatRoom room : rooms) {
            Map<String, Object> dto = new HashMap<>();
            dto.put("roomId", room.getId());
            dto.put("lastMessageAt", room.getLastMessageAt() != null
                    ? room.getLastMessageAt().format(formatter)
                    : "");

            // Thông tin đối phương
            if (shopId != null) {
                // Seller đang xem → hiển thị thông tin Customer
                User customer = room.getCustomer();
                dto.put("partnerName", customer.getProfile() != null && customer.getProfile().getFullName() != null
                        ? customer.getProfile().getFullName()
                        : customer.getEmail());
                dto.put("partnerAvatar", customer.getProfile() != null
                        ? customer.getProfile().getAvatarUrl()
                        : null);
            } else {
                // Buyer đang xem → hiển thị thông tin Shop
                Shop shop = room.getShop();
                dto.put("partnerName", shop.getName());
                dto.put("partnerAvatar", shop.getLogoUrl());
            }

            // Tin nhắn cuối cùng (preview)
            List<ChatMessage> messages = chatService.getMessagesByRoom(room.getId());
            if (!messages.isEmpty()) {
                ChatMessage lastMsg = messages.get(messages.size() - 1);
                String preview = lastMsg.getContent();
                if (preview != null && preview.length() > 50) {
                    preview = preview.substring(0, 50) + "...";
                }
                dto.put("lastMessage", preview);
            } else {
                dto.put("lastMessage", "Chưa có tin nhắn");
            }

            // Số tin nhắn chưa đọc
            long unread = 0;
            try {
                unread = rooms.stream()
                        .filter(r -> r.getId().equals(room.getId()))
                        .count() > 0
                                ? countUnreadForRoom(room, currentUserId, shopId)
                                : 0;
            } catch (Exception e) {
                // ignore
            }
            dto.put("unreadCount", unread);

            result.add(dto);
        }

        return ResponseEntity.ok(result);
    }

    private long countUnreadForRoom(ChatRoom room, Long currentUserId, Long shopId) {
        if (shopId != null) {
            // Seller: đếm tin chưa đọc mà customer gửi
            Shop shop = room.getShop();
            if (shop != null && shop.getUser() != null) {
                return chatService.getMessagesByRoom(room.getId()).stream()
                        .filter(m -> !m.isRead() && !m.getSender().getId().equals(shop.getUser().getId()))
                        .count();
            }
        } else {
            // Buyer: đếm tin chưa đọc mà seller gửi
            return chatService.getMessagesByRoom(room.getId()).stream()
                    .filter(m -> !m.isRead() && !m.getSender().getId().equals(currentUserId))
                    .count();
        }
        return 0;
    }

    /**
     * Lấy lịch sử tin nhắn của phòng
     */
    @GetMapping("/rooms/{roomId}/messages")
    public ResponseEntity<?> getMessages(
            @PathVariable("roomId") Long roomId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            Principal principal) {
        if (principal == null)
            return ResponseEntity.status(401).build();

        User user = userService.getUserByEmail(principal.getName()).orElse(null);
        if (user == null)
            return ResponseEntity.badRequest().build();

        // Đánh dấu đã đọc khi mở phòng (chỉ làm ở trang đầu tiên)
        if (page == 0) {
            chatService.markRoomAsRead(roomId, user.getId());
        }

        List<ChatMessageBufferDTO> messages = chatService.getMessagesPaged(roomId, page, size);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");

        List<Map<String, Object>> result = new ArrayList<>();
        for (ChatMessageBufferDTO msg : messages) {
            Map<String, Object> dto = new HashMap<>();
            dto.put("content", msg.getContent());
            dto.put("senderId", msg.getSenderId());
            dto.put("senderName", msg.getSenderName());
            dto.put("senderAvatar", msg.getSenderAvatar());
            dto.put("time", msg.getCreatedAt() != null ? msg.getCreatedAt().format(formatter) : "");
            dto.put("isOwn", msg.getSenderId().equals(user.getId()));
            result.add(dto);
        }

        return ResponseEntity.ok(result);
    }

    /**
     * Đóng phòng chat và dọn dẹp cache
     */
    @PostMapping("/rooms/{roomId}/close")
    public ResponseEntity<?> closeRoom(@PathVariable("roomId") Long roomId) {
        chatService.clearChatCache(roomId);
        return ResponseEntity.ok().build();
    }

    /**
     * Khởi tạo phòng chat (Buyer click "Chat với Shop")
     */
    @PostMapping("/rooms/init")
    public ResponseEntity<?> initRoom(@RequestParam Long shopId, Principal principal) {
        if (principal == null)
            return ResponseEntity.status(401).build();

        User user = userService.getUserByEmail(principal.getName()).orElse(null);
        if (user == null)
            return ResponseEntity.badRequest().build();

        // Chỉ tìm, không tạo mới ngay
        ChatRoom room = chatService.findRoom(user.getId(), shopId);
        Shop shop = shopRepository.findById(shopId)
                .orElseThrow(() -> new RuntimeException("Shop not found"));

        Map<String, Object> resp = new HashMap<>();
        resp.put("roomId", room != null ? room.getId() : null);
        resp.put("partnerName", shop.getName());
        resp.put("partnerAvatar", shop.getLogoUrl());

        return ResponseEntity.ok(resp);
    }

    /**
     * Đánh dấu đã đọc
     */
    @PostMapping("/rooms/{roomId}/read")
    public ResponseEntity<?> markAsRead(@PathVariable Long roomId, Principal principal) {
        if (principal == null)
            return ResponseEntity.status(401).build();

        User user = userService.getUserByEmail(principal.getName()).orElse(null);
        if (user == null)
            return ResponseEntity.badRequest().build();

        chatService.markRoomAsRead(roomId, user.getId());
        return ResponseEntity.ok(Map.of("status", "success"));
    }

    /**
     * Lấy tổng số tin nhắn chưa đọc (cho badge trên header)
     */
    @GetMapping("/unread-count")
    public ResponseEntity<?> getUnreadCount(Principal principal,
            @RequestParam(required = false) Long shopId) {
        if (principal == null)
            return ResponseEntity.status(401).build();

        User user = userService.getUserByEmail(principal.getName()).orElse(null);
        if (user == null)
            return ResponseEntity.badRequest().build();

        long count;
        if (shopId != null) {
            count = chatService.countUnreadByShop(shopId);
        } else {
            count = chatService.countUnreadByCustomer(user.getId());
        }

        return ResponseEntity.ok(Map.of("count", count));
    }
}
