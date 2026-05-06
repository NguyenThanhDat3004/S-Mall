package com.repository;

import com.entity.AiChatMessage;
import com.entity.AiChatSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface AiChatMessageRepository extends JpaRepository<AiChatMessage, Long> {
    List<AiChatMessage> findBySessionOrderByCreatedAtAsc(AiChatSession session);
}
