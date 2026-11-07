# ĐẶC TẢ CƠ SỞ DỮ LIỆU SQLITE TRÊN TRÌNH DUYỆT (DATABASE_SPEC.md)

---

## 1. KIẾN TRÚC LƯU TRỮ (ARCHITECTURE)

Website Vietjet hoạt động theo mô hình **Client-Side Pure Single-Page / Multi-Page Static Web** không cần máy chủ backend (Node.js hay Python).

Để đáp ứng yêu cầu sử dụng **Cơ sở dữ liệu SQLite**, hệ thống tích hợp:
- **Thư viện:** [sql.js](https://sql.js.org/) (Bản dựng WebAssembly SQLite chính thức).
- **Cơ chế hoạt động:**
  1. Khi ứng dụng tải lần đầu, thư viện nạp `sql-wasm.wasm` và khởi tạo SQLite Database trong bộ nhớ RAM của trình duyệt.
  2. Bảng cơ sở dữ liệu và dữ liệu mẫu (8 Tour, các hãng bay, các chuyến bay) được nạp tự động bằng câu lệnh DDL / DML SQL.
  3. Mọi thao tác tìm kiếm, lọc (filter), thêm giỏ hàng, đặt vé đều thực hiện bằng câu lệnh **SQL chuẩn** (`SELECT`, `INSERT`, `UPDATE`, `DELETE`).
  4. Trạng thái database (như giỏ hàng, đơn hàng mới đặt) được đồng bộ bền vững vào `localStorage` (hoặc `IndexedDB`) dưới dạng chuỗi binary (Uint8Array), giúp dữ liệu không bị mất khi F5 hoặc chuyển trang.

CDN sử dụng:
```html
<script src="https://cdnjs.cloudflare.com/ajax/libs/sql.js/1.8.0/sql-wasm.js"></script>
```

---

## 2. LƯỢC ĐỒ DỮ LIỆU (DATABASE SCHEMA - DDL)

```sql
-- 1. Bảng Hãng Hàng Không (airlines)
CREATE TABLE IF NOT EXISTS airlines (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT NOT NULL UNIQUE,          -- VJ, VN, QH, SQ...
    name TEXT NOT NULL,                 -- VietJet Air, Vietnam Airlines...
    logo TEXT NOT NULL,                 -- Đường dẫn ảnh hoặc SVG logo
    hotline TEXT,
    description TEXT
);

-- 2. Bảng Sân Bay / Thành Phố (airports)
CREATE TABLE IF NOT EXISTS airports (
    code TEXT PRIMARY KEY,              -- SGN, HAN, DAD, PQC, SIN, BKK...
    city_name TEXT NOT NULL,            -- TP. Hồ Chí Minh, Hà Nội, Đà Nẵng...
    airport_name TEXT NOT NULL,         -- Tân Sơn Nhất, Nội Bài...
    country TEXT NOT NULL DEFAULT 'Việt Nam'
);

-- 3. Bảng Chuyến Bay (flights)
CREATE TABLE IF NOT EXISTS flights (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    airline_id INTEGER NOT NULL,
    flight_number TEXT NOT NULL,        -- VJ-124, VN-210, SQ-178...
    origin_code TEXT NOT NULL,          -- SGN, HAN...
    destination_code TEXT NOT NULL,     -- HAN, DAD...
    departure_time TEXT NOT NULL,       -- Ví dụ: '06:30' hoặc ISO datetime
    arrival_time TEXT NOT NULL,         -- Ví dụ: '08:40'
    duration_minutes INTEGER NOT NULL,  -- Ví dụ: 130 phút (2h 10m)
    aircraft_type TEXT NOT NULL,        -- Airbus A321neo, Boeing 787-9...
    price_economy INTEGER NOT NULL,     -- Giá hạng Phổ Thông (VND)
    price_business INTEGER NOT NULL,    -- Giá hạng Thương Gia (VND)
    is_direct INTEGER DEFAULT 1,        -- 1: Bay thẳng, 0: Quá cảnh
    stops_count INTEGER DEFAULT 0,      -- Số điểm dừng (0: bay thẳng)
    services_included TEXT,             -- JSON string hoặc text: 'Hành lý xách tay 7kg, Nước uống'
    FOREIGN KEY (airline_id) REFERENCES airlines(id),
    FOREIGN KEY (origin_code) REFERENCES airports(code),
    FOREIGN KEY (destination_code) REFERENCES airports(code)
);

-- 4. Bảng Tour Du Lịch (tours)
CREATE TABLE IF NOT EXISTS tours (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    airline_id INTEGER NOT NULL,
    departure_city TEXT NOT NULL,       -- Hà Nội, TP.HCM...
    destination_city TEXT NOT NULL,     -- Đà Nẵng, Phú Quốc, Singapore...
    duration_days INTEGER NOT NULL,     -- Số ngày (ví dụ: 4)
    duration_nights INTEGER NOT NULL,   -- Số đêm (ví dụ: 3)
    departure_time TEXT NOT NULL,       -- Giờ cất cánh (ví dụ: '07:15')
    aircraft_type TEXT NOT NULL,        -- Airbus A321, Boeing 737...
    price INTEGER NOT NULL,             -- Giá tour trọn gói (VND)
    thumbnail TEXT NOT NULL,            -- URL ảnh thumbnail 600x400
    is_featured INTEGER DEFAULT 1,      -- 1: Nổi bật ở trang chủ (8 tours)
    services TEXT,                      -- Vé khứ hồi, Khách sạn 4 sao, Xe đưa đón, Ăn uống...
    description TEXT,
    itinerary_json TEXT,                -- Lịch trình JSON các ngày (Day 1, Day 2...)
    FOREIGN KEY (airline_id) REFERENCES airlines(id)
);

-- 5. Bảng Giỏ Hàng (cart_items)
CREATE TABLE IF NOT EXISTS cart_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    item_type TEXT NOT NULL,            -- 'flight' hoặc 'tour'
    reference_id INTEGER NOT NULL,      -- flight_id hoặc tour_id
    ticket_class TEXT DEFAULT 'economy',-- 'economy' hoặc 'business' (chỉ dùng cho flight)
    quantity INTEGER DEFAULT 1,
    unit_price INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 6. Bảng Đơn Đặt Hàng / Đăng Ký (bookings)
CREATE TABLE IF NOT EXISTS bookings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    booking_code TEXT NOT NULL UNIQUE,  -- VJ-20261107-XXXX
    customer_name TEXT NOT NULL,
    customer_email TEXT NOT NULL,
    customer_phone TEXT NOT NULL,
    customer_address TEXT,
    notes TEXT,
    total_amount INTEGER NOT NULL,
    status TEXT DEFAULT 'CONFIRMED',    -- 'PENDING', 'CONFIRMED', 'CANCELLED'
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 7. Bảng Chi Tiết Đơn Hàng (booking_details)
CREATE TABLE IF NOT EXISTS booking_details (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    booking_id INTEGER NOT NULL,
    item_type TEXT NOT NULL,
    reference_id INTEGER NOT NULL,
    item_name TEXT NOT NULL,
    ticket_class TEXT,
    quantity INTEGER NOT NULL,
    unit_price INTEGER NOT NULL,
    subtotal INTEGER NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(id)
);
```

---

## 3. DỮ LIỆU KHỞI TẠO MẪU (SEED DATA - DML)

### 3.1. Danh Sách Hãng Hàng Không
```sql
INSERT INTO airlines (id, code, name, logo, hotline, description) VALUES
(1, 'VJ', 'VietJet Air', 'assets/images/airlines/vietjet.png', '1900 1886', 'Hãng hàng không thế hệ mới - Bay là thích ngay!'),
(2, 'VN', 'Vietnam Airlines', 'assets/images/airlines/vietnam-airlines.png', '1900 1100', 'Hãng hàng không Quốc gia Việt Nam - Tiêu chuẩn 4 sao'),
(3, 'QH', 'Bamboo Airways', 'assets/images/airlines/bamboo.png', '1900 1166', 'Hơn cả một chuyến bay - Dịch vụ tận tâm'),
(4, 'SQ', 'Singapore Airlines', 'assets/images/airlines/singapore.png', '+65 6223 8888', 'Hãng hàng không 5 sao hàng đầu thế giới'),
(5, 'AK', 'AirAsia', 'assets/images/airlines/airasia.png', '+60 3 2176 5888', 'Now Everyone Can Fly'),
(6, 'TG', 'Thai Airways', 'assets/images/airlines/thai-airways.png', '+66 2 356 1111', 'Smooth as silk');
```

### 3.2. Danh Sách Sân Bay
```sql
INSERT INTO airports (code, city_name, airport_name, country) VALUES
('SGN', 'TP. Hồ Chí Minh', 'Sân bay Tân Sơn Nhất', 'Việt Nam'),
('HAN', 'Hà Nội', 'Sân bay Quốc tế Nội Bài', 'Việt Nam'),
('DAD', 'Đà Nẵng', 'Sân bay Quốc tế Đà Nẵng', 'Việt Nam'),
('PQC', 'Phú Quốc', 'Sân bay Quốc tế Phú Quốc', 'Việt Nam'),
('CXR', 'Nha Trang (Cam Ranh)', 'Sân bay Cam Ranh', 'Việt Nam'),
('VDO', 'Vân Đồn (Quảng Ninh)', 'Sân bay Quốc tế Vân Đồn', 'Việt Nam'),
('SIN', 'Singapore', 'Sân bay Quốc tế Changi', 'Singapore'),
('BKK', 'Bangkok', 'Sân bay Suvarnabhumi', 'Thái Lan');
```

### 3.3. Dữ Liệu 8 Tour Du Lịch Nổi Bật (Thumbnail 600x400)
```sql
INSERT INTO tours (id, title, airline_id, departure_city, destination_city, duration_days, duration_nights, departure_time, aircraft_type, price, thumbnail, is_featured, services, description, itinerary_json) VALUES
(1, 'Tour Khám Phá Đà Nẵng - Bà Nà Hills - Cầu Vàng - Phố Cổ Hội An', 1, 'Hà Nội', 'Đà Nẵng', 4, 3, '06:45', 'Airbus A321neo', 4890000, 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?w=600&h=400&fit=crop', 1, 'Vé bay khứ hồi VietJet, Khách sạn 4 sao biển Mỹ Khê, Buffet Bà Nà', 'Khám phá thiên đường nghỉ dưỡng miền Trung với vẻ đẹp hiện đại của Đà Nẵng và hoài niệm cổ kính của Hội An.', '[{"day":1,"title":"Hà Nội - Đà Nẵng - Bán Đảo Sơn Trà - Biển Mỹ Khê","desc":"Xe đón quý khách tại Nội Bài đáp chuyến bay VJ-501 cất cánh 06:45. Đến Đà Nẵng, viếng Chùa Linh Ứng, ngắm toàn cảnh biển Mỹ Khê."},{"day":2,"title":"Khám phá Sun World Bà Nà Hills - Cầu Vàng nổi tiếng","desc":"Đi cáp treo đạt nhiều kỷ lục thế giới, check-in Cầu Vàng bàn tay khổng lồ, vui chơi Fantasy Park, thưởng thức buffet trưa thịnh soạn."},{"day":3,"title":"Ngũ Hành Sơn - Làng đá Non Nước - Phố cổ Hội An","desc":"Tham quan phố cổ lung linh đèn lồng, Chùa Cầu, hội quán Phúc Kiến, thưởng thức cao lầu và thuyền hoa đăng trên sông Hoài."},{"day":4,"title":"Chợ Hàn Đà Nẵng - Tạm biệt Đà Nẵng về Hà Nội","desc":"Mua sắm đặc sản miền Trung tại chợ Hàn, xe tiễn sân bay Đà Nẵng đáp chuyến bay về lại Hà Nội."}]'),

(2, 'Thiên Đường Đảo Ngọc Phú Quốc - Grand World - Sunset Sanato - Cáp Treo Hòn Thơm', 1, 'TP. Hồ Chí Minh', 'Phú Quốc', 3, 2, '07:30', 'Airbus A321', 3990000, 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=600&h=400&fit=crop', 1, 'Vé bay khứ hồi VietJet, Resort 5 sao có bãi biển riêng, Vé cáp treo Hòn Thơm', 'Kỳ nghỉ thư thái tại đảo ngọc Phú Quốc với làn nước ngọc bích, hoàng hôn rực rỡ và thành phố không ngủ Grand World.', '[{"day":1,"title":"TP.HCM - Phú Quốc - Grand World Thành Phố Không Ngủ","desc":"Đáp chuyến bay VJ-321 đến Phú Quốc lúc 08:30. Khám phá bảo tàng Gấu Teddy, show Tinh Hoa Việt Nam rực rỡ."},{"day":2,"title":"Tour 4 Đảo Cano Siêu Tốc - Lặn Ngắm San Hô - Cáp Treo Hòn Thơm","desc":"Lên cano lướt sóng qua Hòn Móng Tay, Hòn Gầm Ghì lặn ngắm san hô tự nhiên, trải nghiệm cáp treo 3 dây vượt biển dài nhất thế giới."},{"day":3,"title":"Chợ Dương Đông - Cơ sở Ngọc Trai - TP.HCM","desc":"Mua sắm hải sản khô, ngọc trai Phú Quốc làm quà. Xe tiễn sân bay Phú Quốc về lại TP.HCM."}]'),

(3, 'Nha Trang Biển Xanh - VinWonders - Du Thuyền Vịnh Nha Trang Sang Trọng', 2, 'Hà Nội', 'Nha Trang', 4, 3, '08:15', 'Boeing 787-9', 5450000, 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=600&h=400&fit=crop', 1, 'Vé bay Vietnam Airlines, Khách sạn 5 sao mặt biển Trần Phú, Vé trọn gói VinWonders', 'Trải nghiệm du thuyền ngắm vịnh Nha Trang - 1 trong 29 vịnh đẹp nhất thế giới, thỏa sức vui chơi tại công viên giải trí đẳng cấp.', '[{"day":1,"title":"Hà Nội - Cam Ranh - Tháp Bà Ponagar - Tắm bùn khoáng I-Resort","desc":"Cất cánh cùng Vietnam Airlines sang trọng. Đến nơi tham quan quần thể tháp Chăm cổ kính và thư giãn ngâm bùn khoáng nóng."},{"day":2,"title":"Trọn ngày khám phá Đảo Hòn Tre & Công Viên Giải Trí VinWonders","desc":"Thử thách tàu lượn siêu tốc, đu quay lộn đầu, thủy cung hiện đại bậc nhất và show diễn triệu đô Tata Show."},{"day":3,"title":"Du thuyền ngắm vịnh biển - Lặn biển ngắm rạn san hô Bãi Tranh","desc":"Tiệc BBQ hải sản trên du thuyền, chèo SUP trên biển xanh trong vắt."},{"day":4,"title":"Chùa Long Sơn - Nhà Yến Nha Trang - Hà Nội","desc":"Chiêm bái tượng Phật Trắng khổng lồ, mua yến sào thiên nhiên Khánh Hòa, về lại Hà Nội."}]'),

(4, 'Sapa Thị Trấn Trong Mây - Đỉnh Fansipan Nóc Nhà Đông Dương - Bản Cát Cát', 1, 'TP. Hồ Chí Minh', 'Hà Nội', 4, 3, '06:00', 'Airbus A321neo', 4690000, 'https://images.unsplash.com/photo-1528127269322-539801943592?w=600&h=400&fit=crop', 1, 'Vé bay khứ hồi VietJet SGN-HAN, Xe Limousine khứ hồi Hà Nội - Sapa, Khách sạn 4 sao', 'Chinh phục nóc nhà Đông Dương Fansipan huyền thoại, săn biển mây trắng bồng bềnh và tìm hiểu văn hóa đồng bào H\'Mông.', '[{"day":1,"title":"TP.HCM - Hà Nội - Di chuyển cao tốc Hà Nội - Lào Cai - Sapa","desc":"Bay sớm chuyến VJ-160 ra Hà Nội, xe limousine cao cấp đón thẳng lên Sapa mộng mơ."},{"day":2,"title":"Chinh phục Nóc Nhà Đông Dương Fansipan hùng vĩ","desc":"Cáp treo Fansipan vượt thung lũng Mường Hoa, bách bộ lên cột mốc 3.143m linh thiêng."},{"day":3,"title":"Bản Cát Cát mộc mạc - Đèo Ô Quy Hồ - Cầu Kính Rồng Mây","desc":"Check-in ruộng bậc thang, thác nước Tiên Sa, ngắm hoàng hôn rực lửa trên đỉnh Ô Quy Hồ đệ nhất tứ đại đỉnh đèo."},{"day":4,"title":"Nhà thờ đá Sapa - Tạm biệt Tây Bắc về lại TP.HCM","desc":"Mua sắm thổ cẩm, thịt trâu gác bếp tại chợ Sapa, khởi hành về sân bay Nội Bài đáp chuyến bay đêm về TP.HCM."}]'),

(5, 'Tour Singapore Quốc Đảo Sư Tử - Gardens by the Bay - Đảo Sentosa', 4, 'Hà Nội', 'Singapore', 4, 3, '09:00', 'Boeing 787-9', 11990000, 'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?w=600&h=400&fit=crop', 1, 'Vé bay Singapore Airlines 5 sao, Khách sạn 4 sao trung tâm Orchard, Vé Flower Dome & Cloud Forest', 'Khám phá thành phố xanh sạch nhất hành tinh với kỳ quan siêu cây, thác nước trong nhà và thiên đường mua sắm sầm uất.', '[{"day":1,"title":"Hà Nội - Singapore Changi - Thác nước Jewel Changi - Công viên Sư Tử Merlion","desc":"Trải nghiệm dịch vụ đẳng cấp thế giới của Singapore Airlines, check-in thác nước nhân tạo cao nhất thế giới tại Jewel Changi."},{"day":2,"title":"Gardens by the Bay - Siêu cây Supertree Grove - Marina Bay Sands","desc":"Chiêm ngưỡng thảm thực vật kỳ vĩ tại Flower Dome và thác nước khổng lồ tại Cloud Forest."},{"day":3,"title":"Đảo Sentosa - Universal Studios - Nhạc nước Wings of Time","desc":"Thỏa sức chụp ảnh bên quả cầu xoay Universal, xem trình diễn pháo hoa và nhạc nước 3D mapping sống động."},{"day":4,"title":"Chùa Răng Phật Chinatown - Phố mua sắm Orchard - Hà Nội","desc":"Khám phá văn hóa ẩm thực Trung Hoa tại Chinatown, shopping hàng hiệu miễn thuế, đáp chuyến bay về Nội Bài."}]'),

(6, 'Bangkok - Pattaya Xứ Sở Nụ Cười - Đảo San Hô Coral - Chùa Phật Vàng', 1, 'TP. Hồ Chí Minh', 'Bangkok', 5, 4, '11:15', 'Airbus A321', 6590000, 'https://images.unsplash.com/photo-1508009603885-50cf7c579365?w=600&h=400&fit=crop', 1, 'Vé bay khứ hồi VietJet, Khách sạn 4 sao tiêu chuẩn Thái Lan, Buffet Baiyoke Sky 86 tầng', 'Thiên đường du lịch Thái Lan với biển đảo sôi động Pattaya, chùa vàng linh thiêng và thiên đường ẩm thực đường phố Bangkok.', '[{"day":1,"title":"TP.HCM - Bangkok Suvarnabhumi - Khởi hành đi thành phố biển Pattaya","desc":"Chuyến bay VietJet VJ-801 sang Bangkok, xe đưa đoàn về thành phố biển Pattaya náo nhiệt."},{"day":2,"title":"Đảo san hô Koh Larn - Trân Bảo Phật Sơn Khao Chee Chan","desc":"Đi cano ra đảo san hô tắm biển trong xanh, viếng tượng Phật Thích Ca dát vàng 9999 trên vách núi."},{"day":3,"title":"Vườn thực vật Nong Nooch - Chợ Nổi 4 Miền - Bangkok","desc":"Xem xiếc voi và múa võ cổ truyền Thái, thưởng thức buffet trái cây nhiệt đới, trở về thủ đô Bangkok."},{"day":4,"title":"Dạo thuyền sông Chaophraya - Chùa Thuyền Wat Yannawa - Iconsiam","desc":"Ngắm hiện tượng cá nổi trên sông linh thiêng, mua sắm thả ga tại siêu trung tâm thương mại Iconsiam lớn nhất Đông Nam Á."},{"day":5,"title":"Chùa Phật Vàng Wat Traimit - TP.HCM","desc":"Chiêm bái tượng Phật bằng vàng nguyên khối nặng 5.5 tấn, xe đưa đoàn ra sân bay về lại Sài Gòn."}]'),

(7, 'Quy Nhơn Kỳ Co - Eo Gió Nơi Ngắm Hoàng Hôn Đẹp Nhất Việt Nam', 3, 'Hà Nội', 'Quy Nhơn', 3, 2, '07:00', 'Airbus A320', 3790000, 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600&h=400&fit=crop', 1, 'Vé Bamboo Airways, Resort FLC Quy Nhơn 5 sao, Hải sản tươi sống lặn ngắm san hô', 'Vẻ đẹp hoang sơ quyến rũ tựa Maldives của Kỳ Co cùng cung đường đi bộ ven biển ngoạn mục tại Eo Gió.', '[{"day":1,"title":"Hà Nội - Phù Cát - Tháp Đôi Chăm Pa - Ghềnh Ráng Tiên Sa","desc":"Thăm mộ thi sĩ Hàn Mặc Tử, bãi tắm Hoàng Hậu đá trứng độc đáo, ngắm toàn cảnh thành phố Quy Nhơn."},{"day":2,"title":"Cano Siêu Tốc đảo Kỳ Co - Eo Gió - Tịnh Xá Ngọc Hòa","desc":"Check-in cây cầu tình yêu Kỳ Co, lặn ngắm rạn san hô Bãi Dứa rực rỡ, chiêm ngưỡng tượng Phật đôi cao nhất Việt Nam."},{"day":3,"title":"Đồi cát Phương Mai - Mua sắm đặc sản bánh ít lá gai - Hà Nội","desc":"Trải nghiệm trượt cát Phương Mai, mua nem Chợ Huyện làm quà, đáp chuyến bay Bamboo về lại Hà Nội."}]'),

(8, 'Di Sản Miền Trung: Huế Mộng Mơ - Đại Nội Kinh Thành - Lăng Cô - Hội An', 2, 'TP. Hồ Chí Minh', 'Huế', 4, 3, '08:30', 'Airbus A321', 4950000, 'https://images.unsplash.com/photo-1570168007204-dfb528c6958f?w=600&h=400&fit=crop', 1, 'Vé Vietnam Airlines, Khách sạn 4 sao bên bờ sông Hương, Du thuyền nghe ca Huế', 'Tìm về nguồn cội lịch sử với quần thể di tích Cố đô Huế trầm mặc, thưởng thức ẩm thực cung đình tao nhã.', '[{"day":1,"title":"TP.HCM - Sân bay Phú Bài - Đại Nội Kinh Thành Huế","desc":"Đáp chuyến bay VN-1370 đến Huế mộng mơ. Tham quan Ngọ Môn, Điện Thái Hòa, Tử Cấm Thành uy nghiêm."},{"day":2,"title":"Chùa Thiên Mụ - Lăng Khải Định - Ca Huế trên sông Hương","desc":"Viếng ngôi chùa cổ bên dòng sông Hương thơ mộng, chiêm ngưỡng kiến trúc khảm sành sứ lăng Khải Định, thả đèn hoa đăng ban đêm."},{"day":3,"title":"Vịnh Lăng Cô - Đèo Hải Vân - Đà Nẵng - Phố cổ Hội An","desc":"Chinh phục 'Thiên hạ đệ nhất hùng quan' Hải Vân, ngắm vịnh biển Lăng Cô xanh ngắt, dạo phố cổ lung linh về đêm."},{"day":4,"title":"Chợ Đông Ba Huế - Trở về TP.HCM","desc":"Thưởng thức bún bò Huế chuẩn vị, mua kẹo mè xửng, nón bài thơ làm quà kỷ niệm, xe tiễn sân bay về lại Sài Gòn."}]');
```

### 3.4. Dữ Liệu Chuyến Bay (Flights Seed Data)
```sql
INSERT INTO flights (airline_id, flight_number, origin_code, destination_code, departure_time, arrival_time, duration_minutes, aircraft_type, price_economy, price_business, is_direct, stops_count, services_included) VALUES
-- SGN -> HAN
(1, 'VJ-120', 'SGN', 'HAN', '05:45', '07:55', 130, 'Airbus A321neo', 1250000, 2850000, 1, 0, 'Hành lý xách tay 7kg'),
(1, 'VJ-124', 'SGN', 'HAN', '08:30', '10:40', 130, 'Airbus A321', 1450000, 3100000, 1, 0, 'Hành lý xách tay 7kg'),
(1, 'VJ-132', 'SGN', 'HAN', '14:15', '16:25', 130, 'Airbus A321neo', 1350000, 2990000, 1, 0, 'Hành lý xách tay 7kg'),
(1, 'VJ-150', 'SGN', 'HAN', '19:40', '21:50', 130, 'Airbus A330-300', 1190000, 2750000, 1, 0, 'Hành lý xách tay 7kg, Thân rộng'),
(2, 'VN-210', 'SGN', 'HAN', '07:00', '09:10', 130, 'Boeing 787-9', 2150000, 4850000, 1, 0, 'Suất ăn nhẹ, Hành lý ký gửi 23kg'),
(2, 'VN-216', 'SGN', 'HAN', '11:00', '13:10', 130, 'Airbus A350-900', 2350000, 5200000, 1, 0, 'Suất ăn nóng, Giải trí màn hình riêng'),
(2, 'VN-222', 'SGN', 'HAN', '17:30', '19:40', 130, 'Boeing 787-9', 2250000, 4990000, 1, 0, 'Hành lý 23kg + xách tay 12kg'),
(3, 'QH-202', 'SGN', 'HAN', '09:15', '11:25', 130, 'Boeing 787-9', 1750000, 3950000, 1, 0, 'Suất ăn nhẹ, Nước suối'),
(3, 'QH-208', 'SGN', 'HAN', '16:00', '18:10', 130, 'Airbus A320', 1650000, 3750000, 1, 0, 'Hành lý 20kg ký gửi'),

-- HAN -> SGN
(1, 'VJ-121', 'HAN', 'SGN', '06:30', '08:40', 130, 'Airbus A321', 1250000, 2850000, 1, 0, 'Hành lý xách tay 7kg'),
(1, 'VJ-135', 'HAN', 'SGN', '13:00', '15:10', 130, 'Airbus A330-300', 1350000, 2990000, 1, 0, 'Hành lý xách tay 7kg'),
(2, 'VN-211', 'HAN', 'SGN', '09:00', '11:10', 130, 'Airbus A350-900', 2150000, 4850000, 1, 0, 'Suất ăn nóng, Màn hình cá nhân'),

-- SGN -> DAD
(1, 'VJ-622', 'SGN', 'DAD', '07:15', '08:35', 80, 'Airbus A320', 890000, 1950000, 1, 0, 'Hành lý xách tay 7kg'),
(1, 'VJ-628', 'SGN', 'DAD', '15:30', '16:50', 80, 'Airbus A321', 990000, 2150000, 1, 0, 'Hành lý xách tay 7kg'),
(2, 'VN-118', 'SGN', 'DAD', '10:00', '11:20', 80, 'Airbus A321', 1450000, 3200000, 1, 0, 'Hành lý 23kg, Nước uống'),

-- HAN -> DAD
(1, 'VJ-501', 'HAN', 'DAD', '06:45', '08:05', 80, 'Airbus A321neo', 850000, 1890000, 1, 0, 'Hành lý xách tay 7kg'),
(2, 'VN-163', 'HAN', 'DAD', '13:30', '14:50', 80, 'Airbus A321', 1350000, 2990000, 1, 0, 'Hành lý 23kg ký gửi'),

-- SGN -> SIN
(4, 'SQ-178', 'SGN', 'SIN', '12:15', '15:20', 125, 'Boeing 787-10', 3650000, 8900000, 1, 0, 'Dịch vụ 5 sao, Bữa ăn quốc tế, Rượu vang'),
(1, 'VJ-813', 'SGN', 'SIN', '08:55', '12:00', 125, 'Airbus A321', 1750000, 3950000, 1, 0, 'Hành lý xách tay 7kg'),

-- SGN -> BKK
(1, 'VJ-801', 'SGN', 'BKK', '11:15', '12:45', 90, 'Airbus A321', 1490000, 3450000, 1, 0, 'Hành lý xách tay 7kg'),
(6, 'TG-551', 'SGN', 'BKK', '10:05', '11:35', 90, 'Boeing 777-300ER', 2850000, 6200000, 1, 0, 'Suất ăn Thái Lan, Hành lý 30kg');
```

---

## 4. TẦNG TRUY XUẤT DỮ LIỆU JAVASCRIPT (`assets/js/db.js`)

Mô-đun `db.js` cung cấp API hướng đối tượng, dễ gọi từ giao diện:

```javascript
/**
 * Vietjet SQLite Client Database Manager
 * Quản lý khởi tạo SQLite WASM và các câu lệnh truy vấn
 */
const VietjetDB = {
  db: null,
  STORAGE_KEY: 'vietjet_sqlite_db_v1',

  async init() {
    if (this.db) return this.db;
    
    const config = {
      locateFile: file => `https://cdnjs.cloudflare.com/ajax/libs/sql.js/1.8.0/${file}`
    };
    const SQL = await initSqlJs(config);

    // Kiểm tra xem đã có dữ liệu lưu trong localStorage chưa
    const savedData = localStorage.getItem(this.STORAGE_KEY);
    if (savedData) {
      const uInt8Array = new Uint8Array(JSON.parse(savedData));
      this.db = new SQL.Database(uInt8Array);
    } else {
      this.db = new SQL.Database();
      this.createTables();
      this.seedInitialData();
      this.persist();
    }
    return this.db;
  },

  // Thực thi câu lệnh SQL trả về danh sách đối tượng JSON
  query(sql, params = []) {
    const stmt = this.db.prepare(sql);
    stmt.bind(params);
    const results = [];
    while (stmt.step()) {
      results.push(stmt.getAsObject());
    }
    stmt.free();
    return results;
  },

  // Thực thi câu lệnh INSERT / UPDATE / DELETE và tự động lưu vào localStorage
  run(sql, params = []) {
    this.db.run(sql, params);
    this.persist();
  },

  // Lưu trạng thái DB xuống localStorage
  persist() {
    if (!this.db) return;
    const binaryArray = this.db.export();
    localStorage.setItem(this.STORAGE_KEY, JSON.stringify(Array.from(binaryArray)));
  },

  // Đặt lại DB về trạng thái gốc
  reset() {
    localStorage.removeItem(this.STORAGE_KEY);
    location.reload();
  }
};
```
