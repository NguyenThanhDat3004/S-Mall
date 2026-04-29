package com.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

@Service
@org.springframework.transaction.annotation.Transactional
public class UserAddressRedisService {

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    private static final String KEY_PREFIX = "user:address:";

    @Autowired
    private com.repository.UserRepository userRepository;

    @Autowired
    private com.repository.UserProfileRepository userProfileRepository;

    @Autowired
    private com.repository.AddressRepository addressRepository;

    /**
     * Lưu địa chỉ người dùng vào Redis và SQL
     */
    public void saveAddress(String email, String address) {
        String key = KEY_PREFIX + email;
        redisTemplate.opsForValue().set(key, address);
        
        // Cập nhật SQL
        userRepository.findByEmail(email).ifPresent(user -> {
            // 1. Cập nhật vào bảng Address (Danh sách địa chỉ - Thêm mới nếu chưa có)
            com.entity.Address sqlAddress = addressRepository.findByUserAndFullAddress(user, address)
                    .orElse(new com.entity.Address());
            
            if (sqlAddress.getId() == null) {
                sqlAddress.setUser(user);
                sqlAddress.setFullAddress(address);
                addressRepository.save(sqlAddress);
                System.out.println(">>> SQL ADDRESS TABLE SAVED (New entry) for " + email + ": " + address);
            } else {
                System.out.println(">>> SQL ADDRESS ALREADY EXISTS in table for " + email);
            }
            
            // KHÔNG cập nhật UserProfile.address theo yêu cầu của USER
            System.out.println(">>> SQL PERSISTENCE: Address added to history, UserProfile left untouched.");
        });
    }

    public void syncAddressFromDbToRedis(String email) {
        userRepository.findByEmail(email).ifPresent(user -> {
            if (user.getProfile() != null && user.getProfile().getAddress() != null) {
                String key = KEY_PREFIX + email;
                redisTemplate.opsForValue().set(key, user.getProfile().getAddress());
            }
        });
    }

    /**
     * Lấy địa chỉ người dùng từ Redis
     */
    public String getAddress(String email) {
        String key = KEY_PREFIX + email;
        Object val = redisTemplate.opsForValue().get(key);
        return val != null ? val.toString() : null;
    }

    /**
     * Xóa địa chỉ người dùng khỏi Redis
     */
    public void deleteAddress(String email) {
        String key = KEY_PREFIX + email;
        redisTemplate.delete(key);
    }
}
