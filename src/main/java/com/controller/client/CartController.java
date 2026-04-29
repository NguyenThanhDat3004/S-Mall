package com.controller.client;

import com.dto.CartDTO;
import com.entity.User;
import com.entity.UserProfile;
import com.service.CartService;
import com.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.security.Principal;
import java.util.Optional;

@Controller
public class CartController {

    private final CartService cartService;
    private final UserService userService;

    @org.springframework.beans.factory.annotation.Value("${app.server-ip}")
    private String serverIp;

    public CartController(CartService cartService, UserService userService) {
        this.cartService = cartService;
        this.userService = userService;
    }

    @GetMapping("/cart")
    public String getCartPage(Model model, Principal principal, HttpSession session) {
        String cartKey = getCartKey(principal, session);
        CartDTO cart = cartService.getCart(cartKey);
        
        if (principal != null) {
            Optional<User> userOpt = userService.getUserByEmail(principal.getName());
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                UserProfile profile = user.getProfile();
                model.addAttribute("userProfile", profile);
                
                boolean isProfileIncomplete = profile == null 
                        || profile.getFullName() == null || profile.getFullName().trim().isEmpty()
                        || profile.getPhoneNumber() == null || profile.getPhoneNumber().trim().isEmpty()
                        || profile.getAddress() == null || profile.getAddress().trim().isEmpty()
                        || profile.getDateOfBirth() == null
                        || profile.getAvatarUrl() == null || profile.getAvatarUrl().trim().isEmpty();
                model.addAttribute("isProfileIncomplete", isProfileIncomplete);
            }
        } else {
            model.addAttribute("isProfileIncomplete", true);
        }
        
        model.addAttribute("cart", cart);
        return "client/cart/index";
    }

    @Autowired
    private com.service.OrderService orderService;

    @Autowired
    private com.service.UserAddressRedisService addressRedisService;

    @Autowired
    private com.repository.AddressRepository addressRepository;

    @GetMapping("/api/cart/check-status")
    @org.springframework.web.bind.annotation.ResponseBody
    public java.util.Map<String, Object> checkCartStatus(
            @RequestParam String ids,
            Principal principal,
            HttpSession session) {
        
        java.util.Map<String, Object> response = new java.util.HashMap<>();
        String cartKey = getCartKey(principal, session);
        CartDTO cart = cartService.getCart(cartKey);
        
        java.util.List<Long> variantIds = java.util.Arrays.stream(ids.split(","))
                .map(Long::parseLong)
                .collect(java.util.stream.Collectors.toList());
        
        // Nếu không còn sản phẩm nào trong variantIds nằm trong giỏ hàng -> Coi như đã đặt hàng thành công
        boolean isDone = cart.getItems().stream()
                .noneMatch(item -> variantIds.contains(item.getVariantId()));
        
        response.put("isDone", isDone);
        return response;
    }

    @GetMapping({"/payment/confirm", "/cart/payment/confirm"})
    public String confirmOrder(
            @RequestParam String ids,
            @RequestParam String ship,
            @RequestParam String addr,
            @RequestParam boolean ins,
            @RequestParam(defaultValue = "false") boolean saveAddr,
            Principal principal) {
        
        if (principal == null) return "redirect:/login";
        
        Optional<User> userOpt = userService.getUserByEmail(principal.getName());
        if (userOpt.isPresent()) {
            User user = userOpt.get();

            // Lưu địa chỉ nếu người dùng chọn
            if (saveAddr) {
                addressRedisService.saveAddress(user.getEmail(), addr);
            }
            
            java.util.List<Long> variantIds = java.util.Arrays.stream(ids.split(","))
                    .map(Long::parseLong)
                    .collect(java.util.stream.Collectors.toList());

            com.entity.Order orderData = new com.entity.Order();
            orderData.setShippingAddress(addr);
            orderData.setShippingMethod(ship);
            orderData.setShippingInsurance(ins);
            orderData.setPaymentMethod("QR"); 
            
            double shippingFee = 30000;
            if ("economy".equals(ship)) shippingFee = 15000;
            else if ("express".equals(ship)) shippingFee = 50000;
            orderData.setShippingFee(shippingFee);

            try {
                orderService.createOrder(user, orderData, variantIds);
            } catch (Exception e) {
                if (e.getMessage().contains("Không tìm thấy sản phẩm hợp lệ")) {
                    return "client/cart/payment_finish_tab";
                }
                throw e;
            }
            
            return "client/cart/payment_finish_tab";
        }
        return "redirect:/";
    }

    private String getAutoDetectedIp() {
        try (java.net.DatagramSocket socket = new java.net.DatagramSocket()) {
            socket.connect(java.net.InetAddress.getByName("8.8.8.8"), 10002);
            String ip = socket.getLocalAddress().getHostAddress();
            return (ip != null && !ip.isEmpty()) ? ip : serverIp;
        } catch (Exception e) {
            return serverIp;
        }
    }

    @GetMapping("/payment")
    public String getPaymentPage(
            @RequestParam("ids") String ids,
            Model model, 
            Principal principal, 
            HttpSession session) {
        if (principal == null) {
            return "redirect:/login";
        }

        Optional<User> userOpt = userService.getUserByEmail(principal.getName());
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            UserProfile profile = user.getProfile();
            
            boolean isProfileIncomplete = profile == null 
                    || profile.getFullName() == null || profile.getFullName().trim().isEmpty()
                    || profile.getPhoneNumber() == null || profile.getPhoneNumber().trim().isEmpty()
                    || profile.getAddress() == null || profile.getAddress().trim().isEmpty()
                    || profile.getDateOfBirth() == null
                    || profile.getAvatarUrl() == null || profile.getAvatarUrl().trim().isEmpty();
            
            if (isProfileIncomplete) {
                return "redirect:/cart?error=profile_incomplete";
            }
            
            String redisAddress = addressRedisService.getAddress(user.getEmail());
            java.util.List<com.entity.Address> savedAddresses = addressRepository.findByUser(user);
            
            model.addAttribute("redisAddress", redisAddress);
            model.addAttribute("savedAddresses", savedAddresses);
            model.addAttribute("userProfile", profile);
            
            String cartKey = getCartKey(principal, session);
            CartDTO cart = cartService.getCart(cartKey);
            
            String finalIp = getAutoDetectedIp();
            model.addAttribute("serverIp", finalIp);
            
            if (ids != null && !ids.isEmpty()) {
                java.util.List<Long> selectedIds = java.util.Arrays.stream(ids.split(","))
                        .map(Long::parseLong)
                        .collect(java.util.stream.Collectors.toList());
                
                java.util.List<com.dto.CartItemDTO> filteredItems = cart.getItems().stream()
                        .filter(item -> selectedIds.contains(item.getVariantId()))
                        .collect(java.util.stream.Collectors.toList());
                
                cart.setItems(filteredItems);
            }
            
            model.addAttribute("cart", cart);
        }

        return "client/cart/payment";
    }

    private String getCartKey(Principal principal, HttpSession session) {
        if (principal != null) {
            return "cart:user:" + principal.getName();
        } else {
            String guestId = (String) session.getAttribute("guestId");
            if (guestId == null) {
                guestId = java.util.UUID.randomUUID().toString();
                session.setAttribute("guestId", guestId);
            }
            return "cart:guest:" + guestId;
        }
    }
}
