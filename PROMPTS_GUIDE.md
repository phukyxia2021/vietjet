# HƯỚNG DẪN DÙNG PROMPT CHO ANTIGRAVITY (PROMPTS_GUIDE.md)

Bạn có thể copy trực tiếp từng Prompt dưới đây dán vào cửa sổ chat của **Antigravity** để yêu cầu trợ lý xây dựng từng phần của website, hoặc dùng lệnh tổng thể để Antigravity tự động thực hiện toàn bộ.

---

## CÁCH 1: THỰC HIỆN TOÀN BỘ TỰ ĐỘNG BẰNG SLASH COMMAND

> Bạn gõ lệnh sau vào ô chat Antigravity:
```text
/goal Hãy đọc kỹ file PRD.md, DATABASE_SPEC.md và IMPLEMENTATION_PLAN.md trong thư mục dự án. Tiến hành xây dựng toàn bộ website Vietjet du lịch bằng HTML, CSS và JavaScript thuần, sử dụng SQLite qua sql.js, không sử dụng backend. Hoàn thành đầy đủ các trang index.html, flights.html, flight-detail.html, tours.html, tour-detail.html, cart.html và chức năng gửi email xác nhận. Đánh dấu hoàn thành các checkbox trong IMPLEMENTATION_PLAN.md khi hoàn tất từng phần.
```

---

## CÁCH 2: THỰC HIỆN TỪNG BƯỚC (STEP-BY-STEP PROMPTS)

### PROMPT 1: KHỞI TẠO CẤU TRÚC VÀ HỆ THỐNG THIẾT KẾ (DESIGN SYSTEM)
```text
Hãy bắt đầu Giai đoạn 1 của dự án Vietjet:
1. Tạo toàn bộ cấu trúc thư mục như mô tả trong IMPLEMENTATION_PLAN.md (assets/css, assets/js, assets/images/airlines).
2. Tạo file `assets/css/style.css` định nghĩa toàn bộ Design System:
   - Màu chủ đạo là đỏ Vietjet (#ee1d23), màu vàng (#f8c200), nền trắng sáng (#ffffff, #f8f9fa).
   - Thiết lập font chữ Be Vietnam Pro/Roboto, reset CSS, container, button, badge, card shadows.
   - Viết sẵn CSS cho Header/Navbar dùng chung (có hiển thị logo.jpg và giỏ hàng có số đếm badge) và Footer chuẩn.
3. Tạo file `assets/js/app.js` chứa các hàm tiện ích định dạng tiền tệ VND, render header và footer chung nếu cần.
```

---

### PROMPT 2: TÍCH HỢP SQLITE DATABASE (SQL.JS) & DỮ LIỆU MẪU
```text
Hãy thực hiện Giai đoạn 2 của dự án Vietjet:
1. Tạo file `assets/js/db.js` tích hợp WebAssembly SQLite qua thư viện `sql.js` (nạp từ CDN).
2. Tạo bảng cơ sở dữ liệu dựa theo file `DATABASE_SPEC.md` gồm các bảng: airlines, airports, flights, tours, cart_items, bookings, booking_details.
3. Chèn toàn bộ dữ liệu mẫu (Seed Data) từ `DATABASE_SPEC.md`:
   - 6 hãng hàng không (VietJet Air, Vietnam Airlines, Bamboo Airways, Singapore Airlines, AirAsia, Thai Airways).
   - Danh sách sân bay (SGN, HAN, DAD, PQC, CXR, SIN, BKK...).
   - 8 Tour du lịch nổi bật kèm ảnh thumbnail 600x400 và chi tiết lịch trình các ngày.
   - Hơn 15 chuyến bay phong phú giữa các thành phố.
4. Cài đặt cơ chế tự động đồng bộ (persist) dữ liệu vào localStorage để không bị mất khi tải lại trang.
5. Viết các hàm helper `VietjetDB.query()` và `VietjetDB.run()` để các trang web khác dễ dàng truy vấn.
```

---

### PROMPT 3: XÂY DỰNG TRANG CHỦ (`index.html`)
```text
Hãy thực hiện Giai đoạn 3 của dự án Vietjet:
1. Tạo trang `index.html` và file CSS tương ứng `assets/css/home.css`.
2. Giao diện nền trắng sáng, tông đỏ Vietjet (#ee1d23) sang trọng và chuyên nghiệp.
3. Xây dựng Khung Tìm Kiếm Chuyến Bay (Search Widget):
   - Chuyển đổi Khứ hồi / Một chiều.
   - Chọn điểm xuất phát, điểm đến, ngày đi, ngày về, số khách.
   - Nút "Tìm Kiếm" thu thập dữ liệu và chuyển sang `flights.html` với URL params.
4. Xây dựng Khu vực 8 Tour Du Lịch Nổi Bật:
   - Đọc dữ liệu từ SQLite `tours` table.
   - Thẻ hiển thị: Ảnh 600x400, hãng du lịch, số ngày/đêm, giá tour màu đỏ (#ee1d23).
   - Click vào tour chuyển đến `tour-detail.html?id=...`.
5. Xây dựng Khu vực Hãng Hàng Không Đối Tác:
   - Hiển thị logo các hãng: VietJet Air, Vietnam Airlines, Singapore Airlines, Bamboo Airways...
   - Click vào logo sẽ chuyển đến `flights.html?airline=...` để lọc chuyến bay của hãng đó.
```

