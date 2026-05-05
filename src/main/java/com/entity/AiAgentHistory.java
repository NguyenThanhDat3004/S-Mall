package com.entity;

import java.time.LocalDateTime;
import jakarta.persistence.*;

/**
 * Lưu trữ lịch sử hội thoại và quá trình tư duy (Reasoning) của AI Agent
 */
@Entity
@Table(name = "ai_agent_history")
public class AiAgentHistory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "seller_id")
    @com.fasterxml.jackson.annotation.JsonIgnore
    private User seller;

    @Column(nullable = false)
    private String role; // USER, ASSISTANT, THOUGHT, TOOL

    @Column(columnDefinition = "NVARCHAR(MAX)")
    private String content;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    public AiAgentHistory() {}

    public AiAgentHistory(User seller, String role, String content) {
        this.seller = seller;
        this.role = role;
        this.content = content;
        this.createdAt = LocalDateTime.now();
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public User getSeller() { return seller; }
    public void setSeller(User seller) { this.seller = seller; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
