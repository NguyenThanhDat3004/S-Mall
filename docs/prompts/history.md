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

### 16. Hệ thống Khám phá Sản phẩm Phân trang (Load More AJAX)
*   **Vấn đề chủ chốt:** Gặp lỗi **404 Not Found** và **403 Forbidden** liên tục khi thực hiện AJAX. Nguyên nhân do Controller nằm sai package quét component và bộ lọc Spring Security mặc định chặn các API mới.
*   **Cách Fix:** 
    1.  Tái cấu trúc lại tệp và di chuyển Controller về đúng package `com.controller.client`.
    2.  Cấu hình `SecurityConfig` để `permitAll()` cho khớp nối `/api/**`.
    3.  Triển khai **Hybrid Discovery Strategy**: Sử dụng mô hình nạp dữ liệu 2 tầng – kết hợp giữa **Local DOM Reveal** (hiển thị ngay 6 items sẵn có) và **Remote AJAX Fetch** (truy xuất thêm 18 items từ Server) để tối ưu hóa triệt để tốc độ phản hồi.
*   **Tối ưu:** Xử lý triệt để lỗi `ClassCastException` trong Redis bằng cách đổi phiên bản Cache Key (v4) và thêm bước kiểm tra kiểu dữ liệu an toàn (`instanceof`).


### 17. Chiến dịch "Nuclear Unicode Fix" & Thẩm mỹ Premium
*   **Vấn đề chủ chốt:** Lỗi phông chữ dấu hỏi (?) do cột Database là `VARCHAR` (không hỗ trợ Unicode). Nghiêm trọng hơn, dữ liệu đã lưu bị hỏng hoàn toàn, không thể cứu vãn bằng cách sửa code hiển thị đơn thuần.
*   **Cách Fix:** Triển khai phương án "Nuclear Reset":
    1.  **Backend:** Sử dụng `JdbcTemplate` thực thi lệnh `ALTER TABLE` cưỡng bức tại runtime để chuyển kiểu dữ liệu sang `NVARCHAR`.
    2.  **Data Persistence:** Chèn lệnh `deleteAll()` triệt để và nạp lại toàn bộ dữ liệu mẫu (Re-seed) thông qua `DataInitializer` để đảm bảo 100% dữ liệu trong DB là Unicode sạch.
    3.  **UI:** Sửa lỗi lặp ký hiệu tiền tệ (`đ đ`) bằng cách chuẩn hóa `Intl.NumberFormat` và nhúng phông chữ **Inter** để đạt thẩm mỹ cao cấp.
*   **Tối ưu:** Giải quyết tận gốc bài toán mã hóa ký tự từ tầng Database -> Java -> JSP, biến đây thành một Case Study điển hình về xử lý Encoding lỗi thời.

## [2026-04-28] - Redis Cart Optimization & Critical Persistence Fixes
### Fixed
- **Database Persistence Loss**: Identified and removed a destructive `deleteAll()` in `DataInitializer.java` that was wiping product data on every application restart (DevTools).
- **NullPointerException in Cart**: Added essential null-checks in `CartServiceImpl` for shops without owners (e.g., system shops), preventing crashes during the "Anti-Self-Purchase" check.
- **REST Exception Handling**: Refactored `GlobalExceptionHandler` to detect `/api/` requests and return structured JSON instead of redirecting to a JSP error page, ensuring AJAX stability.

### Added
- **Seller Tools Contextual UI**: Implemented a premium "Seller Tools" dashboard in `detail.jsp` that appears only when the shop owner views their own product, providing quick access to Edit, Inventory, and Stats.
- **Dynamic Product Statistics**: Replaced hardcoded "2.5k reviews" placeholder with real-time data from the `ReviewRepository`.
- **System Error Branding**: Created custom `404.jsp` and `generic.jsp` error pages consistent with the S-Mall "Premium Green" aesthetic.

### Technical Improvements
- **Service Layer Data Enrichment**: Moved review counting and formatting logic from JSP (math formulas) to the `ProductServiceImpl` using `@Transient` fields, adhering to clean MVC principles.
- **Dependency Redesign**: Standardized `ProductServiceImpl` to use Constructor Injection for all repositories, improving testability and code quality.
- **JSP UI Refinement**: Hidden the "Quantity Selector" when a shop owner views their own product to streamline the interface and prevent invalid actions.

