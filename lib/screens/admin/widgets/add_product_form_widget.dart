import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xanh_coffee/helper/helper.dart';
import 'package:xanh_coffee/share/app_imports.dart';
import '../../../services/supabase/product_service.dart';
import '../../../services/supabase/category_service.dart';
import '../../home/model/product_model.dart';
import '../../home/model/category_model.dart' as CategoryModel;

class AddProductFormWidget extends StatefulWidget {
  final Product? existingProduct;
  final String? existingCategory;

  const AddProductFormWidget({
    super.key,
    this.existingProduct,
    this.existingCategory,
  });

  @override
  State<AddProductFormWidget> createState() => _AddProductFormWidgetState();
}

class _AddProductFormWidgetState extends State<AddProductFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nameEnglishController = TextEditingController();
  final _countryController = TextEditingController();
  final _priceController = TextEditingController();

  String? _selectedCategory;
  CategoryModel.Category? _selectedCategoryObject;
  int? _selectedCategoryId;
  bool _isBestSeller = false;
  File? _selectedImageFile;
  Uint8List? _selectedImageBytes; // For web compatibility
  String? _existingImageUrl;
  bool _isLoading = false;
  String? _errorMessage;

  List<CategoryModel.Category> _categories = [];
  bool _isLoadingCategories = true;

  Future<void> _loadCategories() async {
    try {
      setState(() {
        _isLoadingCategories = true;
      });

      _categories = await CategoryService.getAllCategories(isActive: true);

      // Set _selectedCategoryObject nếu đã có _selectedCategory từ existing product
      if (_selectedCategory != null && _categories.isNotEmpty) {
        _selectedCategoryObject = _categories.firstWhere(
          (cat) => cat.name == _selectedCategory,
          orElse: () => _categories.first,
        );
      }

      setState(() {
        _isLoadingCategories = false;
      });
    } catch (e) {
      debugPrint('Error loading categories: $e');
      setState(() {
        _isLoadingCategories = false;
      });
      _showError('Lỗi tải danh mục: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _initializeForm();
  }

  String priceNotText = "0.0";

  void _initializeForm() {
    if (widget.existingProduct != null) {
      final product = widget.existingProduct!;
      _nameController.text = product.name;
      _nameEnglishController.text = product.nameEnglish;
      _countryController.text = product.country;
      priceNotText = _priceController.text;
      _priceController.text =
          double.parse(product.price.toString()).toCurrencyNotD();
      _isBestSeller = product
          .isBestSeller; // Khởi tạo giá trị best seller từ sản phẩm hiện có
      _existingImageUrl = product.image;

      // Set category từ existing product
      if (product.category.isNotEmpty) {
        _selectedCategory = product.category;
        _selectedCategoryId = product.categoryId;

        // Sẽ set _selectedCategoryObject sau khi _categories load xong
      }
    }

    if (widget.existingCategory != null) {
      _selectedCategory = widget.existingCategory;
    }

    // Set default values
    if (_countryController.text.isEmpty) {
      _countryController.text = 'Vietnam';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameEnglishController.dispose();
    _countryController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        if (kIsWeb) {
          // For web platform, read as bytes
          _selectedImageBytes = await image.readAsBytes();
          _selectedImageFile = null;
        } else {
          // For mobile platforms, use File
          _selectedImageFile = File(image.path);
          _selectedImageBytes = null;
        }
        setState(() {});
      }
    } catch (e) {
      _showError('Lỗi chọn ảnh: $e');
    }
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });

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

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategoryObject == null) {
      _showError('Vui lòng chọn danh mục');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final cleanValue = _priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
    try {
      final product = Product(
        id: widget.existingProduct?.id ??
            0, // Sử dụng existing ID hoặc 0 cho sản phẩm mới
        name: _nameController.text.trim(),
        nameEnglish: _nameEnglishController.text.trim(),
        country: _countryController.text.trim(),
        price: double.parse(cleanValue),
        categoryId: _selectedCategoryObject!.id,
        image: _existingImageUrl ?? '', // Sẽ được cập nhật sau khi upload
        category: _selectedCategoryObject!.name, // Sử dụng category đã chọn
        isBestSeller: _isBestSeller,
        isActive: widget.existingProduct?.isActive ??
            true, // Mặc định true cho sản phẩm mới
      );

      if (widget.existingProduct == null) {
        // Thêm sản phẩm mới
        await ProductService.addProduct(
          product: product,
          category: _selectedCategoryObject!.name,
          categoryId: _selectedCategoryObject!.id,
          imageFile: _selectedImageFile,
          imageBytes: _selectedImageBytes,
          isBestSeller: _isBestSeller,
        );

        _showSuccess('Thêm sản phẩm thành công!');
        _resetForm();
      } else {
        // Cập nhật sản phẩm
        await ProductService.updateProduct(
          productId: product.id,
          name: product.name,
          price: product.price,
          country: product.country,
          category: _selectedCategoryObject!.name,

          isBestSeller: _isBestSeller,
          newImageFile: _selectedImageFile,
          newImageBytes: _selectedImageBytes,
        );

        _showSuccess('Cập nhật sản phẩm thành công!');
        Navigator.of(context).pop(true); // Return success
      }
    } catch (e) {
      _showError('Lỗi lưu sản phẩm: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _nameEnglishController.clear();
    _countryController.text = 'Vietnam';
    _priceController.clear();
    setState(() {
      _selectedCategory = null;
      _selectedCategoryObject = null;
      _selectedCategoryId = null;
      _isBestSeller = false;
      _selectedImageFile = null;
      _existingImageUrl = null;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingProduct == null
            ? 'Thêm sản phẩm mới'
            : 'Chỉnh sửa sản phẩm'),
        backgroundColor: Colors.brown[600],
        foregroundColor: Colors.white,
        actions: [
          if (widget.existingProduct == null)
            TextButton(
              onPressed: _resetForm,
              child: const Text(
                'Reset',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Error message
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
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
                    ],
                  ),
                ),

              // Product Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên sản phẩm *',
                  hintText: 'Nhập tên sản phẩm',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên sản phẩm';
                  }
                  if (value.trim().length < 2) {
                    return 'Tên sản phẩm phải có ít nhất 2 ký tự';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _nameEnglishController,
                decoration: const InputDecoration(
                  labelText: 'Tên sản phẩm Tiếng anh *',
                  hintText: 'Nhập tên sản phẩm Tiếng anh',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên sản phẩm Tiếng anh';
                  }
                  if (value.trim().length < 2) {
                    return 'Tên sản phẩm phải có ít nhất 2 ký tự';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<CategoryModel.Category>(
                value: _selectedCategoryObject,
                decoration: const InputDecoration(
                  labelText: 'Danh mục *',
                  border: OutlineInputBorder(),
                ),
                items: _isLoadingCategories
                    ? []
                    : _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category.name),
                        );
                      }).toList(),
                onChanged: _isLoadingCategories
                    ? null
                    : (value) {
                        setState(() {
                          _selectedCategoryObject = value;
                          _selectedCategory = value?.name;
                          _selectedCategoryId = value?.id;
                          print(_selectedCategoryObject);
                        });
                      },
                validator: (value) {
                  if (value == null) {
                    return 'Vui lòng chọn danh mục';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Price
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Giá (VNĐ) *',
                  hintText: 'Nhập giá sản phẩm',
                  border: OutlineInputBorder(),
                  suffix: Text('đ'),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  print(value);
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập giá sản phẩm';
                  }

                  // Xóa các ký tự không phải số
                  final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');

                  final price = int.tryParse(cleanValue);
                  if (price == null || price <= 0) {
                    return 'Giá phải là số nguyên dương';
                  }
                  if (price < 1000) {
                    return 'Giá phải ít nhất 1,000đ';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Best Seller Switch
              SwitchListTile(
                title: const Text('Sản phẩm bán chạy'),
                subtitle: const Text('Đánh dấu là sản phẩm best seller'),
                value: _isBestSeller,
                onChanged: (value) {
                  setState(() {
                    _isBestSeller = value;
                  });
                },
                activeColor: AppStyle.primaryGreen_0_81_49,
              ),

              const SizedBox(height: 16),

              // Image Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Hình ảnh sản phẩm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Image preview
                      if (_selectedImageFile != null ||
                          _selectedImageBytes != null ||
                          _existingImageUrl != null)
                        Container(
                          height: 500,
                          width: 400,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: AppStyle.padding_TB_16(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: _selectedImageFile != null && !kIsWeb
                                  ? Image.file(
                                      _selectedImageFile!,
                                      fit: BoxFit.contain,
                                    )
                                  : _selectedImageBytes != null && kIsWeb
                                      ? Image.memory(
                                          _selectedImageBytes!,
                                          fit: BoxFit.contain,
                                        )
                                      : (_existingImageUrl != null
                                          ? Image.network(
                                              _existingImageUrl!,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[200],
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.error,
                                                      size: 50,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : null),
                            ),
                          ),
                        )
                      else
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[300]!,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Chưa chọn ảnh',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 12),

                      // Pick image button
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        label: Text(_selectedImageFile != null ||
                                _existingImageUrl != null
                            ? 'Đổi ảnh'
                            : 'Chọn ảnh'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyle.primaryGreen_0_81_49,
                          foregroundColor: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 8),
                      Text(
                        'Chọn ảnh từ thư viện. Khuyến nghị: 800x800px, dung lượng < 2MB',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Save button
              ElevatedButton(
                onPressed: _isLoading ? null : _saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.primaryGreen_0_81_49,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Đang lưu...'),
                        ],
                      )
                    : Text(widget.existingProduct == null
                        ? 'Thêm sản phẩm'
                        : 'Cập nhật sản phẩm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
