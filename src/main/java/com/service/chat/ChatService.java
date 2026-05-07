package com.service.chat;

import com.entity.ChatMessage;
import com.entity.ChatRoom;
import com.dto.ChatMessageBufferDTO;
import java.util.List;

public interface ChatService {

    /**
     * Tìm phòng chat giữa Customer và Shop (không tạo mới)
     */
    ChatRoom findRoom(Long customerId, Long shopId);

    ChatRoom getOrCreateRoom(Long customerId, Long shopId);

    /**
     * Lưu tin nhắn vào Redis Buffer (không ghi MySQL ngay)
     */
    ChatMessageBufferDTO bufferMessage(Long roomId, Long senderId, String content, Long shopId);

    /**
     * Lấy lịch sử chat (kết hợp MySQL + Redis Buffer)
     */
    List<ChatMessageBufferDTO> getMessagesCombined(Long roomId);

    /**
     * Lưu tin nhắn vào MySQL (Dùng cho Sync Task hoặc các trường hợp đặc biệt)
     */
    ChatMessage saveMessage(Long roomId, Long senderId, String content, Long shopId);

    /**
     * Lấy lịch sử chat theo phòng
     */
    List<ChatMessage> getMessagesByRoom(Long roomId);

    /**
     * Danh sách phòng chat phía Buyer (theo customer_id)
     */
    List<ChatRoom> getRoomsByCustomer(Long userId);

    /**
     * Danh sách phòng chat phía Seller (theo shop_id)
     */
    List<ChatRoom> getRoomsByShop(Long shopId);

    /**
     * Tổng số tin nhắn chưa đọc phía Buyer
     */
    long countUnreadByCustomer(Long userId);

    /**
     * Tổng số tin nhắn chưa đọc phía Seller (tính theo shop)
     */
    long countUnreadByShop(Long shopId);

    /**
     * Đánh dấu tất cả tin nhắn trong phòng là đã đọc (của đối phương)
     */
    void markRoomAsRead(Long roomId, Long userId);
}