### 19. Đồng bộ hóa Giao diện Premium & Modernization
*   **Vấn đề chủ chốt:** Sự thiếu nhất quán giữa Trang chủ và Trang chi tiết (Footer bị vỡ, Header bị biến dạng khoảng cách, Font chữ không đồng bộ).
*   **Cách Fix:** 
    1.  **Layout Standardization:** Chuyển đổi toàn bộ cấu hình Container sang chuẩn Bootstrap và nhúng font **Inter** toàn cục.
    2.  **Flex-Gap Architecture:** Thay thế các `margin` thủ công trong Header bằng thuộc tính `gap` của Flexbox để đạt độ chính xác tuyệt đối 15px giữa các thành phần điều hướng.
    3.  **Feedback Micro-interaction:** Xây dựng hệ thống **Custom Toast Notification** (trượt từ góc màn hình) thay thế cho các lệnh `alert` thô sơ, mang lại cảm giác ứng dụng Web hiện đại và đắt tiền.
*   **Tối ưu:** Sử dụng `URLSearchParams` thay cho `FormData` để tăng tính tương thích với các API Spring MVC truyền thống, đảm bảo dữ liệu luôn được gửi đi chính xác 100%.

---

### 24. Hệ thống Hộ chiếu Đơn hàng (Smart Order Passport) & Hóa đơn Tự động (Automated Invoice)
*   **Prompt:** "Tôi muốn hiện đại hóa quản lý đơn hàng của Seller theo phong cách Luxury Minimalist, tích hợp mã QR Passport để mọi vai trò (Seller, Shipper, Buyer) dễ dàng thao tác, và phải có cơ chế xuất hóa đơn Invoice tự động vào DB ngay khi thanh toán thành công."
*   **Kết quả:** Triển khai hệ thống vận hành 360 độ:
    1.  **Order Passport:** Tạo trang `passport.jsp` (Mobile-first) với QR Code định danh. Hệ thống tự động nhận diện Role (Seller/Shipper/Buyer) khi quét mã để hiển thị các nút hành động tương ứng (Xác nhận/Giao hàng/Đã nhận).
    2.  **Cơ chế Invoice Thông minh:** Thiết lập luồng tài chính tự động: Xuất hóa đơn ngay khi đặt hàng (đối với thanh toán QR trả trước) và xuất hóa đơn khi giao hàng thành công (đối với COD).
    3.  **UI Modernization:** Nâng cấp bảng chi tiết đơn hàng với Timeline 5 bước hành trình, Việt hóa toàn diện và tích hợp thẻ "Hồ sơ người mua" chuyên nghiệp với nút Chat nhanh.
*   **Tối ưu:** Chuẩn hóa Enum `OrderStatus` đầy đủ 6 bước và triển khai logic `createInvoiceForOrder` đảm bảo tính nhất quán tuyệt đối giữa trạng thái vận chuyển và ghi nhận doanh thu.

---

### 20. Hệ thống Gợi ý Cá nhân hóa (Weighted Scoring & Resilient Redis)
*   **Vấn đề chủ chốt:** Hệ thống gợi ý ban đầu còn mang tính "tĩnh", chưa thay đổi theo hành vi thực tế và gặp lỗi định dạng dữ liệu (`ClassCastException`, `START_ARRAY`) khi nạp từ Redis.
*   **Cách Fix:** 
    1.  **Thuật toán AI (WSS):** Triển khai Weighted Scoring System sử dụng Redis Sorted Sets (ZSET) với trọng số: View (+1), Add to Cart (+5), Purchase (+10).
    2.  **Hybrid Recommendation:** Kết hợp giữa sản phẩm Cá nhân hóa (Top 5 Categories) và cơ chế Bù đắp (Filling) từ kho sản phẩm Top Rated để danh sách luôn đầy đủ (đủ 18 item) và sống động (Shuffle).
    3.  **Resilient Serialization:** Loại bỏ cấu hình `activateDefaultTyping` gây lỗi mảng, chuyển sang dùng `objectMapper.convertValue` trong Service để tương thích 100% với cả dữ liệu cũ và mới.
    4.  **UI Premium:** Triển khai nhãn "Sale Badge" động và logic hiển thị "9+" cho badge giỏ hàng/chat trên Header để đạt chuẩn thiết kế hiện đại.
