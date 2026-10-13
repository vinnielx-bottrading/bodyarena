# Kết quả kiểm tra — 13/10/2026

Đã thực thi schema trên PostgreSQL nhúng PGlite với bảng auth.users và hàm auth.uid mô phỏng môi trường Supabase. Dùng tài khoản giả A/B, không dùng dữ liệu người thật.

Đạt:
- Chạy toàn bộ schema trong transaction.
- Người dùng tạo hồ sơ/tiến độ của chính mình và cập nhật kích thước.
- Trigger cập nhật timestamp hoạt động.
- Chặn tạo hồ sơ mang UUID người khác và đổi owner sang UUID khác.
- Tài khoản B không thấy hoặc cập nhật được hồ sơ A.
- Chặn người chơi tự thêm mình vào bảng admin.
- Chặn người chơi thêm danh mục nhân vật.
- Admin cập nhật và xem được mẫu ẩn; người chơi/anon chỉ thấy mẫu enabled.
- Anon không đọc được bảng hồ sơ.
- JavaScript adapter vượt qua kiểm tra cú pháp Node.

Chưa kiểm tra:
- Dự án Supabase thực, Google OAuth/callback, phiên đăng nhập trong trình duyệt.
- Tích hợp giao diện game, khôi phục checkpoint, đồng bộ nhiều thiết bị.

Không có thao tác tạo dự án hoặc thay đổi cơ sở dữ liệu Supabase của người dùng trong lần đóng gói này.
