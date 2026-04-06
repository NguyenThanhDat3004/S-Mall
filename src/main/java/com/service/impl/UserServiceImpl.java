package com.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.entity.UserProfile;
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
    public UserProfile handleSaveUser(UserProfile user){
        try {
           user =  this.userRepository.save(user);
        } catch (Exception e) {
            return null;
        }
        return user;
    }
    public List<UserProfile> getAllUsers(){
        return this.userRepository.findAll();
    }
    public List<UserProfile> getUsersByEmail(String email){
        return this.userRepository.findByEmail(email);
    }
    public boolean deleteById(int id){
        boolean success = false;
        try {
            this.userRepository.deleteById(id);
            success =  true;
        } catch (Exception e) {
            System.out.println("Error deleting user with id " + id + ": " + e.getMessage());
            success =  false;
        }
        return success;
    }
    public UserProfile handleUpdateUser(UserProfile user){
        try {
           user =  this.userRepository.save(user);
        } catch (Exception e) {
            return null;
        }
        return user;
    }
    public UserProfile findById(int id){
        UserProfile user = null;
        try {
           user =  this.userRepository.findById(id);
        } catch (Exception e) {
            return null;
        }
        return user;
    }
}
