# DỰ ÁN WEBSITE DU LỊCH & ĐẶT VÉ MÁY BAY VIETJET

Chào mừng bạn đến với dự án website du lịch **Vietjet**. Bộ tài liệu và quy chuẩn này được thiết kế chuyên biệt để bạn và trợ lý AI **Antigravity** phát triển toàn bộ website du lịch, đặt vé máy bay và tour trọn gói một cách mượt mà và chính xác nhất.

---

## 📂 DANH SÁCH CÁC FILE ĐẶC TẢ (.MD) DÀNH CHO ANTIGRAVITY

1. **[PRD.md](file:///d:/VibeCode_XiaPK1/VietJet/PRD.md)**
   - *Tài liệu Đặc tả Yêu cầu Sản phẩm (Product Requirements Document)*
   - Quy chuẩn nhận diện thương hiệu, bảng màu đỏ chủ đạo `#ee1d23`, nền trắng sáng.
   - Đặc tả chi tiết từng trang: Trang chủ (`index.html`), Chuyến bay (`flights.html`), Chi tiết chuyến bay (`flight-detail.html`), Tour (`tours.html`), Chi tiết Tour (`tour-detail.html`), Giỏ hàng & Thanh toán (`cart.html`).
   - Sơ đồ luồng dữ liệu (Data Flow) và yêu cầu phi chức năng.

2. **[DATABASE_SPEC.md](file:///d:/VibeCode_XiaPK1/VietJet/DATABASE_SPEC.md)**
   - *Đặc tả Cơ sở Dữ liệu SQLite Client-Side (sql.js / WebAssembly)*
   - Không cần backend: SQLite chạy trực tiếp trên trình duyệt, duy trì trạng thái bằng `localStorage`.
   - Lược đồ DDL tạo bảng: `airlines`, `airports`, `flights`, `tours`, `cart_items`, `bookings`, `booking_details`.
   - Dữ liệu mẫu (Seed Data): 6 hãng bay, danh sách sân bay, 8 tour du lịch nổi bật (ảnh 600x400) kèm lịch trình từng ngày, hơn 15 chuyến bay đa dạng.
   - Hướng dẫn module JavaScript truy xuất dữ liệu `assets/js/db.js`.

3. **[IMPLEMENTATION_PLAN.md](file:///d:/VibeCode_XiaPK1/VietJet/IMPLEMENTATION_PLAN.md)**
   - *Kế hoạch Triển khai Từng bước (Checklist & Milestones)*
   - Phân chia 8 giai đoạn từ thiết lập giao diện, tích hợp SQLite, xây dựng từng trang web đến giỏ hàng và email.
   - Các checkbox `[ ]` để theo dõi tiến độ công việc của Antigravity.

4. **[PROMPTS_GUIDE.md](file:///d:/VibeCode_XiaPK1/VietJet/PROMPTS_GUIDE.md)**
   - *Bộ Prompt mẫu ra lệnh cho Antigravity*
   - Cung cấp câu lệnh tổng thể với Slash Command `/goal`.
   - Cung cấp 7 prompt chi tiết theo từng bước để bạn dễ dàng điều phối Antigravity.

5. **[.gemini/rules/vietjet_rules.md](file:///d:/VibeCode_XiaPK1/VietJet/.gemini/rules/vietjet_rules.md)**
   - *Quy tắc ghi nhớ tự động cho Antigravity*
   - Tự động áp dụng ràng buộc công nghệ (HTML/CSS/JS thuần, không backend, SQLite qua `sql.js`, màu đỏ `#ee1d23`, gửi email từ `nvhai061993@gmail.com`).

---

## 🚀 CÁCH SỬ DỤNG VỚI ANTIGRAVITY

### Cách 1: Chạy tự động toàn bộ dự án
Gõ trực tiếp vào ô chat của Antigravity:
```text
/goal Dựa trên PRD.md, DATABASE_SPEC.md và IMPLEMENTATION_PLAN.md, hãy tiến hành code hoàn chỉnh toàn bộ website Vietjet du lịch (HTML, CSS, JS thuần, SQLite qua sql.js).
```

### Cách 2: Code từng trang theo ý muốn
Mở file **[PROMPTS_GUIDE.md](file:///d:/VibeCode_XiaPK1/VietJet/PROMPTS_GUIDE.md)**, copy prompt của trang bạn muốn làm (ví dụ: Prompt 3 cho Trang chủ, Prompt 4 cho Chuyến bay...) và gửi cho Antigravity.
