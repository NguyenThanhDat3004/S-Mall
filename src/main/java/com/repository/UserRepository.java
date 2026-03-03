package com.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.entity.UserProfile;

@Repository
public interface UserRepository extends JpaRepository<UserProfile, Integer> {
    UserProfile save(UserProfile userProfile);
    List<UserProfile> findByEmail(String email);
    void deleteById(int id);
    UserProfile findById(int id);

} 
