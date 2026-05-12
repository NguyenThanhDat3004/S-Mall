# S-Mall: Luồng Chạy Tính Năng (Feature Flow Documentation)

Tài liệu này mô tả các luồng xử lý kỹ thuật cho các tính năng chính của dự án S-Mall.

---

## 1. Hệ thống Gợi ý Cá nhân hóa (AI Recommendation Engine)

Hệ thống sử dụng mô hình **Hybrid Recommendation** kết hợp hành vi người dùng thời gian thực và dữ liệu phổ biến.

### Sơ đồ Luồng (Sequence Diagram)
```mermaid
sequenceDiagram
    participant User as Người dùng
    participant Controller as Interaction Controllers
    participant BehaviorSvc as UserBehaviorService (WSS)
    participant Redis as Redis (ZSET & List)
    participant RecoSvc as RecommendationService
    participant DB as SQL Database

    Note over User, DB: Giai đoạn 1: Thu thập hành vi
    User->>Controller: Xem SP / Thêm giỏ hàng / Mua hàng
    Controller->>BehaviorSvc: logAction(identifier, categoryId)
    BehaviorSvc->>Redis: ZINCRBY user:interests:cats <weight> <catId>
    
    Note over User, DB: Giai đoạn 2: Gợi ý sản phẩm
    User->>RecoSvc: Truy cập Cart / Homepage
    RecoSvc->>Redis: ZREVRANGEBYSCORE (Lấy Top 5 Category IDs)
    RecoSvc->>DB: Query sản phẩm thuộc Top 5 Categories
    RecoSvc->>DB: Query sản phẩm Top Rated (Bù đắp/Fallback)
    RecoSvc->>RecoSvc: Mix & Shuffle (Trộn & Xáo trộn)
    RecoSvc-->>User: Hiển thị 18 sản phẩm cá nhân hóa
```

### Trọng số Điểm tiềm năng (Weighted Scoring)
| Hành động | Trọng số | Ghi chú |
| :--- | :--- | :--- |
| Xem chi tiết (View) | +1 | Quan tâm mức độ thấp |
| Tìm kiếm (Search) | +2 | Có chủ đích tìm kiếm |
| Thêm vào giỏ (Cart) | +5 | Quan tâm mức độ cao |
| Mua hàng (Purchase) | +10 | Chuyển đổi thành công |

---

## 2. Hệ thống Lưu trữ Lai (Hybrid Persistence: SQL + Redis)

Hệ thống kết hợp sức mạnh của Redis (Tốc độ) và SQL (Bền bỉ) để đảm bảo dữ liệu không bao giờ bị mất ngay cả khi server bảo trì hoặc RAM bị xóa.

### Quy trình "Double-Write" (Ghi song song):
1.  **Thêm vào giỏ**: Hệ thống đồng thời lưu vào Redis (để lấy nhanh) và bảng `cart_items` trong SQL (để lưu trữ lâu dài).
2.  **Lưu địa chỉ**: Khi người dùng tích chọn "Lưu địa chỉ", thông tin sẽ được nạp vào Redis và bảng `addresses` (như một bản ghi lịch sử).

### Quản lý Vòng đời Dữ liệu (Lifecycle Management):
-   **Khi Đăng nhập (Sync on Login)**: `CustomAuthenticationSuccessHandler` kích hoạt lệnh nạp dữ liệu từ SQL lên Redis. Đảm bảo người dùng luôn thấy giỏ hàng của mình dù đổi thiết bị.
-   **Khi Đăng xuất (Purge on Logout)**: `CustomLogoutHandler` xóa sạch dữ liệu người dùng trên Redis để giải phóng RAM, nhưng vẫn giữ nguyên bản gốc trong SQL.

---

## 3. Luồng Quản lý Địa chỉ & Lịch sử Giao hàng

Hệ thống hỗ trợ lưu nhiều địa chỉ và cho phép người dùng chọn lại các địa chỉ đã từng sử dụng.

