import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:xanh_coffee/share/app_imports.dart';
import '../../../services/supabase/blog_service.dart';
import '../../../share/size_configs.dart';
import 'add_blog_widget.dart';

class BlogManagementWidget extends StatefulWidget {
  const BlogManagementWidget({super.key});

  @override
  State<BlogManagementWidget> createState() => _BlogManagementWidgetState();
}

class _BlogManagementWidgetState extends State<BlogManagementWidget> {
  List<Map<String, dynamic>> _blogs = [];
  List<Map<String, dynamic>> _originalBlogs = []; // Lưu trạng thái gốc
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasChanges = false; // Theo dõi có thay đổi không
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBlogs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBlogs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final blogs = await BlogService.getAllBlogsRaw();
      setState(() {
        _blogs = blogs;
        _originalBlogs =
            List<Map<String, dynamic>>.from(blogs); // Lưu bản sao gốc
        _hasChanges = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi tải blog: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchBlogs(String query) async {
    if (query.trim().isEmpty) {
      _loadBlogs();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final blogs = await BlogService.searchBlogs(query.trim());
      setState(() {
        _blogs = blogs;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi tìm kiếm: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteBlog(int blogId, String title) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
              'Bạn có chắc chắn muốn xóa bài viết "$title"?\n\nHành động này không thể hoàn tác!'),
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
        await BlogService.deleteBlog(blogId);
        _showSuccess('Đã xóa bài viết "$title"');
        _loadBlogs();
      } catch (e) {
        _showError('Lỗi xóa bài viết: $e');
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

  void _moveBlogUp(int? blogId) {
    if (blogId == null) return;

    setState(() {
      _blogs = BlogService.moveBlogUpInList(_blogs, blogId);
      _hasChanges = true;
    });
    _showSuccess('Di chuyển tạm thời. Nhấn Save để lưu!');
  }

  void _moveBlogDown(int? blogId) {
    if (blogId == null) return;

    setState(() {
      _blogs = BlogService.moveBlogDownInList(_blogs, blogId);
      _hasChanges = true;
    });
    _showSuccess('Di chuyển tạm thời. Nhấn Save để lưu!');
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    setState(() {
      final item = _blogs.removeAt(oldIndex);
      _blogs.insert(newIndex, item);
      _hasChanges = true;
    });

    _showSuccess('Thay đổi tạm thời. Nhấn Save để lưu!');
  }

  // Lưu thay đổi vào database
  Future<void> _saveChanges() async {
    if (!_hasChanges) return;

    try {
      setState(() {
        _isLoading = true;
      });

      // Sử dụng phương thức mới để lưu thứ tự
      await BlogService.saveBlogOrder(_blogs);

      _showSuccess('Đã lưu thay đổi thứ tự thành công!');

      // Tải lại để cập nhật trạng thái
      await _loadBlogs();
    } catch (e) {
      _showError('Lỗi lưu thay đổi: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Hủy thay đổi và khôi phục về trạng thái gốc
  void _resetChanges() {
    setState(() {
      _blogs = List<Map<String, dynamic>>.from(_originalBlogs);
      _hasChanges = false;
    });
    _showSuccess('Đã khôi phục về trạng thái gốc');
  }

  void _showBlogDetail(Map<String, dynamic> blog) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(blog['title'] ?? 'N/A'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (blog['link_img'] != null && blog['link_img'].isNotEmpty) ...[
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      blog['link_img'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              const Text(
                'Nội dung chính:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(blog['main_detail'] ?? 'N/A'),
              if (blog['sub_detail'] != null &&
                  blog['sub_detail'].isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Nội dung phụ:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(blog['sub_detail']),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
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
        title: const Text('Quản lý Blog'),
        backgroundColor: AppStyle.primaryGreen_0_81_49,
        foregroundColor: Colors.white,
        actions: [
          // Reset button
          if (_hasChanges)
            IconButton(
              onPressed: _resetChanges,
              icon: const Icon(Icons.undo),
              tooltip: 'Khôi phục',
            ),

          // Save button
          if (_hasChanges)
            IconButton(
              onPressed: _saveChanges,
              icon: const Icon(Icons.save),
              tooltip: 'Lưu thay đổi',
            ),

          // Refresh button
          IconButton(
            onPressed: _loadBlogs,
            icon: const Icon(Icons.refresh),
            tooltip: 'Tải lại',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (context) => const AddBlogWidget(),
            ),
          );

          if (result == true) {
            _loadBlogs();
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
            // Search bar
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm theo tiêu đề...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _loadBlogs();
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                  border: const OutlineInputBorder(),
                ),
                onChanged: _searchBlogs,
              ),
            ),
        
            // Statistics and instructions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Icons.article, color: Colors.blue[600]),
                          const SizedBox(width: 8),
                          Text(
                            'Tổng số bài viết: ${_blogs.length}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    color: Colors.blue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue[600]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Cách di chuyển: Kéo thả bài viết hoặc dùng nút ⬆️ ⬇️ (lưu vĩnh viễn)',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        
            // Changes notification banner
            if (_hasChanges)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  border: Border.all(color: Colors.orange[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Có thay đổi chưa lưu. Nhấn Save để lưu hoặc Reset để hủy.',
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _resetChanges,
                      child: Text(
                        'Reset',
                        style: TextStyle(color: Colors.orange[700]),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      child: const Text('Save'),
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
        
            // Blog list
            Expanded(
              child: _buildBlogList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlogList() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải bài viết...'),
          ],
        ),
      );
    }

    if (_blogs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isNotEmpty
                  ? 'Không tìm thấy bài viết nào'
                  : 'Chưa có bài viết nào',
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
                    builder: (context) => const AddBlogWidget(),
                  ),
                );

                if (result == true) {
                  _loadBlogs();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Thêm bài viết đầu tiên'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.primaryGreen_0_81_49,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _blogs.length,
      onReorder: _onReorder,
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            final double animValue =
                Curves.easeInOut.transform(animation.value);
            final double elevation = lerpDouble(0, 6, animValue)!;
            final double scale = lerpDouble(1, 1.02, animValue)!;
            return Transform.scale(
              scale: scale,
              child: Card(
                elevation: elevation,
                child: child,
              ),
            );
          },
          child: child,
        );
      },
      itemBuilder: (context, index) {
        final blog = _blogs[index];
        return _buildBlogCard(blog, index);
      },
    );
  }

  Widget _buildBlogCard(Map<String, dynamic> blog, int index) {
    // Debug: Kiểm tra dữ liệu blog
    print('Blog data: $blog');
    print('Blog ID: ${blog['id']}, Type: ${blog['id'].runtimeType}');

    // Đảm bảo có ID hợp lệ để làm key
    final blogId = blog['id'];
    final uniqueKey =
        blogId != null ? ValueKey(blogId) : ValueKey('blog_$index');

    return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        key: uniqueKey,
        margin: const EdgeInsets.only(bottom: 12),
        child: Card(
          elevation: _hasChanges ? 3 : 1, // Nâng cao khi có thay đổi
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Drag handle

                // Index indicator
                Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppStyle.primaryGreen_0_81_49,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Blog image thumbnail
                if (blog['link_img'] != null && blog['link_img'].isNotEmpty)
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        blog['link_img'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                              size: 20,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                else
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: const Icon(
                      Icons.article,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),

                const SizedBox(width: 12),

                // Blog info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        blog['title'] ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        blog['main_detail'] ?? 'N/A',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Language indicators
                      Row(
                        children: [
                          // Vietnamese indicator (always present)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue[600],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'VI',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // English indicator (if available)
                          if (blog['title_en'] != null &&
                              blog['title_en']
                                  .toString()
                                  .trim()
                                  .isNotEmpty) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green[600],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'EN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${blog['id'] ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),


                // Actions
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // // Move up button
                    // IconButton(
                    //   onPressed: (index == 0 || blog['id'] == null)
                    //       ? null
                    //       : () {
                    //           final blogId = blog['id'] as int?;
                    //           if (blogId != null) {
                    //             _moveBlogUp(blogId);
                    //           }
                    //         },
                    //   icon: const Icon(Icons.keyboard_arrow_up),
                    //   color: (index == 0 || blog['id'] == null)
                    //       ? Colors.grey[400]
                    //       : Colors.green[600],
                    //   tooltip: 'Di chuyển lên',
                    // ),
                    //
                    // // Move down button
                    // IconButton(
                    //   onPressed:
                    //       (index == _blogs.length - 1 || blog['id'] == null)
                    //           ? null
                    //           : () {
                    //               final blogId = blog['id'] as int?;
                    //               if (blogId != null) {
                    //                 _moveBlogDown(blogId);
                    //               }
                    //             },
                    //   icon: const Icon(Icons.keyboard_arrow_down),
                    //   color: (index == _blogs.length - 1 || blog['id'] == null)
                    //       ? Colors.grey[400]
                    //       : Colors.green[600],
                    //   tooltip: 'Di chuyển xuống',
                    // ),

                    // View detail button
                    // IconButton(
                    //   onPressed: () => _showBlogDetail(blog),
                    //   icon: const Icon(Icons.visibility),
                    //   color: Colors.blue[600],
                    //   tooltip: 'Xem chi tiết',
                    // ),

                    // Delete button

                    IconButton(
                      onPressed: blog['id'] == null
                          ? null
                          : () {
                              final blogId = blog['id'] as int?;
                              final title = blog['title'] as String?;
                              if (blogId != null) {
                                _deleteBlog(blogId, title ?? 'N/A');
                              }
                            },
                      icon: const Icon(Icons.delete),
                      color: blog['id'] == null
                          ? Colors.grey[400]
                          : Colors.red[600],
                      tooltip: 'Xóa',
                    ),
                  ],
                ),
                SizedBox(width: 32,),
              ],
            ),
          ),
        )); // Đóng AnimatedContainer
  }
}
