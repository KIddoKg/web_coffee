# BLOG MANAGEMENT GUIDE - Hướng dẫn quản lý Blog

## Tổng quan
Hệ thống blog đã được cập nhật để hỗ trợ đa ngôn ngữ (Tiếng Việt và Tiếng Anh) với các tính năng quản lý nâng cao.

## Cấu trúc Database

### Bảng `blogs`
```sql
- id (SERIAL): ID tự động tăng
- title (TEXT): Tiêu đề tiếng Việt (bắt buộc)
- main_detail (TEXT): Nội dung chính tiếng Việt (bắt buộc)
- sub_detail (TEXT): Nội dung phụ tiếng Việt (tùy chọn)
- link_img (TEXT): Link ảnh minh họa (tùy chọn)
- order (INTEGER): Thứ tự sắp xếp (mặc định 0)

-- Các cột tiếng Anh (tùy chọn)
- title_en (TEXT): Tiêu đề tiếng Anh
- main_detail_en (TEXT): Nội dung chính tiếng Anh
- sub_detail_en (TEXT): Nội dung phụ tiếng Anh

-- Metadata
- created_at (TIMESTAMP): Thời gian tạo
- updated_at (TIMESTAMP): Thời gian cập nhật (tự động)
```

## Các tính năng chính

### 1. Quản lý đa ngôn ngữ
- **Tiếng Việt**: Bắt buộc cho mọi bài viết
- **Tiếng Anh**: Tùy chọn, có thể thêm sau
- Hiển thị badge ngôn ngữ trên giao diện quản lý

### 2. Sắp xếp thứ tự (Drag & Drop)
- Kéo thả để thay đổi thứ tự bài viết
- **ID Swapping**: Thay đổi ID để lưu thứ tự vĩnh viễn
- Nút **Save** để lưu thay đổi
- Nút **Reset** để hủy thay đổi
- Animation mượt mà khi kéo thả

### 3. Upload ảnh
- Hỗ trợ upload ảnh lên Supabase Storage
- Bucket: `blog-images`
- Xem trước ảnh trực tiếp trong form
- Validation URL ảnh

## Hướng dẫn sử dụng

### Setup Database
1. **Tạo mới**: Chạy `database_setup_blogs.sql`
2. **Update hiện có**: Chạy `database_update_blogs.sql`
3. **Setup đầy đủ**: Database đã được bao gồm trong `lib/services/supabase/database_setup.sql`

### Tạo bài viết mới
1. Điền thông tin tiếng Việt (bắt buộc)
2. Toggle "Thêm phiên bản tiếng Anh" nếu cần
3. Upload ảnh (tùy chọn)
4. Submit để tạo bài viết

### Quản lý thứ tự
1. Vào trang Blog Management
2. Kéo thả bài viết để sắp xếp
3. Nhấn **Save Changes** để lưu
4. Nhấn **Reset Changes** để hủy

### Chỉnh sửa bài viết
1. Click vào bài viết cần sửa
2. Update nội dung
3. Có thể thêm/xóa phiên bản tiếng Anh
4. Save để lưu thay đổi

## Model Structure

### BlogModel Class
```dart
class BlogModel {
  final int id;
  final String title;           // Tiếng Việt (bắt buộc)
  final String mainDetail;      // Tiếng Việt (bắt buộc)
  final String? subDetail;      // Tiếng Việt (tùy chọn)
  final String? linkImg;
  final int order;
  
  // English version (tùy chọn)
  final String? titleEn;
  final String? mainDetailEn;
  final String? subDetailEn;
  
  // Helper methods
  String getTitle(String language);        // Lấy title theo ngôn ngữ
  String getMainDetail(String language);   // Lấy nội dung theo ngôn ngữ
  String? getSubDetail(String language);   // Lấy mô tả theo ngôn ngữ
  bool get hasEnglishVersion;              // Kiểm tra có bản tiếng Anh
}
```

## API Methods

### BlogService
```dart
// CRUD operations
Future<List<BlogModel>> getBlogs()
Future<BlogModel> addBlog({...})
Future<BlogModel> updateBlog(BlogModel blog)
Future<void> deleteBlog(int id)

// Search với đa ngôn ngữ
Future<List<BlogModel>> searchBlogs(String query, {String? language})

// Quản lý thứ tự
Future<void> swapBlogIds(int id1, int id2)
Future<void> moveBlogUpPermanent(int blogId)
Future<void> moveBlogDownPermanent(int blogId)
Future<void> saveBlogOrder(List<BlogModel> blogs)
```

## UI Components

### AddBlogWidget
- Form tạo bài viết mới
- Toggle hiển thị các trường tiếng Anh
- Upload và preview ảnh
- Validation form

### BlogManagementWidget
- Danh sách bài viết với drag & drop
- Badge hiển thị ngôn ngữ có sẵn
- Nút Save/Reset changes
- Animation khi di chuyển

## Lưu ý kỹ thuật

### Database Constraints
- `title` và `main_detail` bắt buộc (NOT NULL)
- `order` có default = 0
- Các cột tiếng Anh có thể NULL
- Auto-increment ID
- Timestamp tự động update

### Performance
- Index trên `order`, `title`, `title_en`, `created_at`
- RLS policies cho security
- Efficient search với đa ngôn ngữ

### Storage
- Bucket `blog-images` cho ảnh blog
- Public read access
- Authenticated write access
- Automatic image optimization

## Migration Notes
Nếu đã có bảng blog cũ:
1. Backup dữ liệu hiện có
2. Chạy `database_update_blogs.sql`
3. Kiểm tra index và policies
4. Test các chức năng mới

## Troubleshooting

### Lỗi thường gặp
1. **Permission denied**: Kiểm tra RLS policies
2. **Upload failed**: Kiểm tra storage bucket permissions
3. **Order không save**: Kiểm tra method `saveBlogOrder`
4. **Null safety error**: Kiểm tra validation form

### Debug
- Kiểm tra logs trong Supabase Dashboard
- Sử dụng Flutter Inspector cho UI issues
- Test API calls trong Postman/curl
