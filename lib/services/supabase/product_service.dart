import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../screens/home/model/product_model.dart';
import '../../generated/l10n.dart';
import 'services_supabase.dart';

class ProductService {
  static const String _tableName = 'products';
  static const String _bucketName = 'product-images';

  /// Upload ảnh từ assets lên Supabase Storage
  static Future<String> uploadImageFromAssets(
      String assetPath, String fileName) async {
    try {
      // Load ảnh từ assets
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      // Upload lên Supabase Storage
      final String imageUrl = await SupabaseService.uploadFile(
        bucket: _bucketName,
        path: 'products/$fileName',
        fileBytes: bytes,
        metadata: {
          'content-type': 'image/png',
        },
      );

      return imageUrl;
    } catch (e) {
      debugPrint('Lỗi upload ảnh $assetPath: $e');
      rethrow;
    }
  }

  /// Upload ảnh từ bytes lên Supabase Storage (cho web platform)
  static Future<String> uploadImageFromBytes(
      Uint8List imageBytes, String fileName) async {
    try {
      final String imageUrl = await SupabaseService.uploadFile(
        bucket: _bucketName,
        path: 'products/$fileName',
        fileBytes: imageBytes,
        metadata: {
          'content-type': 'image/png',
        },
      );

      return imageUrl;
    } catch (e) {
      debugPrint('Lỗi upload ảnh từ bytes: $e');
      rethrow;
    }
  }

  static Future<String> uploadImageFromFile(
      File imageFile, String fileName) async {
    try {
      final Uint8List bytes = await imageFile.readAsBytes();

      final String imageUrl = await SupabaseService.uploadFile(
        bucket: _bucketName,
        path: 'products/$fileName',
        fileBytes: bytes,
        metadata: {
          'content-type': 'image/png',
        },
      );

      return imageUrl;
    } catch (e) {
      debugPrint('Lỗi upload file ảnh: $e');
      rethrow;
    }
  }

  /// Thêm sản phẩm mới vào Supabase
  static Future<Map<String, dynamic>> addProduct({
    required Product product,
    required String category,
    required int categoryId,
    String? imageAssetPath,
    File? imageFile,
    Uint8List? imageBytes,
    bool isBestSeller = false,
  }) async {
    try {
      String? imageUrl;
      String? imagePath;

      // Upload ảnh nếu có
      if (imageAssetPath != null) {
        final fileName =
            'product_${product.id}_${DateTime.now().millisecondsSinceEpoch}.png';
        imageUrl = await uploadImageFromAssets(imageAssetPath, fileName);
        imagePath = 'products/$fileName';
      } else if (imageFile != null) {
        final fileName =
            'product_${product.id}_${DateTime.now().millisecondsSinceEpoch}.png';
        imageUrl = await uploadImageFromFile(imageFile, fileName);
        imagePath = 'products/$fileName';
      } else if (imageBytes != null) {
        final fileName =
            'product_${product.id}_${DateTime.now().millisecondsSinceEpoch}.png';
        imageUrl = await uploadImageFromBytes(imageBytes, fileName);
        imagePath = 'products/$fileName';
      }

      // Thêm sản phẩm vào database
      final response = await SupabaseService.from(_tableName)
          .insert({
            'name': product.name,
            'name_english': product.nameEnglish,
            'country': product.country,
            'price': product.price,
            'image_url': imageUrl,
            'image_path': imagePath,
            'category': category,
            'category_id': categoryId,
            'is_best_seller': isBestSeller,
            'is_active': true, // Mặc định sản phẩm mới là active
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      debugPrint('Thêm sản phẩm thành công: ${product.name}');
      return response;
    } catch (e) {
      debugPrint('Lỗi thêm sản phẩm ${product.name}: $e');
      rethrow;
    }
  }

  /// Sync tất cả sản phẩm từ AdminScreenVm lên Supabase
  static Future<void> syncAllProductsToSupabase(
      Map<String, List<Product>> productsByFilter) async {
    try {
      debugPrint('Bắt đầu sync ${productsByFilter.length} categories...');

      int totalProducts = 0;
      int successCount = 0;
      int errorCount = 0;

      for (final category in productsByFilter.keys) {
        final products = productsByFilter[category]!;
        debugPrint(
            'Đang sync category: $category (${products.length} sản phẩm)');

        for (final product in products) {
          try {
            totalProducts++;

            // Kiểm tra xem sản phẩm đã tồn tại chưa (dựa vào tên và category)
            final existingProduct = await SupabaseService.from(_tableName)
                .select('id')
                .eq('name', product.name)
                .eq('category', category)
                .maybeSingle();

            if (existingProduct != null) {
              debugPrint(
                  'Sản phẩm ${product.name} (category: $category) đã tồn tại, bỏ qua');
              continue;
            }

            // Xác định ảnh asset path - product.image đã là full path
            String assetPath = product.image;

            // Kiểm tra xem có phải best seller không
            bool isBestSeller = productsByFilter[S.current.best_seller]
                    ?.any((p) => p.id == product.id) ??
                false;

            await addProduct(
              product: product,
              category: category,
              categoryId: 1,
              imageAssetPath: assetPath,
              isBestSeller: isBestSeller,
            );

            successCount++;
            debugPrint('✅ Sync thành công: ${product.name}');

            // Delay nhỏ để tránh rate limit
            await Future.delayed(const Duration(milliseconds: 100));
          } catch (e) {
            errorCount++;
            debugPrint('❌ Lỗi sync sản phẩm ${product.name}: $e');
          }
        }
      }

      debugPrint(
          '🎉 Hoàn thành sync: $successCount/$totalProducts sản phẩm thành công, $errorCount lỗi');
    } catch (e) {
      debugPrint('Lỗi sync tổng thể: $e');
      rethrow;
    }
  }

  /// Lấy tất cả sản phẩm từ Supabase
  static Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      final response = await SupabaseService.from(_tableName)
          .select('*')
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Lỗi lấy danh sách sản phẩm: $e');
      rethrow;
    }
  }

