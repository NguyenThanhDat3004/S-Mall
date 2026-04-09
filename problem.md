# Báo cáo Sự cố: Lỗi Vòng lặp Chuyển hướng (ERR_TOO_MANY_REDIRECTS)

## 1. Mô tả sự cố
Khi truy cập trang `/login` của ứng dụng S-Mall, trình duyệt liên tục phản hồi lỗi `ERR_TOO_MANY_REDIRECTS` (vòng lặp chuyển hướng vô tận).

## 2. Nguyên nhân gốc rễ (Root Cause)
Sự cố phát sinh từ sự thay đổi hành vi trong **Spring Security 6 (Spring Boot 3)** so với các phiên bản trước:

*   **Bảo mật lệnh Forward**: Trong Spring Boot 3, mọi lệnh điều hướng nội bộ (Internal Forward) từ Controller đến View (JSP) đều bị Spring Security kiểm tra tính hợp lệ.
*   **Vòng lặp logic**:
    1. Người dùng truy cập `/login` (Đã được `permitAll`).
    2. `AuthController` nhận yêu cầu và chuyển tiếp (forward) đến file JSP tại `/WEB-INF/view/client/auth/login.jsp`.
    3. Spring Security phát hiện yêu cầu forward đến thư mục `/WEB-INF/`. Vì đường dẫn này **chưa được cấp quyền**, Security chặn lại và chuyển hướng (redirect) người dùng quay về trang đăng nhập để xác thực.
    4. Trình duyệt quay lại bước 1, tạo thành vòng lặp không hồi kết.

## 3. Giải pháp khắc phục
Chúng ta đã thực hiện cấu hình đặc biệt để Spring Security cho phép các lệnh Forward nội bộ mà không cần kiểm tra lại quyền hạn.

### Mã nguồn thay đổi:
Trong file `SecurityConfig.java`, chúng ta đã thêm quy tắc:
```java
.authorizeHttpRequests(auth -> auth
    .dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll() // Cho phép Forward nội bộ
    .requestMatchers("/login", "/register", ...).permitAll()
    .anyRequest().authenticated()
)
```

## 4. Kết luận & Bài học
Khi xây dựng ứng dụng Web sử dụng **Spring Boot 3 kết hợp với JSP**, việc cho phép `DispatcherType.FORWARD` trong cấu hình bảo mật là **bắt buộc** để tránh lỗi vòng lặp chuyển hướng khi hiển thị giao diện.
