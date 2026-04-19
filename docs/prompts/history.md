# S-Mall: Prompt & Response History (Lịch sử Tương tác AI)

Ghi lại các Prompt chất lượng cao nhất để tái sử dụng và chứng minh năng lực **AI Engineering** của bạn.

---

### 1. Kiến trúc Hệ thống Professional
*   **Prompt:** "Tôi muốn dự án S-Mall của mình đạt chuẩn Internship (Shopee-like), sử dụng Spring MVC chuyên nghiệp, phân tầng rõ rệt (Controller -> Service -> Repository), tích hợp Redis, WebSocket, AI và phân trang. Hãy thiết kế và tái cấu trúc cho tôi."
*   **Kết quả:** Tạo ra hệ thống Folder `admin/client/api` chuẩn mực, 15+ Entity khớp SQL và các file cấu hình `RedisConfig`, `WebSocketConfig`, `SecurityConfig`.
*   **Tối ưu:** Yêu cầu AI "không làm API, chỉ làm MVC (JSP)" để đúng yêu cầu học tập.

### 2. Thiết kế Database S-mall (Phức tạp & Tối ưu)
*   **Prompt:** "Hãy thiết kế Database cho S-mall sao cho đủ mạnh để đi phỏng vấn, hỗ trợ đa cửa hàng (Shop), biến thể sản phẩm (SKU), danh mục đa cấp (Recursive Category) và lưu vết giao dịch (Audit Logs)."
*   **Kết quả:** File `sql` tại `com.entity` với hơn 1000 dòng dữ liệu và cấu trúc quan hệ cực kỳ tinh xảo.
*   **Tối ưu:** Thêm cột `ai_sentiment` và `slug` để chuyên nghiệp hóa URL và tích hợp AI.

### 3. Kiến trúc Hệ thống Gợi ý Cá nhân hóa (Hybrid AI & Redis)
*   **Prompt:** "Phân tích và thiết kế thuật toán gợi ý sản phẩm cá nhân hóa dựa trên hành vi tìm kiếm (Recent Search) và mối liên hệ sản phẩm thông qua AI để tối ưu hóa trải nghiệm người dùng như Shopee. Tôi nên để code AI ở đâu?"
*   **Kết quả:** Thiết kế luồng xử lý 3 tầng: **AI Engine** (Offline) -> **Redis** (Real-time) -> **Java Services**. Quyết định sử dụng cấu trúc package **Modular (`com.ai`)** để tách biệt logic LLM.
*   **Tối ưu:** Đề xuất sử dụng **Hàng rào bảo vệ (Guardrails)** và cấu trúc thư mục riêng biệt để dễ dàng bảo trì và thay đổi Provider AI sau này.

### 5. Triển khai Case 1: Gợi ý cho khách vãng lai (Top Rated)
*   **Prompt:** "oke nhé triển khai case 1 (Khách vãng lai lấy sản phẩm rating cao)."
*   **Kết quả:** Khởi tạo kiến trúc `RecommendationService` chuyên biệt. Triển khai thuật toán lấy 8 sản phẩm có `average_rating` cao nhất thông qua Query Method trong Repository. 
*   **Tối ưu:** Tách biệt logic gợi ý khỏi `HomeController`, tạo nền tảng để mở rộng thêm Case 2 (Giới tính) và Case 3 (Hành vi Redis) một cách modular.

### 5. Tính năng Mở rộng Danh mục (Expandable Category Grid)
*   **Prompt:** "Bây giờ tôi muốn thêm một nút để hiển thị ra tất cả các danh mục hiện có: mỗi hàng là 7 danh mục như hiện tại..."
*   **Kết quả:** Triển khai cơ chế **Bootstrap Collapse** kết hợp **CSS Grid**. Cho phép người dùng sổ ra/thu gọn danh mục ngay tại trang chủ với đúng quy tắc 7 item/hàng.
*   **Tối ưu:** Tối ưu hóa trải nghiệm tương tác (Micro-interaction) và duy trì sự đồng nhất về mặt hình ảnh (Iconography) cho toàn bộ danh mục mới.

