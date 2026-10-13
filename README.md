# BODY ARENA — GitHub Ready v1.2.1
Bộ mã nguồn đầy đủ của bản game hiện tại, kèm schema và lệnh quản trị Supabase. Ngày đóng gói: 13/10/2026.

## Trạng thái
**Game chạy độc lập; đăng nhập Google và đồng bộ Supabase chưa được nối vào giao diện.** Thư mục `supabase/` chứa schema và adapter mẫu. Chạy SQL không tự thêm chức năng tài khoản vào game.

## Tính năng
- Chọn nhân vật, đấu máy ba hiệp, câu hỏi kiến thức và tiến hóa ngoại hình.
- Xoay bằng chuột hoặc Q/R, đạn năng lượng bay từ đầu, khiên và lướt né.
- Kích thước 50–300%, thay đổi trực tiếp tại sân và lưu mức chọn trên trình duyệt.
- Xưởng ảnh: tải ảnh, crop, xóa nền theo màu, tẩy, hoàn tác, căn gốc/đầu.
- Thêm/ẩn/hiện/xóa mẫu và xuất/nhập JSON. Có điều khiển cảm ứng.
- Ảnh và danh mục tự thêm lưu tại trình duyệt, không có ảnh riêng của người chơi trong gói mã nguồn.

## Cấu trúc file
| Đường dẫn | Chức năng |
|---|---|
| dist/index.html | Trang game |
| dist/style.css | Giao diện |
| dist/app.js | Logic game và trình sửa ảnh |
| supabase/schema.sql | Cấu trúc dữ liệu, phân quyền RLS |
| supabase/admin_commands.sql | Lệnh cấp/thu hồi admin và quản lý dữ liệu |
| supabase/verify.sql | Kiểm tra database |
| supabase/integration.example.mjs | Adapter mẫu chưa được game import |
| supabase/README.md | Hướng dẫn Google và Supabase |
| supabase/TEST_RESULTS.md | Kết quả thử schema |
| tests/ | Kiểm thử logic |
| vercel.json | Triển khai riêng dist trên Vercel |
| .github/workflows/pages.yml | Workflow GitHub Pages |
| package.json | Lệnh build và test, không có dependency ngoài |
| CHANGELOG.md | Ghi chép các phiên bản |

## Tải lên GitHub
1. Giải nén ZIP.
2. Tạo repository mới, ví dụ `body-arena`.
3. Tải **toàn bộ nội dung bên trong thư mục đã giải nén** lên gốc repository. `dist/`, `supabase/`, `package.json`, `vercel.json` phải cùng cấp; không lồng thêm thư mục bao ngoài.
4. Nếu dùng GitHub Pages, nhớ đưa `.github/workflows/pages.yml` lên. Thư mục bắt đầu bằng dấu chấm có thể bị trình quản lý tệp ẩn.
5. Không chỉ tải ZIP lên: GitHub không tự giải nén thành website.

Hoặc dùng Git từ thư mục giải nén:
```bash
git init
git add .
git commit -m "Initial BODY ARENA v1.2.1"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/body-arena.git
git push -u origin main
```
Thay URL bằng repository của bạn.

## Vercel
Import repository; Root Directory là gốc repository, Framework là Other, Build Command `npm run build`, Output Directory `dist`. File vercel.json đã khai báo cấu hình. Không cần cài dependency cho game. Sau Deploy, mở URL Vercel cấp.

Chỉ dist được xuất bản, nên README/SQL/tests không được đưa vào output website.

## GitHub Pages (lựa chọn khác)
Settings → Pages → Source: GitHub Actions. Push vào nhánh main hoặc chạy workflow Deploy game to GitHub Pages. Workflow kiểm tra mã rồi xuất bản riêng dist. URL thường là `https://YOUR_USERNAME.github.io/body-arena/`; tài nguyên dùng đường dẫn tương đối.

## Chạy trên máy
Mở dist/index.html, hoặc chạy:
```bash
python -m http.server 8080 --directory dist
```
Mở http://localhost:8080. Máy chủ cục bộ giúp tránh giới hạn lưu dữ liệu của file://. OAuth cần URL web được cấu hình redirect.

## Điều khiển
- WASD/mũi tên di chuyển; chuột hoặc Q/R xoay.
- Giữ Space hoặc chuột để bắn; E khiên; Shift lướt; P tạm dừng.
- Điện thoại dùng nút cảm ứng và chạm sân để ngắm.
- Thanh kích thước dưới sân áp dụng ngay; chỉ đổi hình hiển thị, không đổi sát thương hoặc vùng trúng đòn.

## Supabase và Google
Đọc supabase/README.md: chạy schema.sql, verify.sql, cấu hình Google provider, cấp admin rồi nối adapter vào giao diện game.

**Khi chuyển sang Vercel/Pages, thay URL chatgpt.site trong hướng dẫn bằng URL mới** tại Supabase Site URL/Redirect URLs, Google Authorized JavaScript origins và redirectUrl trong mã.
- Google JavaScript origin chỉ gồm origin, không có đường dẫn /body-arena/.
- Redirect về game cần có đường dẫn /body-arena/ nếu dùng Pages.
- Callback Google vẫn là `https://YOUR_PROJECT_REF.supabase.co/auth/v1/callback`.

Gói không chứa cấu hình Supabase thật hoặc khóa bí mật. Không đưa Google Client Secret/service_role vào frontend. Ảnh riêng vẫn lưu cục bộ.

## Kiểm tra
Node.js 20+:
```bash
npm run build
npm test
```
Đã kiểm tra cú pháp, điểm bắn theo góc/kích thước/tiến hóa, xóa nền liên thông, crop, cập nhật trực tiếp và lưu kích thước. Schema được thử bằng PostgreSQL nhúng. Chưa kiểm thử trực tiếp trình duyệt hoặc Google OAuth thật.

## Phần chưa hoàn tất
Giao diện đăng nhập Google/khôi phục phiên, đồng bộ tiến độ, admin xác thực, đồng bộ ảnh, multiplayer, kiểm chứng điểm số phía server. Bộ schema/adapter là nền tảng để thực hiện các bước này. Chưa tạo repository hoặc triển khai vào tài khoản GitHub/Vercel của bạn.

## Quy tắc cập nhật
Luôn kèm README mô tả thay đổi, cách chạy, kiểm thử và phần còn thiếu.

## Tài liệu
- https://vercel.com/docs/project-configuration
- https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages
