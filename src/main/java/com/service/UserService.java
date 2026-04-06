package com.service;

import java.util.List;
import com.entity.UserProfile;

public interface UserService {
    String getUserInfo();
    UserProfile handleSaveUser(UserProfile user);
    List<UserProfile> getAllUsers();
    List<UserProfile> getUsersByEmail(String email);
    boolean deleteById(int id);
    UserProfile handleUpdateUser(UserProfile user);
    UserProfile findById(int id);
}
