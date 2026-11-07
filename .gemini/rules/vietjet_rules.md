# CÁC NGUYÊN TẮC PHÁT TRIỂN DỰ ÁN VIETJET (ANTIGRAVITY RULES)

Dự án này là website du lịch & vé máy bay **Vietjet**. Bất kỳ lúc nào trợ lý Antigravity làm việc trong workspace này, BẮT BUỘC phải tuân thủ các nguyên tắc sau:

## 1. NGUYÊN TẮC CÔNG NGHỆ (TECH STACK CONSTRAINTS)
- **Frontend thuần túy:** CHỈ dùng HTML5, CSS3 và JavaScript thuần (Vanilla ES6+). KHÔNG dùng React, Vue, Angular hay Tailwind build tool phức tạp.
- **Không có backend:** Tuyệt đối không cài đặt Node.js Express server, Python Flask/Django hay PHP. Dự án chạy hoàn toàn ở phía client (Static Web).
- **Cơ sở dữ liệu SQLite:** Sử dụng bản dựng WebAssembly chính thức của SQLite là `sql.js` (nạp qua CDN `https://cdnjs.cloudflare.com/ajax/libs/sql.js/1.8.0/sql-wasm.js`).
  - Mọi thao tác tìm kiếm, lọc, thêm giỏ hàng, đặt vé phải thông qua truy vấn SQL (`SELECT`, `INSERT`, `UPDATE`, `DELETE`).
  - Tự động lưu trữ binary array của SQLite database vào `localStorage` hoặc `IndexedDB` để duy trì dữ liệu khi F5 hoặc đổi trang.

## 2. NGUYÊN TẮC GIAO DIỆN & MÀU SẮC (DESIGN SYSTEM)
- **Tông màu nền:** Nền trắng sáng (`#ffffff`), các vùng phụ dùng xám nhạt thanh lịch (`#f8f9fa`, `#f1f3f5`).
- **Màu chủ đạo (Primary Color):** Màu đỏ Vietjet `#ee1d23` cho các nút bấm chính, giá vé, icon quan trọng, navbar accent.
- **Màu nhấn (Secondary/Accent):** Vàng `#f8c200`.
- **Kích thước ảnh Tour:** Bắt buộc tuân thủ tỉ lệ chuẩn **600x400** cho tất cả hình ảnh đại diện tour du lịch.
- **Tài nguyên hình ảnh có sẵn:** Dự án đã có sẵn các hình ảnh trong thư mục `images/`:
  - `images/logo.jpg`: Logo chính thức của Vietjet (dùng cho Header, Footer, Invoice).
  - `images/maybay.jpg`: Hình ảnh máy bay Vietjet (dùng cho Hero Banner trang chủ và chi tiết chuyến bay).
  - `images/tiepvien.jpg`: Hình ảnh tiếp viên hàng không Vietjet (dùng cho Hero Banner, dịch vụ khách hàng hoặc giới thiệu).

## 3. CÁC TRANG & CHỨC NĂNG BẮT BUỘC
1. **Trang Chủ (`index.html`):**
   - Bộ chọn ngày, tìm chuyến bay, điểm đi, điểm đến, toggle khứ hồi / một chiều. Click "Tìm Kiếm" -> `flights.html`.
   - 8 tour du lịch nổi bật: Ảnh 600x400, hãng du lịch, số ngày/đêm, giá tour đỏ `#ee1d23`. Click -> `tours.html` / `tour-detail.html`.
   - Phần các hãng bay: Hiện logo VietJet Air, Vietnam Airlines, Singapore Airlines, Bamboo Airways... Click logo -> `flights.html?airline=...`.
2. **Chuyến Bay (`flights.html`):**
   - Cột trái (Filter): Giá vé tăng/giảm dần, vé khứ hồi/một chiều, bay thẳng, nhiều thành phố, các hãng bay, khung giờ cất cánh, hạng vé (phổ thông/thương gia).
   - Cột phải: Danh sách chuyến bay (hãng, ngày, thời gian bay, giá, dịch vụ). Click chọn -> `flight-detail.html`.
3. **Chi Tiết Chuyến Bay (`flight-detail.html`):**
   - Điểm đi, điểm đến, thời gian bay, hãng bay, loại máy bay (Boeing, Airbus...).
   - Chọn giá vé: Hạng Phổ Thông vs Hạng Thương Gia.
   - Chọn chuyến bay -> Lưu vào Giỏ Hàng (`cart_items` trong SQLite).
4. **Tour (`tours.html`):**
   - Cột trái (Filter): Giá tăng/giảm dần, các hãng bay, thời gian cất cánh.
   - Cột phải: Danh sách tour, hãng bay, ngày cất cánh, thời gian bay, giá, dịch vụ. Click -> `tour-detail.html`.
5. **Chi Tiết Tour (`tour-detail.html`):**
   - Điểm đi, điểm đến, thời gian bay, hãng bay, loại máy bay (Boeing, Airbus...).
   - Lịch trình chuyến đi chi tiết theo ngày.
   - Chọn tour -> Lưu vào Giỏ Hàng.
6. **Giỏ Hàng & Đăng Ký (`cart.html`):**
   - Xem các chuyến bay & tour đã chọn. Xóa từng mục hoặc xóa toàn bộ giỏ hàng.
   - Nhập thông tin cá nhân.
   - Nút "Đăng ký" -> Hiển thị thông báo hoàn thành (Modal/Popup thành công).
   - Cơ chế gửi email từ `nvhai061993@gmail.com` đến email khách hàng (thông qua EmailJS hoặc mẫu email xác nhận chuyên nghiệp).
