package com.controller.api;

import com.entity.Notification;
import com.entity.User;
import com.repository.NotificationRepository;
import com.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/notifications")
public class NotificationApiController {

    @Autowired
    private NotificationRepository notificationRepository;

    @Autowired
    private UserService userService;

    @GetMapping("/latest")
    public ResponseEntity<?> getLatestNotifications(Principal principal) {
        if (principal == null) return ResponseEntity.status(401).build();

        Optional<User> userOpt = userService.getUserByEmail(principal.getName());
        if (userOpt.isEmpty()) return ResponseEntity.badRequest().build();

        List<Notification> notifications = notificationRepository.findByRecipientOrderByCreatedAtDesc(userOpt.get());
        long unreadCount = notificationRepository.countByRecipientAndIsReadFalse(userOpt.get());

        Map<String, Object> response = new HashMap<>();
        response.put("notifications", notifications);
        response.put("unreadCount", unreadCount);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/mark-as-read")
    public ResponseEntity<?> markAllAsRead(Principal principal) {
        if (principal == null) return ResponseEntity.status(401).build();

        Optional<User> userOpt = userService.getUserByEmail(principal.getName());
        if (userOpt.isPresent()) {
            List<Notification> notifications = notificationRepository.findByRecipientOrderByCreatedAtDesc(userOpt.get());
            notifications.forEach(n -> n.setRead(true));
            notificationRepository.saveAll(notifications);
        }
        return ResponseEntity.ok(Map.of("status", "success"));
    }
}
