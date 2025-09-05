import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../../screens/home/model/blog_model.dart';
import 'services_supabase.dart';

class BlogService {
  static const String _tableName = 'blog';
  static const String _bucketName =
      'product-images'; // Sử dụng bucket chung với product images

  /// Thêm bài viết blog mới
  static Future<Map<String, dynamic>> addBlog({
    required String title,
    required String mainDetail,
    String? subDetail,
    String? linkImg,
    String? titleEn,
    String? mainDetailEn,
    String? subDetailEn,
  }) async {
    try {
      final response = await SupabaseService.from(_tableName)
          .insert({
            'title': title,
            'main_detail': mainDetail,
            'sub_detail': subDetail,
            'link_img': linkImg,
            'title_en': titleEn,
            'main_detail_en': mainDetailEn,
            'sub_detail_en': subDetailEn,
          })
          .select()
          .single();

      debugPrint('Thêm blog thành công: $title');
      return response;
    } catch (e) {
      debugPrint('Lỗi thêm blog: $e');
      rethrow;
    }
  }

  /// Lấy tất cả blog posts (sắp xếp theo order và created_at)
  static Future<List<BlogModel>> getAllBlogs() async {
    try {
      final response = await SupabaseService.from(_tableName)
          .select('*')
          .order('order', ascending: true)
          .order('created_at', ascending: false);

      return response
          .map<BlogModel>((json) => BlogModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Lỗi lấy danh sách blog: $e');
      rethrow;
    }
  }

  /// Lấy tất cả blog posts (raw data for backward compatibility)
  static Future<List<Map<String, dynamic>>> getAllBlogsRaw() async {
    try {
      final response = await SupabaseService.from(_tableName)
          .select('*')
          .order('order', ascending: true)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Lỗi lấy danh sách blog raw: $e');
      rethrow;
    }
  }

  /// Lấy latest blogs
  static Future<List<BlogModel>> getLatestBlogs({int limit = 5}) async {
    try {
      final response = await SupabaseService.from(_tableName)
          .select('*')
          .order('created_at', ascending: false)
          .limit(limit);

      return response
          .map<BlogModel>((json) => BlogModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Lỗi lấy latest blogs: $e');
      rethrow;
    }
  }

  /// Lấy featured blogs (theo order)
  static Future<List<BlogModel>> getFeaturedBlogs({int limit = 3}) async {
    try {
      final response = await SupabaseService.from(_tableName)
          .select('*')
          .order('order', ascending: true)
          .limit(limit);

      return response
          .map<BlogModel>((json) => BlogModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Lỗi lấy featured blogs: $e');
      rethrow;
    }
  }

  /// Lấy blog theo ID (trả về BlogModel)
  static Future<BlogModel?> getBlog(int blogId) async {
    try {
      final response = await SupabaseService.from(_tableName)
          .select('*')
          .eq('id', blogId)
          .maybeSingle();

      if (response == null) return null;
      return BlogModel.fromJson(response);
    } catch (e) {
      debugPrint('Lỗi lấy blog theo ID $blogId: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> getBlogById(int blogId) async {
    try {
      final response = await SupabaseService.from(_tableName)
          .select('*')
          .eq('id', blogId)
          .maybeSingle();

      return response;
    } catch (e) {
      debugPrint('Lỗi lấy blog theo ID $blogId: $e');
      rethrow;
    }
  }

  /// Xóa blog post
  static Future<void> deleteBlog(int id) async {
    try {
      await SupabaseService.from(_tableName).delete().eq('id', id);

      debugPrint('Đã xóa blog thành công');
    } catch (e) {
      debugPrint('Lỗi xóa blog: $e');
      rethrow;
    }
  }

  /// Tìm kiếm blog theo tiêu đề
  static Future<List<Map<String, dynamic>>> searchBlogs(String query) async {
    try {
      final response = await SupabaseService.from(_tableName)
          .select('*')
          .textSearch('title', query)
          .order('id', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Lỗi tìm kiếm blog: $e');
      rethrow;
    }
  }

  /// Tìm kiếm blog theo cả tiếng Việt và tiếng Anh
  static Future<List<Map<String, dynamic>>> searchBlogsMultiLanguage(
      String query) async {
    try {
      final response = await SupabaseService.from(_tableName)
          .select('*')
          .or('title.ilike.%$query%,title_en.ilike.%$query%,main_detail.ilike.%$query%,main_detail_en.ilike.%$query%')
          .order('id', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Lỗi tìm kiếm blog đa ngôn ngữ: $e');
      rethrow;
    }
  }

  /// Lấy blog theo ngôn ngữ
  static Future<List<Map<String, dynamic>>> getBlogsByLanguage(
      String language) async {
    try {
      final response = await SupabaseService.from(_tableName)
          .select('*')
          .order('id', ascending: false);

      List<Map<String, dynamic>> blogs =
          List<Map<String, dynamic>>.from(response);

      // Lọc blog theo ngôn ngữ
      if (language == 'en') {
        blogs = blogs
            .where((blog) =>
                blog['title_en'] != null &&
                blog['title_en'].toString().isNotEmpty)
            .toList();
      }

      return blogs;
    } catch (e) {
      debugPrint('Lỗi lấy blog theo ngôn ngữ: $e');
      rethrow;
    }
  }

  /// Cập nhật phiên bản tiếng Anh của blog
  static Future<Map<String, dynamic>> updateBlogEnglish({
    required int blogId,
    required String titleEn,
    required String mainDetailEn,
    String? subDetailEn,
  }) async {
    try {
      final response = await SupabaseService.from(_tableName)
          .update({
            'title_en': titleEn,
            'main_detail_en': mainDetailEn,
            'sub_detail_en': subDetailEn,
          })
          .eq('id', blogId)
          .select()
          .single();

      debugPrint('Cập nhật phiên bản tiếng Anh thành công cho blog $blogId');
      return response;
    } catch (e) {
      debugPrint('Lỗi cập nhật phiên bản tiếng Anh: $e');
      rethrow;
    }
  }

  /// Convert từ Supabase data sang BlogModel
  static BlogModel fromSupabaseData(Map<String, dynamic> data) {
    return BlogModel(
      id: data['id'] ?? 0,
      title: data['title'] ?? '',
      mainDetail: data['main_detail'] ?? '',
      subDetail: data['sub_detail'],
      linkImg: data['link_img'],
      order: data['id'] ?? 0, // Sử dụng ID làm order
      titleEn: data['title_en'],
      mainDetailEn: data['main_detail_en'],
      subDetailEn: data['sub_detail_en'],
    );
  }

  /// Lấy danh sách blog theo thứ tự tùy chỉnh (dựa trên danh sách ID)
  static Future<List<Map<String, dynamic>>> getBlogsInOrder(
      List<int> orderedIds) async {
    try {
      final allBlogs = await getAllBlogsRaw();
      final Map<int, Map<String, dynamic>> blogMap = {
        for (var blog in allBlogs) blog['id']: blog
      };

      List<Map<String, dynamic>> orderedBlogs = [];

      // Thêm blog theo thứ tự được chỉ định
      for (int id in orderedIds) {
        if (blogMap.containsKey(id)) {
          orderedBlogs.add(blogMap[id]!);
          blogMap.remove(id);
        }
      }

      // Thêm các blog còn lại (nếu có)
      orderedBlogs.addAll(blogMap.values);

      return orderedBlogs;
    } catch (e) {
      debugPrint('Lỗi lấy blog theo thứ tự: $e');
      rethrow;
    }
  }

  /// Hoán đổi vị trí giữa hai blog trong danh sách (chỉ ở phía client)
  static List<Map<String, dynamic>> swapBlogsInList(
      List<Map<String, dynamic>> blogs, int index1, int index2) {
    if (index1 < 0 ||
        index1 >= blogs.length ||
        index2 < 0 ||
        index2 >= blogs.length) {
      return blogs;
    }

    final temp = blogs[index1];
    blogs[index1] = blogs[index2];
    blogs[index2] = temp;

    return blogs;
  }

  /// Di chuyển blog lên trên trong danh sách
  static List<Map<String, dynamic>> moveBlogUpInList(
      List<Map<String, dynamic>> blogs, int blogId) {
    final currentIndex = blogs.indexWhere((blog) => blog['id'] == blogId);

    if (currentIndex <= 0) {
      return blogs; // Đã ở đầu danh sách hoặc không tìm thấy
    }

    return swapBlogsInList(blogs, currentIndex, currentIndex - 1);
  }

  /// Di chuyển blog xuống dưới trong danh sách
  static List<Map<String, dynamic>> moveBlogDownInList(
      List<Map<String, dynamic>> blogs, int blogId) {
    final currentIndex = blogs.indexWhere((blog) => blog['id'] == blogId);

    if (currentIndex == -1 || currentIndex >= blogs.length - 1) {
      return blogs; // Đã ở cuối danh sách hoặc không tìm thấy
    }

    return swapBlogsInList(blogs, currentIndex, currentIndex + 1);
  }

  /// Di chuyển blog đến vị trí cụ thể trong danh sách
  static List<Map<String, dynamic>> moveBlogToPositionInList(
      List<Map<String, dynamic>> blogs, int blogId, int targetPosition) {
    final currentIndex = blogs.indexWhere((blog) => blog['id'] == blogId);

    if (currentIndex == -1 ||
        targetPosition < 0 ||
        targetPosition >= blogs.length ||
        currentIndex == targetPosition) {
      return blogs;
    }

    final blogToMove = blogs.removeAt(currentIndex);
    blogs.insert(targetPosition, blogToMove);

    return blogs;
  }

  /// Upload ảnh cho blog từ bytes lên Supabase Storage
  static Future<String> uploadBlogImage({
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    try {
      final String path =
          'blog/blog_${DateTime.now().millisecondsSinceEpoch}_$fileName';

      final String imageUrl = await SupabaseService.uploadFile(
        bucket: _bucketName,
        path: path,
        fileBytes: fileBytes,
      );

      debugPrint('Upload blog image thành công: $imageUrl');
      return imageUrl;
    } catch (e) {
      debugPrint('Lỗi upload blog image: $e');
      rethrow;
    }
  }

  /// Xóa ảnh blog từ storage
  static Future<void> deleteBlogImage(String imageUrl) async {
    try {
      // Trích xuất path từ URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      if (pathSegments.length >= 3) {
        final path = pathSegments.sublist(2).join('/');
        await SupabaseService.deleteFile(bucket: _bucketName, path: path);
        debugPrint('Xóa blog image thành công: $path');
      }
    } catch (e) {
      debugPrint('Lỗi xóa blog image: $e');
      // Không rethrow vì việc xóa ảnh không quan trọng bằng việc xóa blog record
    }
  }

  /// Hoán đổi ID giữa hai blog (để lưu vĩnh viễn thứ tự)
  static Future<void> swapBlogIds(int blogId1, int blogId2) async {
    try {
      // Lấy thông tin hai blog
      final blog1 = await getBlogById(blogId1);
      final blog2 = await getBlogById(blogId2);

      if (blog1 == null || blog2 == null) {
        throw Exception('Không tìm thấy blog để hoán đổi');
      }

      // Sử dụng ID tạm thời để tránh conflict
      const int tempId = -999999;

      // Bước 1: Chuyển blog1 sang ID tạm thời
      await SupabaseService.from(_tableName)
          .update({'id': tempId}).eq('id', blogId1);

      // Bước 2: Chuyển blog2 sang ID của blog1
      await SupabaseService.from(_tableName)
          .update({'id': blogId1}).eq('id', blogId2);

      // Bước 3: Chuyển blog từ ID tạm thời sang ID của blog2
      await SupabaseService.from(_tableName)
          .update({'id': blogId2}).eq('id', tempId);

      debugPrint('Hoán đổi ID thành công: $blogId1 ↔ $blogId2');
    } catch (e) {
      debugPrint('Lỗi hoán đổi ID blog: $e');
      rethrow;
    }
  }

  /// Di chuyển blog lên trên (hoán đổi ID với blog phía trước)
  static Future<void> moveBlogUpPermanent(
      List<Map<String, dynamic>> blogs, int blogId) async {
    try {
      final currentIndex = blogs.indexWhere((blog) => blog['id'] == blogId);

      if (currentIndex <= 0) {
        throw Exception('Blog đã ở vị trí đầu tiên');
      }

      final currentBlog = blogs[currentIndex];
      final previousBlog = blogs[currentIndex - 1];

      await swapBlogIds(currentBlog['id'], previousBlog['id']);
      debugPrint('Di chuyển blog $blogId lên trên thành công');
    } catch (e) {
      debugPrint('Lỗi di chuyển blog lên: $e');
      rethrow;
    }
  }

  /// Di chuyển blog xuống dưới (hoán đổi ID với blog phía sau)
  static Future<void> moveBlogDownPermanent(
      List<Map<String, dynamic>> blogs, int blogId) async {
    try {
      final currentIndex = blogs.indexWhere((blog) => blog['id'] == blogId);

      if (currentIndex == -1 || currentIndex >= blogs.length - 1) {
        throw Exception('Blog đã ở vị trí cuối cùng');
      }

      final currentBlog = blogs[currentIndex];
      final nextBlog = blogs[currentIndex + 1];

      await swapBlogIds(currentBlog['id'], nextBlog['id']);
      debugPrint('Di chuyển blog $blogId xuống dưới thành công');
    } catch (e) {
      debugPrint('Lỗi di chuyển blog xuống: $e');
      rethrow;
    }
  }

  /// Lưu thứ tự blog mới dựa trên danh sách hiện tại
  static Future<void> saveBlogOrder(
      List<Map<String, dynamic>> currentOrder) async {
    try {
      // Tạo map ID -> vị trí mới
      Map<int, int> newPositions = {};
      for (int i = 0; i < currentOrder.length; i++) {
        final blogId = currentOrder[i]['id'] as int?;
        if (blogId != null) {
          newPositions[blogId] = i;
        }
      }

      // Lấy danh sách gốc từ database
      final originalBlogs = await getAllBlogsRaw();

      // Tạo danh sách các thay đổi cần thực hiện
      List<Map<String, dynamic>> swapsNeeded = [];

      for (int newPos = 0; newPos < currentOrder.length; newPos++) {
        final currentBlogId = currentOrder[newPos]['id'] as int?;
        final originalBlogAtPos = originalBlogs.length > newPos
            ? originalBlogs[newPos]['id'] as int?
            : null;

        if (currentBlogId != null &&
            originalBlogAtPos != null &&
            currentBlogId != originalBlogAtPos) {
          swapsNeeded.add({
            'currentId': currentBlogId,
            'targetId': originalBlogAtPos,
            'position': newPos,
          });
        }
      }

      // Thực hiện các thay đổi
      for (var swap in swapsNeeded) {
        await swapBlogIds(swap['currentId'], swap['targetId']);
      }

      debugPrint(
          'Lưu thứ tự blog thành công với ${swapsNeeded.length} thay đổi');
    } catch (e) {
      debugPrint('Lỗi lưu thứ tự blog: $e');
      rethrow;
    }
  }

  /// Xóa tất cả blog (dùng để reset database)
  static Future<void> clearAllBlogs() async {
    try {
      await SupabaseService.from(_tableName).delete().neq('id', 0);
      debugPrint('Đã xóa tất cả blog');
    } catch (e) {
      debugPrint('Lỗi xóa tất cả blog: $e');
      rethrow;
    }
  }
}
