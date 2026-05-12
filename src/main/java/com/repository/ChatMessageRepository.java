package com.repository;

import com.entity.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {
    // Phân trang tin nhắn cũ từ CSDL (Spring Data tự sinh SQL chuẩn)
    org.springframework.data.domain.Page<ChatMessage> findByChatRoomId(Long roomId, org.springframework.data.domain.Pageable pageable);

    // Lấy tin nhắn cuối cùng để làm preview
    ChatMessage findFirstByChatRoomIdOrderByCreatedAtDesc(Long roomId);

    // Lấy toàn bộ tin nhắn của 1 phòng (cho preview hoặc đếm)
    List<ChatMessage> findByChatRoomIdOrderByCreatedAtAsc(Long roomId);

    // Đếm tin nhắn chưa đọc trong phòng (không tính tin của chính mình)
    long countByChatRoomIdAndSenderIdNotAndIsReadFalse(Long roomId, Long userId);

    // Lấy tin nhắn chưa đọc để đánh dấu đã đọc
    List<ChatMessage> findByChatRoomIdAndSenderIdNotAndIsReadFalse(Long roomId, Long userId);
}