### Quy trình kỹ thuật:
1.  **Lưu trữ**: Địa chỉ được lưu vào bảng `addresses` (liên kết ManyToOne với User). Cột `address` trong `user_profiles` được giữ làm địa chỉ mặc định/gần nhất.
2.  **Truy xuất**: Tại trang thanh toán, hệ thống truy vấn tất cả địa chỉ cũ từ SQL và hiển thị thành danh sách gợi ý.
3.  **Tương tác**: Người dùng click vào địa chỉ gợi ý -> JavaScript tự động điền vào ô nhập liệu (Textarea).

---

## 4. Luồng Bảo mật & Chống Brute Force

Đảm bảo an toàn cho tài khoản người dùng thông qua Redis.

### Quy trình:
1.  **Theo dõi**: Mỗi lần login sai, tăng giá trị đếm tại `login:attempts:{username}` trong Redis.
2.  **Khóa (Lock)**: Nếu đếm đạt 5 lần, đặt TTL cho key là 30 phút.
3.  **Hành động**: 
    - Chặn mọi yêu cầu login tiếp theo trong thời gian khóa.
    - Gửi email cảnh báo bảo mật cho người dùng.
    - Hiển thị đồng hồ đếm ngược thời gian mở khóa trên giao diện.

---

## 5. Mô phỏng Thanh toán QR & Xác nhận Đơn hàng (Simulated QR Payment)

Hệ thống cung cấp quy trình thanh toán QR giả lập chuyên nghiệp, tích hợp đồng bộ dữ liệu địa chỉ.

### Sơ đồ Luồng (Sequence Diagram)
```mermaid
sequenceDiagram
    participant User as Người dùng (PC/Phone)
    participant Browser as Trình duyệt (Payment Page)
    participant SimulationCtrl as PaymentSimulationController
    participant MailSvc as MailService (JavaMail)
    participant ConfirmCtrl as CartController (Confirm API)
    participant AddressSvc as UserAddressRedisService (SQL+Redis)
    participant OrderSvc as OrderServiceImpl (Business Logic)

    Note over User, Browser: Bước 1: Khởi tạo QR
    User->>Browser: Nhấn "Đặt Hàng" & Tích "Lưu địa chỉ"
    Browser->>Browser: Gắn tham số saveAddr=true vào Simulation Link
    Browser->>Browser: Hiển thị Modal QR
    
    Note over User, SimulationCtrl: Bước 2: Quét mã & Gửi Mail
    User->>SimulationCtrl: Quét QR -> Nhận diện saveAddr
    SimulationCtrl->>MailSvc: Gửi Email chứa Link Xác nhận (kèm saveAddr)
    
    Note over User, OrderSvc: Bước 3: Xác nhận & Persistence
    User->>ConfirmCtrl: Click nút trong Email (Confirm Link)
    ConfirmCtrl->>AddressSvc: Nếu saveAddr=true -> Lưu vào SQL Addresses
    ConfirmCtrl->>OrderSvc: createOrder(...) & Clear Redis Cart
    OrderSvc-->>User: Hoàn tất đơn hàng
```

### Các công nghệ & Giải pháp áp dụng:
1.  **Auto IP Detection**: Sử dụng `DatagramSocket` trong Java để tự động tìm IP nội bộ, giúp điện thoại quét được mã QR mà không cần cấu hình thủ công.
2.  **Idempotency (Tính nhất quán)**: Xử lý trường hợp người dùng nhấn link xác nhận nhiều lần mà không gây lỗi "Trống giỏ hàng".
3.  **Real-time Polling**: Trình duyệt tự động thăm dò trạng thái đơn hàng để đóng Modal QR ngay khi người dùng xác nhận trên thiết bị khác.
4.  **Seamless Experience**: Tab xác nhận từ Email tự động hiển thị hướng dẫn đóng tab để tập trung trải nghiệm vào Tab chính.

---

## 6. Hệ thống Hộ chiếu Đơn hàng (Smart Order Passport) & Hóa đơn Tự động

