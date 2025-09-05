import 'package:flutter/material.dart';
import 'package:xanh_coffee/share/size_configs.dart';
import '../../../services/supabase/category_service.dart';
import '../../../share/app_styles.dart';
import '../../home/model/category_model.dart';
import 'category_form_widget.dart';

class CategoryManagementWidget extends StatefulWidget {
  const CategoryManagementWidget({super.key});

  @override
  State<CategoryManagementWidget> createState() =>
      _CategoryManagementWidgetState();
}

class _CategoryManagementWidgetState extends State<CategoryManagementWidget> {
  List<Category> _categories = [];
  Map<int, int> _productCounts = {};
  bool _isLoading = false;
  String? _errorMessage;
  bool _showInactiveCategories = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadProductCounts();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _categories = await CategoryService.getAllCategories(
        isActive: _showInactiveCategories ? null : true,
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi tải danh sách danh mục: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadProductCounts() async {
    try {
      _productCounts = await CategoryService.getProductCountByCategory();
      setState(() {});
    } catch (e) {
      debugPrint('Lỗi tải số lượng sản phẩm: $e');
    }
  }

  Future<void> _toggleCategoryStatus(Category category) async {
    try {
      if (category.isActive) {
        await CategoryService.hideCategory(category.id);
        _showSuccess('Đã ẩn danh mục "${category.name}"');
      } else {
        await CategoryService.showCategory(category.id);
        _showSuccess('Đã hiện danh mục "${category.name}"');
      }
      _loadCategories();
    } catch (e) {
      _showError('Lỗi thay đổi trạng thái: $e');
    }
  }

  Future<void> _deleteCategory(Category category) async {
    final productCount = _productCounts[category.id] ?? 0;

    if (productCount > 0) {
      _showError(
          'Không thể xóa danh mục vì còn có $productCount sản phẩm đang sử dụng');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
              'Bạn có chắc chắn muốn xóa danh mục "${category.name}"?\n\nHành động này không thể hoàn tác!'),
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
        await CategoryService.deleteCategory(category.id);
        _showSuccess('Đã xóa danh mục "${category.name}"');
        _loadCategories();
        _loadProductCounts();
      } catch (e) {
        _showError('Lỗi xóa danh mục: $e');
      }
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
        backgroundColor: AppStyle.primaryGreen_0_81_49,
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
        title: const Text('Quản lý Danh mục'),
        backgroundColor: AppStyle.primaryGreen_0_81_49,
        foregroundColor: Colors.white,
        actions: [
          // Toggle show inactive categories
          IconButton(
            onPressed: () {
              setState(() {
                _showInactiveCategories = !_showInactiveCategories;
              });
              _loadCategories();
            },
            icon: Icon(_showInactiveCategories
                ? Icons.visibility_off
                : Icons.visibility),
            tooltip: _showInactiveCategories
                ? 'Ẩn danh mục đã tắt'
                : 'Hiện danh mục đã tắt',
          ),
          IconButton(
            onPressed: () {
              _loadCategories();
              _loadProductCounts();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Tải lại',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (context) => const CategoryFormWidget(),
            ),
          );

          if (result == true) {
            _loadCategories();
            _loadProductCounts();
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
                    _showInactiveCategories
                        ? Icons.visibility
                        : Icons.visibility_off,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _showInactiveCategories
                        ? 'Hiển thị tất cả danh mục'
                        : 'Chỉ hiển thị danh mục đang hoạt động',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Error message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(16),
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

            // Categories list
            Expanded(
              child: _buildCategoriesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesList() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải danh mục...'),
          ],
        ),
      );
    }

    if (_categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có danh mục nào',
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
                    builder: (context) => const CategoryFormWidget(),
                  ),
                );

                if (result == true) {
                  _loadCategories();
                  _loadProductCounts();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Thêm danh mục đầu tiên'),
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
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return _buildCategoryCard(category);
      },
    );
  }

  Widget _buildCategoryCard(Category category) {
    final productCount = _productCounts[category.id] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Category Icon & Status
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: category.isActive ? AppStyle.primaryGreen_0_81_49.withOpacity(0.1) : Colors.grey[300],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                Icons.category,
                color: category.isActive ? AppStyle.primaryGreen_0_81_49 : Colors.grey[600],
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Category Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: category.isActive
                                ? Colors.black
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: category.isActive
                              ? AppStyle.primaryGreen_0_81_49.withOpacity(0.1)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          category.isActive ? 'Hoạt động' : 'Đã tắt',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: category.isActive
                                ? AppStyle.primaryGreen_0_81_49
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (category.description != null &&
                      category.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      category.description!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.inventory_2,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '$productCount sản phẩm',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'ID: ${category.id}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
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
                    final result = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (context) => CategoryFormWidget(
                          existingCategory: category,
                        ),
                      ),
                    );

                    if (result == true) {
                      _loadCategories();
                      _loadProductCounts();
                    }
                  },
                  icon: const Icon(Icons.edit),
                  color: Colors.blue[600],
                  tooltip: 'Chỉnh sửa',
                ),

                // Toggle status button
                IconButton(
                  onPressed: () => _toggleCategoryStatus(category),
                  icon: Icon(category.isActive
                      ? Icons.visibility_off
                      : Icons.visibility),
                  color: category.isActive
                      ? Colors.orange[600]
                      : AppStyle.primaryGreen_0_81_49,
                  tooltip: category.isActive ? 'Ẩn danh mục' : 'Hiện danh mục',
                ),

                // Delete button (only if no products)
                if (productCount == 0)
                  IconButton(
                    onPressed: () => _deleteCategory(category),
                    icon: const Icon(Icons.delete),
                    color: Colors.red[600],
                    tooltip: 'Xóa vĩnh viễn',
                  )
                else
                  IconButton(
                    onPressed: null,
                    icon: const Icon(Icons.delete),
                    color: Colors.grey[400],
                    tooltip: 'Không thể xóa (có sản phẩm)',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
