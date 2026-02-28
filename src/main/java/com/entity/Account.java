package com.entity;

import java.time.LocalDateTime;

public class Account {
    private int id;
    private String phoneNumber;
    private String passwordHash;
    private String roleId;
    private boolean status;
    private LocalDateTime createdAt;

    public Account() {
        this.roleId = "User";
        this.status = true;
        this.createdAt = LocalDateTime.now();
    }

    public Account(int id, String phoneNumber, String passwordHash, String roleId, boolean status, LocalDateTime createdAt) {
        this.id = id;
        this.phoneNumber = phoneNumber;
        this.passwordHash = passwordHash;
        this.roleId = roleId;
        this.status = status;
        this.createdAt = createdAt;
    }

    public Account(String phoneNumber, String passwordHash, String roleId, LocalDateTime createdAt) {

        this.phoneNumber = phoneNumber;
        this.passwordHash = passwordHash;
        this.roleId = roleId;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getphoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getRoleId() { return roleId; }
    public void setRoleId(String roleId) { this.roleId = roleId; }

    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
