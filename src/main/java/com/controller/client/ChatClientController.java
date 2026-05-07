package com.controller.client;

import com.entity.Shop;
import com.entity.User;
import com.repository.ShopRepository;
import com.service.UserService;
import com.service.chat.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.security.Principal;

@Controller
public class ChatClientController {

    @Autowired
    private ChatService chatService;

    @Autowired
    private UserService userService;

    @Autowired
    private ShopRepository shopRepository;

    /**
     * Trang chat chính cho Buyer: /messages
     * Nếu có param shopId → tự tạo/mở phòng chat với shop đó
     */
    @GetMapping("/messages")
    public String messagesPage(@RequestParam(required = false) Long shopId,
                               @RequestParam(required = false) Long room,
                               Model model, Principal principal) {
        if (principal == null) return "redirect:/login";

        User user = userService.getUserByEmail(principal.getName()).orElse(null);
        if (user == null) return "redirect:/login";

        model.addAttribute("currentUserId", user.getId());

        // Nếu được gọi từ trang sản phẩm (có shopId), tự tạo phòng chat
        if (shopId != null) {
            var chatRoom = chatService.getOrCreateRoom(user.getId(), shopId);
            model.addAttribute("activeRoomId", chatRoom.getId());
        } else if (room != null) {
            model.addAttribute("activeRoomId", room);
        }

        return "client/chat/messages";
    }

    /**
     * Trang chat cho Seller: /seller/chat
     */
    @GetMapping("/seller/chat")
    public String sellerChatPage(Model model, Principal principal) {
        if (principal == null) return "redirect:/login";

        User user = userService.getUserByEmail(principal.getName()).orElse(null);
        if (user == null) return "redirect:/login";

        Shop shop = shopRepository.findByUser(user).orElse(null);
        if (shop == null) return "redirect:/seller/dashboard";

        model.addAttribute("currentUserId", user.getId());
        model.addAttribute("shopId", shop.getId());

        return "seller/chat/chat";
    }
}
