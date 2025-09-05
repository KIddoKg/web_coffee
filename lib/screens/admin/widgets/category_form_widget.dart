import 'package:flutter/material.dart';
import 'package:xanh_coffee/share/app_styles.dart';
import '../../../services/supabase/category_service.dart';
import '../../home/model/category_model.dart';

class CategoryFormWidget extends StatefulWidget {
  final Category? existingCategory;

  const CategoryFormWidget({
    super.key,
    this.existingCategory,
  });

  @override
  State<CategoryFormWidget> createState() => _CategoryFormWidgetState();
}

class _CategoryFormWidgetState extends State<CategoryFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isActive = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.existingCategory != null) {
      final category = widget.existingCategory!;
      _nameController.text = category.name;
      _nameEnController.text = category.nameEn ?? '';
      _descriptionController.text = category.description ?? '';
      _isActive = category.isActive;
    }
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final name = _nameController.text.trim();
      final nameEn = _nameEnController.text.trim();
      final description = _descriptionController.text.trim();

      // Kiểm tra tên có bị trùng không
      final isNameExists = await CategoryService.isCategoryNameExists(
        name,
        excludeId: widget.existingCategory?.id,
      );

      if (isNameExists) {
        setState(() {
          _errorMessage = 'Tên danh mục đã tồn tại';
        });
        return;
      }

      if (widget.existingCategory == null) {
        // Thêm category mới
        await CategoryService.addCategory(
          name: name,
          nameEn: nameEn.isEmpty ? null : nameEn,
          description: description.isEmpty ? null : description,
          isActive: _isActive,
        );
      } else {
        // Cập nhật category
        await CategoryService.updateCategory(
          id: widget.existingCategory!.id,
          name: name,
          nameEn: nameEn.isEmpty ? null : nameEn,
          description: description.isEmpty ? null : description,
          isActive: _isActive,
        );
      }

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi lưu danh mục: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameEnController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.existingCategory == null ? 'Thêm Danh mục' : 'Sửa Danh mục'),
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên danh mục (Tiếng Việt) *',
                  border: OutlineInputBorder(),
                  hintText: 'Nhập tên danh mục',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tên danh mục là bắt buộc';
                  }
                  if (value.trim().length < 2) {
                    return 'Tên danh mục phải có ít nhất 2 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // English name field
              TextFormField(
                controller: _nameEnController,
                decoration: const InputDecoration(
                  labelText: 'Tên danh mục (Tiếng Anh)',
                  border: OutlineInputBorder(),
                  hintText: 'Nhập tên danh mục bằng tiếng Anh (tùy chọn)',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tên danh mục tiếng anh là bắt buộc';
                  }
                  if (value.trim().length < 2) {
                    return 'Tên danh mục phải có ít nhất 2 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(),
                  hintText: 'Nhập mô tả cho danh mục (tùy chọn)',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value != null &&
                      value.trim().isNotEmpty &&
                      value.trim().length < 5) {
                    return 'Mô tả phải có ít nhất 5 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Active status switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trạng thái hoạt động',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Danh mục sẽ hiển thị cho khách hàng',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    activeColor: AppStyle.primaryGreen_0_81_49,
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        _isActive = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Save button
              ElevatedButton(
                onPressed: _isLoading ? null : _saveCategory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.primaryGreen_0_81_49,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        widget.existingCategory == null
                            ? 'Thêm danh mục'
                            : 'Cập nhật danh mục',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),

              // Additional info for existing category
              if (widget.existingCategory != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thông tin bổ sung',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ID: ${widget.existingCategory!.id}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      if (widget.existingCategory!.createdAt != null)
                        Text(
                          'Ngày tạo: ${widget.existingCategory!.createdAt.toString().substring(0, 19)}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      if (widget.existingCategory!.updatedAt != null)
                        Text(
                          'Cập nhật lần cuối: ${widget.existingCategory!.updatedAt.toString().substring(0, 19)}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
