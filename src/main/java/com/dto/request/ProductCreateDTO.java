package com.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.util.ArrayList;
import java.util.List;

public class ProductCreateDTO {

    @NotBlank(message = "Tên sản phẩm không được để trống")
    private String name;

    private String slug;

    @NotNull(message = "Vui lòng chọn danh mục")
    private Long categoryId;

    private String description;

    @Valid
    private List<ProductVariantDTO> variants = new ArrayList<>();

    public ProductCreateDTO() {
        // Khởi tạo sẵn một biến thể mặc định
        this.variants.add(new ProductVariantDTO());
    }

    // Getters and Setters
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }
    public Long getCategoryId() { return categoryId; }
    public void setCategoryId(Long categoryId) { this.categoryId = categoryId; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public List<ProductVariantDTO> getVariants() { return variants; }
    public void setVariants(List<ProductVariantDTO> variants) { this.variants = variants; }
}