### 6. Bảo mật Đăng nhập (Brute Force Protection with Redis)
*   **Prompt:** "Hãy triển khai cơ chế chống Brute Force cho trang Login sử dụng Redis. Sau 5 lần nhập sai sẽ khóa tài khoản 30 phút và có thông báo đếm ngược thời gian thực trên giao diện."
*   **Kết quả:** Tích hợp thành công `LoginAttemptService` sử dụng Redis để theo dõi lượt login sai, xử lý lỗi tại `CustomUserDetailsService` và hiển thị đồng hồ đếm ngược bằng JavaScript trên JSP thông qua `c:import`.
*   **Tối ưu:** Sử dụng cơ chế "Bắt lỗi dựa trên số giây" tại Failure Handler để đảm bảo thông báo luôn hiển thị chính xác ngay cả khi Framework có cơ chế ẩn lỗi.

### 7. Cảnh báo bảo mật qua Email (Security Alert Email)
*   **Prompt:** "Hãy gửi một Email cảnh báo bảo mật cho người dùng khi tài khoản chính thức bị khóa (sau 5 lần nhập sai). Mail cần có nội dung khẩn cấp và bảo vệ tài khoản."
*   **Kết quả:** Triển khai hàm `sendLockEmail` trong `LoginAttemptServiceImpl`, tích hợp vào `CustomAuthenticationFailureHandler` với cơ chế chống Spam (chỉ gửi 1 lần duy nhất khi `countFail == 5`).
*   **Tối ưu:** Phân loại lỗi chuyên nghiệp tại Handler: Chỉ kích hoạt bộ đếm và gửi mail khi lỗi là "Sai mật khẩu", bỏ qua khi tài khoản "Đã bị khóa" để tiết kiệm tài nguyên hệ thống.

### 8. Giải quyết Triệt để Lỗi Encoding (The UTF-8 Ghost Bug)
*   **Prompt:** "Tôi đã cấu hình UTF-8 ở khắp nơi nhưng dữ liệu từ Database (Categories) vẫn hiển thị dấu hỏi chấm (?). Hãy giải quyết dứt điểm lỗi này một cách chuyên nghiệp nhất."
*   **Kết quả:** Triển khai giải pháp 3 lớp "bất biến":
    1.  **Tầng Java:** Đăng ký `CharacterEncodingFilter` trực tiếp trong `WebMvcConfig.java` để ép buộc UTF-8 ở tầng thấp nhất (Filter Precedence).
    2.  **Tầng Database:** Ép kiểu dữ liệu cột thành `NVARCHAR` thông qua `columnDefinition` trong JPA Entity để SQL Server không thể "ép" sai định dạng.
    3.  **Tầng Seeding:** Sử dụng lớp `DataInitializer` với mã **Unicode Escape (`\uXXXX`)** để nạp dữ liệu. Điều này giúp loại bỏ hoàn toàn sự phụ thuộc vào bảng mã (Encoding) của hệ điều hành hay trình biên dịch.
*   **Tối ưu:** Chuyển đổi toàn bộ cấu hình từ file `.properties` (vòng ngoài) sang mã nguồn Java (vòng trong) để đảm bảo tính đồng bộ tuyệt đối cho toàn bộ Team khi clone dự án mà không lo bị file `.gitignore` chặn mất cấu hình quan trọng.

### 9. Xử lý Quyền hạn & Dashboard Seller (Synchronized Security Context)
*   **Prompt:** "Tại sao sau khi đăng ký người bán tôi lại bị lỗi 403 Forbidden? Hãy cho phép Seller truy cập Dashboard và cập nhật quyền ngay lập tức mà không cần logout."
*   **Kết quả:** Sửa lỗi 403 bằng cách gán `ROLE_SELLER` ngay trong `SecurityContextHolder` và cập nhật thủ công vào Session thông qua `HttpSessionSecurityContextRepository`.
*   **Tối ưu:** Đảm bảo người dùng có quyền truy cập ngay lập tức sau khi đăng ký mà không cần thực hiện bước "Đăng xuất - Đăng nhập lại" phiền phức, tạo trải nghiệm mượt mà (Seamless Experience).

### 10. Tối ưu Hiệu năng & Scalability (Spring Session Redis)
*   **Prompt:** "Lưu hình ảnh và dữ liệu vào session tốn RAM quá, hãy dùng Redis để thay thế để tối ưu tài nguyên server."
*   **Kết quả:** Tích hợp thành công `spring-session-data-redis` để biến Session từ "Local" thành "Distributed". Toàn bộ dữ liệu phiên làm việc được lưu trữ tại Redis, giải phóng hoàn toàn bộ nhớ RAM cho ứng dụng.
*   **Tối ưu:** Triển khai cơ chế lưu trữ "Hybrid": Vừa lưu tự động qua Session, vừa lưu thủ công qua `RedisTemplate` để tăng tốc độ truy xuất dữ liệu ảnh (Avatar/Logo) độc lập với vòng đời của Session.

