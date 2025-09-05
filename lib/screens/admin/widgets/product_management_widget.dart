import 'package:flutter/material.dart';
import 'package:xanh_coffee/helper/helper.dart';
import 'package:xanh_coffee/share/app_imports.dart';
import 'package:xanh_coffee/share/size_configs.dart';
import 'add_product_form_widget.dart';
import '../../../services/supabase/product_service.dart';
import '../../../services/supabase/category_service.dart';
import '../../home/model/category_model.dart';

class ProductManagementWidget extends StatefulWidget {
  const ProductManagementWidget({super.key});

  @override
  State<ProductManagementWidget> createState() =>
      _ProductManagementWidgetState();
}

class _ProductManagementWidgetState extends State<ProductManagementWidget> {
  String? _selectedCategory;
  List<Map<String, dynamic>> _products = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _showInactiveProducts = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = 'Tất cả';
    _loadCategories();
    _loadProducts();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await CategoryService.getAllCategories(isActive: true);
      setState(() {
        _categories = [
          Category(id: 0, name: 'Tất cả', isActive: true),
          ...categories.where((cat) => cat.isActive), // Chỉ lấy danh mục active
        ];
      });
    } catch (e) {
      debugPrint('Lỗi tải danh mục: $e');
      // Fallback to default categories if API fails
      setState(() {
        _categories = [
          Category(id: 0, name: 'Tất cả', isActive: true),
        ];
      });
    }
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_selectedCategory == 'Tất cả') {
        if (_showInactiveProducts) {
          // Hiển thị tất cả sản phẩm (cả active và inactive)
          _products = await ProductService.getAllProducts();
        } else {
          // Chỉ hiển thị sản phẩm active và thuộc danh mục active
          final allProducts =
              await ProductService.getProductsByStatus(isActive: true);

          // Lấy danh sách tên các danh mục đang active (trừ "Tất cả")
          final activeCategoryNames = _categories
              .where((cat) => cat.isActive && cat.name != 'Tất cả')
              .map((cat) => cat.name)
              .toSet();

          // Lọc sản phẩm chỉ thuộc các danh mục đang active
          _products = allProducts
              .where((product) =>
                  activeCategoryNames.contains(product['category']))
              .toList();
        }
      } else {
        // Filter theo category và status
        final allCategoryProducts =
            await ProductService.getProductsByCategory(_selectedCategory!);
        if (_showInactiveProducts) {
          _products = allCategoryProducts;
        } else {
          _products = allCategoryProducts
              .where((product) => product['is_active'] ?? true)
              .toList();
        }
      }

      // Sắp xếp: Best Seller lên đầu, sau đó sản phẩm inactive lên trước active
      _products.sort((a, b) {
        final aIsBestSeller = a['is_best_seller'] ?? false;
        final bIsBestSeller = b['is_best_seller'] ?? false;
        final aIsActive = a['is_active'] ?? true;
        final bIsActive = b['is_active'] ?? true;

        // 1. Best Seller lên đầu
        if (aIsBestSeller != bIsBestSeller) {
          return aIsBestSeller ? -1 : 1;
        }

        // 2. Nếu đang hiển thị sản phẩm đã ẩn, inactive lên trước active
        if (_showInactiveProducts && aIsActive != bIsActive) {
          return aIsActive ? 1 : -1;
        }

        // 3. Nếu cùng trạng thái thì sắp xếp theo tên
        return (a['name'] ?? '').compareTo(b['name'] ?? '');
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi tải sản phẩm: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteProduct(int productId, String productName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
              'Bạn có chắc chắn muốn xóa sản phẩm "$productName"?\n\nHành động này không thể hoàn tác!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await ProductService.deleteProduct(productId);
        _showSuccess('Đã xóa sản phẩm "$productName"');
        _loadProducts(); // Reload list
      } catch (e) {
        _showError('Lỗi xóa sản phẩm: $e');
      }
    }
  }

  Future<void> _toggleProductStatus(
      int productId, bool currentStatus, String productName) async {
    try {
      await ProductService.toggleProductStatus(productId);
      final newStatus = !currentStatus;
      _showSuccess('Đã ${newStatus ? 'hiện' : 'ẩn'} sản phẩm "$productName"');
      _loadProducts(); // Reload list
    } catch (e) {
      _showError('Lỗi thay đổi trạng thái sản phẩm: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppStyle.primaryGreen_0_81_49
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final width = SizeConfig.screenWidth!;
    final height = SizeConfig.screenHeight!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Sản phẩm'),
        backgroundColor: AppStyle.primaryGreen_0_81_49,
        foregroundColor: Colors.white,
        actions: [
          // Toggle show inactive products
          if(_selectedCategory == "Tất cả")
          IconButton(
            onPressed: () {
              setState(() {
                _showInactiveProducts = !_showInactiveProducts;
              });
              _loadProducts();
            },
            icon: Icon(_showInactiveProducts
                ? Icons.visibility_off
                : Icons.visibility),
            tooltip: _showInactiveProducts
                ? 'Ẩn sản phẩm đã tắt'
                : 'Hiện sản phẩm đã tắt',
          ),
          IconButton(
            onPressed: _loadProducts,
            icon: const Icon(Icons.refresh),
            tooltip: 'Tải lại',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (context) => const AddProductFormWidget(),
            ),
          );

          if (result == true) {
            _loadProducts(); // Reload list if product was added
          }
        },
        backgroundColor: AppStyle.primaryGreen_0_81_49,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: AppStyle.padding_LR_16().copyWith(
            left: width < 1200 ? 0 : width * 0.15,
            right: width < 1200 ? 0 : width * 0.15),
        child: Column(
          children: [
            // Filter info
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[50],
              child: Row(
                children: [
                  Icon(
                    _showInactiveProducts
                        ? Icons.visibility
                        : Icons.visibility_off,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _showInactiveProducts
                        ? 'Hiển thị tất cả sản phẩm (cả đã ẩn)'
                        : 'Chỉ hiển thị sản phẩm đang hoạt động',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Category filter
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    'Danh mục: ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButton<String>(
                      iconEnabledColor: AppStyle.primaryGreen_0_81_49.withOpacity(0.1),
                      value: _selectedCategory,
                      isExpanded: true,

                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category.name,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                        _loadProducts();
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Error message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border.all(color: Colors.red[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red[800]),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                        });
                      },
                      icon: const Icon(Icons.close),
                      color: Colors.red[600],
                    ),
                  ],
                ),
              ),

            // Products list
            Expanded(
              child: _buildProductsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsList() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải sản phẩm...'),
          ],
        ),
      );
    }

    if (_products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _selectedCategory == 'Tất cả'
                  ? 'Chưa có sản phẩm nào'
                  : 'Chưa có sản phẩm nào trong danh mục này',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (context) => AddProductFormWidget(
                      existingCategory: _selectedCategory != 'Tất cả' &&
                              _categories.isNotEmpty
                          ? _selectedCategory
                          : null,
                    ),
                  ),
                );

                if (result == true) {
                  _loadProducts();
                }
              },
              icon: const Icon(Icons.add,color: Colors.white,),
              label: const Text('Thêm sản phẩm đầu tiên'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.primaryGreen_0_81_49,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final isActive = product['is_active'] ?? true;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color:
          isActive ? null : Colors.grey[100], // Màu xám cho sản phẩm inactive
      child: Opacity(
        opacity: isActive ? 1.0 : 0.6, // Làm mờ sản phẩm inactive
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Product Image
              Container(
                width: 100,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: isActive ? Colors.grey[300]! : Colors.grey[400]!),
                ),
                child: Padding(
                  padding: AppStyle.padding_TB_8(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: product['image_url'] != null
                        ? ColorFiltered(
                            colorFilter: isActive
                                ? const ColorFilter.mode(
                                    Colors.transparent, BlendMode.multiply)
                                : ColorFilter.mode(
                                    Colors.grey[400]!, BlendMode.saturation),
                            child: Image.network(
                              product['image_url'],
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.coffee,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] ?? 'N/A',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.black : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Giá: ${double.parse(product['price'].toString()).toCurrency()}',
                      style: TextStyle(
                        fontSize: 14,
                        color: isActive ? AppStyle.primaryGreen_0_81_49 : Colors.grey[500],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Danh mục: ${product['category'] ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (product['is_best_seller'] == true) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.orange[100]
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Best Seller',
                              style: TextStyle(
                                fontSize: 10,
                                color: isActive
                                    ? Colors.orange[800]
                                    : Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isActive ? AppStyle.primaryGreen_0_81_49.withOpacity(0.1) : Colors.red[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isActive ? 'Hiển thị' : 'Đã ẩn',
                            style: TextStyle(
                              fontSize: 10,
                              color: isActive
                                  ? AppStyle.primaryGreen_0_81_49
                                  : Colors.red[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              Column(
                children: [
                  // Edit button
                  IconButton(
                    onPressed: () async {
                      // Convert to Product model for editing
                      final productModel =
                          ProductService.fromSupabaseData(product);

                      final result = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (context) => AddProductFormWidget(
                            existingProduct: productModel,
                            existingCategory: product['category'],
                          ),
                        ),
                      );

                      if (result == true) {
                        _loadProducts(); // Reload list
                      }
                    },
                    icon: const Icon(Icons.edit),
                    color: isActive ? AppStyle.primaryGreen_0_81_49 : Colors.grey[500],
                    tooltip: 'Chỉnh sửa',
                  ),

                  // Toggle status button
                  IconButton(
                    onPressed: () => _toggleProductStatus(
                      product['id'],
                      isActive,
                      product['name'] ?? 'N/A',
                    ),
                    icon: Icon(
                        isActive ? Icons.visibility_off : Icons.visibility),
                    color: isActive ? Colors.orange[600] : AppStyle.primaryGreen_0_81_49,
                    tooltip: isActive ? 'Ẩn sản phẩm' : 'Hiện sản phẩm',
                  ),

                  // Delete button
                  IconButton(
                    onPressed: () => _deleteProduct(
                      product['id'] ?? 0, // Use ID instead of key
                      product['name'] ?? 'N/A',
                    ),
                    icon: const Icon(Icons.delete),
                    color: isActive ? Colors.red[600] : Colors.grey[500],
                    tooltip: 'Xóa',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