Hệ thống quản lý vòng đời đơn hàng khép kín, tích hợp bản đồ vận chuyển thời gian thực và tự chủ công nghệ định danh QR.

### Sơ đồ Luồng Vận hành Passport:
```mermaid
sequenceDiagram
    participant Role as User (Seller/Shipper/Buyer)
    participant LocalAPI as /api/qrcode (Internal QR)
    participant Map as Leaflet.js (Dynamic Map)
    participant PassportCtrl as OrderPassportController
    participant OrderSvc as OrderService (updateStatus)
    participant InvoiceSvc as OrderService (createInvoice)
    participant DB as SQL Database (Orders/Invoices)

    Note over Role, LocalAPI: Bước 1: Tạo mã & Quét định danh
    LocalAPI->>LocalAPI: QRCodeService tạo QR nội bộ (PNG)
    Role->>PassportCtrl: Truy cập /order/passport/{code} thông qua quét QR
    PassportCtrl->>PassportCtrl: Nhận diện Role & Trạng thái đơn hàng
    
    Note over Role, Map: Bước 2: Theo dõi hành trình thời gian thực
    Map->>Map: Vẽ Route qua các trạm dừng (Hà Nội -> Hà Tĩnh -> ...)
    alt Trạng thái = SHIPPING (Giao tận tay)
        Map->>Map: Di chuyển 🚚 áp sát địa chỉ khách hàng (95% quãng đường)
    end
    PassportCtrl-->>Role: Hiển thị Bản đồ động & Nhật ký trạm dừng (Ledger)

    Note over Role, DB: Bước 3: Thao tác & Ghi nhận Doanh thu
    Role->>OrderSvc: Nhấn "Xác nhận" / "Giao hàng"
    OrderSvc->>DB: Cập nhật trạng thái & Lưu vết trạm dừng
    
    rect rgb(240, 255, 240)
        Note right of OrderSvc: Cơ chế Invoice thông minh
        alt Phương thức là QR (Trả trước)
            OrderSvc->>InvoiceSvc: Xuất Hóa đơn ngay khi đặt hàng thành công
        else Phương thức là COD (Trả sau)
            OrderSvc->>InvoiceSvc: Chỉ xuất Hóa đơn khi trạng thái = DELIVERED
        end
    end
    
    InvoiceSvc->>DB: Lưu bản ghi Invoices (Doanh thu chính thức)
```

### Các công nghệ & Giải pháp áp dụng:
1.  **Tự chủ công nghệ QR (Internal QR Engine)**: Triển khai API `/api/qrcode` sử dụng thư viện ZXing để tạo ảnh QR trực tiếp từ Server. Loại bỏ hoàn toàn sự phụ thuộc vào bên thứ ba, đảm bảo tính riêng tư và tốc độ tải cực nhanh.
2.  **Dynamic Route Visualization**: Sử dụng **Leaflet.js** để vẽ hành trình giao hàng. Hệ thống tự động tính toán tọa độ các trạm dừng trung chuyển và hiển thị vị trí mô phỏng của phương tiện vận chuyển dựa trên trạng thái đơn hàng.
3.  **Logistics Ledger (Nhật ký hành trình)**: Tự động ghi lại thời gian và địa điểm của từng bước xử lý (Xác nhận đơn, Xuất kho, Qua trạm trung chuyển, Giao hàng thành công) một cách minh bạch.
4.  **Revenue Recognition (Ghi nhận doanh thu)**: 
    - **Thanh toán QR**: Xuất hóa đơn ngay lập tức (Prepaid) để khớp nối dòng tiền.
    - **Thanh toán COD**: Chỉ xuất hóa đơn khi đơn hàng đạt trạng thái `DELIVERED` (Đã giao thành công), đảm bảo tính pháp lý và tài chính chính xác.
5.  **Bảo mật Stacking (Z-Index Fix)**: Xử lý lỗi giao diện menu hành động bị che khuất bằng cơ chế nâng cấp `z-index` động khi tương tác, mang lại trải nghiệm người dùng chuyên nghiệp.


