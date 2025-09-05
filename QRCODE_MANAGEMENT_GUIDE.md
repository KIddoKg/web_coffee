# Hướng dẫn quản lý QR Code

## Tổng quan
Hệ thống quản lý QR Code cho phép admin tạo, quản lý và xóa các mã QR với các tính năng sau:

## Cơ sở dữ liệu
- **Bảng**: `qrcodes`
- **Cột**:
  - `id`: ID tự tăng (SERIAL PRIMARY KEY)
  - `color`: Mã màu (VARCHAR(20)) - có thể là hex code như #FF0000 hoặc tên màu
  - `image_url`: Link ảnh QR code được lưu trên Supabase Storage (TEXT)
  - `link_url`: Link mà QR code trỏ tới (TEXT NOT NULL)
  - `created_at`: Thời gian tạo (TIMESTAMP WITH TIME ZONE)
  - `updated_at`: Thời gian cập nhật (TIMESTAMP WITH TIME ZONE)

## Tính năng chính

### 1. Thêm QR Code mới
- **Đường dẫn**: Admin Dashboard → Quản lý QR Code → Nút (+)
- **Thông tin cần nhập**:
  - Link URL (bắt buộc): Link mà QR code sẽ trỏ tới
  - Màu (tuỳ chọn): Có thể nhập hex code (#FF0000) hoặc tên màu
  - Ảnh QR Code (tuỳ chọn): Chọn ảnh từ gallery, tự động upload lên Supabase Storage

### 2. Xem danh sách QR Codes
- Hiển thị tất cả QR codes đã tạo
- Thông tin hiển thị: ID, ảnh thumbnail, link URL, màu, thời gian tạo
- Tìm kiếm theo link URL
- Thống kê tổng số QR codes

### 3. Xem chi tiết QR Code
- Nhấn nút "Xem chi tiết" (👁️)
- Hiển thị:
  - Ảnh QR code đầy đủ
  - Link URL (có thể copy)
  - Màu sắc với preview
  - Thời gian tạo
- Nút "Copy Link" để copy URL vào clipboard

### 4. Xóa QR Code
- Nhấn nút "Xóa" (🗑️)
- Xác nhận trước khi xóa
- Tự động xóa ảnh từ Supabase Storage
- Không thể hoàn tác

## Lưu trữ ảnh
- **Bucket**: `product-images` (bucket chung)
- **Folder**: `qr/` (folder con dành riêng cho QR codes)
- **Định dạng tên file**: `qr_{timestamp}_{tên_file_gốc}`
- **Hỗ trợ định dạng**: PNG, JPG, JPEG
- **Kích thước tối đa**: Tùy theo cấu hình ImagePicker (hiện tại: 1024x1024, quality 85%)

## API Service Methods

### QRCodeService
```dart
// Thêm QR code mới
static Future<QRCodeModel> addQRCode({
  required String linkUrl,
  String? color,
  String? imageUrl,
})

// Thêm QR code với ảnh
static Future<QRCodeModel> addQRCodeWithImage({
  required String linkUrl,
  required String fileName,
  required Uint8List fileBytes,
  String? color,
})

// Lấy tất cả QR codes
static Future<List<QRCodeModel>> getAllQRCodes()

// Lấy QR code theo ID
static Future<QRCodeModel?> getQRCodeById(int id)

// Cập nhật QR code
static Future<QRCodeModel> updateQRCode({
  required int id,
  String? color,
  String? imageUrl,
  String? linkUrl,
})

// Xóa QR code
static Future<void> deleteQRCode(int id)

// Tìm kiếm QR codes
static Future<List<QRCodeModel>> searchQRCodes(String query)

// Upload ảnh
static Future<String> uploadQRCodeImage({
  required String fileName,
  required Uint8List fileBytes,
})

// Xóa ảnh
static Future<void> deleteQRCodeImage(String imageUrl)
```

## Cách sử dụng

### Bước 1: Tạo bảng database
Chạy script SQL trong file `database_setup_qrcodes.sql`:
```sql
-- Tạo bảng qrcodes với các trigger tự động cập nhật timestamp
```

### Bước 2: Truy cập tính năng
1. Đăng nhập Admin Dashboard
2. Chọn "Quản lý QR Code"
3. Sử dụng các tính năng như mô tả ở trên

### Bước 3: Thêm QR Code mới
1. Nhấn nút (+) ở góc dưới bên phải
2. Nhập Link URL (bắt buộc)
3. Nhập màu (tuỳ chọn)
4. Chọn ảnh QR code (tuỳ chọn)
5. Nhấn "Thêm QR Code"

## Lưu ý kỹ thuật
- Sử dụng ImagePicker thay vì FilePicker để tương thích tốt hơn
- Tự động xóa ảnh cũ khi xóa QR code
- Có validation cho URL format
- Hỗ trợ hex color code và tên màu
- Responsive design cho mobile và web
- Có loading states và error handling
- Copy to clipboard functionality

## Troubleshooting
1. **Lỗi upload ảnh**: Kiểm tra quyền Supabase Storage
2. **Lỗi tạo QR code**: Kiểm tra format URL
3. **Lỗi không hiển thị ảnh**: Kiểm tra URL và bucket policy
4. **Lỗi xóa**: Kiểm tra foreign key constraints (nếu có)

## Mở rộng tương lai
- Thêm tính năng edit QR code
- Thêm bulk operations (xóa nhiều cùng lúc)
- Thêm category/tag cho QR codes
- Thêm analytics/tracking clicks
- Export QR codes to PDF/CSV
- QR code generator tích hợp
