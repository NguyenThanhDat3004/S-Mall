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
}
