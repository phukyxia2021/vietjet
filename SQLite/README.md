# THƯ MỤC CƠ SỞ DỮ LIỆU SQLITE (SQlite/)

Thư mục này chứa toàn bộ các file script SQL phục vụ việc khởi tạo, chèn dữ liệu mẫu và các câu lệnh truy vấn cho website **Vietjet**.

---

## 📁 CÁC FILE TRONG THƯ MỤC

| File | Nội dung & Mục đích |
| :--- | :--- |
| **[01_schema.sql](file:///d:/VibeCode_XiaPK1/VietJet/SQlite/01_schema.sql)** | DDL tạo các bảng: `airlines`, `airports`, `flights`, `tours`, `cart_items`, `bookings`, `booking_details` và các chỉ mục (indexes). |
| **[02_seed_data.sql](file:///d:/VibeCode_XiaPK1/VietJet/SQlite/02_seed_data.sql)** | DML chèn dữ liệu mẫu: 6 hãng hàng không, 8 sân bay, **8 tour du lịch nổi bật kèm ảnh tỉ lệ 600x400** và lịch trình từng ngày, danh sách các chuyến bay nội địa và quốc tế. |
| **[03_sample_queries.sql](file:///d:/VibeCode_XiaPK1/VietJet/SQlite/03_sample_queries.sql)** | Các câu lệnh `SELECT`, `INSERT`, `DELETE` mẫu dùng trực tiếp cho các trang: Bộ lọc chuyến bay, tour, giỏ hàng, đặt vé. |
| **[init_vietjet_db.sql](file:///d:/VibeCode_XiaPK1/VietJet/SQlite/init_vietjet_db.sql)** | **File tổng hợp (All-in-one)**: Chạy một lệnh duy nhất là tạo xong toàn bộ bảng và chèn dữ liệu mẫu hoàn chỉnh. |

---

## 🛠️ CÁCH SỬ DỤNG

### 1. Dùng với SQLite3 CLI (Dòng lệnh)
Để tạo một file database `vietjet.db` từ script:
```powershell
sqlite3 vietjet.db < SQlite/init_vietjet_db.sql
```

### 2. Dùng với DB Browser for SQLite
1. Mở phần mềm **DB Browser for SQLite**.
2. Chọn menu **File** -> **Execute SQL**.
3. Mở file `SQlite/init_vietjet_db.sql` và bấm nút **Execute (F5)**.

### 3. Dùng trong JavaScript thuần trên trình duyệt (`sql.js`)
Trong file JavaScript kết nối DB (`assets/js/db.js`):
```javascript
// Nạp nội dung init_vietjet_db.sql hoặc chạy trực tiếp các câu lệnh SQL
const db = new SQL.Database();
db.run(sqlString);
```
