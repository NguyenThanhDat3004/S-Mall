# S-Mall: Solved & Pending Log (Nhật ký Vấn đề)

Đây là nơi lưu lại toàn bộ các "trận chiến" bạn đã tham gia để hoàn thiện S-Mall:

## ✅ Đã giải quyết (Solved)
*   [X] **Kiến trúc Dự án (Core Structure)**: Xây dựng hệ thống Layered (Controller -> Service -> Repository).
*   [X] **Database (SQL Server)**: Hoàn thiện Schema cho 15+ Entity (Shop, ProductVariant, Order, ...).
*   [ ] **Fix cú pháp Java**: Khử toàn bộ SQL-style comments trong các file Entity.
*   [X] **Configuration**: Cấu hình xong Redis, WebSocket, Security (Spring MVC mode).
*   [X] **Git Clean-up**: Tối ưu `.gitignore` và untrack folder `target`.

*   [X] **AI Guardrails (Hàng rào bảo vệ AI)**: Thiết kế xong cơ chế chặn gợi ý vô lý (Score Threshold, Category Matrix).

## 🚧 Đang thực hiện (In Progress)
*   [X] **Feature 1: Product Homepage (Phase 1 - Frontend)**: Đã hoàn thành giao diện thanh danh mục (Expandable Grid) và khung lưới sản phẩm.
*   [/] **Feature 2: Hybrid Recommendation System**: Đang trong giai đoạn phân tích thuật toán và thiết kế sơ đồ luồng dữ liệu (Data Flow).
*   [/] **Feature 3: Advanced Catalog**: Đang xây dựng trang Danh mục sản phẩm dùng Redis Caching và Phân trang (Pagination).

*   [ ] **Feature 4: Order Flow**: Hệ thống Giỏ hàng và Đặt hàng.
*   [X] **Feature 5: Security & Login**: Đã hoàn thành Giao diện Login và bộ máy xác thực Spring Security (Case 1).

---
> [!TIP]
> Mỗi khi chuyển sang một Feature mới, hãy cập nhật trạng thái tại đây để luôn nắm bắt được tiến độ dự án.
