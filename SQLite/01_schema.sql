-- ====================================================================
-- DỰ ÁN WEBSITE DU LỊCH & ĐẶT VÉ MÁY BAY VIETJET
-- FILE: 01_schema.sql (LƯỢC ĐỒ CƠ SỞ DỮ LIỆU SQLITE)
-- ====================================================================

PRAGMA foreign_keys = ON;

-- 1. Bảng Hãng Hàng Không (airlines)
DROP TABLE IF EXISTS booking_details;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS tours;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS airports;
DROP TABLE IF EXISTS airlines;

CREATE TABLE airlines (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT NOT NULL UNIQUE,              -- VJ, VN, QH, SQ, AK, TG...
    name TEXT NOT NULL,                     -- VietJet Air, Vietnam Airlines, Singapore Airlines...
    logo TEXT NOT NULL,                     -- Đường dẫn ảnh hoặc icon logo
    hotline TEXT,                           -- Số điện thoại tổng đài hỗ trợ
    country TEXT NOT NULL DEFAULT 'Việt Nam',
    description TEXT
);

-- 2. Bảng Sân Bay / Thành Phố (airports)
CREATE TABLE airports (
    code TEXT PRIMARY KEY,                  -- SGN, HAN, DAD, PQC, CXR, SIN, BKK...
    city_name TEXT NOT NULL,                -- TP. Hồ Chí Minh, Hà Nội, Đà Nẵng...
    airport_name TEXT NOT NULL,             -- Tân Sơn Nhất, Nội Bài, Changi...
    country TEXT NOT NULL DEFAULT 'Việt Nam'
);

-- 3. Bảng Chuyến Bay (flights)
CREATE TABLE flights (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    airline_id INTEGER NOT NULL,
    flight_number TEXT NOT NULL,            -- VJ-124, VN-210, SQ-178...
    origin_code TEXT NOT NULL,              -- SGN, HAN...
    destination_code TEXT NOT NULL,         -- HAN, DAD, SIN...
    departure_time TEXT NOT NULL,           -- Giờ khởi hành: '06:30'
    arrival_time TEXT NOT NULL,             -- Giờ hạ cánh: '08:40'
    duration_minutes INTEGER NOT NULL,      -- Thời gian bay (phút): 130
    aircraft_type TEXT NOT NULL,            -- Airbus A321neo, Boeing 787-9 Dreamliner, Boeing 737 MAX...
    price_economy INTEGER NOT NULL,         -- Giá vé Hạng Phổ Thông (VND)
    price_business INTEGER NOT NULL,        -- Giá vé Hạng Thương Gia (VND)
    is_direct INTEGER DEFAULT 1,            -- 1: Bay thẳng, 0: Quá cảnh / có điểm dừng
    stops_count INTEGER DEFAULT 0,          -- Số điểm dừng (0: bay thẳng)
    services_economy TEXT,                  -- Tiện ích hạng Phổ thông
    services_business TEXT,                 -- Tiện ích hạng Thương gia
    seats_available INTEGER DEFAULT 180,    -- Số ghế còn lại
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (airline_id) REFERENCES airlines(id) ON DELETE CASCADE,
    FOREIGN KEY (origin_code) REFERENCES airports(code) ON DELETE CASCADE,
    FOREIGN KEY (destination_code) REFERENCES airports(code) ON DELETE CASCADE
);

-- 4. Bảng Tour Du Lịch (tours)
CREATE TABLE tours (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,                    -- Tên tour du lịch
    airline_id INTEGER NOT NULL,            -- Hãng hàng không vận chuyển
    departure_city TEXT NOT NULL,           -- Thành phố khởi hành (Hà Nội, TP.HCM...)
    destination_city TEXT NOT NULL,         -- Điểm đến (Đà Nẵng, Phú Quốc, Singapore...)
    duration_days INTEGER NOT NULL,         -- Số ngày (ví dụ: 4)
    duration_nights INTEGER NOT NULL,       -- Số đêm (ví dụ: 3)
    departure_time TEXT NOT NULL,           -- Khung giờ bay dự kiến: '07:15'
    aircraft_type TEXT NOT NULL,            -- Airbus A321, Boeing 787-9...
    price INTEGER NOT NULL,                 -- Giá tour trọn gói (VND)
    thumbnail TEXT NOT NULL,                -- Ảnh đại diện chuẩn tỉ lệ 600x400
    is_featured INTEGER DEFAULT 1,          -- 1: Tour nổi bật trang chủ (8 tours), 0: Tour thường
    services_included TEXT,                 -- Dịch vụ bao gồm (Vé máy bay, khách sạn, ăn uống...)
    services_excluded TEXT,                 -- Dịch vụ không bao gồm (Chi phí cá nhân, tips...)
    description TEXT,                       -- Giới thiệu ngắn về tour
    itinerary_json TEXT,                    -- Chi tiết lịch trình theo từng ngày (JSON)
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (airline_id) REFERENCES airlines(id) ON DELETE CASCADE
);

