import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xanh_coffee/share/app_imports.dart';
import 'package:xanh_coffee/share/size_configs.dart';
import '../../../services/supabase/blog_service.dart';

class AddBlogWidget extends StatefulWidget {
  const AddBlogWidget({super.key});

  @override
  State<AddBlogWidget> createState() => _AddBlogWidgetState();
}

class _AddBlogWidgetState extends State<AddBlogWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _mainDetailController = TextEditingController();
  final _subDetailController = TextEditingController();
  final _linkImgController = TextEditingController();

  // English version controllers
  final _titleEnController = TextEditingController();
  final _mainDetailEnController = TextEditingController();
  final _subDetailEnController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  bool _isUploadingImage = false;
  String? _errorMessage;
  bool _showEnglishFields = false; // Toggle để hiển thị/ẩn các trường tiếng Anh

  @override
  void initState() {
    super.initState();
    // Listen to image URL changes for preview
    _linkImgController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _mainDetailController.dispose();
    _subDetailController.dispose();
    _linkImgController.dispose();
    _titleEnController.dispose();
    _mainDetailEnController.dispose();
    _subDetailEnController.dispose();
    super.dispose();
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

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return;

      setState(() {
        _isUploadingImage = true;
        _errorMessage = null;
      });

      // Read image bytes
      final bytes = await image.readAsBytes();

      // Upload to Supabase
      final imageUrl = await BlogService.uploadBlogImage(
        fileName: image.name,
        fileBytes: bytes,
      );

      // Update the URL field
      _linkImgController.text = imageUrl;
      _showSuccess('Upload ảnh thành công!');
    } catch (e) {
      _showError('Lỗi upload ảnh: $e');
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  Future<void> _saveBlog() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await BlogService.addBlog(
        title: _titleController.text.trim(),
        mainDetail: _mainDetailController.text.trim(),
        subDetail: _subDetailController.text.trim().isEmpty
            ? null
            : _subDetailController.text.trim(),
        linkImg: _linkImgController.text.trim().isEmpty
            ? null
            : _linkImgController.text.trim(),
        titleEn: _titleEnController.text.trim().isEmpty
            ? null
            : _titleEnController.text.trim(),
        mainDetailEn: _mainDetailEnController.text.trim().isEmpty
            ? null
            : _mainDetailEnController.text.trim(),
        subDetailEn: _subDetailEnController.text.trim().isEmpty
            ? null
            : _subDetailEnController.text.trim(),
      );

      _showSuccess('Thêm bài viết thành công!');
      _resetForm();
    } catch (e) {
      _showError('Lỗi thêm bài viết: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _mainDetailController.clear();
    _subDetailController.clear();
    _linkImgController.clear();
    _titleEnController.clear();
    _mainDetailEnController.clear();
    _subDetailEnController.clear();
    setState(() {
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final width = SizeConfig.screenWidth!;
    final height = SizeConfig.screenHeight!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Bài viết Blog'),
        backgroundColor: AppStyle.primaryGreen_0_81_49,
        foregroundColor: Colors.white,
        actions: [
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
        child: Padding(
          padding: AppStyle.padding_LR_16().copyWith(
              left: width < 1200 ? 0 : width * 0.15,
              right: width < 1200 ? 0 : width * 0.15),
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
          
                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Tiêu đề bài viết *',
                    hintText: 'Nhập tiêu đề bài viết',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  maxLength: 255,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập tiêu đề';
                    }
                    if (value.trim().length < 5) {
                      return 'Tiêu đề phải có ít nhất 5 ký tự';
                    }
                    return null;
                  },
                ),
          
                const SizedBox(height: 16),
          
                // Main Detail
                TextFormField(
                  controller: _mainDetailController,
                  decoration: const InputDecoration(
                    labelText: 'Nội dung tiêu đề *',
                    hintText: 'Nhập nội dung đề của bài viết...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.article),
                  ),
                  maxLines: 3,
                  maxLength: 1000,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập nội dung phụ';
                    }
                    if (value.trim().length < 5) {
                      return 'Nội dung chính phải có ít nhất 5 ký tự';
                    }
                    return null;
                  },
                ),
          
                const SizedBox(height: 16),
          
                // Sub Detail
                TextFormField(
                  controller: _subDetailController,
                  decoration: const InputDecoration(
                    labelText: 'Nội dung chính',
                    hintText: 'Nhập mô tả thêm, ..',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 5,
                  maxLength: 5000,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập nội dung chính';
                    }
                    if (value.trim().length < 20) {
                      return 'Nội dung chính phải có ít nhất 20 ký tự';
                    }
                    return null;
                  },
                ),
          
                const SizedBox(height: 16),
          
                // Image Link with Upload Button
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _linkImgController,
                        decoration: const InputDecoration(
                          labelText: 'Link ảnh minh họa (Tùy chọn)',
                          hintText: 'https://example.com/image.jpg',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.image),
                        ),
                        keyboardType: TextInputType.url,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập URL';
                          }
          
                          final uri = Uri.tryParse(value.trim());
                          if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
                            return 'Vui lòng nhập URL hợp lệ';
                          }
          
                          return null;
                        },
          
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _isUploadingImage ? null : _pickAndUploadImage,
                      icon: _isUploadingImage
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.cloud_upload),
                      label: Text(_isUploadingImage ? 'Đang tải...' : 'Upload'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyle.primaryGreen_0_81_49,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
          
                const SizedBox(height: 16),
          
                // Image preview
                if (_linkImgController.text.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Xem trước ảnh:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 500,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                _linkImgController.text.trim(),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Không thể tải ảnh',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          
                const SizedBox(height: 24),
          
                // English version toggle
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.language, color: Colors.blue[600]),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Phiên bản tiếng Anh',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Switch(
                          value: _showEnglishFields,
                          onChanged: (value) {
                            setState(() {
                              _showEnglishFields = value;
                            });
                          },
                          activeColor: AppStyle.primaryGreen_0_81_49,
                        ),
                      ],
                    ),
                  ),
                ),
          
                // English fields
                if (_showEnglishFields) ...[
                  const SizedBox(height: 16),
          
                  // English Title
                  TextFormField(
                    controller: _titleEnController,
                    decoration: const InputDecoration(
                      labelText: 'English Title',
                      hintText: 'Enter blog title in English',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title_outlined),
                    ),
                    maxLength: 255,
                    validator: _showEnglishFields
                        ? (value) {
                            if (value != null &&
                                value.trim().isNotEmpty &&
                                value.trim().length < 5) {
                              return 'English title must be at least 5 characters';
                            }
                            return null;
                          }
                        : null,
                  ),
          
                  const SizedBox(height: 16),
          
                  // English Main Detail
                  TextFormField(
                    controller: _mainDetailEnController,
                    decoration: const InputDecoration(
                      labelText: 'English Main Content',
                      hintText: 'Enter main content in English...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.article_outlined),
                    ),
                    maxLines: 8,
                    maxLength: 5000,
                    validator: _showEnglishFields
                        ? (value) {
                            if (value != null &&
                                value.trim().isNotEmpty &&
                                value.trim().length < 20) {
                              return 'English main content must be at least 20 characters';
                            }
                            return null;
                          }
                        : null,
                  ),
          
                  const SizedBox(height: 16),
          
                  // English Sub Detail
                  TextFormField(
                    controller: _subDetailEnController,
                    decoration: const InputDecoration(
                      labelText: 'English Sub Content (Optional)',
                      hintText: 'Enter additional description, summary...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description_outlined),
                    ),
                    maxLines: 4,
                    maxLength: 1000,
                  ),
                ],
          
                const SizedBox(height: 24),
          
                // Info card
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue[600]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Bài viết mới sẽ được hiển thị ở đầu danh sách. Bạn có thể sắp xếp lại thứ tự sau khi tạo.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          
                const SizedBox(height: 16),
          
                // Save button
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveBlog,
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
                      : const Text('Thêm Bài viết'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
