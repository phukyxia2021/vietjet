/**
 * VIETJET SQLITE DATABASE MANAGER (assets/js/db.js)
 * Tích hợp sql.js (WebAssembly SQLite)
 * Cơ chế nạp ưu tiên: Luôn thử nạp file db.db mới nhất từ ổ đĩa (cache-busting ?t=...)
 * Tự động đồng bộ giỏ hàng và dữ liệu người dùng
 */

const VietjetDB = {
  db: null,
  isInitialized: false,
  STORAGE_KEY: 'vietjet_sqlite_db_v1',
  CART_BACKUP_KEY: 'vietjet_cart_items_backup',
  // Thử lần lượt các đường dẫn file CSDL
  DB_CANDIDATE_PATHS: ['SQLite/db.db', 'db.db'],

  /**
   * Khởi tạo kết nối SQLite Database
   * @param {boolean} forceReloadFromDisk - Bắt buộc nạp lại từ file db.db trên ổ đĩa
   */
  async init(forceReloadFromDisk = false) {
    if (this.isInitialized && this.db && !forceReloadFromDisk) {
      return this.db;
    }

    try {
      const config = {
        locateFile: file => `https://cdnjs.cloudflare.com/ajax/libs/sql.js/1.8.0/${file}`
      };
      
      const SQL = await initSqlJs(config);

      let loadedDB = null;
      let loadSource = '';

      // 1. LUÔN ƯU TIÊN NẠP TRỰC TIẾP TỪ FILE .DB TRÊN Ổ ĐĨA QUA FETCH (Kèm timestamp chống cache trình duyệt)
      for (const path of this.DB_CANDIDATE_PATHS) {
        try {
          const cacheBusterUrl = `${path}?t=${Date.now()}`;
          const response = await fetch(cacheBusterUrl, { cache: 'no-cache' });
          if (response.ok) {
            const arrayBuffer = await response.arrayBuffer();
            if (arrayBuffer && arrayBuffer.byteLength > 0) {
              const uInt8Array = new Uint8Array(arrayBuffer);
              loadedDB = new SQL.Database(uInt8Array);
              loadSource = `file ${path}`;
              console.log(`[VietjetDB] Đã nạp CSDL mới nhất trực tiếp từ ${path} (${arrayBuffer.byteLength} bytes)`);
              break;
            }
          }
        } catch (fetchErr) {
          // Bỏ qua nếu bị chặn CORS do mở file:/// trực tiếp
        }
      }

      // 2. NẾU FETCH THẤT BẠI (VÍ DỤ MỞ FILE BẰNG FILE:///), THỬ ĐỌC TỪ LOCALSTORAGE
      if (!loadedDB && !forceReloadFromDisk) {
        const savedBinary = localStorage.getItem(this.STORAGE_KEY);
        if (savedBinary) {
          try {
            const binaryArray = new Uint8Array(JSON.parse(savedBinary));
            loadedDB = new SQL.Database(binaryArray);
            loadSource = 'localStorage';
            console.log('[VietjetDB] Nạp CSDL từ localStorage');
          } catch (storageErr) {
            console.warn('[VietjetDB] Lỗi parse localStorage:', storageErr);
          }
        }
      }

      // 3. NẾU VẪN CHƯA CÓ, DÙNG BẢN BASE64 DỰ PHÒNG TÍCH HỢP TRONG db-fallback.js
      if (!loadedDB && window.VIETJET_DB_BASE64) {
        try {
          const binaryString = atob(window.VIETJET_DB_BASE64);
          const len = binaryString.length;
          const bytes = new Uint8Array(len);
          for (let i = 0; i < len; i++) {
            bytes[i] = binaryString.charCodeAt(i);
          }
          loadedDB = new SQL.Database(bytes);
          loadSource = 'Base64 Fallback';
          console.log('[VietjetDB] Nạp CSDL từ Base64 Fallback');
        } catch (b64Err) {
          console.error('[VietjetDB] Lỗi nạp Base64 Fallback:', b64Err);
        }
      }

      // 4. NẾU HOÀN TOÀN KHÔNG CÓ DỮ LIỆU
      if (!loadedDB) {
        loadedDB = new SQL.Database();
        loadSource = 'Empty in-memory';
        console.warn('[VietjetDB] Khởi tạo CSDL trống');
      }

      this.db = loadedDB;
      this.isInitialized = true;

      // 5. Khôi phục giỏ hàng đã có trước đó (nếu nạp mới từ file trên đĩa)
      this.restoreCartBackup();

      // Lưu trạng thái hiện tại
      this.persist();

      return this.db;

    } catch (err) {
      console.error('[VietjetDB] Khởi tạo SQLite thất bại:', err);
      throw err;
    }
  },

  /**
   * Khôi phục giỏ hàng từ localStorage vào bảng cart_items
   */
  restoreCartBackup() {
    try {
      const backupStr = localStorage.getItem(this.CART_BACKUP_KEY);
      if (!backupStr || !this.db) return;

      const items = JSON.parse(backupStr);
      if (Array.isArray(items) && items.length > 0) {
        // Kiểm tra xem bảng cart_items có tồn tại không
        this.db.run(`CREATE TABLE IF NOT EXISTS cart_items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          item_type TEXT NOT NULL,
          reference_id INTEGER NOT NULL,
          ticket_class TEXT DEFAULT 'economy',
          quantity INTEGER DEFAULT 1,
          unit_price INTEGER NOT NULL,
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );`);

        // Xóa sạch giỏ cũ trong RAM và chèn lại các mục sao lưu
        this.db.run(`DELETE FROM cart_items`);
        for (const item of items) {
          this.db.run(
            `INSERT INTO cart_items (item_type, reference_id, ticket_class, quantity, unit_price) VALUES (?, ?, ?, ?, ?)`,
            [item.item_type, item.reference_id, item.ticket_class || 'economy', item.quantity || 1, item.unit_price || 0]
          );
        }
        console.log(`[VietjetDB] Đã khôi phục ${items.length} dịch vụ trong giỏ hàng.`);
      }
    } catch (e) {
      console.warn('[VietjetDB] Không thể khôi phục giỏ hàng:', e);
    }
  },

  /**
   * Sao lưu danh sách giỏ hàng ra localStorage
   */
  backupCart() {
    try {
      if (!this.db) return;
      const items = this.query(`SELECT item_type, reference_id, ticket_class, quantity, unit_price FROM cart_items`);
      localStorage.setItem(this.CART_BACKUP_KEY, JSON.stringify(items));
    } catch (e) {
      console.warn('[VietjetDB] Không thể backup giỏ hàng:', e);
    }
  },

  /**
   * Chạy câu lệnh SELECT trả về mảng các đối tượng JavaScript [{ col1: val1, col2: val2 }, ...]
   */
  query(sql, params = []) {
    if (!this.db) {
      console.error('[VietjetDB] CSDL chưa được khởi tạo!');
      return [];
    }

    try {
      const stmt = this.db.prepare(sql);
      if (params && params.length > 0) {
        stmt.bind(params);
      }
      const results = [];
      while (stmt.step()) {
        results.push(stmt.getAsObject());
      }
      stmt.free();
      return results;
    } catch (err) {
      console.error('[VietjetDB] Lỗi query SQL:', sql, params, err);
      return [];
    }
  },

  /**
   * Chạy câu lệnh INSERT, UPDATE, DELETE và tự động lưu trạng thái DB
   */
  run(sql, params = []) {
    if (!this.db) {
      console.error('[VietjetDB] CSDL chưa được khởi tạo!');
      return false;
    }

    try {
      this.db.run(sql, params);
      this.persist();
      return true;
    } catch (err) {
      console.error('[VietjetDB] Lỗi run SQL:', sql, params, err);
      return false;
    }
  },

  /**
   * Lưu CSDL nhị phân vào localStorage
   */
  persist() {
    if (!this.db) return;
    try {
      const binaryArray = this.db.export();
      localStorage.setItem(this.STORAGE_KEY, JSON.stringify(Array.from(binaryArray)));
      this.backupCart();
    } catch (e) {
      console.warn('[VietjetDB] Không thể lưu vào localStorage:', e);
    }
  },

  /**
   * Xóa cache localStorage và nạp lại từ đầu từ file db.db
   */
  async reloadFromDisk() {
    localStorage.removeItem(this.STORAGE_KEY);
    await this.init(true);
    if (window.App && App.showToast) {
      App.showToast('Đã làm mới CSDL thành công từ file db.db!');
    }
    setTimeout(() => location.reload(), 300);
  }
};
