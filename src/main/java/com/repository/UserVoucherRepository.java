package com.repository;

import com.entity.UserVoucher;
import com.entity.Voucher;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

public interface UserVoucherRepository extends JpaRepository<UserVoucher, Long> {
    List<UserVoucher> findByUserIdAndIsUsedFalse(Long userId);
    List<UserVoucher> findByVoucherId(Long voucherId);
    boolean existsByUserIdAndVoucherId(Long userId, Long voucherId);

    @Query("SELECT uv.voucher FROM UserVoucher uv WHERE uv.user.id = :userId AND uv.isUsed = false AND uv.voucher.shop.id IN :shopIds")
    List<Voucher> findAvailableVouchersForUserInShops(Long userId, List<Long> shopIds);
}
