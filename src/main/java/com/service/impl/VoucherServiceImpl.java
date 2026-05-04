package com.service.impl;

import com.entity.Voucher;
import com.entity.Shop;
import com.repository.VoucherRepository;
import com.repository.ShopRepository;
import com.service.VoucherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class VoucherServiceImpl implements VoucherService {

    @Autowired
    private VoucherRepository voucherRepository;

    @Autowired
    private ShopRepository shopRepository;

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
}
