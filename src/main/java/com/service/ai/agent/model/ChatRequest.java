package com.service.ai.agent.model;

public class ChatRequest {
    private String message;
    private Long sessionId;

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public Long getSessionId() { return sessionId; }
    public void setSessionId(Long sessionId) { this.sessionId = sessionId; }
}
