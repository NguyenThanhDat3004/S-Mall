package com.entity;

import java.time.LocalDateTime;
import jakarta.persistence.*;

@Entity
@Table(name = "ai_chat_personas")
public class AiChatPersona {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    @Column(name = "persona_data", columnDefinition = "NVARCHAR(MAX)")
    private String personaData;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();

    public AiChatPersona() {}

    public AiChatPersona(User user, String personaData) {
        this.user = user;
        this.personaData = personaData;
        this.updatedAt = LocalDateTime.now();
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public String getPersonaData() { return personaData; }
    public void setPersonaData(String personaData) { this.personaData = personaData; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