### Các quy tắc nghiệp vụ (Business Rules):
1.  **Tính bảo mật Role-based**: Shipper chỉ thấy nút giao hàng, Seller thấy nút xác nhận chuẩn bị hàng, Buyer thấy nút nhận hàng. Người lạ quét mã chỉ thấy thông tin theo dõi cơ bản.
2.  **Điểm ghi nhận doanh thu (Revenue Recognition)**: 
    - Đối với thanh toán Online (QR): Doanh thu được ghi nhận sớm ngay khi tiền về tài khoản hệ thống.
    - Đối với thanh toán Offline (COD): Doanh thu chỉ được ghi nhận khi hàng đã đến tay khách và tiền đã được thu hộ.
3.  **Mã định danh duy nhất**: Mỗi hóa đơn có một `InvoiceCode` duy nhất gắn liền với `OrderCode` để phục vụ đối soát tài chính và in ấn sau này.
## 7. Hệ thống Voucher Kép (Hybrid Voucher System)

Hệ thống cho phép áp dụng đồng thời mã giảm giá từ Shop và nhiều mã giảm giá từ Sàn (S-Mall).

### Sơ đồ Luồng (Sequence Diagram)
```mermaid
sequenceDiagram
    participant User as Người dùng
    participant UI as Giao diện Thanh toán
    participant Modal as Modal Voucher
    participant Logic as JavaScript (updateSummary)
    participant Server as Order API / QR Simulation

    User->>UI: Mở trang Thanh toán
    UI->>UI: Phân loại Voucher (v.shopId ? Shop : S-Mall)
    
    User->>Modal: Chọn Voucher Shop
    Modal->>Logic: selectVoucher (Single-select per shop)
    Logic->>UI: Cập nhật "Voucher Card" của Shop đó
    
    User->>Modal: Chọn Voucher S-Mall
    Modal->>Logic: selectVoucher (Toggle Multi-select)
    Logic->>UI: Cập nhật danh sách mã S-Mall (Emerald Glow section)

    rect rgb(240, 248, 255)
        Note over Logic: Giai đoạn: Tính toán & Đồng bộ
        Logic->>Logic: Cộng dồn (Shop Discounts + All S-Mall Discounts)
        Logic->>UI: Cập nhật "Tổng tiền cuối cùng"
    end

    User->>UI: Nhấn "Đặt hàng" / Quét QR
    UI->>Server: Gửi shopVouchers & platformVouchers (JSON)
    Server->>Server: Kiểm tra điều kiện & Ghi nhận đơn hàng
```

### Quy tắc Nghiệp vụ (Business Rules):
1.  **Voucher Shop (Shop-fenced)**: Chỉ áp dụng cho sản phẩm của Shop đó. Giới hạn **1 mã/shop**. Nếu người dùng chọn mã mới của cùng 1 shop, mã cũ sẽ bị hủy.
2.  **Voucher Sàn (Platform-wide)**: Áp dụng trên tổng giá trị đơn hàng (Subtotal). Cho phép **chọn nhiều mã** (nếu thỏa mãn điều kiện đơn tối thiểu).
3.  **Điều kiện áp dụng (Min Order)**: Hệ thống tự động kiểm tra lại điều kiện `minOrderValue` mỗi khi có thay đổi (ví dụ: khi người dùng đổi phương thức vận chuyển hoặc bảo hiểm làm thay đổi tổng tiền).
4.  **Tính nhất quán dữ liệu**: Toàn bộ danh sách mã đã chọn được lưu vết và gửi kèm theo đơn hàng để đảm bảo tính minh bạch giữa Client và Server.

---

## 8. Hệ thống Sidebar Thu gọn Toàn cục (Global Collapsible Sidebar)
Hệ thống quản lý trạng thái hiển thị của Sidebar một cách đồng bộ trên toàn bộ Seller Center, tối ưu hóa diện tích làm việc cho người bán.

