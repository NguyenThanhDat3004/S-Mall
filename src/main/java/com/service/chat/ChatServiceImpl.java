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

        return dto;
    }

    @Override
    public List<ChatMessageBufferDTO> getMessagesCombined(Long roomId) {
        // 1. Lấy từ DB
        List<ChatMessage> dbMessages = getMessagesByRoom(roomId);
        List<ChatMessageBufferDTO> result = dbMessages.stream().map(m -> ChatMessageBufferDTO.builder()
                .roomId(roomId)
                .senderId(m.getSender().getId())
                .content(m.getContent())
                .senderName(m.getSender().getProfile() != null ? m.getSender().getProfile().getFullName() : m.getSender().getEmail())
                .senderAvatar(m.getSender().getProfile() != null ? m.getSender().getProfile().getAvatarUrl() : null)
                .createdAt(m.getCreatedAt())
                .build()).collect(Collectors.toList());

        // 2. Lấy từ Redis Buffer (lọc theo roomId)
        List<Object> bufferRaw = redisTemplate.opsForList().range(CHAT_BUFFER_KEY, 0, -1);
        if (bufferRaw != null) {
            for (Object obj : bufferRaw) {
                ChatMessageBufferDTO dto = objectMapper.convertValue(obj, ChatMessageBufferDTO.class);
                if (dto.getRoomId().equals(roomId)) {
                    result.add(dto);
                }
            }
        }

        return result;
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
                .mapToLong(room -> chatMessageRepository.countByChatRoomIdAndSenderIdNotAndIsReadFalse(room.getId(), userId))
                .sum();
    }

    @Override
    public long countUnreadByShop(Long shopId) {
        List<ChatRoom> rooms = chatRoomRepository.findByShopIdOrderByLastMessageAtDesc(shopId);
        Shop shop = shopRepository.findById(shopId).orElse(null);
        if (shop == null || shop.getUser() == null) return 0;

        Long sellerUserId = shop.getUser().getId();
        return rooms.stream()
                .mapToLong(room -> chatMessageRepository.countByChatRoomIdAndSenderIdNotAndIsReadFalse(room.getId(), sellerUserId))
                .sum();
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
