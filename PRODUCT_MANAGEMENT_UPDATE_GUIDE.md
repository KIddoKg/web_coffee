# Cập nhật Product Management - Hỗ trợ ID và Ẩn sản phẩm

## 🆕 Tính năng mới

### 1. Product ID Support
- **Database ID**: Mỗi sản phẩm có ID duy nhất từ database
- **Backward compatibility**: Vẫn giữ `key` field để tương thích
- **API updates**: Tất cả CRUD operations sử dụng ID thay vì key

### 2. Ẩn/Hiện sản phẩm (Stock Management)
- **Soft hide**: Ẩn sản phẩm khi hết hàng thay vì xóa
- **Toggle status**: Dễ dàng ẩn/hiện sản phẩm bằng một click
- **Visual indicators**: Badge hiển thị trạng thái sản phẩm
- **Filter options**: Xem tất cả hoặc chỉ sản phẩm đang hoạt động

### 3. Stock Quantity Management (Optional)
- **Auto-hide**: Tự động ẩn sản phẩm khi số lượng = 0
- **Stock tracking**: Theo dõi số lượng tồn kho
- **Triggers**: Database triggers tự động quản lý trạng thái

## 📊 Cấu trúc Database mới

### Products Table Updates
```sql
ALTER TABLE products 
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;

ALTER TABLE products 
ADD COLUMN IF NOT EXISTS stock_quantity INTEGER DEFAULT 0;

ALTER TABLE products 
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();

ALTER TABLE products 
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
```

### Triggers và Constraints
- **Auto updated_at**: Trigger tự động cập nhật timestamp
- **Auto-hide trigger**: Tự động ẩn khi stock = 0
- **Positive constraints**: Đảm bảo giá và stock không âm
- **Indexes**: Tối ưu query performance

## 🚀 API Updates

### New ProductService Methods

#### Hide/Show Products
```dart
// Ẩn sản phẩm
await ProductService.hideProduct(productId);

// Hiện sản phẩm
await ProductService.showProduct(productId);

// Toggle trạng thái
await ProductService.toggleProductStatus(productId);
```

#### Query by Status
```dart
// Lấy sản phẩm active
List<Map<String, dynamic>> activeProducts = 
    await ProductService.getProductsByStatus(isActive: true);

// Lấy sản phẩm inactive
List<Map<String, dynamic>> hiddenProducts = 
    await ProductService.getProductsByStatus(isActive: false);

// Lấy tất cả sản phẩm
List<Map<String, dynamic>> allProducts = 
    await ProductService.getProductsByStatus();
```

#### Stock Management
```dart
// Cập nhật tồn kho (tự động ẩn nếu = 0)
await ProductService.updateStock(productId, quantity);
```

#### ID-based Operations
```dart
// Lấy sản phẩm theo ID
Map<String, dynamic>? product = 
    await ProductService.getProductById(productId);

// Xóa theo ID
await ProductService.deleteProduct(productId);

// Xóa theo key (compatibility)
await ProductService.deleteProductByKey(productKey);
```

### Updated Methods
```dart
// addProduct - thêm is_active mặc định
await ProductService.addProduct(
  product: product,
  category: category,
  imageFile: imageFile,
  imageBytes: imageBytes, // Web support
  isBestSeller: true,
);

// updateProduct - hỗ trợ isActive
await ProductService.updateProduct(
  productKey: key,
  name: newName,
  price: newPrice, // double thay vì int
  isActive: true,
  isActivestock: newStock,
);
```

## 🎨 UI Improvements

### Product Management Widget
1. **Status Filter Toggle**: AppBar button để show/hide inactive products
2. **Visual Status**: Badge hiển thị "Hiển thị" / "Đã ẩn"
3. **Action Buttons**: 
   - Edit (blue)
   - Toggle visibility (orange/green)
   - Delete (red)
4. **Filter Info**: Banner hiển thị filter hiện tại