### Quy trình kỹ thuật:
1.  **Cấu trúc Layout**: Sử dụng `sidebar.jsp` làm thành phần dùng chung. Nội dung chính của trang được bao bọc trong một container `<div id="main-content">`.
2.  **Trạng thái Toggle**: Khi người dùng nhấn nút Hamburger, hàm `toggleSidebar()` sẽ thêm/xóa class `.collapsed` vào Sidebar và cập nhật lề (`margin-left`) của `main-content`.
3.  **Đồng bộ giao diện**: Tất cả các trang quản trị (Dashboard, Order, Product, Voucher, Customers) đều chia sẻ chung một bộ ID và Class CSS để đảm bảo tính nhất quán khi chuyển trang.

---

## 9. Giao diện Chat SMall AI (Chat UI Alignment Logic)
Trợ lý ảo SMall AI sử dụng cơ chế căn chỉnh tin nhắn thông minh để phân biệt rõ ràng giữa Người dùng và AI, mang lại trải nghiệm chat chuyên nghiệp.

### Logic căn chỉnh Flexbox:
1.  **Container chính**: `#history` (hoặc `#chat-messages`) được thiết lập là `display: flex; flex-direction: column;`.
2.  **Tin nhắn Người dùng (USER)**:
    - Sử dụng class `self-end` để đẩy bubble về phía bên phải.
    - Màu sắc: Xanh Emerald (`bg-emerald-600` hoặc `#10b981`).
    - Bo góc: `rounded-br-none` (góc dưới bên phải vuông) để tạo cảm giác hội thoại.
3.  **Tin nhắn AI (SMall AI)**:
    - Sử dụng class `self-start` để đẩy bubble về phía bên trái.
    - Màu sắc: Xám nhạt/Xanh nhạt (`bg-slate-800` hoặc `#f0fdf4`).
    - Bo góc: `rounded-bl-none` (góc dưới bên trái vuông).

### Sơ đồ luồng hiển thị:
```mermaid
graph TD
    A[Nhận tin nhắn] --> B{Kiểm tra Role?}
    B -- isUser=true --> C[Thêm class self-end + Màu xanh]
    B -- isUser=false --> D[Thêm class self-start + Màu xám]
    C --> E[Render vào #history]
    D --> E
    E --> F[Scroll to Bottom]
```

---

## 10. SMall AI Advisor: Persistence & Intelligence
Hệ thống trợ lý ảo thông minh tích hợp sâu vào quy trình vận hành của Seller, hỗ trợ phân tích dữ liệu khách hàng và thực thi các hành động marketing tự động.

### Sơ đồ Luồng Hoạt động (Execution Flow):
```mermaid
sequenceDiagram
    participant Seller as Chủ Shop
    participant Agent as SellerAgentService
    participant Buffer as chatBuffer (RAM)
    participant LLM as Groq LLM (Llama-3.1-8b)
    participant Tool as VoucherAgentSkill
    participant DB as SQL Server

    Seller->>Agent: Gửi tin nhắn (Chat)
    Agent->>Buffer: Lưu tin nhắn USER vào RAM
    Agent->>LLM: Gửi Prompt (Context + Persona + Tools)
    LLM-->>Agent: Trả về Analysis + Response
    
    alt Có lệnh EXECUTION (Đã được xác nhận)
        Agent->>Tool: executeTool(createVoucher)
        Tool->>DB: INSERT vouchers
    end

    Agent->>Buffer: Lưu phản hồi ASSISTANT vào RAM
    Agent-->>Seller: Hiển thị câu trả lời (Thảo mai)

    Note over Seller, DB: Khi bấm Refresh / Logout
    Agent->>DB: Flush toàn bộ Buffer vào ai_chat_messages
    Agent->>LLM: Summarize Persona (Đúc kết hồ sơ)
    LLM-->>Agent: Trích xuất Tính cách / Phong cách / Thói quen
    Agent->>DB: INSERT ai_chat_personas (Bản ghi mới)
```

