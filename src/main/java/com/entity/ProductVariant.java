package com.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "product_variants")
public class ProductVariant {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true)
    private String sku;

    private double price;

    @Column(name = "discount_price")
    private Double discountPrice;

    private int stock = 0;

    @Column(name = "attributes_json", columnDefinition = "NVARCHAR(MAX)")
    private String attributesJson;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id")
    private Product product;

    public ProductVariant() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getSku() { return sku; }
    public void setSku(String sku) { this.sku = sku; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public Double getDiscountPrice() { return discountPrice; }
    public void setDiscountPrice(Double discountPrice) { this.discountPrice = discountPrice; }
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
    public String getAttributesJson() { return attributesJson; }
    public void setAttributesJson(String attributesJson) { this.attributesJson = attributesJson; }
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
}