-- 5. Bảng Giỏ Hàng (cart_items)
CREATE TABLE cart_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    item_type TEXT NOT NULL CHECK(item_type IN ('flight', 'tour')), -- 'flight' hoặc 'tour'
    reference_id INTEGER NOT NULL,          -- ID của chuyến bay hoặc tour
    ticket_class TEXT DEFAULT 'economy' CHECK(ticket_class IN ('economy', 'business', 'tour_standard')), -- 'economy' hoặc 'business'
    quantity INTEGER DEFAULT 1,             -- Số lượng hành khách / vé
    unit_price INTEGER NOT NULL,            -- Đơn giá tại thời điểm thêm vào giỏ (VND)
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 6. Bảng Đơn Đăng Ký / Đặt Chỗ (bookings)
CREATE TABLE bookings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    booking_code TEXT NOT NULL UNIQUE,      -- Mã đặt vé: VJ-202611-XXXX
    customer_name TEXT NOT NULL,            -- Họ tên khách hàng
    customer_email TEXT NOT NULL,           -- Email nhận vé (sẽ gửi từ nvhai061993@gmail.com)
    customer_phone TEXT NOT NULL,           -- Số điện thoại khách hàng
    customer_address TEXT,                  -- Địa chỉ liên hệ
    notes TEXT,                             -- Yêu cầu đặc biệt (suất ăn, ghế ngồi...)
    total_amount INTEGER NOT NULL,          -- Tổng số tiền đơn hàng (VND)
    payment_method TEXT DEFAULT 'BANK_TRANSFER', -- Phương thức thanh toán
    status TEXT DEFAULT 'CONFIRMED' CHECK(status IN ('PENDING', 'CONFIRMED', 'CANCELLED')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 7. Bảng Chi Tiết Đơn Hàng (booking_details)
CREATE TABLE booking_details (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    booking_id INTEGER NOT NULL,
    item_type TEXT NOT NULL CHECK(item_type IN ('flight', 'tour')),
    reference_id INTEGER NOT NULL,
    item_name TEXT NOT NULL,                -- Tên chuyến bay (SGN -> HAN) hoặc tên tour
    ticket_class TEXT,                      -- Hạng Phổ thông / Hạng Thương gia
    quantity INTEGER NOT NULL DEFAULT 1,
    unit_price INTEGER NOT NULL,
    subtotal INTEGER NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);

-- ====================================================================
-- CÁC CHỈ MỤC (INDEXES) TỐI ƯU HÓA TRUY VẤN
-- ====================================================================
CREATE INDEX IF NOT EXISTS idx_flights_route ON flights(origin_code, destination_code);
CREATE INDEX IF NOT EXISTS idx_flights_airline ON flights(airline_id);
CREATE INDEX IF NOT EXISTS idx_flights_price_eco ON flights(price_economy);
CREATE INDEX IF NOT EXISTS idx_flights_price_bus ON flights(price_business);
CREATE INDEX IF NOT EXISTS idx_flights_departure ON flights(departure_time);
CREATE INDEX IF NOT EXISTS idx_flights_direct ON flights(is_direct);

CREATE INDEX IF NOT EXISTS idx_tours_featured ON tours(is_featured);
CREATE INDEX IF NOT EXISTS idx_tours_airline ON tours(airline_id);
CREATE INDEX IF NOT EXISTS idx_tours_price ON tours(price);

CREATE INDEX IF NOT EXISTS idx_cart_type ON cart_items(item_type, reference_id);
CREATE INDEX IF NOT EXISTS idx_bookings_code ON bookings(booking_code);