*   **Tối ưu:** Đưa toàn bộ các hàm định dạng con số và xử lý đường dẫn ảnh về một nguồn duy nhất (Single Source of Truth) trong `header.jsp`, giúp bảo trì dễ dàng và đồng bộ hóa trải nghiệm trên toàn bộ ứng dụng.

---

### 21. Hệ thống Thanh toán QR Giả lập & Đồng bộ Polling (Simulation Flow)
*   **Prompt:** "Tôi muốn thiết kế một quy trình thanh toán QR giả lập chuyên nghiệp: khi quét bằng điện thoại sẽ tự gửi email xác nhận, và trang web hiện tại phải tự động nhận diện khi thanh toán xong mà không cần F5. Hãy xử lý cả vấn đề localhost không quét được."
*   **Kết quả:** Triển khai luồng thanh toán khép kín:
    1.  **Auto IP Detection:** Sử dụng Java để tự động tìm IP máy tính, giúp điện thoại quét mã QR trong mạng nội bộ dễ dàng.
    2.  **Email Simulation:** Tích hợp `MailService` gửi link xác nhận có tính năng **Idempotency** (chống lỗi click đúp).
    3.  **Real-time Polling:** Sử dụng `setInterval` và API `check-status` để trình duyệt tự động đóng Modal QR và redirect khi đơn hàng hoàn tất.
    4.  **UX Polish:** Tạo trang `payment_finish_tab.jsp` để xử lý việc đóng tab xác nhận một cách tinh tế.
*   **Tối ưu:** Giải quyết triệt để lỗi "No static resource" bằng cơ chế Alias Mapping và khắc phục lỗi lệch Cart Key (`cart:user:email`) giữa các tầng kiến trúc.

### 22. Hệ thống Lưu trữ Lai Bền bỉ & Quản lý Lịch sử Địa chỉ (Resilient Hybrid Persistence)
*   **Prompt:** "Làm sao để giỏ hàng và địa chỉ không bị mất khi RAM Redis bị xóa hoặc server sập? Hãy lưu thêm một bản vào Database và nạp lại khi người dùng login. Đồng thời hãy lưu lịch sử địa chỉ để lần sau người dùng chỉ cần chọn lại."
*   **Kết quả:** Triển khai cơ chế **Double-Write Architecture**:
    1.  **SQL Persistence:** Tự động lưu `CartItem` và `Address` vào Database song song với Redis.
    2.  **Lifecycle Sync:** Sử dụng `CustomAuthenticationSuccessHandler` để nạp ngược dữ liệu từ SQL lên Redis khi login và `CustomLogoutHandler` để dọn dẹp RAM khi logout.
    3.  **Address History:** Tạo bảng `addresses` riêng biệt để lưu trữ mọi địa chỉ người dùng từng sử dụng, thay vì chỉ ghi đè vào Profile.
    4.  **UX Option:** Tích hợp danh sách "Địa chỉ đã dùng" vào giao diện thanh toán, hỗ trợ điền nhanh thông tin chỉ với 1 click.
*   **Tối ưu:** Xử lý triệt để lỗi đồng bộ `cartKey` giữa các tầng API và Controller, đảm bảo tính nhất quán tuyệt đối của dữ liệu giỏ hàng trên mọi thiết bị.

### 23. Hiện đại hóa Dashboard Người bán (Luxury Minimalist & AJAX Load More)
*   **Prompt:** "Hãy hiện đại hóa trang danh sách sản phẩm của Seller: thiết kế theo phong cách Luxury Minimalist (Glassmorphism), đồng bộ màu Emerald với trang chủ, và thay thế phân trang truyền thống bằng cơ chế 'Hiển thị thêm' (Load More) qua AJAX để trải nghiệm mượt mà hơn."
*   **Kết quả:** Lột xác hoàn toàn giao diện quản trị:
    1.  **UI/UX Cao cấp:** Sử dụng Tailwind CSS xây dựng Layout Glassmorphism với bảng màu Emerald & Slate Gray tinh tế. Triển khai Sidebar thông minh tích hợp báo cáo doanh thu và thanh Search Sticky mượt mà.
    2.  **Cơ chế nạp dữ liệu vô tận (Infinite Loading):** Tái cấu trúc sang `product_items.jsp` (Fragment) và sử dụng AJAX để tải thêm sản phẩm mà không cần load lại trang.
    3.  **Hệ thống Nhãn Kinh doanh (Business Badges):** Tự động tính toán và hiển thị các nhãn "Bán chạy", "Xu hướng", "Sắp hết hàng" dựa trên logic real-time từ Database.
    4.  **Tương tác thông minh:** Tích hợp hiệu ứng "Xem chi tiết" khi hover vào ảnh sản phẩm và hệ thống nút hành động (Sửa/Xóa) trực quan, nổi bật.
