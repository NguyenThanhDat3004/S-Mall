package com.service.ai.impl;

import com.service.ai.UserBehaviorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

@Service
public class UserBehaviorServiceImpl implements UserBehaviorService {

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    private static final String CAT_KEY_PREFIX = "user:interests:cats:";
    private static final String KW_KEY_PREFIX = "user:interests:kws:";
    private static final long TTL_HOURS = 24;

    @Override
    public void logProductView(String identifier, Long categoryId) {
        if (identifier == null) return;
        
        String key = CAT_KEY_PREFIX + identifier;
        // Lưu Category ID vào Set (không trùng lặp)
        redisTemplate.opsForSet().add(key, String.valueOf(categoryId));
        // Đặt thời gian sống 24h
        redisTemplate.expire(key, TTL_HOURS, TimeUnit.HOURS);
        
        System.out.println(">>> [AI-TRACKING] Logged View: User " + identifier + " interested in Category " + categoryId);
    }

    @Override
    public void logSearch(String identifier, String keyword) {
        if (identifier == null || keyword == null || keyword.trim().isEmpty()) return;

        String key = KW_KEY_PREFIX + identifier;
        // Lưu từ khóa vào List (giữ thứ tự tìm kiếm gần nhất)
        redisTemplate.opsForList().rightPush(key, keyword.trim());
        // Giới hạn chỉ lưu 10 từ khóa gần nhất
        redisTemplate.opsForList().trim(key, -10, -1);
        // Đặt thời gian sống 24h
        redisTemplate.expire(key, TTL_HOURS, TimeUnit.HOURS);

        System.out.println(">>> [AI-TRACKING] Logged Search: User " + identifier + " searched for " + keyword);
    }
}
