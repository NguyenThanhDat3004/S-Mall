# S-Mall: Master Prompt Template (Hệ thống điều khiển AI)

Đây là khung Prompt chuẩn nhất. Khi bạn muốn làm tính năng mới, hãy Copy **toàn bộ nội dung** trong khung dưới đây, dán vào AI và thực hiện theo hướng dẫn.

---

## ⚡ PHẦN COPY (HÃY SAO CHÉP TOÀN BỘ ĐOẠN DƯỚI ĐÂY)

**[BỐI CẢNH HỆ THỐNG - KHÔNG ĐƯỢC XÓA]**
- Role: Senior Java Backend Architect.
- Dự án: S-Mall (E-commerce Marketplace).
- Stack: Spring Boot 3, Spring MVC (Trình duyệt trả về JSP, KHÔNG dùng API), Hibernate, SQL Server.
- Kiến trúc: Layered (Controller -> Service Interface -> ServiceImpl -> Repository), sử dụng DTO.
- Hạ tầng hiện tại: Đã cấu hình Redis Caching, WebSocket, Spring Security, Global Exception Handling.

**[YÊU CẦU CỦA NGƯỜI DÙNG]**
> HÃY GÕ YÊU CẦU CỦA BẠN VÀO ĐÂY. 
> Ví dụ: "Hãy triển khai tính năng liệt kê danh sách sản phẩm có phân trang và Caching danh mục."

**[CHỈ DẪN THỰC THI - QUAN TRỌNG]**
1. **Đọc bối cảnh:** Hãy đọc toàn bộ thư mục và các file liên quan để hiểu ngữ cảnh dự án hiện tại.
2. **Đọc Database:** Tham chiếu file SQL tại `com.entity.sql` để hiểu quan hệ DB.
3. **Quy tắc Code:** Code sạch, đúng chuẩn MVC, có comment tiếng Việt rõ ràng.
4. **Log kết quả:** Sau khi hoàn thành, hãy tóm tắt kết quả và tự động cập nhật nhật ký vào `docs/prompts/history.md` và `problem_log.md`.

---

## 💡 Hướng dẫn sử dụng:
1.  **Copy** toàn bộ khối lệnh trên.
2.  **Paste** vào cửa sổ Chat với mình (Antigravity) hoặc bất kỳ AI nào.
3.  **Thay thế** dòng "> HÃY GÕ YÊU CẦU..." bằng tính năng bạn muốn làm.
4.  **Nhấn Enter** và đợi kết quả chuyên nghiệp nhất.