  /// Lấy chỉ những sản phẩm active từ Supabase
  static Future<List<Map<String, dynamic>>> getActiveProducts() async {
    try {
      final response = await SupabaseService.from(_tableName)
          .select('*')
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Lỗi lấy danh sách sản phẩm active: $e');
      rethrow;
    }
  }

  /// Lấy sản phẩm theo category (chỉ những sản phẩm active)
  /// Lấy sản phẩm theo category (chỉ active)
  static Future<List<Map<String, dynamic>>> getProductsByCategory(
      String category) async {
    try {
      final response = await SupabaseService.client
          .from('products')
          .select('*, categories!inner(is_active)')
          .eq('category', category)
          .eq('is_active', true) // sản phẩm active
          .eq('categories.is_active', true) // category cũng phải active
          .order('id', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Lỗi lấy sản phẩm theo category $category: $e');
      rethrow;
    }
  }

  /// Lấy sản phẩm best seller (chỉ những sản phẩm active)
  static Future<List<Map<String, dynamic>>> getBestSellerProducts() async {
    try {
      final response = await SupabaseService.client
          .from('products')
          .select('*, categories!inner(id, name, is_active)')
          .eq('is_best_seller', true)
          .eq('is_active', true)
          .eq('categories.is_active', true)
          .order('id', ascending: true);


      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Lỗi lấy sản phẩm best seller: $e');
      rethrow;
    }
  }
  /// Cập nhật sản phẩm
  static Future<Map<String, dynamic>> updateProduct({
    required int productId,
    String? name,
    double? price,
    String? country,
    String? category,

    bool? isBestSeller,
    bool? isActive,
    File? newImageFile,
    Uint8List? newImageBytes,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (name != null) updateData['name'] = name;
      if (price != null) updateData['price'] = price;
      if (country != null) updateData['country'] = country;
      if (category != null) updateData['category'] = category;

      if (isBestSeller != null) updateData['is_best_seller'] = isBestSeller;
      if (isActive != null) updateData['is_active'] = isActive;

      // Upload ảnh mới nếu có
      if (newImageFile != null) {
        final fileName =
            'product_${productId}_${DateTime.now().millisecondsSinceEpoch}.png';
        final imageUrl = await uploadImageFromFile(newImageFile, fileName);
        updateData['image_url'] = imageUrl;
        updateData['image_path'] = 'products/$fileName';
      } else if (newImageBytes != null) {
        final fileName =
            'product_${productId}_${DateTime.now().millisecondsSinceEpoch}.png';
        final imageUrl = await uploadImageFromBytes(newImageBytes, fileName);
        updateData['image_url'] = imageUrl;
        updateData['image_path'] = 'products/$fileName';
      }

      updateData['updated_at'] = DateTime.now().toIso8601String();

      final response = await SupabaseService.from(_tableName)
          .update(updateData)
          .eq('id', productId)
          .select()
          .single();

      debugPrint('Cập nhật sản phẩm thành công: id $productId');
      return response;
    } catch (e) {
      debugPrint('Lỗi cập nhật sản phẩm id $productId: $e');
      rethrow;
    }
  }

  /// Xóa sản phẩm theo ID
  static Future<void> deleteProduct(int productId) async {
    try {
      // Lấy thông tin ảnh trước khi xóa
      final product = await SupabaseService.from(_tableName)
          .select('image_path')
          .eq('id', productId)
          .maybeSingle();

      // Xóa sản phẩm khỏi database
      await SupabaseService.from(_tableName).delete().eq('id', productId);

      // Xóa ảnh khỏi storage nếu có
      if (product != null && product['image_path'] != null) {
        try {
          await SupabaseService.deleteFile(
            bucket: _bucketName,
            path: product['image_path'],
          );
        } catch (e) {
          debugPrint('Không thể xóa ảnh: $e');
        }
      }

      debugPrint('Xóa sản phẩm thành công: ID $productId');
    } catch (e) {
      debugPrint('Lỗi xóa sản phẩm ID $productId: $e');
      rethrow;
    }
  }

  /// Xóa sản phẩm theo key (để tương thích với code cũ)
  /// Lưu ý: Vì bảng không có cột 'key', method này sẽ xóa theo 'id'
  static Future<void> deleteProductByKey(int productKey) async {
    try {
      // Lấy thông tin ảnh trước khi xóa
      final product = await SupabaseService.from(_tableName)
          .select('image_path')
          .eq('id', productKey) // Sử dụng 'id' thay vì 'key'
          .maybeSingle();

      // Xóa sản phẩm khỏi database
      await SupabaseService.from(_tableName)
          .delete()
          .eq('id', productKey); // Sử dụng 'id' thay vì 'key'

      // Xóa ảnh khỏi storage nếu có
      if (product != null && product['image_path'] != null) {
        try {
          await SupabaseService.deleteFile(
            bucket: _bucketName,
            path: product['image_path'],
          );
        } catch (e) {
          debugPrint('Không thể xóa ảnh: $e');
        }
      }

      debugPrint('Xóa sản phẩm thành công: id $productKey');
    } catch (e) {
      debugPrint('Lỗi xóa sản phẩm id $productKey: $e');
      rethrow;
    }
  }

  /// Xóa tất cả sản phẩm (dùng để reset database)
  static Future<void> clearAllProducts() async {
    try {
      await SupabaseService.from(_tableName)
          .delete()
          .neq('id', '00000000-0000-0000-0000-000000000000');
      debugPrint('Đã xóa tất cả sản phẩm');
    } catch (e) {
      debugPrint('Lỗi xóa tất cả sản phẩm: $e');
      rethrow;
    }
  }

  /// Convert từ Supabase data sang Product model
  static Product fromSupabaseData(Map<String, dynamic> data) {
    return Product(
      id: data['id'] ?? 0,
      name: data['name'],
      nameEnglish: data['name_english'] ?? '',
      country: data['country'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      image: data['image_url'] ?? '', // Dùng URL thay vì asset path
      category: data['category'] ?? '',
      categoryId: data['category_id'],
      isBestSeller: data['is_best_seller'] ?? false,
      isActive: data['is_active'] ?? true,
    );
  }

  /// Ẩn sản phẩm (khi hết hàng)
  static Future<void> hideProduct(int productId) async {
    try {
      await SupabaseService.from(_tableName).update({
        'is_active': false,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', productId);

      debugPrint('Ẩn sản phẩm thành công: ID $productId');
    } catch (e) {
      debugPrint('Lỗi ẩn sản phẩm ID $productId: $e');
      rethrow;
    }
  }

  /// Hiện sản phẩm (khi có hàng trở lại)
  static Future<void> showProduct(int productId) async {
    try {
      await SupabaseService.from(_tableName).update({
        'is_active': true,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', productId);

      debugPrint('Hiện sản phẩm thành công: ID $productId');
    } catch (e) {
      debugPrint('Lỗi hiện sản phẩm ID $productId: $e');
      rethrow;
    }
  }

  /// Toggle trạng thái active của sản phẩm
  static Future<void> toggleProductStatus(int productId) async {
    try {
      // Lấy trạng thái hiện tại
      final currentProduct = await SupabaseService.from(_tableName)
          .select('is_active')
          .eq('id', productId)
          .single();

      final currentStatus = currentProduct['is_active'] ?? true;

      // Toggle trạng thái
      await SupabaseService.from(_tableName).update({
        'is_active': !currentStatus,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', productId);

      debugPrint(
          'Toggle trạng thái sản phẩm thành công: ID $productId (${!currentStatus ? 'hiện' : 'ẩn'})');
    } catch (e) {
      debugPrint('Lỗi toggle trạng thái sản phẩm ID $productId: $e');
      rethrow;
    }
  }

  /// Lấy sản phẩm theo trạng thái active
  static Future<List<Map<String, dynamic>>> getProductsByStatus(
      {bool? isActive}) async {
    try {
      var query = SupabaseService.from(_tableName).select('*');

      if (isActive != null) {
        query = query.eq('is_active', isActive);
      }

      final response = await query.order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Lỗi lấy sản phẩm theo trạng thái: $e');
      rethrow;
    }
  }

  /// Lấy sản phẩm theo ID
  static Future<Map<String, dynamic>?> getProductById(int productId) async {
    try {
      final response = await SupabaseService.from(_tableName)
          .select('*')
          .eq('id', productId)
          .maybeSingle();

      return response;
    } catch (e) {
      debugPrint('Lỗi lấy sản phẩm theo ID $productId: $e');
      rethrow;
    }
  }

  /// Cập nhật số lượng tồn kho (nếu cần)
  static Future<void> updateStock(int productId, int stockQuantity) async {
    try {
      final updateData = <String, dynamic>{
        'stock_quantity': stockQuantity,
        'is_active': stockQuantity > 0, // Tự động ẩn nếu hết hàng
        'updated_at': DateTime.now().toIso8601String(),
      };

      await SupabaseService.from(_tableName)
          .update(updateData)
          .eq('id', productId);

      debugPrint(
          'Cập nhật tồn kho thành công: ID $productId, số lượng: $stockQuantity');
    } catch (e) {
      debugPrint('Lỗi cập nhật tồn kho ID $productId: $e');
      rethrow;
    }
  }
}
