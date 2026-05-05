package com.repository;

import com.entity.AiAgentHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface AiAgentHistoryRepository extends JpaRepository<AiAgentHistory, Long> {
    List<AiAgentHistory> findBySellerIdOrderByCreatedAtAsc(Long sellerId);
    
    // Xóa lịch sử hội thoại nếu người dùng muốn làm mới (Reset chat)
    void deleteBySellerId(Long sellerId);
}
