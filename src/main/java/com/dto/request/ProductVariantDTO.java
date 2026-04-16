package com.dto.request;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;

public class ProductVariantDTO {
    
    @NotBlank(message = "Tên biến thể không được để trống")
    private String name;

    @DecimalMin(value = "0.0", message = "Giá không được nhỏ hơn 0")
    private double price;

    @Min(value = 0, message = "Số lượng kho không được nhỏ hơn 0")
    private int stock;

    private String sku;

    private org.springframework.web.multipart.MultipartFile variantImage;

    public ProductVariantDTO() {}

    // Getters and Setters
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
    public String getSku() { return sku; }
    public void setSku(String sku) { this.sku = sku; }
    public org.springframework.web.multipart.MultipartFile getVariantImage() { return variantImage; }
    public void setVariantImage(org.springframework.web.multipart.MultipartFile variantImage) { this.variantImage = variantImage; }
}
