package com.controller.client;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.dto.ProductDTO;
import com.dto.RecommendationResponse;
import com.service.ai.RecommendationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.transaction.annotation.Transactional;


@RestController
@RequestMapping("/api/recommendations")
public class RecommendationApiController {

    @Autowired
    private RecommendationService recommendationService;

    @GetMapping(value = "/more", produces = "application/json; charset=UTF-8")
    public ResponseEntity<RecommendationResponse> getMoreRecommendations(



            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "18") int size,
            HttpSession session) {
        
        String identifier = (String) session.getAttribute("userIdentifier");
        RecommendationResponse response = recommendationService.getPaginatedRecommendations(identifier, page, size);
        return ResponseEntity.ok(response);
    }





    @GetMapping("/ping")
    public ResponseEntity<String> ping() {
        return ResponseEntity.ok("OK");
    }

}

