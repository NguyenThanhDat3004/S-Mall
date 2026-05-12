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

    @Autowired
    private com.repository.ChatRoomRepository chatRoomRepository;

    @Autowired
    private com.repository.ChatMessageRepository chatMessageRepository;

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

        // Tự động phát hiện nếu là chủ shop
        Shop userShop = shopRepository.findByUser(user).orElse(null);
        Long effectiveShopId = (shopId != null) ? shopId : (userShop != null ? userShop.getId() : null);

        List<ChatRoom> rooms;
        Long currentUserId = user.getId();

        if (effectiveShopId != null) {
            // Lấy cả phòng của shop mình và phòng mình đi mua hàng
            rooms = new ArrayList<>(chatService.getRoomsByShop(effectiveShopId));
            List<ChatRoom> customerRooms = chatService.getRoomsByCustomer(user.getId());
            // Tránh trùng lặp
            for (ChatRoom cr : customerRooms) {
                if (rooms.stream().noneMatch(r -> r.getId().equals(cr.getId()))) {
                    rooms.add(cr);
                }
            }
        } else {
            rooms = chatService.getRoomsByCustomer(user.getId());
        }

        // Map sang DTO để tránh lazy loading / JSON recursion
        List<Map<String, Object>> result = new ArrayList<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm dd/MM");

        try {
            for (ChatRoom room : rooms) {
                Map<String, Object> dto = new HashMap<>();
                dto.put("roomId", room.getId());
                dto.put("lastMessageAt", room.getLastMessageAt() != null
                        ? room.getLastMessageAt().format(formatter)
                        : "");

                // Xác định vai trò của người dùng trong phòng chat này
                boolean isSellerInThisRoom = effectiveShopId != null && room.getShop() != null && room.getShop().getId().equals(effectiveShopId);

                if (isSellerInThisRoom) {
                    // Đang xem với tư cách người bán → hiển thị thông tin Khách hàng
                    User customer = room.getCustomer();
                    dto.put("partnerName", customer != null && customer.getProfile() != null && customer.getProfile().getFullName() != null
                            ? customer.getProfile().getFullName()
                            : (customer != null ? customer.getEmail() : "Khách vãng lai"));
                    dto.put("partnerAvatar", customer != null && customer.getProfile() != null
                            ? customer.getProfile().getAvatarUrl()
                            : null);
                } else {
                    // Đang xem với tư cách người mua → hiển thị thông tin Shop
                    Shop shop = room.getShop();
                    dto.put("partnerName", shop != null ? shop.getName() : "Shop ẩn");
                    dto.put("partnerAvatar", shop != null ? shop.getLogoUrl() : null);
                }

                // Tin nhắn cuối cùng (preview) & Pre-load trang đầu vào Redis
                List<com.dto.ChatMessageBufferDTO> firstPage = chatService.getMessagesPaged(room.getId(), 0, 20);
                if (!firstPage.isEmpty()) {
                    com.dto.ChatMessageBufferDTO lastMsg = firstPage.get(firstPage.size() - 1);
                    String preview = lastMsg.getContent();
                    if (preview != null && preview.length() > 50) {
                        preview = preview.substring(0, 50) + "...";
                    }
                    dto.put("lastMessage", preview);
                } else {
                    dto.put("lastMessage", "Chưa có tin nhắn");
                }

                // Số tin nhắn chưa đọc
                long unread = countUnreadForRoom(room, currentUserId, isSellerInThisRoom);
                dto.put("unreadCount", unread);

                result.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("GET ROOMS ERROR: " + e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    private long countUnreadForRoom(ChatRoom room, Long currentUserId, boolean isSellerInThisRoom) {
        // Dùng truy vấn CSDL để đếm thay vì kéo toàn bộ tin nhắn lên RAM
        return chatMessageRepository.countByChatRoomIdAndSenderIdNotAndIsReadFalse(room.getId(), currentUserId);
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

        // KIỂM TRA BẢO MẬT: Chỉ cho phép Customer hoặc Chủ Shop truy cập
        ChatRoom room = chatRoomRepository.findByIdWithDetails(roomId).orElse(null);
        if (room == null) return ResponseEntity.notFound().build();
        
        boolean isCustomer = room.getCustomer().getId().equals(user.getId());
        boolean isShopOwner = room.getShop() != null && room.getShop().getUser() != null && 
                             room.getShop().getUser().getId().equals(user.getId());
        
        if (!isCustomer && !isShopOwner) {
            return ResponseEntity.status(403).body(Map.of("error", "Unauthorized access to this chat room"));
        }

        // Đánh dấu đã đọc khi mở phòng (chỉ làm ở trang đầu tiên)
        if (page == 0) {
            chatService.markRoomAsRead(roomId, user.getId());
        }

        List<ChatMessageBufferDTO> messages = chatService.getMessagesPaged(roomId, page, size);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");

        List<Map<String, Object>> result = new ArrayList<>();
        for (ChatMessageBufferDTO msg : messages) {
            try {
                if (msg == null) continue;
                
                Map<String, Object> dto = new HashMap<>();
                dto.put("content", msg.getContent());
                dto.put("senderId", msg.getSenderId());
                dto.put("senderName", msg.getSenderName());
                dto.put("senderAvatar", msg.getSenderAvatar());
                
                // Robust Time Formatting
                String formattedTime = "";
                try {
                    if (msg.getCreatedAt() != null) {
                        formattedTime = msg.getCreatedAt().format(formatter);
                    }
                } catch (Exception timeEx) {
                    // Fallback if it's not a LocalDateTime or format fails
                    formattedTime = msg.getCreatedAt() != null ? String.valueOf(msg.getCreatedAt()) : "";
                }
                dto.put("time", formattedTime);
                
                dto.put("isOwn", msg.getSenderId() != null && msg.getSenderId().equals(user.getId()));
                result.add(dto);
            } catch (Exception msgEx) {
                System.err.println("Error processing chat message: " + msgEx.getMessage());
            }
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

        // Tự động phát hiện nếu là chủ shop
        Shop userShop = shopRepository.findByUser(user).orElse(null);
        Long effectiveShopId = (shopId != null) ? shopId : (userShop != null ? userShop.getId() : null);

        long count = 0;
        if (effectiveShopId != null) {
            count += chatService.countUnreadByShop(effectiveShopId);
        }
        // Cộng thêm tin nhắn chưa đọc với tư cách là người mua hàng
        count += chatService.countUnreadByCustomer(user.getId());

        return ResponseEntity.ok(Map.of("count", count));
    }
}
