/**
 * VIETJET CART SERVICE (assets/js/cart.js)
 * Quản lý giỏ hàng trên bảng cart_items của SQLite
 */

const CartService = {
  /**
   * Lấy toàn bộ sản phẩm trong giỏ hàng kèm thông tin chi tiết từ chuyến bay / tour
   */
  getItems() {
    const sql = `
      SELECT 
        c.id AS cart_item_id,
        c.item_type,
        c.reference_id,
        c.ticket_class,
        c.quantity,
        c.unit_price,
        (c.quantity * c.unit_price) AS subtotal,
        c.created_at,
        CASE 
          WHEN c.item_type = 'flight' THEN (f.origin_code || ' ➔ ' || f.destination_code || ' (' || f.flight_number || ')')
          ELSE t.title 
        END AS item_title,
        CASE 
          WHEN c.item_type = 'flight' THEN af.name 
          ELSE at.name 
        END AS airline_name,
        CASE 
          WHEN c.item_type = 'flight' THEN af.logo 
          ELSE at.logo 
        END AS airline_logo,
        CASE 
          WHEN c.item_type = 'flight' THEN f.aircraft_type 
          ELSE t.aircraft_type 
        END AS aircraft_type,
        CASE 
          WHEN c.item_type = 'flight' THEN f.departure_time 
          ELSE t.departure_time 
        END AS departure_time,
        CASE 
          WHEN c.item_type = 'flight' THEN f.duration_minutes 
          ELSE (t.duration_days || 'N' || t.duration_nights || 'Đ') 
        END AS duration_info
      FROM cart_items c
      LEFT JOIN flights f ON (c.item_type = 'flight' AND c.reference_id = f.id)
      LEFT JOIN airlines af ON f.airline_id = af.id
      LEFT JOIN tours t ON (c.item_type = 'tour' AND c.reference_id = t.id)
      LEFT JOIN airlines at ON t.airline_id = at.id
      ORDER BY c.created_at DESC;
    `;
    return VietjetDB.query(sql);
  },

  /**
   * Thêm chuyến bay vào giỏ hàng
   */
  addFlight(flightId, ticketClass = 'economy', quantity = 1) {
    const flight = VietjetDB.query('SELECT * FROM flights WHERE id = ?', [flightId])[0];
    if (!flight) {
      console.error('Không tìm thấy chuyến bay có ID:', flightId);
      return false;
    }

    const price = (ticketClass === 'business') ? flight.price_business : flight.price_economy;

    // Kiểm tra xem chuyến bay cùng hạng này đã có trong giỏ chưa
    const existing = VietjetDB.query(
      `SELECT id, quantity FROM cart_items WHERE item_type = 'flight' AND reference_id = ? AND ticket_class = ?`,
      [flightId, ticketClass]
    )[0];

    if (existing) {
      VietjetDB.run(
        `UPDATE cart_items SET quantity = quantity + ? WHERE id = ?`,
        [quantity, existing.id]
      );
    } else {
      VietjetDB.run(
        `INSERT INTO cart_items (item_type, reference_id, ticket_class, quantity, unit_price) VALUES (?, ?, ?, ?, ?)`,
        ['flight', flightId, ticketClass, quantity, price]
      );
    }

    this.notifyUpdate();
    return true;
  },

  /**
   * Thêm tour du lịch vào giỏ hàng
   */
  addTour(tourId, quantity = 1) {
    const tour = VietjetDB.query('SELECT * FROM tours WHERE id = ?', [tourId])[0];
    if (!tour) {
      console.error('Không tìm thấy tour có ID:', tourId);
      return false;
    }

    const price = tour.price;

    const existing = VietjetDB.query(
      `SELECT id, quantity FROM cart_items WHERE item_type = 'tour' AND reference_id = ?`,
      [tourId]
    )[0];

    if (existing) {
      VietjetDB.run(
        `UPDATE cart_items SET quantity = quantity + ? WHERE id = ?`,
        [quantity, existing.id]
      );
    } else {
      VietjetDB.run(
        `INSERT INTO cart_items (item_type, reference_id, ticket_class, quantity, unit_price) VALUES (?, ?, ?, ?, ?)`,
        ['tour', tourId, 'tour_standard', quantity, price]
      );
    }

    this.notifyUpdate();
    return true;
  },

  /**
   * Cập nhật số lượng
   */
  updateQuantity(cartItemId, newQty) {
    if (newQty <= 0) {
      this.removeItem(cartItemId);
    } else {
      VietjetDB.run(`UPDATE cart_items SET quantity = ? WHERE id = ?`, [newQty, cartItemId]);
      this.notifyUpdate();
    }
  },

  /**
   * Xóa một sản phẩm khỏi giỏ hàng
   */
  removeItem(cartItemId) {
    VietjetDB.run(`DELETE FROM cart_items WHERE id = ?`, [cartItemId]);
    this.notifyUpdate();
  },

  /**
   * Xóa toàn bộ giỏ hàng
   */
  clearCart() {
    VietjetDB.run(`DELETE FROM cart_items`);
    this.notifyUpdate();
  },

  /**
   * Tính tổng tiền và tổng số lượng sản phẩm
   */
  getSummary() {
    const res = VietjetDB.query(`SELECT COALESCE(SUM(quantity * unit_price), 0) AS total_amount, COALESCE(SUM(quantity), 0) AS total_items FROM cart_items`)[0];
    return {
      totalAmount: res ? Number(res.total_amount) : 0,
      totalItems: res ? Number(res.total_items) : 0
    };
  },

  /**
   * Phát sự kiện cập nhật để header badge cập nhật tức thì
   */
  notifyUpdate() {
    if (window.VietjetDB && VietjetDB.backupCart) {
      VietjetDB.backupCart();
    }

    const summary = this.getSummary();
    const event = new CustomEvent('vietjet_cart_updated', { detail: summary });
    window.dispatchEvent(event);

    // Cập nhật DOM badge nếu có
    const badges = document.querySelectorAll('.cart-badge');
    badges.forEach(b => {
      b.textContent = summary.totalItems;
      b.style.display = summary.totalItems > 0 ? 'inline-flex' : 'none';
    });
  }
};
