-- ====================================================================
-- DỰ ÁN WEBSITE DU LỊCH & ĐẶT VÉ MÁY BAY VIETJET
-- FILE: 03_sample_queries.sql (CÁC TRUY VẤN MẪU DÙNG CHO FRONTEND)
-- ====================================================================

-- --------------------------------------------------------------------
-- 1. TRANG CHỦ (index.html)
-- --------------------------------------------------------------------

-- 1.1. Lấy danh sách 8 Tour Du Lịch Nổi Bật kèm thông tin Hãng Hàng Không
SELECT 
    t.id,
    t.title,
    t.departure_city,
    t.destination_city,
    t.duration_days,
    t.duration_nights,
    t.price,
    t.thumbnail,
    t.aircraft_type,
    a.name AS airline_name,
    a.code AS airline_code,
    a.logo AS airline_logo
FROM tours t
JOIN airlines a ON t.airline_id = a.id
WHERE t.is_featured = 1
ORDER BY t.id ASC
LIMIT 8;

-- 1.2. Lấy danh sách Hãng Hàng Không để hiển thị logo đối tác
SELECT id, code, name, logo, hotline, description
FROM airlines
ORDER BY id ASC;

-- 1.3. Lấy danh sách Sân Bay để điền vào dropdown Điểm đi / Điểm đến
SELECT code, city_name, airport_name, country
FROM airports
ORDER BY city_name ASC;


-- --------------------------------------------------------------------
-- 2. TRANG CHUYẾN BAY (flights.html) - TÌM KIẾM & BỘ LỌC
-- --------------------------------------------------------------------

-- 2.1. Truy vấn tìm kiếm chuyến bay cơ bản theo Chặng Bay (Ví dụ: SGN -> HAN)
SELECT 
    f.id,
    f.flight_number,
    f.origin_code,
    orig.city_name AS origin_city,
    f.destination_code,
    dest.city_name AS destination_city,
    f.departure_time,
    f.arrival_time,
    f.duration_minutes,
    f.aircraft_type,
    f.price_economy,
    f.price_business,
    f.is_direct,
    f.stops_count,
    f.services_economy,
    f.services_business,
    a.id AS airline_id,
    a.name AS airline_name,
    a.code AS airline_code,
    a.logo AS airline_logo
FROM flights f
JOIN airlines a ON f.airline_id = a.id
JOIN airports orig ON f.origin_code = orig.code
JOIN airports dest ON f.destination_code = dest.code
WHERE f.origin_code = 'SGN' AND f.destination_code = 'HAN'
ORDER BY f.price_economy ASC;

-- 2.2. Truy vấn nâng cao áp dụng TẤT CẢ các bộ lọc bên trái (Left Sidebar Filters)
-- Ví dụ: Lọc hãng VietJet Air & Bamboo, Bay thẳng, Giờ cất cánh từ 06:00 đến 12:00, Giá tăng dần
SELECT 
    f.id,
    f.flight_number,
    f.origin_code,
    f.destination_code,
    f.departure_time,
    f.arrival_time,
    f.duration_minutes,
    f.aircraft_type,
    f.price_economy,
    f.price_business,
    f.is_direct,
    a.name AS airline_name,
    a.logo AS airline_logo
FROM flights f
JOIN airlines a ON f.airline_id = a.id
WHERE f.origin_code = 'SGN' 
  AND f.destination_code = 'HAN'
  AND f.is_direct = 1                               -- Chỉ bay thẳng
  AND a.code IN ('VJ', 'QH')                         -- Lọc theo hãng hàng không
  AND (time(f.departure_time) >= time('06:00') AND time(f.departure_time) < time('12:00')) -- Khung giờ sáng
ORDER BY f.price_economy ASC;                        -- Giá tăng dần (hoặc DESC nếu giảm dần)


-- --------------------------------------------------------------------
-- 3. TRANG CHI TIẾT CHUYẾN BAY (flight-detail.html)
-- --------------------------------------------------------------------

-- Lấy đầy đủ thông tin chuyến bay theo ID (ví dụ: id = 1)
SELECT 
    f.*,
    a.name AS airline_name,
    a.code AS airline_code,
    a.logo AS airline_logo,
    a.hotline AS airline_hotline,
    orig.city_name AS origin_city,
    orig.airport_name AS origin_airport,
    dest.city_name AS destination_city,
    dest.airport_name AS destination_airport
FROM flights f
JOIN airlines a ON f.airline_id = a.id
JOIN airports orig ON f.origin_code = orig.code
JOIN airports dest ON f.destination_code = dest.code
WHERE f.id = 1;


-- --------------------------------------------------------------------
-- 4. TRANG TOUR (tours.html) & CHI TIẾT TOUR (tour-detail.html)
-- --------------------------------------------------------------------