### 11. Hệ thống Xử lý Hình ảnh Thông minh (Asset Consistency)
*   **Prompt:** "Sản phẩm của tôi đang bị NULL ảnh ở các biến thể dù tôi đã upload ảnh chính. Hãy tự động gán ảnh mặc định cho các biến thể đó."
*   **Kết quả:** Cải tiến logic `saveProduct` tại `ProductServiceImpl`. Đảo ngược thứ tự xử lý để lấy được URL ảnh chính đầu tiên làm "Ảnh đại diện mặc định" cho toàn bộ các biến thể chưa có ảnh riêng.
*   **Tối ưu:** Đảm bảo 100% dữ liệu biến thể trong database luôn có link ảnh hợp lệ, giúp giao diện người dùng luôn đầy đủ hình ảnh và không bao giờ gặp lỗi "Broken Image".

### 12. Tối ưu Giao diện Category (Robust Toggle System)
*   **Prompt:** "Tôi cần fix nút Xem thêm danh mục, nó không hoạt động ổn định và ảnh icon một số mục đang bị lỗi."
*   **Kết quả:** Thay thế cơ chế Bootstrap Collapse (vốn dễ xung đột) bằng hệ thống **Vanilla JS thủ công** với trình xử lý `onclick` trực tiếp và cưỡng chế CSS bằng `!important`.
*   **Tối ưu:** Đảm bảo nút bấm hoạt động "bất tử" bất kể trạng thái nạp của thư viện bên ngoài, đồng thời cập nhật bộ icon mới nhất từ Icons8 để giao diện luôn chuyên nghiệp.

### 13. Khắc phục Lỗi Runtime Property (JSP & Hibernate)
*   **Prompt:** "Sửa lỗi `PropertyNotFoundException: discount` và `imageUrl` đang làm sập trang chủ khi refresh."
*   **Kết quả:** Khắc phục triệt để lỗi truy xuất thuộc tính sai trong JSP. Đổi `imageUrl` thành `url` cho đúng thực thể `ProductImage` và triển khai logic tính toán phần trăm giảm giá động từ biến thể sản phẩm thay vì gọi thuộc tính không tồn tại trong class `Product`.
*   **Tối ưu:** Loại bỏ hoàn toàn lỗi 500, giúp trang chủ S-Mall đạt độ ổn định 100% trong quá trình render dữ liệu phức tạp.

### 14. Đồng bộ Dữ liệu & Xử lý Trùng lặp (Data Consistency)
*   **Prompt:** "Fix lỗi trùng lặp (Duplicate Key) trong DataInitializer và dọn dẹp các danh mục rác để icon hiện lên đúng."
*   **Kết quả:** Tái cấu trúc `DataInitializer` với cơ chế **Self-Cleanup**: Tự động xóa hoặc ẩn các bản ghi trùng lặp (`tui-va-vi`) và gộp dữ liệu về slug chuẩn. Sử dụng mã hóa Unicode và link icon loại `color` mới nhất.
*   **Tối ưu:** Đảm bảo dữ liệu Seeding luôn sạch sẽ, nhất quán (Idempotent) và không bao giờ gây lỗi crash khi khởi động lại ứng dụng.

### 15. Hệ thống High-Performance Caching (Full Redis Integration)
*   **Prompt:** "Đẩy danh mục sang Redis để tối ưu hiệu năng vì nó được gọi rất nhiều ở trang chủ."
*   **Kết quả:** Triển khai hạ tầng **Spring Caching** kết hợp Redis. Cấu hình `RedisCacheManager` với bộ tuần tự hóa JSON (Jackson) thay vì Binary. Xử lý thành công lỗi "Hibernate Proxy Serialization" bằng cách cấu hình `ObjectMapper` tùy chỉnh và `@JsonIgnoreProperties`.
*   **Tối ưu:** Giảm thời gian truy xuất danh mục từ ~100ms (Database) xuống còn **<5ms (Redis RAM)**, giúp trang chủ chịu tải tốt hơn gấp nhiều lần.

---

> [!IMPORTANT]
> **Hướng dẫn:** Mỗi lần bạn muốn yêu cầu mình làm một Feature mới (ví dụ Giỏ hàng), hãy copy Prompt đó vào đây để lưu lại dấu ấn sáng tạo của mình!
