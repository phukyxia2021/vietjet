# KẾ HOẠCH TRIỂN KHAI DỰ ÁN VIETJET (IMPLEMENTATION_PLAN.md)

Tài liệu này đóng vai trò là lộ trình hướng dẫn chi tiết từng bước (Step-by-Step Execution Plan) để Antigravity xây dựng toàn bộ dự án website Vietjet.

---

## TỔNG QUAN CÁC GIAI ĐOẠN (ROADMAP OVERVIEW)

| Giai đoạn | Mô tả | Trạng thái |
| :--- | :--- | :---: |
| **Phase 1** | Cấu trúc thư mục & Thiết kế giao diện (CSS / Theme Red `#ee1d23`) | [x] Hoàn thành |
| **Phase 2** | Tích hợp SQLite qua `sql.js` (WebAssembly) & Nạp dữ liệu `db.db` | [x] Hoàn thành |
| **Phase 3** | Xây dựng Trang Chủ (`index.html`) | [x] Hoàn thành |
| **Phase 4** | Xây dựng Trang Tìm Kiếm & Lọc Chuyến Bay (`flights.html`) | [x] Hoàn thành |
| **Phase 5** | Xây dựng Trang Chi Tiết Chuyến Bay (`flight-detail.html`) | [x] Hoàn thành |
| **Phase 6** | Xây dựng Trang Danh Sách Tour (`tours.html`) & Chi Tiết Tour (`tour-detail.html`) | [x] Hoàn thành |
| **Phase 7** | Xây dựng Trang Giỏ Hàng & Đăng Ký Đặt Chỗ (`cart.html`) | [x] Hoàn thành |
| **Phase 8** | Tích hợp Gửi Email (`nvhai061993@gmail.com`) & Kiểm thử toàn diện | [x] Hoàn thành |

---

## CHI TIẾT TỪNG BƯỚC THỰC HIỆN

### PHASE 1: CẤU TRÚC THƯ MỤC & DESIGN SYSTEM
- [x] **1.1. Tạo cây thư mục dự án chuẩn:**
  ```text
  VietJet/
  ├── assets/
  │   ├── css/
  │   │   ├── style.css         # CSS dùng chung, reset, variables, typography
  │   │   ├── home.css          # CSS riêng trang chủ
  │   │   ├── flights.css       # CSS trang danh sách & chi tiết chuyến bay
  │   │   ├── tours.css         # CSS trang danh sách & chi tiết tour
  │   │   └── cart.css          # CSS giỏ hàng & form đặt chỗ
  │   ├── js/
  │   │   ├── db.js             # SQLite Database Manager (sql.js wrapper)
  │   │   ├── data-seed.js      # Câu lệnh SQL tạo bảng & chèn dữ liệu mẫu
  │   │   ├── cart.js           # Quản lý giỏ hàng, LocalStorage, tính tổng tiền
  │   │   ├── email-service.js  # Tích hợp gửi email qua EmailJS
  │   │   └── app.js            # Tiện ích chung, format VND, render navbar/footer
  ├── images/                   # Thư mục hình ảnh có sẵn
  │   ├── logo.jpg              # Logo Vietjet chính thức
  │   ├── maybay.jpg            # Ảnh máy bay Vietjet (Hero banner)
  │   └── tiepvien.jpg          # Ảnh tiếp viên hàng không Vietjet
  ├── index.html                # Trang chủ
  ├── flights.html              # Danh sách chuyến bay + Filter
  ├── flight-detail.html        # Chi tiết chuyến bay + Chọn hạng Eco / Business
  ├── tours.html                # Danh sách tour du lịch
  ├── tour-detail.html          # Chi tiết tour + Lịch trình
  └── cart.html                 # Giỏ hàng, thông tin khách hàng, xác nhận đặt chỗ
  ```
- [x] **1.2. Xây dựng CSS Variables & Typography trong `style.css`:**
  - Nền trắng tinh tế (`--bg-primary: #ffffff; --bg-secondary: #f8f9fa;`).
  - Màu thương hiệu Vietjet: `--primary-color: #ee1d23; --accent-yellow: #f8c200;`.
  - Nút bấm bo góc, hiệu ứng hover, thẻ card nổi khối (`box-shadow`).
  - Component Navbar dùng chung có badge số lượng giỏ hàng thời gian thực.
  - Component Footer chuẩn với thông tin chăm sóc khách hàng.

---

### PHASE 2: TÍCH HỢP SQLITE CLIENT-SIDE (`db.js` & `data-seed.js`)
- [x] **2.1. Nạp WebAssembly `sql.js` qua CDN:**
  - Tải `sql-wasm.js` và `sql-wasm.wasm`.
