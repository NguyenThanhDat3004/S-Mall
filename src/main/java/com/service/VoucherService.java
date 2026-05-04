package com.service;

import com.entity.Voucher;
import java.util.List;

public interface VoucherService {
    Voucher createVoucher(Voucher voucher, Long shopId);
    List<Voucher> getVouchersByShop(Long shopId);
    void deleteVoucher(Long voucherId);
}
