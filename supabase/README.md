# BODY ARENA — Supabase Setup v1
Ngày: 13/10/2026. Bộ cài đặt để chủ dự án tự chạy trên Supabase.

## Trạng thái
Chưa tạo dự án Supabase, chưa chạy SQL trên tài khoản của bạn và chưa bật đăng nhập Google trên game đang xuất bản. Bộ này cung cấp schema, lệnh admin và adapter mẫu. Chạy schema không tự thêm nút đăng nhập vào game. Không thay đổi bản game 1.2.1 hiện tại.

## Các file
| File | Công dụng |
|---|---|
| schema.sql | Tạo 4 bảng, ràng buộc, quyền truy cập, RLS và 3 nhân vật mặc định |
| admin_commands.sql | Tra tài khoản, cấp/thu hồi admin, quản lý nhân vật, xem/reset tiến độ |
| verify.sql | Kiểm tra bảng, RLS, policies, quyền và dữ liệu mẫu |
| integration.example.mjs | Adapter JavaScript mẫu cho Google OAuth và lưu/đọc hồ sơ |
| README.md | Hướng dẫn cài đặt và tích hợp |
| TEST_RESULTS.md | Phạm vi kiểm tra thực tế |

## 1. Tạo dự án
Trong tài khoản Supabase Primary, chọn tổ chức Content Planner và tạo dự án riêng tên BODY ARENA. Có thể chọn Singapore (ap-southeast-1). Kiểm tra gói và chi phí hiển thị trước khi tạo; bộ file này không xác nhận giá hoặc giới hạn dự án của tài khoản.

## 2. Tạo cấu trúc dữ liệu
1. Mở dự án mới → SQL Editor → New query.
2. Dán toàn bộ `schema.sql` và Run.
3. Chạy `verify.sql`: cả 4 bảng phải có `rls_enabled = true`.
4. Schema được thiết kế chạy một lần trên dự án mới, trong transaction. Nếu bảng đã tồn tại, lệnh sẽ báo lỗi và rollback. Không xóa bảng để chạy lại. Không chạy vào một dự án game khác.
5. Nếu đang thiết lập Data API, bảo đảm schema `public` được expose. Các quyền bảng đã được GRANT rõ trong schema.

## 3. Cấu hình đăng nhập Google
Trong Google Cloud / Google Auth Platform:
1. Thiết lập Branding và Audience. Khi còn chế độ Testing, thêm email thử nghiệm vào Test users.
2. Tạo OAuth Client ID loại Web application.
3. Authorized JavaScript origins:
   `https://body-arena-vinh.nguyenhoangvinh456.chatgpt.site`
4. Authorized redirect URIs:
   `https://YOUR_PROJECT_REF.supabase.co/auth/v1/callback`
   Thay YOUR_PROJECT_REF bằng ref dự án mới, không dùng ref của Chu hoặc Hành Tinh Laj.
5. Lưu Client ID và Client Secret vào Supabase → Authentication → Sign In / Providers → Google, rồi bật provider.
6. Supabase → Authentication → URL Configuration:
   - Site URL: `https://body-arena-vinh.nguyenhoangvinh456.chatgpt.site`
   - Redirect URLs: `https://body-arena-vinh.nguyenhoangvinh456.chatgpt.site/`
7. Chỉ yêu cầu thông tin định danh cơ bản (openid, email, profile), không cần quyền đọc Gmail.

Client Secret chỉ nhập trong Supabase Dashboard; không đưa vào HTML/JS hoặc gửi trong chat. Frontend chỉ cần Project URL và publishable key. Không dùng secret key/service_role trong trình duyệt.

Lưu ý: website hiện là Site riêng tư. Google OAuth không tự đổi quyền truy cập Site. Việc mở game cho người khác cần cấu hình chia sẻ riêng.

## 4. Nối với game
`integration.example.mjs` nhận Supabase JavaScript client v2 do ứng dụng khởi tạo; đây không phải một trang đăng nhập hoàn chỉnh. Khi cài SDK, ghim phiên bản chính xác và giữ lockfile. Ví dụ cấu trúc:

```js
import { createClient } from '@supabase/supabase-js';
import { bodyArenaAccount } from './integration.example.mjs';

const client = createClient('https://YOUR_PROJECT_REF.supabase.co', 'YOUR_PUBLISHABLE_KEY', {
  auth: { persistSession: true, autoRefreshToken: true, detectSessionInUrl: true, flowType: 'pkce' }
});
const account = bodyArenaAccount(client, 'https://body-arena-vinh.nguyenhoangvinh456.chatgpt.site/');
// Nút Đăng nhập: await account.login();
// Sau khôi phục session: const saved = await account.load();
```

