package com.repository;

import com.entity.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {
    @org.springframework.data.jpa.repository.Query("SELECT m FROM ChatMessage m LEFT JOIN FETCH m.sender s LEFT JOIN FETCH s.profile p WHERE m.chatRoom.id = :roomId")
    org.springframework.data.domain.Page<ChatMessage> findByChatRoomId(@org.springframework.data.repository.query.Param("roomId") Long roomId, org.springframework.data.domain.Pageable pageable);

    // Đếm tin nhắn chưa đọc trong phòng (không tính tin của chính mình)
    long countByChatRoomIdAndSenderIdNotAndIsReadFalse(Long roomId, Long userId);

    // Lấy tin nhắn chưa đọc để đánh dấu đã đọc
    List<ChatMessage> findByChatRoomIdAndSenderIdNotAndIsReadFalse(Long roomId, Long userId);
}
