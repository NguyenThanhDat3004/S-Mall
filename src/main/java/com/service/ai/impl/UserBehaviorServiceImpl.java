package com.service.ai.impl;

import com.service.ai.UserBehaviorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@Service
public class UserBehaviorServiceImpl implements UserBehaviorService {

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    private static final String CAT_ZSET_PREFIX = "user:interests:cats:zset:";
    private static final String KW_ZSET_PREFIX = "user:interests:kws:zset:";
    private static final String RECENT_CAT_PREFIX = "user:interests:cats:recent:";
    private static final long TTL_DAYS = 7; // Lưu vết trong 7 ngày

    @Override
    public void logProductView(String identifier, Long categoryId, String productName) {
        if (identifier == null) return;
        
        // 1. Tăng điểm danh mục (+1)
        incrementScore(CAT_ZSET_PREFIX + identifier, String.valueOf(categoryId), 1.0);
        
        // 2. Lưu vào danh sách gần đây (đảm bảo tính mới)
        updateRecentList(RECENT_CAT_PREFIX + identifier, String.valueOf(categoryId));

        // 3. Phân tích từ khóa từ tên sản phẩm và tăng điểm (+1)
        logProductKeywords(identifier, productName, 1.0);
    }

    @Override
    public void logSearch(String identifier, String keyword) {
        if (identifier == null || keyword == null || keyword.trim().isEmpty()) return;
        logProductKeywords(identifier, keyword, 2.0);
    }

    @Override
    public void logAddToCart(String identifier, Long categoryId, String productName) {
        if (identifier == null) return;
        // Trọng số cao (+5 cho danh mục, +3 cho từ khóa)
        incrementScore(CAT_ZSET_PREFIX + identifier, String.valueOf(categoryId), 5.0);
        logProductKeywords(identifier, productName, 3.0);
    }

    @Override
    public void logPurchase(String identifier, Long categoryId) {
        if (identifier == null) return;
        // Trọng số cao nhất (+10)
        incrementScore(CAT_ZSET_PREFIX + identifier, String.valueOf(categoryId), 10.0);
    }

    private void logProductKeywords(String identifier, String text, double score) {
        if (text == null) return;
        String key = KW_ZSET_PREFIX + identifier;
        
        // Tách từ cơ bản (lowercase, bỏ ký tự đặc biệt, split space)
        List<String> keywords = Arrays.stream(text.toLowerCase().split("\\s+"))
                .filter(w -> w.length() > 2) // Chỉ lấy từ có nghĩa (> 2 ký tự)
                .map(w -> w.replaceAll("[^a-zA-Z0-9áàảãạâấầẩẫậăắằẳẵặéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵđ]", ""))
                .collect(Collectors.toList());

        for (String kw : keywords) {
            incrementScore(key, kw, score);
        }
    }

    private void incrementScore(String key, String member, double delta) {
        redisTemplate.opsForZSet().incrementScore(key, member, delta);
        redisTemplate.expire(key, TTL_DAYS, TimeUnit.DAYS);
    }

    private void updateRecentList(String key, String value) {
        redisTemplate.opsForList().remove(key, 0, value); // Xóa nếu đã có để đưa lên đầu
        redisTemplate.opsForList().leftPush(key, value);
        redisTemplate.opsForList().trim(key, 0, 9); // Chỉ giữ 10 danh mục gần nhất
        redisTemplate.expire(key, TTL_DAYS, TimeUnit.DAYS);
    }
}