-- 4.1. Lọc danh sách Tour du lịch với bộ lọc giá và hãng hàng không
SELECT 
    t.id,
    t.title,
    t.departure_city,
    t.destination_city,
    t.duration_days,
    t.duration_nights,
    t.departure_time,
    t.aircraft_type,
    t.price,
    t.thumbnail,
    t.services_included,
    a.name AS airline_name,
    a.logo AS airline_logo
FROM tours t
JOIN airlines a ON t.airline_id = a.id
WHERE 1=1
  -- AND a.code = 'VJ'                              -- Filter theo hãng nếu chọn
  -- AND (time(t.departure_time) >= time('06:00') AND time(t.departure_time) < time('12:00')) -- Filter giờ
ORDER BY t.price ASC;                              -- Hoặc DESC

-- 4.2. Xem chi tiết Tour du lịch và Lịch trình (ví dụ: id = 1)
SELECT 
    t.*,
    a.name AS airline_name,
    a.code AS airline_code,
    a.logo AS airline_logo,
    a.hotline AS airline_hotline
FROM tours t
JOIN airlines a ON t.airline_id = a.id
WHERE t.id = 1;


-- --------------------------------------------------------------------
-- 5. GIỎ HÀNG (cart.html)
-- --------------------------------------------------------------------

-- 5.1. Thêm Chuyến Bay vào Giỏ Hàng
INSERT INTO cart_items (item_type, reference_id, ticket_class, quantity, unit_price)
VALUES ('flight', 1, 'business', 1, 2850000);

-- 5.2. Thêm Tour vào Giỏ Hàng
INSERT INTO cart_items (item_type, reference_id, ticket_class, quantity, unit_price)
VALUES ('tour', 1, 'tour_standard', 2, 4890000);

-- 5.3. Lấy toàn bộ sản phẩm trong Giỏ Hàng kèm chi tiết tên, hãng bay, đơn giá
SELECT 
    c.id AS cart_item_id,
    c.item_type,
    c.reference_id,
    c.ticket_class,
    c.quantity,
    c.unit_price,
    (c.quantity * c.unit_price) AS subtotal,
    -- Thông tin nếu là chuyến bay:
    CASE WHEN c.item_type = 'flight' THEN (f.origin_code || ' ➔ ' || f.destination_code || ' (' || f.flight_number || ')')
         ELSE t.title 
    END AS item_title,
    CASE WHEN c.item_type = 'flight' THEN af.name ELSE at.name END AS airline_name,
    CASE WHEN c.item_type = 'flight' THEN f.aircraft_type ELSE t.aircraft_type END AS aircraft_type,
    CASE WHEN c.item_type = 'flight' THEN f.departure_time ELSE t.departure_time END AS departure_time
FROM cart_items c
LEFT JOIN flights f ON (c.item_type = 'flight' AND c.reference_id = f.id)
LEFT JOIN airlines af ON f.airline_id = af.id
LEFT JOIN tours t ON (c.item_type = 'tour' AND c.reference_id = t.id)
LEFT JOIN airlines at ON t.airline_id = at.id
ORDER BY c.created_at DESC;

-- 5.4. Tính Tổng Tiền Giỏ Hàng
SELECT COALESCE(SUM(quantity * unit_price), 0) AS total_amount, COUNT(id) AS total_items
FROM cart_items;

-- 5.5. Xóa 1 mục khỏi giỏ hàng
DELETE FROM cart_items WHERE id = 1;

-- 5.6. Xóa toàn bộ giỏ hàng
DELETE FROM cart_items;


-- --------------------------------------------------------------------
-- 6. ĐẶT HÀNG & CHECKOUT (bookings & booking_details)
-- --------------------------------------------------------------------

-- 6.1. Lưu thông tin Đơn Đăng Ký của Khách Hàng
INSERT INTO bookings (
    booking_code, customer_name, customer_email, customer_phone, 
    customer_address, notes, total_amount, payment_method, status
) VALUES (
    'VJ-202611-8891', 
    'Nguyễn Văn Hải', 
    'nvhai061993@gmail.com', 
    '0901234567', 
    'Quận 1, TP. Hồ Chí Minh', 
    'Yêu cầu ghế gần cửa sổ và hỗ trợ gửi xác nhận qua email', 
    7740000, 
    'BANK_TRANSFER', 
    'CONFIRMED'
);

-- 6.2. Lưu chi tiết từng vé/tour trong đơn hàng
INSERT INTO booking_details (
    booking_id, item_type, reference_id, item_name, ticket_class, quantity, unit_price, subtotal
) VALUES (
    last_insert_rowid(), 
    'flight', 
    1, 
    'Chuyến bay SGN ➔ HAN (VJ-120)', 
    'Hạng Thương Gia (Business)', 
    1, 
    2850000, 
    2850000
);
