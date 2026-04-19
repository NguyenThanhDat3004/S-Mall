package com.dto.request;

import org.springframework.web.multipart.MultipartFile;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class ShopRegistrationDTO {

    @NotBlank(message = "Tên shop không được để trống")
    @Size(min = 3, max = 100, message = "Tên shop phải từ 3 đến 100 ký tự")
    private String name;

    @Size(max = 1000, message = "Mô tả không quá 1000 ký tự")
    private String description;

    private MultipartFile logoFile;

    public ShopRegistrationDTO() {}

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public MultipartFile getLogoFile() { return logoFile; }
    public void setLogoFile(MultipartFile logoFile) { this.logoFile = logoFile; }
}