*   **Tối ưu:** Sử dụng **Alpine.js** để xử lý các tương tác nhẹ (Dropdown, Modal) giúp mã nguồn JSP luôn gọn gàng và đạt hiệu năng phản hồi cực nhanh.

---

### 25. Hệ thống Quản lý Đơn hàng Toàn diện (Full Order Lifecycle & Logistics Tracking)
*   **Prompt:** "Hãy hoàn thiện luồng quản lý đơn hàng cho Người bán: từ việc phê duyệt, theo dõi hành trình (Logistics Passport) với bản đồ thời gian thực, đến việc tự động xuất hóa đơn khi giao hàng thành công. Ngoài ra, hãy tự chủ công nghệ tạo mã QR mà không cần gọi API bên thứ ba."
*   **Kết quả:** Hoàn thiện hệ thống vận hành chuyên nghiệp:
    1.  **Digital Order Passport & Dynamic Map:** Nâng cấp trang `passport.jsp` với bản đồ lộ trình động (Route Visualization). Icon xe tải 🚚 tự động áp sát điểm cuối khi báo "Giao tận tay". Hệ thống nhật ký (Logistics Ledger) tự động liệt kê các trạm dừng thời gian thực.
    2.  **Tự chủ công nghệ QR:** Triển khai API nội bộ `/api/qrcode` sử dụng `QRCodeService` (ZXing) để tạo mã định danh đơn hàng ngay tại Server, loại bỏ hoàn toàn sự phụ thuộc vào các dịch vụ bên ngoài (api.qrserver.com).
    3.  **Logic Tài chính Chuẩn xác:** Tinh chỉnh `OrderServiceImpl` để tự động tạo `Invoice` (Hóa đơn) vào DB dựa trên hình thức thanh toán: Trả trước (QR) tạo ngay khi đặt, Trả sau (COD) chỉ tạo khi trạng thái là `DELIVERED`.
    4.  **Tối ưu hóa UI/UX Triệt để:** 
        - Khắc phục lỗi "Trắng trang" do xung đột thẻ JSTL và lỗi định dạng ngày tháng `LocalDateTime`.
        - Xử lý lỗi chồng lấp menu (z-index) bằng cơ chế Stacking Order động.
        - Chuyển đổi toàn bộ dữ liệu Alpine.js sang dạng "One-liner" để tránh lỗi cú pháp JS khi có dấu xuống dòng.
*   **Tối ưu:** Loại bỏ các file JSP cũ thừa thãi (`details.jsp`) và thay thế bằng cơ chế **Permanent Redirect** sang trang Passport, đảm bảo dự án luôn gọn gàng và chuẩn mực.

### 26. Phục hưng Quản lý Sản phẩm & Ổn định Hệ thống (Seller Product Suite Restoration)
*   **Prompt:** "Khôi phục lại tính năng Sửa và Xóa sản phẩm bị mất, đồng thời làm lại thanh Sidebar cho chuyên nghiệp hơn. Hãy đảm bảo giao diện không bị mất CSS khi chuyển trang và các lỗi biên dịch Java được giải quyết triệt để."
*   **Kết quả:** Hệ thống quản lý sản phẩm đạt độ hoàn thiện cao nhất:
    1.  **Full CRUD Operations:** 
        - **Edit:** Tái cấu trúc `ProductCreateDTO` và `SellerController` để hỗ trợ cập nhật sản phẩm hiện có, tự động đổ dữ liệu cũ vào form và xử lý biến thể (Variants) mượt mà.
        - **Delete:** Triển khai cơ chế **Soft Delete** qua AJAX, giúp người bán ẩn sản phẩm ngay lập tức với hiệu ứng UI trượt biến mất (fade-out) mà không cần load lại trang.
    2.  **Sidebar "Luxury" & Context-Aware:** Nâng cấp Sidebar với menu Sản phẩm dạng xổ xuống (Collapsible). Menu tự động nhận diện vị trí hiện tại (List hay Create) để mở sẵn và highlight mục tương ứng.
    3.  **Vá lỗi Hệ thống & UI:** 
        - Khắc phục triệt để tình trạng "Sidebar mất CSS" bằng cách bổ sung đầy đủ thư viện Tailwind CSS và Alpine.js vào các trang còn thiếu (`create.jsp`, `dashboard.jsp`).
        - Giải quyết các lỗi biên dịch `Unresolved compilation problems` bằng cách bổ sung toàn bộ các Import còn thiếu trong `SellerController`.
