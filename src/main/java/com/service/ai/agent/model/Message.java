package com.service.ai.agent.model;

/**
 * Lớp đại diện cho một tin nhắn trong hội thoại với LLM
 */
public class Message {
    private String role; // user, assistant, system
    private String content;

    public Message() {}

    public Message(String role, String content) {
        this.role = role;
        this.content = content;
    }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
}
