package com.dto;

import java.time.LocalDateTime;

public class CustomerInsightDTO {
    private Long userId;
    private String email;
    private String fullName;
    private String avatarUrl;
    private long totalOrders;
    private double totalSpent;
    private LocalDateTime lastOrderDate;

    public CustomerInsightDTO(Long userId, String email, String fullName, String avatarUrl, long totalOrders, double totalSpent, LocalDateTime lastOrderDate) {
        this.userId = userId;
        this.email = email;
        this.fullName = fullName;
        this.avatarUrl = avatarUrl;
        this.totalOrders = totalOrders;
        this.totalSpent = totalSpent;
        this.lastOrderDate = lastOrderDate;
    }

    // Getters and Setters
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }
    public long getTotalOrders() { return totalOrders; }
    public void setTotalOrders(long totalOrders) { this.totalOrders = totalOrders; }
    public double getTotalSpent() { return totalSpent; }
    public void setTotalSpent(double totalSpent) { this.totalSpent = totalSpent; }
    public LocalDateTime getLastOrderDate() { return lastOrderDate; }
    public void setLastOrderDate(LocalDateTime lastOrderDate) { this.lastOrderDate = lastOrderDate; }
}