---

### PROMPT 4: XÂY DỰNG TRANG CHUYẾN BAY & BỘ LỌC (`flights.html`)
```text
Hãy thực hiện Giai đoạn 4 của dự án Vietjet:
1. Tạo trang `flights.html` và `assets/css/flights.css`.
2. Bên trái: Bộ lọc (Filter Sidebar) đầy đủ các tiêu chí:
   - Sắp xếp giá vé tăng dần / giảm dần.
   - Loại vé: Khứ hồi / Một chiều.
   - Bay thẳng / Nhiều thành phố.
   - Checkbox các hãng hàng không.
   - Thời gian cất cánh theo các khung giờ (0h-6h, 6h-12h, 12h-18h, 18h-24h).
   - Hạng dịch vụ (Phổ thông, Thương gia).
3. Bên phải: Danh sách các chuyến bay truy vấn từ SQLite Database:
   - Lọc và hiển thị theo thời gian thực mỗi khi người dùng thay đổi filter bên trái.
   - Thẻ chuyến bay gồm: Hãng bay, số hiệu, ngày cất cánh, thời gian bay, giá tiền, dịch vụ đi kèm.
   - Click "Chọn chuyến bay" chuyển hướng sang `flight-detail.html?id=...`.
```

---

### PROMPT 5: XÂY DỰNG TRANG CHI TIẾT CHUYẾN BAY (`flight-detail.html`)
```text
Hãy thực hiện Giai đoạn 5 của dự án Vietjet:
1. Tạo trang `flight-detail.html` hiển thị chi tiết chuyến bay theo tham số `id` trên URL.
2. Hiển thị thông tin lộ trình: Điểm đi, điểm đến, thời gian bay, hãng bay, loại máy bay (Boeing 787-9, Airbus A321neo...).
3. Khu vực so sánh và lựa chọn 2 hạng vé rõ ràng:
   - Hạng Phổ Thông (Economy): Giá vé tiêu chuẩn, hành lý xách tay 7kg...
   - Hạng Thương Gia (Business): Giá vé cao cấp, hành lý ký gửi 30kg, phòng chờ VIP, ưu tiên làm thủ tục...
4. Khi khách hàng bấm chọn hạng vé:
   - Lưu chuyến bay kèm hạng vé vào bảng `cart_items` trong SQLite.
   - Hiển thị thông báo thành công và chuyển sang `cart.html`.
```

---

### PROMPT 6: XÂY DỰNG TRANG TOUR & CHI TIẾT TOUR (`tours.html` & `tour-detail.html`)
```text
Hãy thực hiện Giai đoạn 6 của dự án Vietjet:
1. Tạo trang `tours.html` và `assets/css/tours.css`:
   - Bên trái: Filter giá tăng/giảm dần, hãng hàng không liên kết, thời gian cất cánh.
   - Bên phải: Danh sách các tour du lịch, hãng bay, ngày cất cánh, thời gian bay, giá tiền, dịch vụ. Click chọn tour dẫn đến `tour-detail.html`.
2. Tạo trang `tour-detail.html`:
   - Hiển thị điểm đi, điểm đến, thời gian bay, hãng bay, loại máy bay (Boeing, Airbus...).
   - Hiển thị Lịch trình chuyến đi chi tiết theo từng ngày (Day 1, Day 2, Day 3...).
   - Nút "Chọn Tour" lưu vào bảng `cart_items` trong SQLite và chuyển đến `cart.html`.
```

---

### PROMPT 7: XÂY DỰNG TRANG GIỎ HÀNG, ĐĂNG KÝ & GỬI EMAIL (`cart.html`)
```text
Hãy thực hiện Giai đoạn 7 và 8 của dự án Vietjet:
1. Tạo trang `cart.html` và `assets/css/cart.css`.
2. Khu vực Giỏ hàng:
   - Hiển thị toàn bộ chuyến bay và tour đã chọn từ SQLite `cart_items`.
   - Có thể xóa từng mục hoặc nút Xóa toàn bộ giỏ hàng.
   - Tự động tính tổng tiền thanh toán (VND).
3. Khu vực Form Thông tin cá nhân:
   - Nhập Họ tên, Số điện thoại, Email nhận vé, Địa chỉ, Ghi chú.
4. Xử lý khi nhấn nút "Đăng Ký":
   - Validate form hợp lệ.
   - Tạo mã đơn hàng mới, lưu vào bảng `bookings` và `booking_details` trong SQLite, xóa giỏ hàng.
   - Hiển thị Modal/Popup thông báo đặt vé thành công chuyên nghiệp.
   - Kích hoạt gửi email xác nhận đặt chỗ từ `nvhai061993@gmail.com` đến địa chỉ email của khách hàng (dùng EmailJS hoặc mở giao diện mẫu Email xác nhận đầy đủ thông tin).
```