### Product Card Display
```dart
// Status badge
Container(
  decoration: BoxDecoration(
    color: isActive ? Colors.green[100] : Colors.red[100],
  ),
  child: Text(isActive ? 'Hiển thị' : 'Đã ẩn'),
)
```

## 🔄 Migration Guide

### 1. Database Migration
```bash
# Chạy script cập nhật database
psql -d your_database -f database_update_products.sql
```

### 2. Code Migration
Các API calls cũ vẫn hoạt động nhờ backward compatibility:
```dart
// Cũ (vẫn hoạt động)
await ProductService.deleteProduct(productKey);

// Mới (khuyến nghị)
await ProductService.deleteProduct(productId);
```

### 3. Model Updates
Product model đã được cập nhật với fields mới:
```dart
Product(
  id: data['id'], // Mới
  key: data['key'], // Cũ, vẫn giữ
  // ...existing fields
  isActive: data['is_active'] ?? true, // Mới
  categoryId: data['category_id'], // Mới
);
```

## 🎯 Use Cases

### 1. Quản lý hết hàng
```dart
// Khi sản phẩm hết hàng
await ProductService.hideProduct(productId);

// Khi có hàng trở lại
await ProductService.showProduct(productId);
```

### 2. Quản lý seasonal products
```dart
// Ẩn sản phẩm theo mùa
await ProductService.updateProduct(
  productKey: key,
  isActive: false,
);
```

### 3. Inventory management
```dart
// Cập nhật stock, tự động ẩn nếu hết
await ProductService.updateStock(productId, 0); // Auto-hide
await ProductService.updateStock(productId, 50); // Auto-show
```

## 📱 User Experience

### Admin Dashboard
1. **Quick Actions**: Toggle product visibility ngay từ list
2. **Visual Feedback**: Màu sắc rõ ràng cho trạng thái
3. **Smart Filtering**: Tự động filter theo status
4. **Context Aware**: Badge và tooltip informatove

### Performance
1. **Indexed Queries**: Fast filtering by status
2. **Soft Delete**: Không mất dữ liệu lịch sử
3. **Batch Operations**: Có thể extend cho bulk hide/show

## 🔧 Configuration

### Enable Stock Auto-Hide
Set trong database trigger (đã included):
```sql
-- Trigger tự động ẩn khi stock = 0
CREATE TRIGGER trigger_auto_hide_out_of_stock 
    BEFORE UPDATE OF stock_quantity ON products
    FOR EACH ROW EXECUTE FUNCTION auto_hide_out_of_stock();
```

### Disable Auto-Hide (nếu cần)
```sql
DROP TRIGGER IF EXISTS trigger_auto_hide_out_of_stock ON products;
```

## 🚨 Lưu ý quan trọng

1. **Backup Database**: Luôn backup trước khi migrate
2. **Test Environment**: Test trên staging trước production
3. **ID vs Key**: Prefer sử dụng ID cho operations mới
4. **Soft Delete**: Sản phẩm ẩn vẫn tồn tại trong database
5. **Performance**: Monitor query performance với tables lớn

## 🐛 Troubleshooting

### Lỗi thường gặp
1. **"Column 'is_active' does not exist"**: Chưa chạy migration script
2. **"Method not found"**: Cần update ProductService import
3. **"ID null"**: Sản phẩm cũ chưa có ID, dùng key fallback

### Debug Commands
```dart
// Kiểm tra product có ID không
final product = await ProductService.getProductById(id);
debugPrint('Product: $product');

// Kiểm tra status
final activeProducts = await ProductService.getProductsByStatus(isActive: true);
debugPrint('Active products: ${activeProducts.length}');
```

## 📈 Future Enhancements

1. **Bulk Operations**: Hide/show multiple products
2. **Stock Alerts**: Notification khi sắp hết hàng
3. **Analytics**: Thống kê sản phẩm hidden/active
4. **Scheduled Hide**: Tự động ẩn theo thời gian
5. **Category-based Rules**: Rules ẩn theo category
