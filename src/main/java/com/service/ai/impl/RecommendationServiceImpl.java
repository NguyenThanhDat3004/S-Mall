package com.service.ai.impl;

import java.util.*;
import java.util.stream.Collectors;
import java.util.concurrent.TimeUnit;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

import com.dto.ProductDTO;
import com.dto.RecommendationResponse;
import com.entity.Product;
import com.entity.ProductImage;
import com.repository.ProductRepository;
import com.service.ai.RecommendationService;

@Service
public class RecommendationServiceImpl implements RecommendationService {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    private static final String CAT_ZSET_PREFIX = "user:interests:cats:zset:";
    private static final String RECENT_CAT_PREFIX = "user:interests:cats:recent:";

    @Override
    @Transactional(readOnly = true)
    public List<Product> getHomepageRecommendations(String identifier) {
        int targetSize = 18;
        List<Long> topCatIds = getTop5CategoryIds(identifier);
        
        // 1. Lấy sản phẩm Top Rated làm nền tảng bù đắp (Base Fallback)
        List<Product> baseFallback = productRepository.findByIsActiveTrueOrderByAverageRatingDesc(PageRequest.of(0, 40)).getContent();

        if (topCatIds.isEmpty()) {
            List<Product> result = new ArrayList<>(baseFallback);
            Collections.shuffle(result);
            return result.stream().limit(targetSize).collect(Collectors.toList());
        }

        // 2. Lấy sản phẩm cá nhân hóa
        List<Product> personalized = new ArrayList<>(productRepository.findTop30ByCategoryIdInAndIsActiveTrueOrderByAverageRatingDesc(topCatIds));
        Collections.shuffle(personalized);

        // 3. Cơ chế Bù đắp (Filling): Nếu thiếu thì chèn thêm từ Base Fallback
        Set<Product> finalSet = new LinkedHashSet<>(personalized);
        for (Product p : baseFallback) {
            if (finalSet.size() >= targetSize) break;
            finalSet.add(p);
        }

        return new ArrayList<>(finalSet);
    }

    @Override
    @Transactional(readOnly = true)
    public RecommendationResponse getPaginatedRecommendations(String identifier, int page, int size) {
        List<Long> topCatIds = getTop5CategoryIds(identifier);
        
        // Luôn lấy Top Rated để làm dữ liệu nền
        Page<Product> basePage = productRepository.findByIsActiveTrueOrderByAverageRatingDesc(PageRequest.of(page, size));
        List<Product> baseList = basePage.getContent();

        // Trang đầu tiên: Áp dụng logic cá nhân hóa mạnh mẽ + Bù đắp
        if (page == 0 && !topCatIds.isEmpty()) {
            List<Product> personalized = productRepository.findTop30ByCategoryIdInAndIsActiveTrueOrderByAverageRatingDesc(topCatIds);
            
            // Dùng Set để tránh trùng lặp khi bù đắp
            Set<Product> combined = new LinkedHashSet<>();
            
            // Trộn danh sách cá nhân hóa để đa dạng hóa danh mục
            List<Product> shuffledPersonalized = new ArrayList<>(personalized);
            Collections.shuffle(shuffledPersonalized);
            combined.addAll(shuffledPersonalized);
            
            // Bù đắp từ danh sách cơ bản nếu không đủ size
            for (Product p : baseList) {
                if (combined.size() >= size) break;
                combined.add(p);
            }
            
            List<ProductDTO> dtos = combined.stream().map(this::convertToDTO).collect(Collectors.toList());
            return new RecommendationResponse(dtos, basePage.hasNext());
        }

        // Các trang sau hoặc khi không có dữ liệu: Trả về base bình thường
        List<ProductDTO> dtos = baseList.stream().map(this::convertToDTO).collect(Collectors.toList());
        return new RecommendationResponse(dtos, basePage.hasNext());
    }

    private List<Long> getTop5CategoryIds(String identifier) {
        if (identifier == null) return Collections.emptyList();

        Set<ZSetOperations.TypedTuple<Object>> topCats = redisTemplate.opsForZSet().reverseRangeWithScores(CAT_ZSET_PREFIX + identifier, 0, 4);
        
        if (topCats != null && !topCats.isEmpty()) {
            return topCats.stream()
                    .map(t -> Long.parseLong(t.getValue().toString()))
                    .collect(Collectors.toList());
        }

        List<Object> recent = redisTemplate.opsForList().range(RECENT_CAT_PREFIX + identifier, 0, 4);
        if (recent != null && !recent.isEmpty()) {
            return recent.stream()
                    .map(o -> Long.parseLong(o.toString()))
                    .collect(Collectors.toList());
        }

        return Collections.emptyList();
    }

    private ProductDTO convertToDTO(Product p) {
        ProductDTO dto = new ProductDTO();
        dto.setId(p.getId());
        dto.setName(p.getName());
        dto.setSlug(p.getSlug());
        dto.setAverageRating(p.getAverageRating());
        dto.setSoldCount(p.getSoldCount());
        
        if (p.getVariants() != null && !p.getVariants().isEmpty()) {
            dto.setPrice(p.getVariants().get(0).getPrice());
            dto.setDiscountPrice(p.getVariants().get(0).getDiscountPrice());
        }
        
        if (p.getImages() != null && !p.getImages().isEmpty()) {
            p.getImages().stream()
                .filter(ProductImage::isMain)
                .findFirst()
                .ifPresent(img -> dto.setMainImageUrl(img.getUrl()));
            
            if (dto.getMainImageUrl() == null) {
                dto.setMainImageUrl(p.getImages().get(0).getUrl());
            }
        }
        return dto;
    }
}
