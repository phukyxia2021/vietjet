-- ====================================================================
-- DỰ ÁN WEBSITE DU LỊCH & ĐẶT VÉ MÁY BAY VIETJET
-- FILE: 02_seed_data.sql (DỮ LIỆU KHỞI TẠO MẪU CHO SQLITE)
-- ====================================================================

-- 1. CHÈN DỮ LIỆU CÁC HÃNG HÀNG KHÔNG (AIRLINES)
INSERT INTO airlines (id, code, name, logo, hotline, country, description) VALUES
(1, 'VJ', 'VietJet Air', 'images/logo.jpg', '1900 1886', 'Việt Nam', 'Hãng hàng không thế hệ mới - Chi phí tiết kiệm, dịch vụ linh hoạt, bay là thích ngay!'),
(2, 'VN', 'Vietnam Airlines', 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e6/Vietnam_Airlines_logo.svg/320px-Vietnam_Airlines_logo.svg.png', '1900 1100', 'Việt Nam', 'Hãng hàng không Quốc gia Việt Nam - Thành viên SkyTeam, tiêu chuẩn quốc tế 4 sao.'),
(3, 'QH', 'Bamboo Airways', 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cf/Bamboo_Airways_logo.svg/320px-Bamboo_Airways_logo.svg.png', '1900 1166', 'Việt Nam', 'Hơn cả một chuyến bay - Phong cách phục vụ hiếu khách, tận tâm và chu đáo.'),
(4, 'SQ', 'Singapore Airlines', 'https://upload.wikimedia.org/wikipedia/en/thumb/6/6b/Singapore_Airlines_Logo_2.svg/320px-Singapore_Airlines_Logo_2.svg.png', '+65 6223 8888', 'Singapore', 'Hãng hàng không 5 sao đẳng cấp thế giới với đội tàu bay hiện đại và dịch vụ vượt trội.'),
(5, 'AK', 'AirAsia', 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/AirAsia_New_Logo.svg/320px-AirAsia_New_Logo.svg.png', '+60 3 2176 5888', 'Malaysia', 'Now Everyone Can Fly - Hãng hàng không giá rẻ hàng đầu khu vực Châu Á.'),
(6, 'TG', 'Thai Airways', 'https://upload.wikimedia.org/wikipedia/en/thumb/f/f3/Thai_Airways_Logo.svg/320px-Thai_Airways_Logo.svg.png', '+66 2 356 1111', 'Thái Lan', 'Smooth as silk - Hãng hàng không Hoàng gia Thái Lan mang đậm bản sắc văn hóa xứ Chùa Vàng.');

-- 2. CHÈN DỮ LIỆU CÁC SÂN BAY / THÀNH PHỐ (AIRPORTS)
INSERT INTO airports (code, city_name, airport_name, country) VALUES
('SGN', 'TP. Hồ Chí Minh', 'Sân bay Quốc tế Tân Sơn Nhất', 'Việt Nam'),
('HAN', 'Hà Nội', 'Sân bay Quốc tế Nội Bài', 'Việt Nam'),
('DAD', 'Đà Nẵng', 'Sân bay Quốc tế Đà Nẵng', 'Việt Nam'),
('PQC', 'Phú Quốc', 'Sân bay Quốc tế Phú Quốc', 'Việt Nam'),
('CXR', 'Nha Trang (Cam Ranh)', 'Sân bay Quốc tế Cam Ranh', 'Việt Nam'),
('VDO', 'Vân Đồn (Quảng Ninh)', 'Sân bay Quốc tế Vân Đồn', 'Việt Nam'),
('SIN', 'Singapore', 'Sân bay Quốc tế Changi Singapore', 'Singapore'),
('BKK', 'Bangkok', 'Sân bay Quốc tế Suvarnabhumi Bangkok', 'Thái Lan');

-- 3. CHÈN DỮ LIỆU 8 TOUR DU LỊCH NỔI BẬT (ẢNH 600x400 & LỊCH TRÌNH CHI TIẾT)
INSERT INTO tours (
    id, title, airline_id, departure_city, destination_city, 
    duration_days, duration_nights, departure_time, aircraft_type, 
    price, thumbnail, is_featured, services_included, services_excluded, 
    description, itinerary_json
) VALUES
(
    1, 
    'Tour Đà Nẵng - Bà Nà Hills - Cầu Vàng Bàn Tay - Phố Cổ Hội An', 
    1, 
    'Hà Nội', 
    'Đà Nẵng', 
    4, 
    3, 
    '06:45', 
    'Airbus A321neo', 
    4890000, 
    'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?w=600&h=400&fit=crop', 
    1, 
    'Vé máy bay khứ hồi VietJet Air, Khách sạn 4 sao biển Mỹ Khê, Vé cáp treo Bà Nà Hills & buffet trưa, Xe du lịch máy lạnh, Hướng dẫn viên suốt tuyến, Bảo hiểm du lịch 50 triệu/vụ.',
    'Chi phí cá nhân ngoài chương trình, Thuế VAT, Tiền tip cho HDV và tài xế.',
    'Hành trình khám phá dải đất miền Trung tuyệt mỹ với danh thắng Ngũ Hành Sơn huyền ảo, phố cổ Hội An hoài niệm và kỳ quan Cầu Vàng Bà Nà Hills nổi tiếng toàn cầu.',
    '[{"day":1,"title":"Hà Nội - Đà Nẵng - Bán Đảo Sơn Trà - Tắm Biển Mỹ Khê","desc":"Sáng xe đón quý khách tại Nội Bài đáp chuyến bay VJ-501 cất cánh 06:45 đi Đà Nẵng. Đến nơi xe đưa quý khách viếng Chùa Linh Ứng Bãi Bụt ngắm tượng Phật Bà 67m, nhận phòng khách sạn 4 sao nghỉ ngơi và tự do tắm biển Mỹ Khê tuyệt đẹp."},{"day":2,"title":"Khám Phá Sun World Bà Nà Hills - Kỳ Quan Cầu Vàng","desc":"Đoàn đi tuyến cáp treo đạt nhiều kỷ lục thế giới lên đỉnh Bà Nà. Check-in siêu phẩm Cầu Vàng bàn tay khổng lồ giữa biển mây, Làng Pháp cổ kính, vui chơi tại Fantasy Park và thưởng thức đại tiệc buffet hơn 100 món tại nhà hàng Arapang."},{"day":3,"title":"Ngũ Hành Sơn - Làng Đá Non Nước - Đèn Lồng Phố Cổ Hội An","desc":"Tham quan danh thắng Ngũ Hành Sơn với động Huyền Không linh thiêng. Buổi chiều bách bộ ngắm Chùa Cầu, Hội quán Phúc Kiến, dạo thuyền hoa đăng rực rỡ sắc màu trên dòng sông Hoài thơ mộng, thưởng thức đặc sản cao lầu Hội An."},{"day":4,"title":"Chợ Hàn Đà Nẵng Mua Đặc Sản - Sân Bay Đà Nẵng về Hà Nội","desc":"Tự do tắm biển sáng sớm và mua sắm chả bò, mực rim me tại chợ Hàn. Xe đưa đoàn ra sân bay Đà Nẵng đáp chuyến bay về lại Hà Nội. Kết thúc hành trình đầy ắp kỷ niệm đẹp."}]'
),
(
    2, 
    'Thiên Đường Đảo Ngọc Phú Quốc - Grand World - Hòn Thơm - Sunset Sanato', 
    1, 
    'TP. Hồ Chí Minh', 
    'Phú Quốc', 
    3, 
    2, 
    '07:30', 
    'Airbus A321', 
    3990000, 
    'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=600&h=400&fit=crop', 
    1, 
    'Vé máy bay khứ hồi VietJet Air SGN-PQC, Resort 5 sao có bãi biển riêng, Cano 4 đảo lặn ngắm san hô, Vé cáp treo Hòn Thơm 3 dây vượt biển, Các bữa ăn chính hải sản.',
    'Vé xem show Tinh Hoa Việt Nam tại Grand World, Đồ uống gọi thêm trong bữa ăn, Chi phí trò chơi cá nhân.',
    'Trải nghiệm kỳ nghỉ thiên đường nhiệt đới tại đảo ngọc Phú Quốc với làn nước trong vắt tựa ngọc bích, hoàng hôn rực rỡ và thành phố không ngủ Grand World lộng lẫy.',
    '[{"day":1,"title":"TP.HCM - Phú Quốc - Thành Phố Không Ngủ Grand World","desc":"Bay từ Tân Sơn Nhất trên chuyến bay VJ-321 (07:30 - 08:30). Nhận phòng resort 5 sao. Buổi chiều khám phá bảo tàng Gấu Teddy, ngồi thuyền Gondola ngắm dòng sông Venice lãng mạn và thưởng thức show diễn nhạc nước triệu đô."},{"day":2,"title":"Tour Cano 4 Đảo Siêu Tốc - Lặn San Hô Tự Nhiên - Cáp Treo Hòn Thơm","desc":"Lên cano lướt sóng đến Hòn Móng Tay, Hòn Gầm Ghì đắm mình trong làn nước xanh biếc. Chụp ảnh SUP flycam chuyên nghiệp. Chiều đi cáp treo vượt biển dài nhất thế giới ngắm toàn cảnh vịnh An Thới, ngắm hoàng hôn Sunset Sanato."},{"day":3,"title":"Chợ Dương Đông - Cơ Sở Nuôi Cấy Ngọc Trai - TP.HCM","desc":"Thăm trung tâm ngọc trai Long Beach, nhà thùng nước mắm truyền thống, mua đặc sản tiêu sọ và hải sản khô tại chợ Dương Đông. Xe tiễn sân bay Phú Quốc về lại TP.HCM."}]'
),
(
    3, 
    'Nha Trang Vịnh Biển Thiên Đường - VinWonders - Du Thuyền Hoàng Hôn Sang Trọng', 
    2, 
    'Hà Nội', 
    'Nha Trang', 
    4, 
    3, 
    '08:15', 
    'Boeing 787-9 Dreamliner', 
    5450000, 
    'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=600&h=400&fit=crop', 
    1, 
    'Vé máy bay Vietnam Airlines máy bay thân rộng Boeing 787, Khách sạn 5 sao mặt tiền biển đường Trần Phú, Thẻ trọn gói VinWonders, Du thuyền ngắm hoàng hôn vịnh Nha Trang tiệc BBQ.',
    'Dịch vụ lặn bình khí Scuba diving, Tắm bùn khoáng VIP riêng biệt, Tiền tip.',
    'Chuyến nghỉ dưỡng thượng lưu ngắm vịnh biển Nha Trang - 1 trong những vịnh biển đẹp nhất thế giới, tận hưởng dịch vụ bay 4 sao Vietnam Airlines và công viên giải trí quốc tế.',
    '[{"day":1,"title":"Hà Nội - Sân Bay Cam Ranh - Tháp Bà Ponagar - Tắm Bùn Khoáng I-Resort","desc":"Khởi hành trên máy bay thân rộng Boeing 787-9. Đến Cam Ranh xe đưa về Nha Trang, chiêm bái quần thể kiến trúc tháp Chăm Ponagar cổ kính và ngâm bùn khoáng nóng tái tạo năng lượng."},{"day":2,"title":"Thỏa Sức Khám Phá Công Viên Giải Trí Quốc Tế VinWonders Nha Trang","desc":"Đi cano sang đảo Hòn Tre, trải nghiệm vịnh phao nổi lớn nhất thế giới, đu quay khổng lồ Sky Wheel, khám phá Vườn Quý Vương với hổ trắng Bengal và thưởng thức Tata Show đỉnh cao."},{"day":3,"title":"Du Thuyền 5 Sao Ngắm Hoàng Hôn Vịnh Nha Trang - Tiệc BBQ Rượu Vang","desc":"Bách bộ bãi biển Trần Phú. 16:30 lên du thuyền sang trọng thưởng thức champagne, hòa tấu violin và ngắm hoàng hôn buông xuống vịnh biển, tiệc tối BBQ tôm hùm thượng hạng."},{"day":4,"title":"Chùa Long Sơn - Viện Hải Dương Học - Trở Về Hà Nội","desc":"Chiêm bái tượng Kim Thân Phật Tổ, tham quan bảo tàng sinh vật biển với hơn 20.000 mẫu vật quý hiếm. Mua yến sào Khánh Hòa làm quà. Xe đưa ra sân bay về lại Hà Nội."}]'
),
(
    4, 
    'Sapa Thị Trấn Sương Mù - Đỉnh Fansipan 3.143m - Bản Cát Cát Thơ Mộng', 
    1, 
    'TP. Hồ Chí Minh', 
    'Hà Nội', 
    4, 
    3, 
    '06:00', 
    'Airbus A321neo', 
    4690000, 
    'https://images.unsplash.com/photo-1528127269322-539801943592?w=600&h=400&fit=crop', 
    1, 
    'Vé máy bay khứ hồi VietJet Air SGN-HAN, Xe Limousine Dcar cao cấp Hà Nội - Sapa, Khách sạn 4 sao trung tâm thị trấn Sapa, Vé cáp treo Fansipan khứ hồi, Bữa ăn lẩu cá hồi Tây Bắc.',
    'Vé tàu hỏa leo núi Mường Hoa, Chi phí thuê trang phục dân tộc, Tiền tip.',
    'Chạm tay vào Nóc nhà Đông Dương Fansipan huyền thoại, săn biển mây trắng bồng bềnh và hòa mình vào nhịp sống bình yên của bản làng Tây Bắc đại ngàn.',
    '[{"day":1,"title":"TP.HCM - Hà Nội - Cao Tốc Nội Bài Lào Cai - Thị Trấn Sapa","desc":"Bay chuyến sáng VJ-160 từ TP.HCM ra Nội Bài. Xe Limousine đón đoàn chạy thẳng cao tốc Nội Bài - Lào Cai lên thị trấn trong sương Sapa. Dạo quanh hồ Sapa và nhà thờ đá cổ kính."},{"day":2,"title":"Chinh Phục Đỉnh Fansipan Nóc Nhà Đông Dương - Cầu Kính Rồng Mây","desc":"Đi tuyến cáp treo Fansipan băng qua thung lũng Mường Hoa, bách bộ lên cột mốc 3.143m linh thiêng. Chiều check-in Đèo Ô Quy Hồ đệ nhất tứ đại đỉnh đèo ngắm hoàng hôn ngoạn mục."},{"day":3,"title":"Bản Cát Cát H''''Mông - Thác Nước Tiên Sa - Thưởng Thức Lẩu Cá Hồi","desc":"Bách bộ tham quan cối xay nước khổng lồ, ruộng bậc thang trập trùng, trải nghiệm mặc trang phục H''''Mông check-in suối Mường Hoa. Tối thưởng thức tiệc lẩu cá hồi măng cay Tây Bắc."},{"day":4,"title":"Chợ Sapa - Mua Đặc Sản Thịt Trâu Gác Bếp - Về Lại TP.HCM","desc":"Mua hạt dẻ nướng, nấm hương rừng, rượu ngô Bản Phố. Xe limousine đưa đoàn về thẳng sân bay Nội Bài đáp chuyến bay VietJet đêm trở về TP.HCM an toàn."}]'
),
(
    5, 
    'Tour Singapore Quốc Đảo Sư Tử - Gardens by the Bay - Đảo Sentosa Hiện Đại', 
    4, 
    'Hà Nội', 
    'Singapore', 
    4, 
    3, 
    '09:00', 
    'Boeing 787-10 Dreamliner', 
    11990000, 
    'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?w=600&h=400&fit=crop', 
    1, 
    'Vé máy bay Singapore Airlines 5 sao khứ hồi, Khách sạn 4 sao chuẩn quốc tế gần Orchard, Vé vào cổng 2 nhà kính Flower Dome & Cloud Forest, Vé show nhạc nước Wings of Time, Bữa ăn lẩu cua sốt ớt Chilli Crab.',
    'Hộ chiếu còn hạn trên 6 tháng, Chi phí mua sắm cá nhân, Thuế phòng khách sạn nếu có.',
    'Khám phá đất nước sạch đẹp và văn minh bậc nhất thế giới cùng hãng hàng không danh tiếng Singapore Airlines, chiêm ngưỡng kỳ quan siêu cây Supertrees và thiên đường giải trí Sentosa.',
    '[{"day":1,"title":"Hà Nội - Sân Bay Jewel Changi Singapore - Công Viên Sư Tử Merlion","desc":"Trải nghiệm dịch vụ 5 sao trên chuyến bay SQ-175. Đến Changi, check-in thác nước nhân tạo trong nhà cao nhất thế giới tại Rain Vortex. Xe đưa đoàn về chụp ảnh cùng biểu tượng Sư Tử Biển Merlion Park nhìn ra vịnh Marina Bay."},{"day":2,"title":"Kỳ Quan Gardens by the Bay - Marina Bay Sands - Phố Cổ Chinatown","desc":"Khám phá hai nhà kính Flower Dome và Cloud Forest với thảm thực vật quý hiếm. Chiều mua sắm hàng hiệu miễn thuế tại The Shoppes Marina Bay Sands và thưởng thức trà sữa truyền thống tại Chinatown."},{"day":3,"title":"Thiên Đường Giải Trí Đảo Sentosa - Universal Studios - Nhạc Nước 3D","desc":"Tham quan đảo Sentosa, chụp ảnh biểu tượng quả cầu xoay Universal Studios, thủy cung S.E.A Aquarium lớn nhất khu vực. Buổi tối thưởng thức show biểu diễn nhạc nước và pháo hoa Wings of Time rực rỡ."},{"day":4,"title":"Chùa Răng Phật - Đại Lộ Mua Sắm Orchard Road - Trở Về Hà Nội","desc":"Viếng Chùa Răng Phật linh thiêng, tự do mua sắm thời trang tại thiên đường Orchard Road. Xe đưa đoàn ra sân bay Changi đáp chuyến bay Singapore Airlines về lại Hà Nội."}]'
),
(
    6, 
    'Bangkok - Biển Đảo Pattaya Xứ Sở Nụ Cười - Đảo San Hô Coral - Chùa Vàng', 
    1, 
    'TP. Hồ Chí Minh', 
    'Bangkok', 
    5, 
    4, 
    '11:15', 
    'Airbus A321', 
    6590000, 
    'https://images.unsplash.com/photo-1508009603885-50cf7c579365?w=600&h=400&fit=crop', 
    1, 
    'Vé máy bay khứ hồi VietJet Air SGN-BKK, Khách sạn 4 sao trung tâm Bangkok & Pattaya, Tàu cano cao tốc ra đảo San hô Coral, Buffet quốc tế tại tòa nhà 86 tầng Baiyoke Sky, Massage Thái cổ truyền 60 phút.',
    'Chi phí dù lượn và lặn biển tại đảo Coral, Tiền tip chuẩn quốc tế 5 USD/khách/ngày, Chi tiêu cá nhân.',
    'Trọn vẹn vẻ đẹp Thái Lan với thành phố biển sôi động Pattaya, đảo san hô nguyên sơ, trung tâm mua sắm Iconsiam sầm uất và những ngôi chùa dát vàng linh thiêng.',
    '[{"day":1,"title":"TP.HCM - Bangkok Suvarnabhumi - Khởi Hành Đi Thành Phố Biển Pattaya","desc":"Đáp chuyến bay VJ-801 đi Bangkok. Đến nơi xe đón đoàn khởi hành về thành phố biển Pattaya. Nhận phòng khách sạn, tự do khám phá phố đi bộ Walking Street rực rỡ ánh đèn về đêm."},{"day":2,"title":"Cano Khám Phá Đảo San Hô Coral - Núi Phật Vàng Khao Chee Chan","desc":"Lên cano vượt sóng đến đảo Coral tắm biển trong xanh. Buổi chiều chiêm bái tượng Phật Thích Ca dát vàng 9999 khắc nổi trên vách núi đá Khao Chee Chan, trải nghiệm massage Thái cổ truyền phục hồi thể lực."},{"day":3,"title":"Vườn Nhiệt Đới Nong Nooch - Chợ Nổi 4 Miền - Trở Về Thủ Đô Bangkok","desc":"Chiêm ngưỡng vườn lan quý hiếm và show biểu diễn võ thuật Muay Thái tại Nong Nooch. Thưởng thức xôi xoài ngọt lịm tại chợ nổi 4 miền trước khi lên đường về thủ đô Bangkok."},{"day":4,"title":"Dạo Thuyền Sông Chaophraya - Chùa Thuyền Wat Yannawa - Siêu TTTM Iconsiam","desc":"Du thuyền ngắm cảnh hai bên bờ sông Huyền Thoại Chaophraya và hiện tượng cá nổi linh thiêng. Mua sắm tại thiên đường Iconsiam với khu chợ nổi ẩm thực trong nhà hoành tráng."},{"day":5,"title":"Chùa Phật Vàng Wat Traimit Nặng 5.5 Tấn - Sân Bay Về TP.HCM","desc":"Chiêm bái tượng Phật bằng vàng nguyên khối lớn nhất thế giới tại Wat Traimit, cầu bình an tài lộc. Xe đưa đoàn ra sân bay đáp chuyến bay VietJet về lại Sài Gòn."}]'
),
(
    7, 
    'Quy Nhơn Kỳ Co - Eo Gió Nơi Ngắm Hoàng Hôn Tuyệt Mỹ - Resort FLC 5 Sao', 
    3, 
    'Hà Nội', 
    'Quy Nhơn', 
    3, 
    2, 
    '07:00', 
    'Airbus A320', 
    3790000, 
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600&h=400&fit=crop', 
    1, 
    'Vé máy bay Bamboo Airways khứ hồi, Nghỉ dưỡng tại quần thể resort FLC Quy Nhơn 5 sao, Cano cao tốc khứ hồi đảo Kỳ Co, Bữa tiệc hải sản tươi sống 8 món, Xe du lịch đời mới suốt tuyến.',
    'Trò chơi môtô nước, lặn ngắm san hô bằng bình khí, Tiền tip.',
    'Hành trình chạm đến dải bờ biển hoang sơ đẹp tựa Maldives của đảo Kỳ Co cùng cung đường đi bộ ven vách đá tuyệt mỹ tại Eo Gió Quy Nhơn.',
    '[{"day":1,"title":"Hà Nội - Sân Bay Phù Cát - Tháp Đôi Chăm Pa - Ghềnh Ráng Tiên Sa","desc":"Cất cánh cùng Bamboo Airways từ Nội Bài đến Phù Cát. Xe đưa đoàn viếng mộ thi sĩ Hàn Mặc Tử tại Ghềnh Ráng Tiên Sa, ngắm bãi đá trứng Hoàng Hậu và chiêm ngưỡng kiến trúc Tháp Đôi ngàn năm tuổi."},{"day":2,"title":"Thiên Đường Biển Đảo Kỳ Co - Eo Gió - Tịnh Xá Ngọc Hòa","desc":"Vượt biển trên cano cao tốc đến Bãi tắm Kỳ Co với làn nước 2 màu xanh ngắt. Lặn ngắm rạn san hô Bãi Dứa. Chiều dạo bước trên cung đường ven biển hùng vĩ tại Eo Gió và viếng tượng Phật đôi cao nhất Việt Nam."},{"day":3,"title":"Đồi Cát Phương Mai - Thưởng Thức Bánh Xèo Tôm Nhảy - Hà Nội","desc":"Trải nghiệm trượt cát tại đồi cát Phương Mai bạt ngàn. Thưởng thức đặc sản bánh xèo tôm nhảy giòn rụm và mua bánh ít lá gai làm quà. Xe đưa đoàn ra sân bay Phù Cát về lại Hà Nội."}]'
),
(
    8, 
    'Di Sản Miền Trung Cố Đô Huế - Đại Nội Hoàng Thành - Vịnh Lăng Cô - Hội An', 
    2, 
    'TP. Hồ Chí Minh', 
    'Huế', 
    4, 
    3, 
    '08:30', 
    'Airbus A321', 
    4950000, 
    'https://images.unsplash.com/photo-1570168007204-dfb528c6958f?w=600&h=400&fit=crop', 
    1, 
    'Vé máy bay Vietnam Airlines khứ hồi, Khách sạn 4 sao bên bờ sông Hương thơ mộng, Thuyền rồng nghe ca Huế và thả hoa đăng, Vé tham quan Đại Nội và các lăng tẩm, Bữa ăn cơm niêu cung đình Huế.',
    'Dịch vụ thuê trang phục hoàng gia chụp ảnh, Chi phí cá nhân, Thuế VAT.',
    'Trầm mặc không gian di sản cố đô triều Nguyễn với cung điện nguy nga, lăng tẩm uy nghiêm hòa quyện cùng nét hoài cổ rực rỡ đèn lồng phố cổ Hội An.',
    '[{"day":1,"title":"TP.HCM - Sân Bay Phú Bài Huế - Quần Thể Đại Nội Hoàng Cung","desc":"Đáp chuyến bay Vietnam Airlines VN-1370 đến vùng đất Cố Đô. Chiều tham quan Ngọ Môn, Điện Thái Hòa, Tử Cấm Thành nơi làm việc và sinh hoạt của 13 vị vua triều Nguyễn."},{"day":2,"title":"Chùa Thiên Mụ Cổ Kính - Lăng Khải Định - Ca Huế Trên Sông Hương","desc":"Viếng ngôi cổ tự Thiên Mụ bên dòng sông Hương êm đềm. Khám phá tuyệt tác nghệ thuật ghép sành sứ độc nhất vô nhị tại Lăng vua Khải Định. Tối lên thuyền rồng thả đèn hoa đăng và nghe ca Huế."},{"day":3,"title":"Vịnh Lăng Cô Tuyệt Mỹ - Đèo Hải Vân Hùng Vĩ - Phố Cổ Hội An","desc":"Chinh phục Đèo Hải Vân ngắm vịnh biển Lăng Cô xanh biếc. Đến Hội An bách bộ phố đèn lồng, ghé nhà cổ Tấn Ký, Hội quán Quảng Đông và thưởng thức chè mè đen trứ danh."},{"day":4,"title":"Chợ Đông Ba Huế - Thưởng Thức Bún Bò Huế Chuẩn Vị - TP.HCM","desc":"Mua mè xửng, nem tré, nón bài thơ tại chợ Đông Ba. Thưởng thức tô bún bò Huế đậm đà trước khi xe tiễn đoàn ra sân bay Phú Bài đáp chuyến bay trở về TP.HCM."}]'
);

-- 4. CHÈN DỮ LIỆU CÁC CHUYẾN BAY (FLIGHTS DIVERSITY)
INSERT INTO flights (
    airline_id, flight_number, origin_code, destination_code, 
    departure_time, arrival_time, duration_minutes, aircraft_type, 
    price_economy, price_business, is_direct, stops_count, 
    services_economy, services_business, seats_available
) VALUES
-- Tuyến: TP.HCM (SGN) -> Hà Nội (HAN)
(1, 'VJ-120', 'SGN', 'HAN', '05:45', '07:55', 130, 'Airbus A321neo', 1250000, 2850000, 1, 0, 'Hành lý xách tay 7kg', 'Hành lý ký gửi 30kg + xách tay 14kg, Phòng chờ SkyBoss VIP, Ưu tiên làm thủ tục, Suất ăn nóng miễn phí', 142),
(1, 'VJ-124', 'SGN', 'HAN', '08:30', '10:40', 130, 'Airbus A321', 1450000, 3100000, 1, 0, 'Hành lý xách tay 7kg', 'Hành lý ký gửi 30kg, Suất ăn nóng, Chọn chỗ ngồi trước, Phòng chờ VIP', 98),
(1, 'VJ-132', 'SGN', 'HAN', '14:15', '16:25', 130, 'Airbus A321neo', 1350000, 2990000, 1, 0, 'Hành lý xách tay 7kg', 'Hành lý ký gửi 30kg, SkyBoss Lounge, Ưu tiên soi chiếu an ninh', 115),
(1, 'VJ-150', 'SGN', 'HAN', '19:40', '21:50', 130, 'Airbus A330-300', 1190000, 2750000, 1, 0, 'Máy bay thân rộng, Hành lý xách tay 7kg', 'Ghế da ngả phẳng 180 độ, Hành lý ký gửi 40kg, Thực đơn cao cấp', 160),
(2, 'VN-210', 'SGN', 'HAN', '07:00', '09:10', 130, 'Boeing 787-9 Dreamliner', 2150000, 4850000, 1, 0, 'Suất ăn sáng nóng sốt, Hành lý ký gửi 23kg', 'Phòng chờ Bông Sen Lotus Lounge, Ghế nằm phẳng rộng rãi, Hành lý ký gửi 32kg x 2', 45),
(2, 'VN-216', 'SGN', 'HAN', '11:00', '13:10', 130, 'Airbus A350-900', 2350000, 5200000, 1, 0, 'Suất ăn trưa đầy đủ, Màn hình cá nhân HD, Hành lý 23kg', 'Dịch vụ Lotus Business 4 sao, Rượu vang thượng hạng, Ưu tiên lối đi riêng', 38),
(2, 'VN-222', 'SGN', 'HAN', '17:30', '19:40', 130, 'Boeing 787-9 Dreamliner', 2250000, 4990000, 1, 0, 'Bữa tối nóng sốt, Hành lý ký gửi 23kg', 'Ghế Business xoay chéo riêng tư, Quầy bar mini trên khoang', 52),
(3, 'QH-202', 'SGN', 'HAN', '09:15', '11:25', 130, 'Boeing 787-9 Dreamliner', 1750000, 3950000, 1, 0, 'Suất ăn nhẹ, Nước suối, Hành lý xách tay 7kg', 'Hành lý ký gửi 40kg, Phòng chờ First Lounge sang trọng, Xe đưa đón riêng', 60),
(3, 'QH-208', 'SGN', 'HAN', '16:00', '18:10', 130, 'Airbus A320', 1650000, 3750000, 1, 0, 'Hành lý ký gửi 20kg miễn cước, Nước suối', 'Khoang Thương gia êm ái, Suất ăn nóng đặc sản, Thủ tục ưu tiên', 75),

-- Tuyến: Hà Nội (HAN) -> TP.HCM (SGN)
(1, 'VJ-121', 'HAN', 'SGN', '06:30', '08:40', 130, 'Airbus A321', 1250000, 2850000, 1, 0, 'Hành lý xách tay 7kg', 'SkyBoss VIP, Hành lý ký gửi 30kg, Suất ăn nóng miễn phí', 130),
(1, 'VJ-135', 'HAN', 'SGN', '13:00', '15:10', 130, 'Airbus A330-300', 1350000, 2990000, 1, 0, 'Thân rộng êm ái, Hành lý xách tay 7kg', 'Ghế nằm phẳng 180 độ SkyBoss, Phòng chờ sang trọng', 110),
(1, 'VJ-145', 'HAN', 'SGN', '20:15', '22:25', 130, 'Airbus A321neo', 1150000, 2690000, 1, 0, 'Hành lý xách tay 7kg', 'SkyBoss trọn gói tiện ích cao cấp', 155),
(2, 'VN-211', 'HAN', 'SGN', '09:00', '11:10', 130, 'Airbus A350-900', 2150000, 4850000, 1, 0, 'Suất ăn nhẹ, Màn hình giải trí cá nhân, Hành lý 23kg', 'Khoang Thương gia Lotus Lounge, Ghế ngả phẳng, Thực đơn hảo hạng', 64),
(3, 'QH-203', 'HAN', 'SGN', '15:30', '17:40', 130, 'Boeing 787-9 Dreamliner', 1700000, 3890000, 1, 0, 'Hành lý 20kg miễn phí, Bữa ăn nhẹ ngon miệng', 'Business Class Bamboo VIP, Hành lý 40kg, Xe đón tại chân thang', 80),

-- Tuyến: TP.HCM (SGN) -> Đà Nẵng (DAD)
(1, 'VJ-622', 'SGN', 'DAD', '07:15', '08:35', 80, 'Airbus A320', 890000, 1950000, 1, 0, 'Hành lý xách tay 7kg', 'SkyBoss Lounge, Hành lý 30kg, Ưu tiên làm thủ tục', 120),
(1, 'VJ-628', 'SGN', 'DAD', '15:30', '16:50', 80, 'Airbus A321', 990000, 2150000, 1, 0, 'Hành lý xách tay 7kg', 'SkyBoss trọn gói tiện ích', 95),
(2, 'VN-118', 'SGN', 'DAD', '10:00', '11:20', 80, 'Airbus A321', 1450000, 3200000, 1, 0, 'Suất ăn nhẹ, Hành lý ký gửi 23kg', 'Khoang thương gia 4 sao, Phòng chờ Lotus, Hành lý 32kg', 70),

-- Tuyến: Hà Nội (HAN) -> Đà Nẵng (DAD)
(1, 'VJ-501', 'HAN', 'DAD', '06:45', '08:05', 80, 'Airbus A321neo', 850000, 1890000, 1, 0, 'Hành lý xách tay 7kg', 'SkyBoss Lounge, Suất ăn nóng, Hành lý 30kg', 140),
(2, 'VN-163', 'HAN', 'DAD', '13:30', '14:50', 80, 'Airbus A321', 1350000, 2990000, 1, 0, 'Hành lý ký gửi 23kg, Nước uống', 'Lotus Business, Ưu tiên lên máy bay, Phòng chờ cao cấp', 55),

-- Tuyến: TP.HCM (SGN) -> Phú Quốc (PQC)
(1, 'VJ-321', 'SGN', 'PQC', '07:30', '08:30', 60, 'Airbus A321', 790000, 1750000, 1, 0, 'Hành lý xách tay 7kg', 'SkyBoss Lounge, Hành lý 30kg ký gửi', 135),
(1, 'VJ-329', 'SGN', 'PQC', '16:45', '17:45', 60, 'Airbus A320', 820000, 1800000, 1, 0, 'Hành lý xách tay 7kg', 'SkyBoss trọn gói', 110),
(2, 'VN-1823', 'SGN', 'PQC', '11:20', '12:25', 65, 'Airbus A321', 1290000, 2890000, 1, 0, 'Hành lý ký gửi 23kg, Đồ uống miễn phí', 'Hạng Thương gia cao cấp, Phòng chờ VIP', 65),

-- Tuyến Quốc Tế: TP.HCM (SGN) -> Singapore (SIN)
(4, 'SQ-178', 'SGN', 'SIN', '12:15', '15:20', 125, 'Boeing 787-10 Dreamliner', 3650000, 8900000, 1, 0, 'Dịch vụ 5 sao quốc tế, Bữa ăn Á-Âu hảo hạng, Rượu vang miễn phí, Hành lý 30kg', 'Ghế Business Class nằm phẳng hoàn toàn, Phòng chờ SilverKris Changi, Ẩm thực sao Michelin', 42),
(1, 'VJ-813', 'SGN', 'SIN', '08:55', '12:00', 125, 'Airbus A321', 1750000, 3950000, 1, 0, 'Hành lý xách tay 7kg', 'SkyBoss Quốc tế, Phòng chờ đối tác Changi, Hành lý 30kg', 88),

-- Tuyến Quốc Tế: TP.HCM (SGN) -> Bangkok (BKK)
(1, 'VJ-801', 'SGN', 'BKK', '11:15', '12:45', 90, 'Airbus A321', 1490000, 3450000, 1, 0, 'Hành lý xách tay 7kg', 'SkyBoss Quốc tế, Suất ăn nóng Thái Lan, Hành lý 30kg', 105),
(6, 'TG-551', 'SGN', 'BKK', '10:05', '11:35', 90, 'Boeing 777-300ER', 2850000, 6200000, 1, 0, 'Hành lý 30kg, Bữa ăn hương vị Thái Lan, Giải trí đa phương tiện', 'Royal Silk Business Class, Phòng chờ Hoàng gia Thái Lan, Ghế ngả tiện nghi', 50);