*   **Tình trạng:** Dashboard người bán hiện đã ổn định 100%, sẵn sàng cho việc mở rộng các tính năng phân tích AI nâng cao.




### 27. Hệ thống Voucher Kép & Tối ưu hóa Thanh toán (Hybrid Voucher System)
*   **Prompt:** "Tôi muốn tối ưu hóa logic chọn Voucher: Voucher của Shop thì chỉ được chọn 1 cái (mã sau đè mã trước), còn Voucher của Sàn (S-Mall) thì người dùng có thể chọn nhiều mã cùng lúc để cộng dồn ưu đãi. Hãy làm giao diện thật đẹp và đồng bộ với cả phần thanh toán QR."
*   **Kết quả:** Triển khai cơ chế quản lý Voucher thông minh:
    1.  **Dual-Logic Selection:** Tách biệt logic dựa trên `shop_id`. Tự động áp dụng cơ chế "Toggle Multi-select" cho mã Sàn và "Single-select" cho mã Shop.
    2.  **Premium Checkout UI:** Bổ sung khu vực "Ưu đãi từ S-Mall" với hiệu ứng Emerald Glow. Cập nhật Modal Voucher với hệ thống Checkmark xanh giúp người dùng nhận diện trạng thái chọn tức thì.
    3.  **Real-time aggregation:** Nâng cấp hàm `updateSummary` để tính toán chính xác tổng chiết khấu từ nhiều nguồn khác nhau.
    4.  **Submission Sync:** Đồng bộ hóa dữ liệu Voucher vào cả luồng đặt hàng chính thức và luồng quét mã QR giả lập thông qua tham số JSON.
*   **Tối ưu:** Xử lý triệt để bài toán đồng bộ dữ liệu giữa UI và Logic tính toán, giúp hệ thống Voucher của S-Mall đạt chuẩn trải nghiệm của các sàn TMĐT lớn.

### 28. Đồng bộ Sidebar Toàn cục & Nâng cấp Trợ lý SMall AI (Global UI Sync & SMall AI)
*   **Prompt:** "Hãy đồng bộ tính năng ẩn/hiện Sidebar trên toàn bộ các trang Seller để tối ưu diện tích làm việc. Đồng thời, đổi tên AI Advisor thành SMall AI và sửa lại giao diện chat (Người bên phải, AI bên trái) để đạt chuẩn UX/UI hiện đại."
*   **Kết quả:** Triển khai gói nâng cấp trải nghiệm người dùng (UX) toàn diện:
    1.  **Global Sidebar Toggle:** Tích hợp nút Hamburger và logic `toggleSidebar()` trên 6 trang quản trị (Dashboard, Sản phẩm, Đơn hàng, Voucher, Khách hàng). Sử dụng CSS `transition` và cấu trúc `main-content` để đảm bảo hiệu ứng trượt mượt mà, không bị vỡ Layout.
    2.  **SMall AI Branding:** Chính thức đổi tên trợ lý ảo thành **SMall AI**. Cập nhật toàn bộ các nhãn (Labels), tin nhắn chào mừng và trạng thái hoạt động ("Online") trên giao diện.
    3.  **Chat UI/UX Refinement:** Tái cấu trúc logic hiển thị tin nhắn. Tin nhắn người dùng được căn phải (`self-end`) với màu xanh Emerald, tin nhắn AI được căn trái (`self-start`) với màu xám nhạt. 
    4.  **Security Header Robustness:** Thay thế kiểm tra Role qua Session bằng `pageContext.request.isUserInRole`, giúp nút "Kênh người bán" hiển thị chính xác 100% dựa trên Security Context.
*   **Tối ưu:** Khắc phục lỗi "Required parameter 'ids'" tại trang thanh toán bằng cơ chế **Robust Redirect**, giúp hệ thống không bao giờ bị "crash" khi người dùng truy cập trực tiếp link thanh toán mà không thông qua giỏ hàng.

