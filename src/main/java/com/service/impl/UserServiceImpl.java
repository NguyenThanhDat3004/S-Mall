package com.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import java.util.Optional;
import com.entity.User;
import com.repository.UserRepository;
import com.service.UserService;

@Service
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;

    public UserServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public String getUserInfo() {
        return "User information from UserService";
    }

    public User handleSaveUser(User user) {
        try {
            return this.userRepository.save(user);
        } catch (Exception e) {
            return null;
        }
    }

    public List<User> getAllUsers() {
        return this.userRepository.findAll();
    }

    public Optional<User> getUsersByEmail(String email) {
        return this.userRepository.findByEmail(email);
    }

    public boolean deleteById(Long id) {
        try {
            this.userRepository.deleteById(id);
            return true;
        } catch (Exception e) {
            System.out.println("Error deleting user with id " + id + ": " + e.getMessage());
            return false;
        }
    }

    public User handleUpdateUser(User user) {
        try {
            return this.userRepository.save(user);
        } catch (Exception e) {
            return null;
        }
    }

    public User findById(Long id) {
        return this.userRepository.findById(id).orElse(null);
    }
}
