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

## 2. Luồng Xử lý Giỏ hàng (Cart Persistence Flow)

Sử dụng Redis làm bộ lưu trữ chính để đảm bảo tốc độ và khả năng mở rộng.

### Quy trình nghiệp vụ:
1.  **Định danh (Identification)**: Sử dụng `username` (nếu đã login) hoặc `sessionId` (nếu vãng lai).
2.  **Lưu trữ**: Dữ liệu lưu tại Redis với key `cart_v2:{identifier}`.
3.  **Xử lý Serialization**: 
    - Lưu dưới dạng JSON thuần túy (Plain JSON).
    - Khi đọc lên, nếu là `LinkedHashMap`, hệ thống sử dụng `ObjectMapper.convertValue` để ánh xạ về `CartDTO` một cách an toàn.

---

## 3. Luồng Bảo mật & Chống Brute Force

Đảm bảo an toàn cho tài khoản người dùng thông qua Redis.

### Quy trình:
1.  **Theo dõi**: Mỗi lần login sai, tăng giá trị đếm tại `login:attempts:{username}` trong Redis.
2.  **Khóa (Lock)**: Nếu đếm đạt 5 lần, đặt TTL cho key là 30 phút.
3.  **Hành động**: 
    - Chặn mọi yêu cầu login tiếp theo trong thời gian khóa.
    - Gửi email cảnh báo bảo mật cho người dùng.
    - Hiển thị đồng hồ đếm ngược thời gian mở khóa trên giao diện.