Luồng tích hợp cần làm:
- Hiển thị nút Google khi chưa đăng nhập, tên người chơi + Đăng xuất khi đã đăng nhập.
- Sau khi SDK xử lý callback/khôi phục session, gọi `load()`. Nếu profile/progress là null, tạo giá trị ban đầu.
- Dùng `textContent` để hiển thị tên/email, không đưa metadata người dùng vào innerHTML.
- Khôi phục nickname, nhân vật đã chọn và kích thước. Nếu ID nhân vật ảnh riêng không tồn tại trên thiết bị mới, báo rõ và chọn `mint` dự phòng.
- Gọi `saveProfile()` khi thay đổi cài đặt (debounce khoảng 500–1000 ms).
- Gọi `saveProgress()` sau khi hoàn tất câu hỏi giữa hiệp: ghi `nextRound` là hiệp sắp chơi, `runEvolution` là cấp đã đạt và `runHealth` là năng lượng sau hồi phục. Không ghi lúc đang bay đạn.
- Thắng hiệp 3: tăng completedRuns, cập nhật bestScore/highestEvolution, đặt hasCheckpoint=false. Chỉ ghi một lần cho một kết quả, khóa nút trong lúc lưu để tránh cộng trùng.
- Khi tải lại và có checkpoint, cung cấp nút “Tiếp tục hiệp …”. Adapter chỉ trả dữ liệu; game phải khởi tạo lại hiệp từ dữ liệu đó.
- Khi thua hoặc bỏ lượt chơi: đặt hasCheckpoint=false. Không xóa thành tích cao nhất.
- Khi đăng xuất: dừng trận, xóa hồ sơ hiện tại khỏi giao diện; không dùng dữ liệu tài khoản trước cho tài khoản tiếp theo.
- Khi lưu lỗi/offline: hiển thị “Chưa đồng bộ”, giữ thay đổi để thử lại; không báo đã lưu khi API thất bại.
- Không await thao tác Supabase khác trực tiếp bên trong callback onAuthStateChange; điều phối đọc hồ sơ ngoài callback để tránh khóa phiên.

Ví dụ tiến độ ban đầu:
```js
await account.saveProgress({
  bestScore:0, completedRuns:0, highestEvolution:0,
  nextRound:1, runScore:0, runEvolution:0,
  runHealth:100, correctAnswers:0, hasCheckpoint:false
});
```

## 5. Cấp quyền admin
Sau khi bạn đăng nhập Google thành công ít nhất một lần:
1. Mở `admin_commands.sql`.
2. Bỏ comment và chạy riêng mục 1, thay YOUR_GOOGLE_EMAIL@example.com bằng email của bạn.
3. Sao chép UUID chính xác nhận được; thay REPLACE_WITH_USER_UUID trong mục 2 rồi chạy riêng mục đó.
4. Chạy mục 3 để kiểm tra danh sách admin.
5. Không chạy cả file: các lệnh reset/xóa được comment để tránh thực thi nhầm.

Người chơi không thể tự INSERT vào `body_arena_admins`. Việc ẩn nút admin ở frontend chỉ là giao diện; RLS mới là lớp thực thi quyền. Admin được sửa danh mục nhân vật, không mặc nhiên được đọc hồ sơ mọi người qua frontend. Các câu xem dữ liệu người chơi trong SQL Editor dành cho chủ dự án.

## Dữ liệu và phạm vi
- `body_arena_profiles`: biệt danh, ID nhân vật, kích thước 50–300%.
- `body_arena_progress`: điểm cao nhất, số lượt hoàn thành, cấp cao nhất và checkpoint đầu hiệp.
- `body_arena_characters`: 3 mẫu dựng sẵn và biến thể do admin thêm; chưa có cloud upload ảnh.
- `body_arena_admins`: danh sách UUID admin, chỉ sửa trong SQL Editor/backend tin cậy.
- Email do Supabase Auth quản lý, không sao chép vào bảng công khai.
- Ảnh cá nhân và file đã crop/xóa nền vẫn nằm trong trình duyệt, không tự tải lên backend.
- Không có bảng xếp hạng công khai; điểm do client gửi, chưa chống gian lận. Không dùng để trao thưởng tiền.
- Đồng bộ nhiều thiết bị đồng thời hiện theo lần lưu sau cùng. Để tránh ghi đè thành tích, bản production nên dùng RPC giao dịch để cập nhật max/counter và kiểm soát phiên chơi. Adapter mẫu chưa giải quyết xung đột đa thiết bị.
- Chưa tạo một trang quản trị hoặc UI Google login hoàn chỉnh. Đây là gói cấu hình backend để tự thêm theo yêu cầu.

## Kiểm thử sau triển khai
- Đăng nhập hai tài khoản Google A/B. A không được đọc hoặc sửa profile/progress của B, kể cả thay UUID trong request.
- Chưa đăng nhập: chỉ đọc được nhân vật enabled; không đọc hồ sơ/tiến độ/admin.
- Người chơi thường không thêm/ẩn/xóa danh mục hoặc tự cấp admin.
- Admin thấy cả mẫu ẩn và có thể bật/tắt chúng; giữ ít nhất một mẫu enabled.
- Đổi kích thước, lưu, đăng xuất/đăng nhập và kiểm tra khôi phục.
- Lưu checkpoint sau hiệp 1, mở lại trên máy khác và thử tiếp tục hiệp 2.
- Kiểm tra logout, từ chối Google consent, mất mạng khi lưu, callback sai URL và lỗi provider chưa bật.
- SQL Editor chạy bằng quyền cao nên `verify.sql` không thay thế kiểm tra RLS với JWT người chơi.

## Quy tắc làm việc
Mỗi gói cập nhật BODY ARENA cần có README mô tả thay đổi, cách chạy, kiểm thử và phần chưa hoàn tất.

## Tài liệu chính thức
- https://supabase.com/docs/guides/auth/social-login/auth-google
- https://supabase.com/docs/guides/auth/redirect-urls
- https://supabase.com/docs/guides/database/postgres/row-level-security
- https://supabase.com/docs/reference/javascript/auth-signinwithoauth
