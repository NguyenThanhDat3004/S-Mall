package com.repository;

import com.entity.Voucher;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface VoucherRepository extends JpaRepository<Voucher, Long> {
    List<Voucher> findByShopIdOrderByCreatedAtDesc(Long shopId);
    Optional<Voucher> findByCode(String code);
}
