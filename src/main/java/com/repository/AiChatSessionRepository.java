package com.repository;

import com.entity.AiChatSession;
import com.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface AiChatSessionRepository extends JpaRepository<AiChatSession, Long> {
    List<AiChatSession> findByUserOrderByCreatedAtDesc(User user);
    Optional<AiChatSession> findTopByUserAndIsActiveTrueOrderByCreatedAtDesc(User user);
}
