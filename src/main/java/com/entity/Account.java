package com.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
@Entity
public class Account {
    @jakarta.persistence.Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    private String phoneNumber;
    private String passwordHash;
    private boolean status;
    private LocalDateTime createdAt;

    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role;
    // khi nao co join thi khi do moi co truong so huu
    // duoc tao ra
    @OneToMany(mappedBy = "account")
    private java.util.List<Order> orders;
    // con cai nay la dung moi quan he de lay data chu khong tao them
    public Account() {
        this.role = new Role(1, "User");
        this.status = true;
        this.createdAt = LocalDateTime.now();
    }

    public Account(int id, String phoneNumber, String passwordHash, Role role, boolean status, LocalDateTime createdAt) {
        this.id = id;
        this.phoneNumber = phoneNumber;
        this.passwordHash = passwordHash;
        this.role = role;
        this.status = status;
        this.createdAt = createdAt;
    }

    public Account(String phoneNumber, String passwordHash, Role role, LocalDateTime createdAt) {

        this.phoneNumber = phoneNumber;
        this.passwordHash = passwordHash;
        this.role = role;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getphoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public Role getRole() {
        return role;
    }
    public void setRole(Role role) {
        this.role = role;
    }
    public String getPhoneNumber() {
        return phoneNumber;
    }
    
    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
