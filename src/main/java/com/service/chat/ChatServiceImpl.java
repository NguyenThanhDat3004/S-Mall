package com.service.chat;

import com.entity.ChatMessage;
import com.entity.ChatRoom;
import com.entity.Shop;
import com.entity.User;
import com.repository.ChatMessageRepository;
import com.repository.ChatRoomRepository;
import com.repository.ShopRepository;
import com.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

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
    @Transactional
    public ChatMessage saveMessage(Long roomId, Long senderId, String content) {
        ChatRoom room = chatRoomRepository.findById(roomId)
                .orElseThrow(() -> new RuntimeException("ChatRoom not found: " + roomId));
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
