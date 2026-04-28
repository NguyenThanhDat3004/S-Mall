package com.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

@Service
public class UserAddressRedisService {

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    private static final String KEY_PREFIX = "user:address:";

    /**
     * Lưu địa chỉ người dùng vào Redis vô thời hạn
     */
    public void saveAddress(String email, String address) {
        String key = KEY_PREFIX + email;
        redisTemplate.opsForValue().set(key, address);
        // Không set TTL để lưu vô thời hạn
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
