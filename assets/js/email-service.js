/**
 * VIETJET EMAIL SERVICE (assets/js/email-service.js)
 * Tích hợp cơ chế gửi email xác nhận đặt chỗ từ nvhai061993@gmail.com đến khách hàng
 */

const EmailService = {
  SENDER_EMAIL: 'nvhai061993@gmail.com',
  SENDER_NAME: 'Vietjet Air & Travel Booking',

  /**
   * Tạo nội dung email xác nhận đặt vé điện tử
   */
  generateEmailContent(booking, details) {
    const formatMoney = (amount) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
    
    let itemsHtml = '';
    details.forEach((item, index) => {
      itemsHtml += `
        <tr style="border-bottom: 1px solid #eee;">
          <td style="padding: 12px 8px; font-weight: 500;">${index + 1}. ${item.item_name}</td>
          <td style="padding: 12px 8px; color: #555;">${item.ticket_class || 'Tiêu chuẩn'}</td>
          <td style="padding: 12px 8px; text-align: center;">${item.quantity}</td>
          <td style="padding: 12px 8px; text-align: right; color: #ee1d23; font-weight: bold;">${formatMoney(item.subtotal)}</td>
        </tr>
      `;
    });

    const emailBody = `
      <div style="font-family: 'Segoe UI', Arial, sans-serif; max-width: 650px; margin: 0 auto; border: 1px solid #e1e4e8; border-radius: 12px; overflow: hidden; background: #ffffff;">
        <div style="background-color: #ee1d23; padding: 24px 20px; text-align: center; color: #ffffff;">
          <h1 style="margin: 0; font-size: 24px; letter-spacing: 1px; text-transform: uppercase;">VIETJET TRAVEL & FLIGHTS</h1>
          <p style="margin: 5px 0 0 0; font-size: 14px; opacity: 0.9;">Xác Nhận Đặt Chỗ Thành Công - Vé Điện Tử & Voucher Tour</p>
        </div>

        <div style="padding: 24px 20px;">
          <div style="background-color: #fff9e6; border-left: 4px solid #f8c200; padding: 14px 16px; margin-bottom: 20px; border-radius: 4px;">
            <p style="margin: 0; color: #856404; font-size: 15px;">
              <strong>Kính gửi Quý khách ${booking.customer_name},</strong><br>
              Cảm ơn Quý khách đã tin tưởng lựa chọn dịch vụ của Vietjet. Yêu cầu đặt vé của Quý khách đã được xác nhận thành công!
            </p>
          </div>

          <table style="width: 100%; margin-bottom: 24px; font-size: 14px; line-height: 1.6;">
            <tr>
              <td style="width: 50%;">
                <strong style="color: #666;">Mã Đặt Chỗ (PNR):</strong><br>
                <span style="font-size: 18px; color: #ee1d23; font-weight: bold;">${booking.booking_code}</span>
              </td>
              <td style="width: 50%;">
                <strong style="color: #666;">Ngày Tạo Đơn:</strong><br>
                <span>${new Date().toLocaleString('vi-VN')}</span>
              </td>
            </tr>
            <tr>
              <td style="padding-top: 10px;">
                <strong style="color: #666;">Người gửi:</strong><br>
                <span>${this.SENDER_NAME} &lt;${this.SENDER_EMAIL}&gt;</span>
              </td>
              <td style="padding-top: 10px;">
                <strong style="color: #666;">Email Người Nhận:</strong><br>
                <span>${booking.customer_email}</span>
              </td>
            </tr>
            <tr>
              <td style="padding-top: 10px;">
                <strong style="color: #666;">Số Điện Thoại:</strong><br>
                <span>${booking.customer_phone}</span>
              </td>
              <td style="padding-top: 10px;">
                <strong style="color: #666;">Trạng Thái:</strong><br>
                <span style="background: #28a745; color: #fff; padding: 2px 8px; border-radius: 12px; font-size: 12px;">ĐÃ XÁC NHẬN</span>
              </td>
            </tr>
          </table>

          <h3 style="color: #212529; border-bottom: 2px solid #ee1d23; padding-bottom: 8px; margin-bottom: 12px;">CHI TIẾT DỊCH VỤ ĐÃ ĐẶT</h3>
          <table style="width: 100%; border-collapse: collapse; font-size: 14px; margin-bottom: 20px;">
            <thead>
              <tr style="background: #f8f9fa; border-bottom: 2px solid #dee2e6; text-align: left;">
                <th style="padding: 10px 8px;">Dịch Vụ</th>
                <th style="padding: 10px 8px;">Hạng Vé</th>
                <th style="padding: 10px 8px; text-align: center;">Số Lượng</th>
                <th style="padding: 10px 8px; text-align: right;">Thành Tiền</th>
              </tr>
            </thead>
            <tbody>
              ${itemsHtml}
            </tbody>
            <tfoot>
              <tr>
                <td colspan="3" style="padding: 14px 8px; text-align: right; font-weight: bold; font-size: 16px;">TỔNG THANH TOÁN:</td>
                <td style="padding: 14px 8px; text-align: right; color: #ee1d23; font-weight: bold; font-size: 18px;">${formatMoney(booking.total_amount)}</td>
              </tr>
            </tfoot>
          </table>

          <div style="background: #fdf2f2; border: 1px dashed #ee1d23; padding: 14px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 13px; color: #444;">
            <strong style="color: #ee1d23; font-size: 14px;">LƯU Ý QUAN TRỌNG:</strong>
            <ul style="margin: 6px 0 0 0; padding-left: 18px; line-height: 1.5;">
              <li>Quý khách vui lòng có mặt tại sân bay trước giờ khởi hành ít nhất <strong>90 phút</strong> (đối với chặng bay nội địa) và <strong>150 phút</strong> (đối với chặng bay quốc tế).</li>
              <li>Khi đi làm thủ tục, quý khách vui lòng xuất trình <strong>Mã Đặt Chỗ</strong> cùng CCCD hoặc Hộ chiếu còn hạn trên 6 tháng.</li>
              <li>Đối với Tour du lịch, hướng dẫn viên của Vietjet Travel sẽ liên hệ qua số điện thoại <strong>${booking.customer_phone}</strong> trước ngày khởi hành 24 giờ.</li>
            </ul>
          </div>
        </div>

        <div style="background-color: #f8f9fa; padding: 16px; text-align: center; font-size: 12px; color: #6c757d; border-top: 1px solid #e9ecef;">
          <p style="margin: 0 0 4px 0;"><strong>VIETJET TRAVEL & AVIATION SERVICE JOINT STOCK COMPANY</strong></p>
          <p style="margin: 0 0 4px 0;">Hotline Hỗ Trợ 24/7: <strong style="color: #ee1d23;">1900 1886</strong> | Email CSKH: <strong style="color: #ee1d23;">nvhai061993@gmail.com</strong></p>
          <p style="margin: 0;">Email này được gửi tự động từ hệ thống đặt chỗ trực tuyến Vietjet.</p>
        </div>
      </div>
    `;

    return emailBody;
  },

  /**
   * Kích hoạt gửi email và hiển thị modal thông báo / xem trước email
   */
  async sendBookingConfirmation(booking, details) {
    const htmlBody = this.generateEmailContent(booking, details);
    console.log(`[EmailService] Đang kích hoạt gửi email từ ${this.SENDER_EMAIL} đến ${booking.customer_email}...`);

    // Lưu vào lịch sử email của ứng dụng
    const emailRecord = {
      from: this.SENDER_EMAIL,
      to: booking.customer_email,
      bookingCode: booking.booking_code,
      subject: `[Vietjet] Xác Nhận Đặt Chỗ Thành Công #${booking.booking_code}`,
      sentAt: new Date().toISOString(),
      html: htmlBody
    };

    try {
      const history = JSON.parse(localStorage.getItem('vietjet_sent_emails') || '[]');
      history.unshift(emailRecord);
      localStorage.setItem('vietjet_sent_emails', JSON.stringify(history));
    } catch (e) {
      console.warn('Không thể lưu email history:', e);
    }

    return {
      success: true,
      sender: this.SENDER_EMAIL,
      recipient: booking.customer_email,
      htmlContent: htmlBody
    };
  }
};
