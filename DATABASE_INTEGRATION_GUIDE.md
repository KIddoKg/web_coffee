# DATABASE INTEGRATION GUIDE
# Hướng dẫn tích hợp Database cho Coffee Shop App

## 📋 Tổng quan
Đã tích hợp thành công hệ thống lấy dữ liệu danh mục và sản phẩm từ Supabase database.

## 🗄️ Cấu trúc Database

### Bảng Categories
```sql
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Bảng Products  
```sql
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    name_english VARCHAR(255),
    country VARCHAR(100) NOT NULL DEFAULT 'Vietnam',
    price NUMERIC(10,2) NOT NULL,
    image_url TEXT,
    image_path TEXT,
    category VARCHAR(100) NOT NULL,
    category_id INTEGER REFERENCES categories(id),
    is_best_seller BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    stock_quantity INTEGER DEFAULT 0,
    amount INTEGER DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## 🚀 Cách sử dụng

### 1. Khởi tạo Database
```bash
# Chạy script setup database
psql -d your_database -f database_setup_categories.sql
psql -d your_database -f update_products_table.sql
```

### 2. Sử dụng trong App

#### Load dữ liệu tự động
```dart
// HomeScreenVm đã được cập nhật để tự động load dữ liệu khi init()
final vm = Provider.of<HomeScreenVm>(context);
vm.init(); // Sẽ tự động load categories và products từ database
```

#### Refresh dữ liệu
```dart
// Refresh toàn bộ dữ liệu
await vm.refreshData();

// Load sản phẩm theo filter
await vm.selectFilter(1); // Sẽ tự động load từ database nếu chưa có
```

#### Truy cập dữ liệu
```dart
// Lấy danh sách categories
List<Category> categories = vm.categories;

// Lấy tất cả products
List<Product> products = vm.allProducts;

// Lấy products theo filter hiện tại
List<Product> currentProducts = vm.currentProducts;

// Check loading state
bool isLoading = vm.isLoadingProducts || vm.isLoadingCategories;

// Check error
String? error = vm.errorMessage;
```

### 3. Active Filter Logic
**Quan trọng**: Chỉ những categories và products có `is_active = true` mới được hiển thị.

```dart
// Categories không active sẽ không xuất hiện trong filters
// Products không active sẽ bị loại bỏ khỏi danh sách hiển thị
// Best seller products cũng phải có is_active = true mới hiển thị

// Khi category bị set is_active = false:
// - Filter tương ứng sẽ biến mất khỏi filter tabs
// - Tất cả products trong category đó sẽ không hiển thị

// Khi product bị set is_active = false:
// - Product sẽ biến mất khỏi tất cả filter views
// - Kể cả trong best seller nếu product đó là best seller
```

## 🛠️ Services API

### CategoryService
```dart
// Lấy tất cả categories
List<Category> categories = await CategoryService.getAllCategories();

// Lấy categories active
List<Category> activeCategories = await CategoryService.getAllCategories(isActive: true);

// Thêm category mới
Category category = await CategoryService.addCategory(
  name: 'New Category',
  description: 'Category description',
  isActive: true,
);

// Cập nhật category
Category updated = await CategoryService.updateCategory(
  id: 1,
  name: 'Updated Name',
  isActive: false,
);
```

### ProductService
```dart
// Lấy tất cả products
List<Map<String, dynamic>> products = await ProductService.getAllProducts();

// Lấy products theo category
List<Map<String, dynamic>> categoryProducts = 
    await ProductService.getProductsByCategory('Trà sữa');

// Lấy best seller products
List<Map<String, dynamic>> bestSellers = 
    await ProductService.getBestSellerProducts();

// Thêm product mới
await ProductService.addProduct(
  product: product,
  category: 'Trà sữa',
  imageAssetPath: 'assets/images/product.png',
  isBestSeller: false,
);

// Cập nhật product
await ProductService.updateProduct(
  productId: 1,
  name: 'New Name',
  price: 25000,
  isActive: true,
);
```

### 3. Test Active Filter
```dart
// Sử dụng TestActiveFilter widget để test logic
Navigator.push(context, MaterialPageRoute(
  builder: (context) => TestActiveFilter(),
));
```

## 🔧 Testing & Admin

### 1. Test Database Connection
```dart
// Sử dụng TestDatabaseSync widget
Navigator.push(context, MaterialPageRoute(
  builder: (context) => TestDatabaseSync(),
));
```

### 2. Admin Dashboard
```dart
// Sử dụng AdminDatabaseScreen
Navigator.push(context, MaterialPageRoute(
  builder: (context) => AdminDatabaseScreen(),
));
```

### 3. Test Active Filter Logic
```dart
// Test active/inactive logic
Navigator.push(context, MaterialPageRoute(
  builder: (context) => TestActiveFilter(),
));
```

### 3. Sync dữ liệu hardcode lên Database
```dart
// Chỉ chạy 1 lần để tạo categories mặc định
await vm.syncHardcodedDataToDatabase();
```

## 📱 UI Updates

### Loading States
- Widget sẽ hiển thị CircularProgressIndicator khi đang load
- Error message sẽ hiển thị nếu có lỗi
- Refresh button để tải lại dữ liệu

### Error Handling
- Tất cả lỗi được catch và hiển thị trong UI
- User có thể retry bằng cách nhấn "Thử lại"

## 🗂️ File Structure
```
lib/
├── models/
│   ├── category_model.dart      # Category model
│   └── product_model.dart       # Product model
├── services/supabase/
│   ├── category_service.dart    # Category CRUD operations
│   ├── product_service.dart     # Product CRUD operations
│   └── services_supabase.dart   # Base Supabase service
├── screens/home/
│   ├── viewModel/
│   │   └── home_screen_vm.dart  # Updated với database integration
│   └── widgets/
│       └── all_product_widget.dart # Updated với loading/error states
├── test_database_sync.dart      # Test widget
├── admin_database_screen.dart   # Admin interface
└── test_active_filter.dart      # Test active filter logic
```

## ⚠️ Lưu ý quan trọng

1. **Database Setup**: Đảm bảo đã chạy script setup database trước khi sử dụng
2. **Supabase Config**: Cần cấu hình Supabase credentials trong services_supabase.dart
3. **First Run**: Chạy syncHardcodedDataToDatabase() một lần để tạo categories mặc định
4. **Performance**: Dữ liệu được cache trong memory, chỉ load từ DB khi cần thiết
5. **Error Handling**: Luôn có fallback UI cho trường hợp lỗi network/database

## 🎯 Next Steps

1. **Image Upload**: Implement upload ảnh sản phẩm lên Supabase Storage
2. **Real-time Updates**: Thêm real-time subscription cho updates
3. **Caching**: Implement local caching với SharedPreferences/Hive
4. **Search**: Thêm tính năng search products
5. **Pagination**: Thêm pagination cho danh sách sản phẩm lớn

## 🐛 Troubleshooting

### Database Connection Issues
- Kiểm tra Supabase URL và API key
- Đảm bảo bảng đã được tạo đúng schema
- Check network connectivity

### No Data Loading
- Chạy TestDatabaseSync để kiểm tra connection
- Verify database có dữ liệu
- Check console logs cho error details

### Performance Issues
- Implement pagination nếu có quá nhiều products
- Optimize query với proper indexing
- Consider caching strategies
