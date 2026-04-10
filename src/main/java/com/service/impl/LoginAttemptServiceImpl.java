package com.service.impl;

import java.util.concurrent.TimeUnit;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import com.service.LoginAttemptService;

@Service
public class LoginAttemptServiceImpl implements LoginAttemptService {

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    private static final int MAX_ATTEMPT = 5;
    private static final long LOCK_TIME = 30; // 30 minutes
    private static final String BLOCK_PREFIX = "BLOCK_";
    private static final String ATTEMPT_PREFIX = "ATTEMPT_";

    @Override
    public void loginSucceeded(String key) {
        redisTemplate.delete(ATTEMPT_PREFIX + key);
        redisTemplate.delete(BLOCK_PREFIX + key);
    }

    @Override
    public void loginFailed(String key) {
        int attempts = 0;
        Object cachedAttempts = redisTemplate.opsForValue().get(ATTEMPT_PREFIX + key);
        if (cachedAttempts != null) {
            attempts = (Integer) cachedAttempts;
        }
        attempts++;
        redisTemplate.opsForValue().set(ATTEMPT_PREFIX + key, attempts, LOCK_TIME, TimeUnit.MINUTES);

        if (attempts >= MAX_ATTEMPT) {
            redisTemplate.opsForValue().set(BLOCK_PREFIX + key, "blocked", LOCK_TIME, TimeUnit.MINUTES);
        }
    }

    @Override
    public boolean isBlocked(String key) {
        return redisTemplate.hasKey(BLOCK_PREFIX + key);
    }

    @Override
    public long getLockExpiry(String key) {
        Long expire = redisTemplate.getExpire(BLOCK_PREFIX + key, TimeUnit.SECONDS);
        return (expire != null) ? expire : 0;
    }
}
