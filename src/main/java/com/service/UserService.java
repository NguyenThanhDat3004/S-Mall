package com.service;

import java.util.List;
import com.entity.User;
import java.util.Optional;

public interface UserService {
    String getUserInfo();

    User handleSaveUser(User user);

    List<User> getAllUsers();

    Optional<User> getUserByEmail(String email);

    boolean deleteById(Long id);

    User handleUpdateUser(User user);

    User findById(Long id);
}