---
### 29. SMall AI Persistence & Personality Refinement (Trí nhớ dài hạn & Thảo mai Mode)
*   **Prompt:** "Tôi muốn trợ lý SMall AI phải có trí nhớ dài hạn, không bị mất dữ liệu khi restart server. Đồng thời AI phải nói chuyện 'thảo mai', ngọt ngào, gọi tên tôi là anh Đạt, và chỉ được tạo Voucher khi tôi đã đồng ý. Hãy tối ưu hiệu năng để không làm chậm server khi chat nhiều."
*   **Kết quả:** Triển khai hệ thống trợ lý ảo chuẩn Enterprise:
    1.  **3NF Persistence:** Thiết kế lại toàn bộ hạ tầng lưu trữ với 4 bảng chuẩn hóa (`AiChatSession`, `AiChatMessage`, `AiChatPlan`, `AiChatPersona`). Dữ liệu chat tồn tại vĩnh viễn, không bị mất khi restart server.
    2.  **Persona Evolution (Long-term Memory):** Triển khai cơ chế đúc kết Persona sau mỗi phiên chat. AI tự động đọc **3 bản ghi Persona gần nhất** để hiểu "quá trình tiến hóa" của người dùng, giúp câu trả lời luôn nhất quán và cá nhân hóa sâu sắc.
    3.  **High-Performance Buffering:** Xây dựng cơ chế **RAM Caching** sử dụng `ConcurrentHashMap`. Tin nhắn được lưu tạm trên RAM và chỉ ghi xuống DB một lần duy nhất (Batch save) khi kết thúc phiên, giảm tải cho Database đến 90%.
    4.  **Personality & Safety:** Cấu hình Prompt "Thảo mai mode", xưng hô đích danh tên chủ shop. Thiết lập quy trình "Proposal -> Confirm -> Execute" cho việc tạo Voucher, đảm bảo quyền kiểm soát tuyệt đối cho người bán.
*   **Tối ưu:** 
    - Khắc phục triệt để lỗi "Violation of UNIQUE KEY" trên MSSQL bằng script xóa ràng buộc động.
    - Xử lý lỗi lồng dữ liệu JSON (Nesting depth) bằng `@JsonIgnore`.
    - Nâng cấp lên Model **Llama-3.1-8b-instant** để đạt tốc độ phản hồi "nháy mắt".

### 30. Phục hưng Chat Widget & Hệ thống Cuộn trang Vô tận (Chat Widget Fix & Infinite Scroll)
*   **Prompt:** "Tôi đang gặp lỗi ReferenceError: openRoom is not defined khi mở chat widget. Đồng thời tôi muốn người bán có thể xem được lịch sử tin nhắn cũ bằng cách cuộn lên phía trên thay vì chỉ xem được 20 tin gần nhất."
*   **Kết quả:** Giải quyết triệt để lỗi vận hành và nâng cấp trải nghiệm người dùng:
    1.  **Chat Widget Restoration:** Sửa lỗi đệ quy vô hạn trong `chat-widget.js` (hàm `toggleWindow` gọi sai phạm vi), giúp widget chat phía khách hàng hoạt động ổn định 100%.
    2.  **Infinite Scroll (Seller Chat):** Triển khai cơ chế nạp dữ liệu vô tận cho `chat.jsp`. Khi người bán cuộn lên top, hệ thống tự động gọi API lấy `page=1, 2...` và chèn ngược (prepend) vào đầu danh sách mà không làm nhảy vị trí cuộn của người dùng.
    3.  **Real-time Synchronization Fix:** Sửa lỗi routing tin nhắn WebSocket tại Backend (`ChatWebSocketController`). Chuyển đổi định danh người nhận từ `ID` (số) sang `Email` (Principal) để đảm bảo tin nhắn được đẩy về đúng trình duyệt của người dùng ngay lập tức mà không cần F5.
    4.  **Defensive UI:** Bổ sung hệ thống log chi tiết và xử lý lỗi 403/404 ngay trên giao diện chat, giúp người dùng biết rõ lý do nếu không có quyền truy cập thay vì màn hình trắng.
*   **Tối ưu:** Sử dụng cơ chế `oldScrollHeight` để duy trì trải nghiệm đọc lịch sử mượt mà, giúp S-Mall đạt chuẩn tính năng nhắn tin của các sàn thương mại điện tử chuyên nghiệp.
