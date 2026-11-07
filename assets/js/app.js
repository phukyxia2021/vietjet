/**
 * VIETJET APPLICATION MAIN HELPER (assets/js/app.js)
 * Cung cấp các tiện ích dùng chung: Format VND, Header/Footer, Toasts, URL helpers
 */

const App = {
  /**
   * Định dạng số tiền sang VND
   */
  formatVND(amount) {
    if (isNaN(amount)) return '0 ₫';
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
  },

  /**
   * Format thời gian phút -> Xh Ym
   */
  formatDuration(minutes) {
    const hours = Math.floor(minutes / 60);
    const mins = minutes % 60;
    if (hours === 0) return `${mins}m`;
    if (mins === 0) return `${hours}h`;
    return `${hours}h ${mins}m`;
  },

  /**
   * Lấy tham số từ URL
   */
  getUrlParam(paramName) {
    const params = new URLSearchParams(window.location.search);
    return params.get(paramName);
  },

  /**
   * Hiển thị thông báo Toast nhanh góc màn hình
   */
  showToast(message, type = 'success') {
    let container = document.getElementById('toast-container');
    if (!container) {
      container = document.createElement('div');
      container.id = 'toast-container';
      document.body.appendChild(container);
    }

    const toast = document.createElement('div');
    toast.className = `vietjet-toast ${type}`;
    
    let icon = 'check-circle';
    if (type === 'error') icon = 'times-circle';
    if (type === 'warning') icon = 'exclamation-circle';

    toast.innerHTML = `
      <i class="fas fa-${icon}"></i>
      <div class="toast-content">${message}</div>
    `;

    container.appendChild(toast);

    setTimeout(() => {
      toast.classList.add('show');
    }, 10);

    setTimeout(() => {
      toast.classList.remove('show');
      setTimeout(() => toast.remove(), 300);
    }, 3500);
  },

  /**
   * Khởi tạo Header và cập nhật Giỏ hàng
   */
  setupNav() {
    // Cập nhật số lượng giỏ hàng ban đầu
    if (window.CartService && window.VietjetDB && VietjetDB.db) {
      CartService.notifyUpdate();
    }

    // Lắng nghe sự kiện click mở menu mobile
    const toggleBtn = document.querySelector('.mobile-menu-toggle');
    const navMenu = document.querySelector('.nav-menu');
    if (toggleBtn && navMenu) {
      toggleBtn.addEventListener('click', () => {
        navMenu.classList.toggle('active');
      });
    }
  }
};

// Tự động lắng nghe giỏ hàng khi trang nạp
document.addEventListener('DOMContentLoaded', () => {
  window.addEventListener('vietjet_cart_updated', (e) => {
    const badges = document.querySelectorAll('.cart-badge');
    badges.forEach(b => {
      b.textContent = e.detail.totalItems;
      b.style.display = e.detail.totalItems > 0 ? 'inline-flex' : 'none';
    });
  });
});
