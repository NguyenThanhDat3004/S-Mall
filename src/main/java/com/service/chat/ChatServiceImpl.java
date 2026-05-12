package com.service.chat;

import com.entity.ChatMessage;
import com.entity.ChatRoom;
import com.entity.Shop;
import com.entity.User;
import com.repository.ChatMessageRepository;
import com.repository.ChatRoomRepository;
import com.repository.ShopRepository;
import com.repository.UserRepository;
import com.dto.ChatMessageBufferDTO;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ChatServiceImpl implements ChatService {

    @Autowired
    private ChatRoomRepository chatRoomRepository;

    @Autowired
    private ChatMessageRepository chatMessageRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ShopRepository shopRepository;

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    @Autowired
    private ObjectMapper objectMapper;

    private static final String CHAT_BUFFER_KEY = "chat:buffer:messages";
    private static final String CHAT_CACHE_PREFIX = "chat:cache:";
    private static final int CHAT_CACHE_TTL_MINUTES = 10;

    @Override
    public ChatRoom findRoom(Long customerId, Long shopId) {
        return chatRoomRepository.findByCustomerIdAndShopId(customerId, shopId).orElse(null);
    }

    @Override
    @Transactional
    public ChatRoom getOrCreateRoom(Long customerId, Long shopId) {
        return chatRoomRepository.findByCustomerIdAndShopId(customerId, shopId)
                .orElseGet(() -> {
                    User customer = userRepository.findById(customerId)
                            .orElseThrow(() -> new RuntimeException("User not found: " + customerId));
                    Shop shop = shopRepository.findById(shopId)
                            .orElseThrow(() -> new RuntimeException("Shop not found: " + shopId));

                    ChatRoom room = new ChatRoom();
                    room.setCustomer(customer);
                    room.setShop(shop);
                    return chatRoomRepository.save(room);
                });
    }

    @Override
    public ChatMessageBufferDTO bufferMessage(Long roomId, Long senderId, String content, Long shopId) {
        User sender = userRepository.findById(senderId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // Nếu là tin nhắn đầu tiên (Lazy Creation), tạo phòng trong MySQL ngay
        Long actualRoomId = roomId;
        if (actualRoomId == null || actualRoomId == 0) {
            ChatRoom room = getOrCreateRoom(senderId, shopId);
            actualRoomId = room.getId();
        }

        ChatMessageBufferDTO dto = ChatMessageBufferDTO.builder()
                .roomId(actualRoomId)
                .senderId(senderId)
                .content(content)
                .senderName(sender.getProfile() != null ? sender.getProfile().getFullName() : sender.getEmail())
                .senderAvatar(sender.getProfile() != null ? sender.getProfile().getAvatarUrl() : null)
                .createdAt(LocalDateTime.now())
                .build();

        // Đẩy vào Redis Buffer
        redisTemplate.opsForList().rightPush(CHAT_BUFFER_KEY, dto);

        // Xóa cache của trang đầu tiên (page 0) để khi reload trang, API sẽ nạp lại dữ liệu mới nhất
        try {
            redisTemplate.delete("chat:cache:" + actualRoomId + ":page:0");
        } catch (Exception e) {
            System.err.println("Failed to clear chat cache: " + e.getMessage());
        }

        return dto;
    }

    @Override
    @Transactional(readOnly = true)
    public List<ChatMessageBufferDTO> getMessagesPaged(Long roomId, int page, int size) {
        String cacheKey = CHAT_CACHE_PREFIX + roomId + ":page:" + page;
        
        // 1. Thử lấy từ Redis Cache trước
        try {
            List<Object> cached = redisTemplate.opsForList().range(cacheKey, 0, -1);
            if (cached != null && !cached.isEmpty()) {
                return cached.stream()
                    .map(obj -> objectMapper.convertValue(obj, ChatMessageBufferDTO.class))
                    .collect(Collectors.toList());
            }
        } catch (Exception e) {
            System.err.println("[ChatService] Cache error: " + e.getMessage());
        }

        List<ChatMessageBufferDTO> result = new ArrayList<>();
        if (roomId == null) return result;

        // 2. Lấy từ DB
        try {
            org.springframework.data.domain.Pageable pageable = org.springframework.data.domain.PageRequest.of(
                page, size, org.springframework.data.domain.Sort.by("createdAt").descending());
            
            org.springframework.data.domain.Page<ChatMessage> dbPage = chatMessageRepository.findByChatRoomId(roomId, pageable);
            
            // Chuyển sang DTO và đảo ngược lại thành ASC (để hiển thị đúng thứ tự thời gian trong 1 trang)
            List<ChatMessage> content = new ArrayList<>(dbPage.getContent());
            java.util.Collections.reverse(content);

            for (ChatMessage m : content) {
                result.add(ChatMessageBufferDTO.builder()
                    .roomId(roomId)
                    .senderId(m.getSender() != null ? m.getSender().getId() : null)
                    .content(m.getContent())
                    .senderName(m.getSender() != null 
                            ? (m.getSender().getProfile() != null && m.getSender().getProfile().getFullName() != null 
                                ? m.getSender().getProfile().getFullName() 
                                : m.getSender().getEmail()) 
                            : "Hệ thống")
                    .senderAvatar(m.getSender() != null && m.getSender().getProfile() != null ? m.getSender().getProfile().getAvatarUrl() : null)
                    .createdAt(m.getCreatedAt())
                    .build());
            }

            // 3. Nếu là trang 0 (mới nhất), gộp thêm tin nhắn từ Buffer (Redis List)
            if (page == 0) {
                List<Object> bufferRaw = redisTemplate.opsForList().range(CHAT_BUFFER_KEY, 0, -1);
                if (bufferRaw != null) {
                    for (Object obj : bufferRaw) {
                        ChatMessageBufferDTO dto = objectMapper.convertValue(obj, ChatMessageBufferDTO.class);
                        if (dto.getRoomId() != null && String.valueOf(dto.getRoomId()).equals(String.valueOf(roomId))) {
                            result.add(dto);
                        }
                    }
                }
            }

            // 4. Lưu vào Redis Cache (nếu trang có dữ liệu)
            if (!result.isEmpty()) {
                try {
                    redisTemplate.opsForList().rightPushAll(cacheKey, result.toArray());
                    redisTemplate.expire(cacheKey, java.time.Duration.ofMinutes(CHAT_CACHE_TTL_MINUTES));
                } catch (Exception e) {
                    System.err.println("[ChatService] Failed to cache messages: " + e.getMessage());
                }
            }

        } catch (Exception e) {
            System.err.println("[ChatService] DB Error: " + e.getMessage());
        }

        return result;
    }

    @Override
    public void clearChatCache(Long roomId) {
        try {
            String pattern = CHAT_CACHE_PREFIX + roomId + ":*";
            java.util.Set<String> keys = redisTemplate.keys(pattern);
            if (keys != null && !keys.isEmpty()) {
                redisTemplate.delete(keys);
            }
        } catch (Exception e) {
            System.err.println("[ChatService] Clear cache error: " + e.getMessage());
        }
    }

    @Override
    @Transactional
    public ChatMessage saveMessage(Long roomId, Long senderId, String content, Long shopId) {
        ChatRoom room;
        if (roomId != null && roomId > 0) {
            room = chatRoomRepository.findById(roomId)
                    .orElseThrow(() -> new RuntimeException("ChatRoom not found: " + roomId));
        } else if (shopId != null) {
            // Lazy Creation: Tạo phòng khi gửi tin nhắn đầu tiên
            room = getOrCreateRoom(senderId, shopId);
        } else {
            throw new RuntimeException("Cannot save message: Both roomId and shopId are null");
        }

        User sender = userRepository.findById(senderId)
                .orElseThrow(() -> new RuntimeException("User not found: " + senderId));

        ChatMessage message = new ChatMessage();
        message.setChatRoom(room);
        message.setSender(sender);
        message.setContent(content);
        message.setMessageType("TEXT");
        message.setCreatedAt(LocalDateTime.now());

        // Cập nhật thời gian tin nhắn cuối của phòng
        room.setLastMessageAt(LocalDateTime.now());
        chatRoomRepository.save(room);

        return chatMessageRepository.save(message);
    }

    @Override
    public ChatMessage getLastMessage(Long roomId) {
        return chatMessageRepository.findFirstByChatRoomIdOrderByCreatedAtDesc(roomId);
    }

    @Override
    public List<ChatMessage> getMessagesByRoom(Long roomId) {
        return chatMessageRepository.findByChatRoomIdOrderByCreatedAtAsc(roomId);
    }

    @Override
    public List<ChatRoom> getRoomsByCustomer(Long userId) {
        return chatRoomRepository.findByCustomerIdOrderByLastMessageAtDesc(userId);
    }

    @Override
    public List<ChatRoom> getRoomsByShop(Long shopId) {
        return chatRoomRepository.findByShopIdOrderByLastMessageAtDesc(shopId);
    }

    @Override
    public long countUnreadByCustomer(Long userId) {
        List<ChatRoom> rooms = chatRoomRepository.findByCustomerIdOrderByLastMessageAtDesc(userId);
        return rooms.stream()
                .filter(room -> chatMessageRepository.countByChatRoomIdAndSenderIdNotAndIsReadFalse(room.getId(), userId) > 0)
                .count();
    }

    @Override
    public long countUnreadByShop(Long shopId) {
        List<ChatRoom> rooms = chatRoomRepository.findByShopIdOrderByLastMessageAtDesc(shopId);
        Shop shop = shopRepository.findById(shopId).orElse(null);
        if (shop == null || shop.getUser() == null) return 0;

        Long sellerUserId = shop.getUser().getId();
        return rooms.stream()
                .filter(room -> chatMessageRepository.countByChatRoomIdAndSenderIdNotAndIsReadFalse(room.getId(), sellerUserId) > 0)
                .count();
    }

    @Override
    @Transactional
    public void markRoomAsRead(Long roomId, Long userId) {
        List<ChatMessage> unread = chatMessageRepository
                .findByChatRoomIdAndSenderIdNotAndIsReadFalse(roomId, userId);
        unread.forEach(msg -> msg.setRead(true));
        chatMessageRepository.saveAll(unread);
    }
}
