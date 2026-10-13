# BODY ARENA — bản mẫu v1
Game giáo dục giới tính dành cho người từ 18 tuổi. Nhân vật giải phẫu cách điệu, không mô phỏng hoạt động tình dục trực diện.

## Chơi
Mở dist/index.html hoặc dùng đường dẫn đã xuất bản. Chọn nhân vật rồi vào đấu trường.
- WASD / mũi tên: di chuyển.
- Chuột: ngắm; Space hoặc giữ chuột: bắn năng lượng. Không ngắm bằng chuột thì tự ngắm đối thủ.
- E: khiên trong 2 giây, hồi chiêu 7 giây.
- Shift: lướt, hồi chiêu 3 giây.
- P: tạm dừng. Có nút cảm ứng trên màn hình nhỏ.
- Ba hiệp đấu máy. Giữa hiệp trả lời kiến thức; câu đúng thưởng điểm và hồi năng lượng.

## Xưởng nhân vật
Thêm PNG/WebP/JPEG dưới 1 MB, ẩn/hiện/xóa mẫu tự thêm. Ảnh được thu nhỏ. Xuất và nhập JSON để sao lưu. Dữ liệu lưu localStorage của trình duyệt; không đồng bộ giữa người chơi. Đây là xưởng thử nghiệm, chưa phải admin có xác thực. Mọi nhân vật có chỉ số bằng nhau.

## Phạm vi tiếp theo
Backend lưu bộ nhân vật dùng chung, xác thực và phân quyền admin, multiplayer chưa được triển khai. Xác nhận 18+ là tự khai báo, không xác minh tuổi. Không thu thập thông tin sức khỏe người chơi.

## Nguồn tham khảo
- https://www.who.int/health-topics/sexual-health
- https://www.who.int/news-room/questions-and-answers/item/condoms
- https://www.who.int/news-room/fact-sheets/detail/sexually-transmitted-infections-(stis)

## Kiểm tra
Đã kiểm tra cú pháp JavaScript. Cần thử trải nghiệm trực tiếp trên trình duyệt và điện thoại trước khi phát hành công khai. Không có thư viện bên ngoài hoặc bước build.

## Bản 1.1
- Nhân vật xoay 360 độ theo chuột; Q/R xoay thủ công, giữ hướng sau khi thả. Điện thoại có nút xoay và chạm sân để ngắm.
- Điểm xuất phát đạn trùng đầu của hình đã xoay; tia dẫn hướng hiển thị hướng bắn.
- Minh họa mặc định có sắc độ da, tạo khối và cấu trúc rõ hơn; đây vẫn là minh họa.
- Ảnh cá nhân xử lý hoàn toàn tại thiết bị. Chọn gốc và đầu trong xưởng để căn trục và điểm bắn; có thể căn lại mẫu cũ. Tệp JSON sao lưu có chứa ảnh.
- Giữ tỷ lệ ảnh trong đấu trường. Cache phiên bản 1.1 cho JS/CSS.
- Kiểm tra: node tests/geometry.cjs kiểm tra hướng bắn, gốc đạn theo góc xoay, tỷ lệ ảnh ngang, hồi chiêu. Chưa có kiểm thử trình duyệt trực tiếp.

## Bản 1.2
- Xưởng ảnh: kéo chọn vùng crop; xóa nền bằng cách chọn màu tại điểm chạm và xóa vùng liên thông; chỉnh ngưỡng màu; tẩy thủ công; hoàn tác 12 bước; khôi phục ảnh lúc mở trình sửa.
- Nền phức tạp có thể cần tẩy thủ công. Công cụ không dùng AI và không gửi ảnh ra ngoài thiết bị.
- Sau khi sửa ảnh cần chọn lại gốc và đầu. Mẫu đã lưu có thể mở Sửa ảnh.
- Thanh kích thước trong sảnh: 70–160%, thay đổi hình hiển thị, không thay đổi sát thương hay vùng trúng đòn. Ảnh PNG lưu giữ độ trong suốt.
- Mỗi hiệp thắng tăng một cấp: Vân năng lượng → Bi giáp → Giáp tinh anh. Thân lớn dần và phụ kiện giả tưởng. Cấp 3 hiện trên sân và kết quả sau hiệp cuối; chơi lại bắt đầu từ cấp 0.
- Điểm bắn tiếp tục khớp hình sau khi tăng kích thước/tiến hóa. Không mô tả can thiệp cơ thể thật.
- Kiểm tra: tests/geometry.cjs và tests/editor.cjs. Chưa kiểm thử trực tiếp trình duyệt.

## Bản 1.2.1 — kích thước
- Thanh kích thước trực tiếp trong đấu trường, đồng bộ với sảnh, giới hạn 50–300%.
- Lưu mức kích thước vào trình duyệt và khôi phục khi tải lại; nút đặt lại 100%.
- Ảnh xem trước thay đổi chiều rộng/cao trực tiếp thay vì chỉ CSS scale. Nhãn tên, thanh năng lượng và khoảng cách với mép sân điều chỉnh theo hình.
- tests/scale.cjs kiểm tra áp dụng ngay vào nhân vật, đồng bộ hai thanh điều khiển và lưu cấu hình.
