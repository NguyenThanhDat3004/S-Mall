package com.repository;

import com.entity.Invoice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface InvoiceRepository extends JpaRepository<Invoice, Long> {
    Optional<Invoice> findByOrderOrderCode(String orderCode);
    Optional<Invoice> findByInvoiceCode(String invoiceCode);
}
