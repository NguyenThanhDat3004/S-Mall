package com.repository;

import com.entity.UserVoucher;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface UserVoucherRepository extends JpaRepository<UserVoucher, Long> {
    List<UserVoucher> findByUserIdAndIsUsedFalse(Long userId);
    List<UserVoucher> findByVoucherId(Long voucherId);
    boolean existsByUserIdAndVoucherId(Long userId, Long voucherId);
}
