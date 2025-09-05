# Hệ thống quản lý Categories và Products

## Tính năng mới

### 1. Quản lý Categories
- **Thêm danh mục**: Tạo danh mục mới với tên và mô tả
- **Sửa danh mục**: Cập nhật thông tin danh mục
- **Ẩn/Hiện danh mục**: Soft delete - ẩn danh mục thay vì xóa
- **Xóa danh mục**: Xóa vĩnh viễn (chỉ khi không có sản phẩm nào)
- **Kiểm tra tên trùng**: Tự động kiểm tra tên danh mục không bị trùng

### 2. Cải tiến quản lý Products
- **Liên kết với categories**: Sản phẩm được liên kết với categories từ database
- **Hỗ trợ web compatibility**: Upload ảnh hoạt động trên cả web và mobile
- **Trạng thái sản phẩm**: Quản lý trạng thái active/inactive
- **Best seller flag**: Đánh dấu sản phẩm bán chạy

## Cấu trúc Database

### Bảng Categories
```sql
categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
)
```

### Bảng Products (cập nhật)
```sql
products (
    id SERIAL PRIMARY KEY,
    key INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    country VARCHAR(100),
    price DECIMAL(10,2),
    image_url TEXT,
    image_path TEXT,
    category VARCHAR(100), -- Để backward compatibility
    category_id INTEGER REFERENCES categories(id), -- Liên kết mới
    is_best_seller BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
)
```

## Cách sử dụng

### 1. Thiết lập Database
1. Chạy script `database_setup_categories.sql` trong Supabase SQL Editor
2. Script sẽ tự động:
   - Tạo bảng categories
   - Thêm cột category_id vào bảng products
   - Insert các danh mục mặc định
   - Tạo các index cần thiết
   - Tạo trigger cho updated_at

### 2. Sử dụng trong App

#### Quản lý Categories
```dart
// Vào Admin Dashboard > Quản lý Danh mục
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const CategoryManagementWidget(),
  ),
);
```

#### API Categories
```dart
// Lấy tất cả categories
List<Category> categories = await CategoryService.getAllCategories();

// Lấy chỉ categories đang active
List<Category> activeCategories = await CategoryService.getAllCategories(isActive: true);

// Thêm category mới
Category newCategory = await CategoryService.addCategory(
  name: 'Trà thảo mộc',
  description: 'Các loại trà từ thảo mộc tự nhiên',
  isActive: true,
);

// Cập nhật category
Category updatedCategory = await CategoryService.updateCategory(
  id: 1,
  name: 'Cà phê đặc biệt',
  description: 'Các loại cà phê cao cấp',
);

// Ẩn category (soft delete)
await CategoryService.hideCategory(1);

// Hiện category
await CategoryService.showCategory(1);

// Xóa vĩnh viễn (chỉ khi không có sản phẩm)
await CategoryService.deleteCategory(1);
```

#### API Products (cập nhật)
```dart
// Thêm product với image bytes (web compatibility)
await ProductService.addProduct(
  product: product,
  category: 'Đồ uống cà phê',
  imageBytes: selectedImageBytes, // Cho web
  imageFile: selectedImageFile,   // Cho mobile
  isBestSeller: true,
);

// Cập nhật product
await ProductService.updateProduct(
  productKey: 123,
  name: 'Cà phê sữa đá',
  price: 25000,
  newImageBytes: imageBytes, // Cho web
  newImageFile: imageFile,   // Cho mobile
);
```

## Tính năng Web Compatibility

### Image Upload
- **Mobile**: Sử dụng `File` object từ ImagePicker
- **Web**: Sử dụng `Uint8List` bytes từ ImagePicker
- **Display**: Tự động chọn `Image.file()` hoặc `Image.memory()` dựa trên platform

### Platform Detection
```dart
if (kIsWeb) {
  // Web-specific code
  _selectedImageBytes = await image.readAsBytes();
  return Image.memory(_selectedImageBytes!);
} else {
  // Mobile-specific code
  _selectedImageFile = File(image.path);
  return Image.file(_selectedImageFile!);
}
```

## Luồng dữ liệu

1. **Categories**: Database → CategoryService → UI
2. **Products**: Database → ProductService → UI
3. **Images**: ImagePicker → SupabaseStorage → Database URL

## Kiểm tra và Debug

### Kiểm tra Categories
```dart
// Kiểm tra số lượng sản phẩm theo category
Map<int, int> productCounts = await CategoryService.getProductCountByCategory();

// Kiểm tra tên category có trùng không
bool exists = await CategoryService.isCategoryNameExists('Cà phê');
```

### Debug Console
- Tất cả operations đều có debug logging
- Kiểm tra console để xem thông tin chi tiết

## Migration từ hệ thống cũ

1. **Dữ liệu categories cũ**: Script sẽ tự động map từ cột `category` sang `category_id`
2. **Backward compatibility**: Cột `category` vẫn được giữ lại
3. **Gradual migration**: Có thể chuyển đổi từng phần mà không ảnh hưởng hệ thống

## Lưu ý quan trọng

1. **Xóa categories**: Chỉ có thể xóa vĩnh viễn khi không có sản phẩm nào sử dụng
2. **Web images**: Cần test kỹ trên cả web và mobile
3. **Database backup**: Luôn backup trước khi chạy migration scripts
4. **Performance**: Categories được cache, products load theo pagination

## Troubleshooting

### Lỗi thường gặp
1. **"Category name already exists"**: Tên danh mục bị trùng
2. **"Cannot delete category"**: Còn sản phẩm đang sử dụng
3. **"Image.file not supported on web"**: Đã fix bằng platform detection

### Debug steps
1. Kiểm tra console logs
2. Verify database connection
3. Check Supabase permissions
4. Test với dữ liệu nhỏ trước
