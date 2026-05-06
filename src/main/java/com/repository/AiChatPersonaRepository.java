package com.repository;

import com.entity.AiChatPersona;
import com.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface AiChatPersonaRepository extends JpaRepository<AiChatPersona, Long> {
    List<AiChatPersona> findTop3ByUserOrderByUpdatedAtDesc(User user);
}
