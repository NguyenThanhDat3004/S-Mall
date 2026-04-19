package com.service.ai.impl;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.concurrent.TimeUnit;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
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

    private static final String CAT_KEY_PREFIX = "user:interests:cats:";

    @Override
    public List<Product> getHomepageRecommendations(String identifier) {
        // Lấy trang đầu tiên (Page 0) với kích thước 18 sản phẩm
        // Ở đây chúng ta vẫn dùng Hybrid Logic cho trang chủ để tăng trải nghiệm cá nhân hóa
        
        List<Product> topRated = productRepository.findByIsActiveTrueOrderByAverageRatingDesc(PageRequest.of(0, 18)).getContent();
        
        if (identifier == null) {
            return topRated;
        }

        String redisKey = CAT_KEY_PREFIX + identifier;
        Set<Object> interestedCatIds = redisTemplate.opsForSet().members(redisKey);

        if (interestedCatIds == null || interestedCatIds.isEmpty()) {
            return topRated;
        }

        List<Long> catIds = interestedCatIds.stream()
                .map(obj -> Long.parseLong(obj.toString()))
                .collect(Collectors.toList());

        // 4. Lấy các sản phẩm thuộc danh mục quan tâm (Lấy tối đa 30 và sắp xếp theo Rating)
        List<Product> personalized = productRepository.findTop30ByCategoryIdInAndIsActiveTrueOrderByAverageRatingDesc(catIds);

        Set<Product> finalRecommendations = new LinkedHashSet<>();
        if (personalized != null) {
            finalRecommendations.addAll(personalized.stream().limit(9).collect(Collectors.toList()));
        }
        finalRecommendations.addAll(topRated);

        return finalRecommendations.stream().limit(18).collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public RecommendationResponse getPaginatedRecommendations(String identifier, int page, int size) {
        String cacheKey = "recs:paged:v4:page" + page + ":size" + size;
        
        // 1. Kiểm tra Cache Redis (Sử dụng kiểm tra an toàn kiểu dữ liệu)
        Object cachedObj = redisTemplate.opsForValue().get(cacheKey);
        if (cachedObj instanceof RecommendationResponse) {
            return (RecommendationResponse) cachedObj;
        }

        // 2. Nếu không có cache -> Lấy từ DB
        Pageable pageable = PageRequest.of(page, size);
        Page<Product> productPage = productRepository.findByIsActiveTrueOrderByAverageRatingDesc(pageable);
        
        List<ProductDTO> dtos = productPage.getContent().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());

        RecommendationResponse response = new RecommendationResponse(dtos, productPage.hasNext());

        // 3. Lưu vào Redis (30 phút)
        redisTemplate.opsForValue().set(cacheKey, response, 30, TimeUnit.MINUTES);

        return response;
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
            for (ProductImage img : p.getImages()) {
                if (img.isMain()) {
                    dto.setMainImageUrl(img.getUrl());
                    break;
                }
            }
            if (dto.getMainImageUrl() == null) {
                dto.setMainImageUrl(p.getImages().get(0).getUrl());
            }
        }
        
        return dto;
    }

}

