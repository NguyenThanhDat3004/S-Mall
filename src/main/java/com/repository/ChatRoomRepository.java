package com.repository;

import com.entity.ChatRoom;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;
import java.util.List;

public interface ChatRoomRepository extends JpaRepository<ChatRoom, Long> {
    Optional<ChatRoom> findByCustomerIdAndShopId(Long customerId, Long shopId);
    List<ChatRoom> findByShopIdOrderByLastMessageAtDesc(Long shopId);
    List<ChatRoom> findByCustomerIdOrderByLastMessageAtDesc(Long customerId);
}
