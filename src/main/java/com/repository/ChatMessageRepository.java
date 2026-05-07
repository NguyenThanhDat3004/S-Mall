package com.repository;

import com.entity.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {
    List<ChatMessage> findByChatRoomIdOrderByCreatedAtAsc(Long roomId);

    // Đếm tin nhắn chưa đọc trong phòng (không tính tin của chính mình)
    long countByChatRoomIdAndSenderIdNotAndIsReadFalse(Long roomId, Long userId);

    // Lấy tin nhắn chưa đọc để đánh dấu đã đọc
    List<ChatMessage> findByChatRoomIdAndSenderIdNotAndIsReadFalse(Long roomId, Long userId);
}
