package com.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
public class UploadService {

    // Đường dẫn vật lý bên ngoài dự án để đảm bảo vĩnh viễn
    private final String STORAGE_PATH = "E:/s-mall/storage/images/";

    public String saveImage(MultipartFile file) throws IOException {
        if (file.isEmpty()) return null;

        // 1. Đảm bảo thư mục tồn tại
        File directory = new File(STORAGE_PATH);
        if (!directory.exists()) {
            directory.mkdirs();
        }

        // 2. Tạo tên file theo format: Tên gốc + Thời gian hiện tại
        String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
        
        // 3. Lưu file vật lý
        Path path = Paths.get(STORAGE_PATH + fileName);
        Files.write(path, file.getBytes());

        // 4. Trả về URL đường dẫn tương đối để lưu vào DB (Theo ánh xạ /images/**)
        return "/images/" + fileName;
    }
}
