import 'package:flutter/foundation.dart' hide Category;
import '../../screens/home/model/category_model.dart';
import 'services_supabase.dart';

class CategoryService {
  static const String _tableName = 'categories';

  /// Lấy tất cả categories
  static Future<List<Category>> getAllCategories({bool? isActive}) async {
    try {
      var query = SupabaseService.from(_tableName).select();

      if (isActive != null) {
        query = query.eq('is_active', isActive);
      }

      final response = await query.order('name');

      return response.map<Category>((json) => Category.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Lỗi lấy danh sách categories: $e');
      rethrow;
    }
  }

  /// Lấy category theo ID
  static Future<Category?> getCategoryById(int id) async {
    try {
      final response = await SupabaseService.from(_tableName)
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      return Category.fromJson(response);
    } catch (e) {
      debugPrint('Lỗi lấy category theo ID: $e');
      rethrow;
    }
  }

  /// Thêm category mới
  static Future<Category> addCategory({
    required String name,
    String? nameEn,
    String? description,
    bool isActive = true,
  }) async {
    try {
      final response = await SupabaseService.from(_tableName)
          .insert({
            'name': name,
            'name_en': nameEn,
            'description': description,
            'is_active': isActive,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      debugPrint('Thêm category thành công: $name');
      return Category.fromJson(response);
    } catch (e) {
      debugPrint('Lỗi thêm category: $e');
      rethrow;
    }
  }

  /// Cập nhật category
  static Future<Category> updateCategory({
    required int id,
    String? name,
    String? nameEn,
    String? description,
    bool? isActive,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (name != null) updateData['name'] = name;
      if (nameEn != null) updateData['name_en'] = nameEn;
      if (description != null) updateData['description'] = description;
      if (isActive != null) updateData['is_active'] = isActive;

      final response = await SupabaseService.from(_tableName)
          .update(updateData)
          .eq('id', id)
          .select()
          .single();

      debugPrint('Cập nhật category thành công: ID $id');
      return Category.fromJson(response);
    } catch (e) {
      debugPrint('Lỗi cập nhật category: $e');
      rethrow;
    }
  }

  /// Xóa category (soft delete - chỉ ẩn)
  static Future<void> hideCategory(int id) async {
    try {
      await updateCategory(id: id, isActive: false);
      debugPrint('Ẩn category thành công: ID $id');
    } catch (e) {
      debugPrint('Lỗi ẩn category: $e');
      rethrow;
    }
  }

  /// Hiện category
  static Future<void> showCategory(int id) async {
    try {
      await updateCategory(id: id, isActive: true);
      debugPrint('Hiện category thành công: ID $id');
    } catch (e) {
      debugPrint('Lỗi hiện category: $e');
      rethrow;
    }
  }

  /// Xóa category hoàn toàn (chỉ nên dùng khi không còn sản phẩm nào)
  static Future<void> deleteCategory(int id) async {
    try {
      // Kiểm tra xem có sản phẩm nào đang sử dụng category này không
      final productsResponse = await SupabaseService.from('products')
          .select('id')
          .eq('category_id', id);

      if (productsResponse.isNotEmpty) {
        throw Exception(
            'Không thể xóa category vì còn có sản phẩm đang sử dụng');
      }

      await SupabaseService.from(_tableName).delete().eq('id', id);

      debugPrint('Xóa category thành công: ID $id');
    } catch (e) {
      debugPrint('Lỗi xóa category: $e');
      rethrow;
    }
  }

  /// Kiểm tra tên category có bị trùng không
  static Future<bool> isCategoryNameExists(String name,
      {int? excludeId}) async {
    try {
      var query =
          SupabaseService.from(_tableName).select('id').eq('name', name);

      if (excludeId != null) {
        query = query.neq('id', excludeId);
      }

      final response = await query.maybeSingle();
      return response != null;
    } catch (e) {
      debugPrint('Lỗi kiểm tra tên category: $e');
      return false;
    }
  }

  /// Lấy số lượng sản phẩm theo category
  static Future<Map<int, int>> getProductCountByCategory() async {
    try {
      final response = await SupabaseService.from('products')
          .select('category_id')
          .eq('is_active', true);

      final Map<int, int> countMap = {};
      for (final item in response) {
        final categoryId = item['category_id'] as int?;
        if (categoryId != null) {
          countMap[categoryId] = (countMap[categoryId] ?? 0) + 1;
        }
      }

      return countMap;
    } catch (e) {
      debugPrint('Lỗi lấy số lượng sản phẩm theo category: $e');
      return {};
    }
  }
}
