package com.entity;

import java.time.LocalDateTime;
import jakarta.persistence.*;

@Entity
@Table(name = "ai_chat_messages")
public class AiChatMessage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "session_id", nullable = false)
    private AiChatSession session;

    @Column(nullable = false)
    private String role; // USER, ASSISTANT

    @Column(columnDefinition = "NVARCHAR(MAX)")
    private String content;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    public AiChatMessage() {}

    public AiChatMessage(AiChatSession session, String role, String content) {
        this.session = session;
        this.role = role;
        this.content = content;
        this.createdAt = LocalDateTime.now();
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public AiChatSession getSession() { return session; }
    public void setSession(AiChatSession session) { this.session = session; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
