package com.service;

import org.springframework.stereotype.Service;

@Service
public class UserService {
    public String getUserInfo() {
        return "User information from UserService";
    }
}
