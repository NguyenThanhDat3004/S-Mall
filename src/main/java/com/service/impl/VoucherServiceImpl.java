package com.service.impl;

import com.entity.Shop;
import com.entity.Voucher;
import com.repository.VoucherRepository;
import com.repository.ShopRepository;
import com.repository.UserVoucherRepository;
import com.service.VoucherService;
import com.entity.User;
import com.entity.UserVoucher;
import com.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.time.LocalDateTime;

@Service
public class VoucherServiceImpl implements VoucherService {

    @Autowired
    private VoucherRepository voucherRepository;

    @Autowired
    private ShopRepository shopRepository;

    @Autowired
    private UserVoucherRepository userVoucherRepository;

    @Autowired
    private UserRepository userRepository;

    @Override
    @Transactional
    public Voucher createVoucher(Voucher voucher, Long shopId) {
        Shop shop = shopRepository.findById(shopId)
                .orElseThrow(() -> new RuntimeException("Shop not found"));
        
        // Tự động sinh mã nếu người dùng không nhập (hoặc luôn sinh mới)
        if (voucher.getCode() == null || voucher.getCode().trim().isEmpty()) {
            voucher.setCode(generateRandomCode());
        }
        
        // Gán số lượng ban đầu bằng số lượng nhập vào
        voucher.setInitialQuantity(voucher.getQuantity());

        if (voucherRepository.findByCode(voucher.getCode()).isPresent()) {
            // Nếu trùng (xác suất thấp), thử sinh lại một lần nữa
            voucher.setCode(generateRandomCode());
        }

        voucher.setShop(shop);
        return voucherRepository.save(voucher);
    }

    private String generateRandomCode() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder sb = new StringBuilder("SM");
        java.util.Random rnd = new java.util.Random();
        for (int i = 0; i < 8; i++) {
            sb.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return sb.toString();
    }

    @Override
    public List<Voucher> getVouchersByShop(Long shopId) {
        return voucherRepository.findByShopIdOrderByCreatedAtDesc(shopId);
    }

    @Override
    @Transactional
    public void deleteVoucher(Long voucherId) {
        voucherRepository.deleteById(voucherId);
    }

    @Override
    public List<Voucher> getAvailableVouchersForCheckout(User user, List<Long> shopIds) {
        if (shopIds == null || shopIds.isEmpty()) return new ArrayList<>();

        // 1. Lấy Voucher công khai của các shop này
        List<Voucher> publicVouchers = voucherRepository.findByShopIdInAndPublicVoucherTrue(shopIds);

        // 2. Lấy Voucher cá nhân trong ví của User thuộc các shop này
        List<Voucher> privateVouchers = userVoucherRepository.findAvailableVouchersForUserInShops(user.getId(), shopIds);

        // Hợp nhất và lọc bỏ những voucher hết hạn hoặc hết số lượng
        List<Voucher> allVouchers = new ArrayList<>();
        allVouchers.addAll(publicVouchers);
        allVouchers.addAll(privateVouchers);

        LocalDateTime now = LocalDateTime.now();
        List<Voucher> filtered = allVouchers.stream()
                .distinct()
                .filter(v -> v.getQuantity() > 0)
                .filter(v -> v.getExpiryDate() == null || v.getExpiryDate().isAfter(now))
                .collect(Collectors.toList());

        System.out.println(">>> [DEBUG VOUCHER] Tổng cộng tìm thấy: " + allVouchers.size());
        System.out.println(">>> [DEBUG VOUCHER] Sau khi lọc (hạn dùng & số lượng): " + filtered.size());
        
        return filtered;
    }

    @Override
    @Transactional
    public void assignVoucherToUser(Long voucherId, Long userId) {
        Voucher voucher = voucherRepository.findById(voucherId)
                .orElseThrow(() -> new RuntimeException("Voucher not found"));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (voucher.getQuantity() <= 0) {
            throw new RuntimeException("Voucher is out of stock");
        }

        UserVoucher uv = new UserVoucher();
        uv.setUser(user);
        uv.setVoucher(voucher);
        uv.setAssignedAt(LocalDateTime.now());
        userVoucherRepository.save(uv);

        // Giảm số lượng voucher
        voucher.setQuantity(voucher.getQuantity() - 1);
        voucherRepository.save(voucher);
    }

    @Override
    @Transactional
    public void createAndAssignVoucher(Long shopId, Long userId, double discount, int expiryDays) {
        Voucher voucher = new Voucher();
        voucher.setDiscountAmount(discount);
        voucher.setMinOrderValue(0);
        voucher.setQuantity(1);
        voucher.setInitialQuantity(1);
        voucher.setPublicVoucher(false); // Voucher riêng tư
        voucher.setExpiryDate(LocalDateTime.now().plusDays(expiryDays));
        
        Voucher savedVoucher = createVoucher(voucher, shopId);
        assignVoucherToUser(savedVoucher.getId(), userId);
    }
}
