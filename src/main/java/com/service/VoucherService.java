package com.service;

import com.entity.Voucher;
import com.entity.User;
import java.util.List;

public interface VoucherService {
    Voucher createVoucher(Voucher voucher, Long shopId);
    List<Voucher> getVouchersByShop(Long shopId);
    void deleteVoucher(Long voucherId);
    
    // Mới: Lấy voucher khả dụng cho checkout
    List<Voucher> getAvailableVouchersForCheckout(User user, List<Long> shopIds);
    // Mới: Gán voucher cho một User cụ thể (Voucher 1-1)
    void assignVoucherToUser(Long voucherId, Long userId);

    // Mới: Tạo và gán nhanh (Dùng cho AI)
    void createAndAssignVoucher(Long shopId, Long userId, double discount, int expiryDays);
}