- [x] **2.2. Viết tầng kết nối `VietjetDB` trong `db.js`:**
  - `init()`: Tải WASM, kiểm tra lưu trữ `localStorage`, khôi phục DB nhị phân nếu đã có.
  - `createTables()`: Chạy DDL tạo các bảng `airlines`, `airports`, `flights`, `tours`, `cart_items`, `bookings`, `booking_details`.
  - `seedInitialData()`: Chèn 6 hãng hàng không, danh sách sân bay, 8 tour nổi bật (kèm ảnh 600x400) và hơn 15 chuyến bay mẫu.
  - `query(sql, params)`: Trả về mảng Object JS tiện dụng cho UI.
  - `run(sql, params)`: Thực thi DML và tự động `persist()` vào `localStorage`.
- [x] **2.3. Kiểm thử DB:** Gọi thử các hàm SQL qua console để đảm bảo dữ liệu truy xuất mượt mà.

---

### PHASE 3: XÂY DỰNG TRANG CHỦ (`index.html`)
- [x] **3.1. Header & Navigation:**
  - Logo Vietjet, menu liên kết các trang, nút xem giỏ hàng với counter động.
- [x] **3.2. Flight Search Widget (Khung tìm kiếm chuyến bay):**
  - Switch chuyển đổi: Khứ hồi vs Một chiều.
  - Dropdown chọn sân bay đi (HAN, SGN, DAD, PQC, SIN...) & sân bay đến.
  - Datepicker ngày đi và ngày về (tự động khóa ngày về nếu chọn Một chiều).
  - Nút "Tìm Kiếm" -> Thu thập tham số URL và điều hướng: `flights.html?from=SGN&to=HAN&date=2026-11-10&trip=roundtrip`.
- [x] **3.3. Section 8 Tour Du Lịch Nổi Bật:**
  - Query dữ liệu từ SQLite: `SELECT * FROM tours WHERE is_featured = 1 LIMIT 8`.
  - Hiển thị Grid 4x2 responsive: Ảnh 600x400, logo hãng liên kết, thời lượng (ví dụ 4N3Đ), giá tiền màu đỏ `#ee1d23`.
  - Nút "Xem Chi Tiết" -> Điều hướng `tour-detail.html?id=...`.
- [x] **3.4. Section Các Hãng Hàng Không Đối Tác:**
  - Logo VietJet Air, Vietnam Airlines, Singapore Airlines, Bamboo Airways, AirAsia, Thai Airways.
  - Click vào logo -> Chuyển đến `flights.html?airline=VJ` (hoặc VN, SQ).

---

### PHASE 4: XÂY DỰNG TRANG CHUYẾN BAY (`flights.html`)
- [x] **4.1. Thanh tóm tắt lộ trình tìm kiếm (Header Filter Summary).**
- [x] **4.2. Bộ lọc bên trái (Left Sidebar Filters):**
  - Radio/Select sắp xếp giá vé: Tăng dần (ASC) / Giảm dần (DESC).
  - Filter loại vé: Vé một chiều, vé khứ hồi.
  - Filter điểm dừng: Bay thẳng (is_direct = 1), nhiều điểm dừng.
  - Checkbox danh sách hãng hàng không (VietJet, Vietnam Airlines, Bamboo, Singapore Airlines...).
  - Filter khung giờ cất cánh: Sáng sớm (0h-6h), Buổi sáng (6h-12h), Buổi chiều (12h-18h), Buổi tối (18h-24h).
  - Filter hạng dịch vụ: Phổ thông, Thương gia.
- [x] **4.3. Danh sách chuyến bay bên phải (Right Flight Cards List):**
  - Dynamic SQL Generator: Tự động ghép nối mệnh đề `WHERE ... ORDER BY ...` dựa theo các filter người dùng tick chọn.
  - Card hiển thị: Logo hãng, số hiệu chuyến, giờ cất cánh - hạ cánh, thời lượng bay (2h 10m), loại máy bay, dịch vụ bao gồm, giá từ thấp nhất.
  - Nút "Chọn Chuyến Bay" -> Chuyển đến `flight-detail.html?id={id}`.

---

### PHASE 5: XÂY DỰNG TRANG CHI TIẾT CHUYẾN BAY (`flight-detail.html`)
- [x] **5.1. Hiển thị thông tin máy bay & lộ trình:**
  - Lấy `id` từ query parameter (`?id=...`) và chạy `SELECT * FROM flights WHERE id = ?`.
  - Hiển thị loại máy bay trực quan: **Boeing 787-9 Dreamliner**, **Airbus A321neo**, **Airbus A330-300**...
  - Sơ đồ chặng bay chi tiết (Sân bay xuất phát -> Sân bay hạ cánh).
- [x] **5.2. Khối so sánh và lựa chọn Hạng Vé:**
  - **Cột Hạng Phổ Thông (Eco):**
    - Giá vé cơ bản.
    - Hành lý xách tay 7kg tiêu chuẩn.
    - Suất ăn mua thêm.
    - Nút "Chọn Hạng Này".
  - **Cột Hạng Thương Gia (SkyBoss / Business):**
    - Giá vé cao cấp (hiển thị nổi bật với viền vàng/đỏ).
    - Hành lý xách tay 14kg + 30kg ký gửi.
    - Phòng chờ VIP sang trọng.
    - Ưu tiên làm thủ tục & xe riêng ra máy bay.
    - Suất ăn nóng miễn phí.
    - Nút "Chọn Hạng Này".
