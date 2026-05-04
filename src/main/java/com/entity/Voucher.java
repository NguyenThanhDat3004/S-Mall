package com.entity;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import com.validator.FutureDateTime;

import jakarta.persistence.*;

@Entity
@Table(name = "vouchers")
public class Voucher {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String code;

    @Column(name = "discount_amount")
    private double discountAmount;

    @Column(name = "min_order_value")
    private double minOrderValue;

    @Column(name = "expiry_date")
    @FutureDateTime
    private LocalDateTime expiryDate;

    private int quantity;

    @Column(name = "initial_quantity", nullable = false, columnDefinition = "int default 0")
    private int initialQuantity = 0;

    @Column(name = "is_public")
    private boolean publicVoucher = true;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "shop_id")
    private Shop shop;

    @OneToMany(mappedBy = "voucher", cascade = CascadeType.ALL)
    private List<UserVoucher> userVouchers;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    public Voucher() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public double getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(double discountAmount) { this.discountAmount = discountAmount; }
    public double getMinOrderValue() { return minOrderValue; }
    public void setMinOrderValue(double minOrderValue) { this.minOrderValue = minOrderValue; }
    public LocalDateTime getExpiryDate() { return expiryDate; }
    public void setExpiryDate(LocalDateTime expiryDate) { this.expiryDate = expiryDate; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public int getInitialQuantity() { return initialQuantity; }
    public void setInitialQuantity(int initialQuantity) { this.initialQuantity = initialQuantity; }
    public boolean isPublicVoucher() { return publicVoucher; }
    public void setPublicVoucher(boolean publicVoucher) { this.publicVoucher = publicVoucher; }
    public Shop getShop() { return shop; }
    public void setShop(Shop shop) { this.shop = shop; }
    public List<UserVoucher> getUserVouchers() { return userVouchers; }
    public void setUserVouchers(List<UserVoucher> userVouchers) { this.userVouchers = userVouchers; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getFormattedExpiryDate() {
        if (expiryDate == null) return "N/A";
        return expiryDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
}