### Các công nghệ & Giải pháp áp dụng:
1.  **High-Performance Buffering**: Sử dụng `ConcurrentHashMap` để lưu trữ tin nhắn tạm thời trong RAM. Hệ thống chỉ ghi vào database (I/O) một lần duy nhất khi kết thúc phiên chat, giảm tải cho SQL Server đến 90%.
2.  **Persona Evolution**: Thay vì ghi đè, hệ thống tạo bản ghi mới cho mỗi phiên chat. Khi khởi động phiên mới, AI sẽ đọc **3 bản ghi gần nhất** để hiểu "quá trình tiến hóa" của người dùng, đảm bảo trí nhớ dài hạn mà không tốn quá nhiều Token.
3.  **Diplomatic Persona (Thảo mai)**: AI được cấu hình để xưng hô đích danh tên chủ shop, sử dụng ngôn ngữ khéo léo và hỗ trợ.
- **Secure Tool-Use**: AI không bao giờ tự ý thực thi hành động. Nó phải đề xuất phương án và chỉ thực thi lệnh `createVoucher` khi nhận được sự đồng ý rõ ràng từ chủ shop.
5.  **Robust Persistence**: Xử lý triệt để các lỗi đệ quy JSON (Jackson) và xung đột ràng buộc database (Unique Constraint) trong môi trường chạy ngầm (Async).

## 11. Hệ thống Chat Real-time & Cuộn nạp lịch sử (Infinite Scroll Chat)
Hệ thống tin nhắn tức thời cho phép người bán và người mua hội thoại trực tiếp, hỗ trợ lưu trữ bền bỉ và nạp dữ liệu thông minh.

### Sơ đồ Luồng (Sequence Diagram)
```mermaid
sequenceDiagram
    participant User as Người dùng (Buyer/Seller)
    participant WS as WebSocket (STOMP/SockJS)
    participant Ctrl as ChatWebSocketController
    participant Svc as ChatService (Redis Buffer)
    participant DB as SQL Database
    
    Note over User, WS: Giai đoạn: Gửi tin nhắn
    User->>WS: SEND /app/chat.send {roomId, content}
    WS->>Ctrl: handleMessage(payload)
    Ctrl->>Svc: bufferMessage(...)
    Svc->>DB: Lưu tin nhắn mới vào SQL
    Svc->>Svc: Cập nhật Redis Buffer (Cache 20 tin gần nhất)
    
    Note over Ctrl, User: Giai đoạn: Phản hồi Real-time
    Ctrl->>WS: convertAndSendToUser(targetEmail, payload)
    WS-->>User: Hiển thị tin nhắn ngay lập tức (appendMessage)
    
    Note over User, Svc: Giai đoạn: Tải lịch sử (Scroll Up)
    User->>User: Cuộn lên top (scrollTop == 0)
    User->>Svc: API /api/chat/rooms/{id}/messages?page=N
    Svc->>DB: Truy vấn phân trang tin nhắn cũ
    Svc-->>User: Trả về dữ liệu -> prependMessage()
```

### Các quy tắc kỹ thuật & Tối ưu:
1.  **Định danh WebSocket (User Destination)**: Sử dụng **Email** thay vì ID để khớp nối với `Principal` của Spring Security, đảm bảo tin nhắn được đẩy chính xác đến từng người dùng.
2.  **Cơ chế Duy trì Vị trí Cuộn (Scroll Anchor)**: Khi nạp tin nhắn cũ lên đầu (`prepend`), hệ thống tính toán chênh lệch `scrollHeight` để giữ nguyên vị trí mắt đang đọc, tránh tình trạng màn hình bị nhảy xuống dưới.
3.  **Phân tầng dữ liệu**: Ưu tiên hiển thị tin nhắn từ mảng tin nhắn tức thời của WebSocket trước, sau đó mới đến dữ liệu đồng bộ từ API nạp lịch sử.
4.  **Phân quyền (Security)**: Mọi yêu cầu lấy tin nhắn đều được kiểm tra `isShopOwner || isCustomer`. Nếu không thỏa mãn, hệ thống trả về 403 Forbidden và hiển thị thông báo lỗi trực quan trên UI.