- [x] **5.3. Thêm vào Giỏ Hàng:**
  - Bấm chọn hạng -> Gọi hàm `CartService.addItem({ type: 'flight', id, class: 'economy' | 'business' })`.
  - Lưu vào bảng `cart_items` trong SQLite.
  - Hiển thị thông báo "Đã thêm chuyến bay vào giỏ hàng thành công!" và chuyển đến `cart.html`.

---

### PHASE 6: XÂY DỰNG TRANG TOUR (`tours.html` & `tour-detail.html`)
- [x] **6.1. Trang danh sách Tour (`tours.html`):**
  - Cột trái: Filter giá vé tăng/giảm dần, lọc theo hãng hàng không vận chuyển, lọc theo khung giờ cất cánh.
  - Cột phải: Danh sách thẻ tour với hình ảnh đại diện, hãng bay, lịch bay, giá tour, dịch vụ trọn gói đi kèm.
- [x] **6.2. Trang Chi Tiết Tour (`tour-detail.html`):**
  - Hiển thị: Điểm đi, điểm đến, thời gian bay, hãng bay đối tác, loại máy bay (Boeing, Airbus...).
  - **Lịch trình chuyến đi (Interactive Itinerary Timeline):** Accordion hoặc tab theo từng ngày (Ngày 1, Ngày 2, Ngày 3, Ngày 4...).
  - Danh sách quyền lợi bao gồm & không bao gồm.
  - Nút **"Chọn Tour / Đặt Tour"** -> Lưu tour vào SQLite `cart_items` -> Chuyển đến `cart.html`.

---

### PHASE 7: TRANG GIỎ HÀNG & ĐĂNG KÝ ĐẶT CHỖ (`cart.html`)
- [x] **7.1. Bảng danh sách dịch vụ trong giỏ hàng:**
  - Tải tất cả items từ bảng `cart_items` (kết hợp JOIN với bảng `flights` và `tours`).
  - Cho phép tăng giảm số lượng hành khách, nút xóa từng dịch vụ, nút "Xóa tất cả".
  - Tính toán tự động: Tiền vé/tour + Thuế VAT & Phí sân bay + Tổng cộng thanh toán.
  - Xử lý trạng thái khi giỏ hàng trống (hiển thị nút "Tìm chuyến bay ngay").
- [x] **7.2. Form thông tin khách hàng:**
  - Các trường: Họ và tên, Số điện thoại, Email nhận vé, Địa chỉ, Yêu cầu đặc biệt.
  - Kiểm tra tính hợp lệ dữ liệu (Validate form).
- [x] **7.3. Nút Đăng Ký & Xử lý đơn hàng:**
  - Click "ĐĂNG KÝ":
    1. Tạo mã đặt chỗ duy nhất (Ví dụ: `VJ-202611-9872`).
    2. Chèn dữ liệu vào bảng `bookings` và `booking_details`.
    3. Xóa dữ liệu bảng `cart_items`.
    4. Kích hoạt dịch vụ gửi email xác nhận.
    5. Hiển thị Modal Popup hoàn thành chúc mừng khách hàng.

---

### PHASE 8: TÍCH HỢP GỬI EMAIL & HOÀN THIỆN
- [x] **8.1. Dịch vụ gửi Email qua EmailJS Client SDK:**
  - Sử dụng cấu hình dịch vụ gửi từ `nvhai061993@gmail.com` gửi đến email của khách hàng.
  - Nội dung email gồm: Mã đặt vé, Danh sách chuyến bay/tour đã đăng ký, Họ tên khách, Tổng số tiền cần thanh toán.
  - Cơ chế dự phòng (Fallback): Nếu không có kết nối internet hoặc API key demo, tự động mở cửa sổ xem trước Email (Email Preview Modal) và lưu file xác nhận định dạng hóa đơn đẹp mắt.
- [x] **8.2. Kiểm thử luồng trải nghiệm người dùng (E2E User Flow):**
  - Luồng 1: Trang chủ -> Tìm chuyến bay SGN-HAN -> Lọc Vietnam Airlines -> Xem chi tiết chuyến -> Chọn Hạng Thương Gia -> Xem giỏ hàng -> Nhập form -> Đăng ký -> Nhận thông báo & email.
  - Luồng 2: Trang chủ -> Bấm 1 trong 8 Tour nổi bật -> Xem chi tiết lịch trình tour -> Chọn tour -> Đăng ký trong giỏ hàng.
  - Luồng 3: Trang chủ -> Bấm logo hãng hàng không (Singapore Airlines) -> Tự động lọc chuyến bay của hãng đó.
