package com.entity;

import java.time.LocalDate;

public class UserProfile {
    private int id;
    private String fullName;
    private String email;
    private boolean gender;
    private String address;
    private LocalDate dateOfBirth;

    public UserProfile() {}

    public UserProfile(int id, String fullName, String email, boolean gender, String address, LocalDate dateOfBirth) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.gender = gender;
        this.address = address;
        this.dateOfBirth = dateOfBirth;
    }

    public UserProfile( String fullName, String email, boolean gender, String address, LocalDate dateOfBirth) {
        this.fullName = fullName;
        this.email = email;
        this.gender = gender;
        this.address = address;
        this.dateOfBirth = dateOfBirth;
    }
    

    // Getters and Setters
    public int getUserId() { return id; }
    public void setUserId(int userId) { this.id = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public boolean isGender() { return gender; }
    public void setGender(boolean gender) { this.gender = gender; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public LocalDate getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(LocalDate dateOfBirth) { this.dateOfBirth = dateOfBirth; }
}

