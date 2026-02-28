package com.entity;

import java.time.LocalDate;
import java.time.LocalDateTime;

// UserProflile and Account combined Data Transfer Object
public class UserDTO {
    // Account fields
    private int accountId;
    private String phoneNumber;
    private String passwordHash;
    private String roleId;
    private boolean status;
    private LocalDateTime createdAt;

    // User profile fields
    private int profileId;
    private String fullName;
    private String email;
    private boolean gender;
    private String address;
    private LocalDate dateOfBirth;

    public UserDTO() {
    }

    public UserDTO(int accountId, String phoneNumber, String passwordHash, String roleId, boolean status, LocalDateTime createdAt, int profileId, String fullName, String email, boolean gender, String address, LocalDate dateOfBirth) {
        this.accountId = accountId;
        this.phoneNumber = phoneNumber;
        this.passwordHash = passwordHash;
        this.roleId = roleId;
        this.status = status;
        this.createdAt = createdAt;
        this.profileId = profileId;
        this.fullName = fullName;
        this.email = email;
        this.gender = gender;
        this.address = address;
        this.dateOfBirth = dateOfBirth;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public int getProfileId() {
        return profileId;
    }

    public void setProfileId(int profileId) {
        this.profileId = profileId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public boolean isGender() {
        return gender;
    }

    public void setGender(boolean gender) {
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    
    @Override
    public String toString() {
        return "UserDTO{" + "accountId=" + accountId + ", phoneNumber=" + phoneNumber + ", passwordHash=" + passwordHash + ", roleId=" + roleId + ", status=" + status + ", createdAt=" + createdAt + ", profileId=" + profileId + ", fullName=" + fullName + ", email=" + email + ", gender=" + gender + ", address=" + address + ", dateOfBirth=" + dateOfBirth + '}';
    }

    

}
