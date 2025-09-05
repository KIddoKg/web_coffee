import 'package:flutter/services.dart';
import 'package:xanh_coffee/generated/l10n.dart';
import 'package:xanh_coffee/screens/home/model/product_model.dart';
import 'package:xanh_coffee/services/supabase/product_service.dart';

import '../../../share/app_imports.dart';

class AdminScreenVm extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isSyncingToSupabase = false;
  bool get isSyncingToSupabase => _isSyncingToSupabase;

  List<Map<String, dynamic>> _supabaseProducts = [];
  List<Map<String, dynamic>> get supabaseProducts => _supabaseProducts;

  // Map<String, List<Product>> productsByFilter = {
  //   S.current.best_seller: [
  //     Product(
  //       key: 6,
  //       name: S.current.milk_tea_classic,
  //       country: "Vietnam",
  //       price: 25000,
  //       image: Assets.png.png6.keyName,
  //     ),
  //     Product(
  //       key: 7,
  //       name: S.current.milk_tea_chocolate,
  //       country: "Vietnam",
  //       price: 30000,
  //       image: Assets.png.png7.keyName,
  //     ),
  //     Product(
  //       key: 36,
  //       name: S.current.yaourt_passion,
  //       country: "Vietnam",
  //       price: 20000,
  //       image: Assets.png.png36.keyName,
  //     ),
  //     Product(
  //       key: 37,
  //       name: S.current.soda_lemon,
  //       country: "Vietnam",
  //       price: 35000,
  //       image: Assets.png.png37.keyName,
  //     ),
  //     Product(
  //       key: 1,
  //       name: S.current.coffee_ice,
  //       country: "Vietnam",
  //       price: 20000,
  //       image: Assets.png.png1.keyName,
  //     ),
  //     Product(
  //       key: 2,
  //       name: S.current.milk_coffee_ice,
  //       country: "Vietnam",
  //       price: 25000,
  //       image: Assets.png.png2.keyName,
  //     ),
  //   ],
  //   S.current.coffee_drink: [
  //     Product(
  //       key: 1,
  //       name: S.current.coffee_ice,
  //       country: "Vietnam",
  //       price: 20000,
  //       image: Assets.png.png1.keyName,
  //     ),
  //     Product(
  //       key: 2,
  //       name: S.current.milk_coffee_ice,
  //       country: "Vietnam",
  //       price: 25000,
  //       image: Assets.png.png2.keyName,
  //     ),
  //     Product(
  //       key: 3,
  //       name: S.current.bac_xiu_ice,
  //       country: "Vietnam",
  //       price: 25000,
  //       image: Assets.png.png3.keyName,
  //     ),
  //     Product(
  //       key: 4,
  //       name: S.current.cacao_milk_ice,
  //       country: "Vietnam",
  //       price: 25000,
  //       image: Assets.png.png4.keyName,
  //     ),
  //     Product(
  //       key: 5,
  //       name: S.current.salted_coffee,
  //       country: "Vietnam",
  //       price: 25000,
  //       image: Assets.png.png5.keyName,
  //     ),
  //   ],
  //   S.current.milk_tea_drink: [
  //     Product(
  //       key: 6,
  //       name: S.current.milk_tea_classic,
  //       country: "Vietnam",
  //       price: 25000,
  //       image: Assets.png.png6.keyName,
  //     ),
  //     Product(
  //       key: 7,
  //       name: S.current.milk_tea_chocolate,
  //       country: "Vietnam",
  //       price: 30000,
  //       image: Assets.png.png7.keyName,
  //     ),
  //     Product(
  //       key: 8,
  //       name: S.current.milk_tea_butterfly_pea,
  //       country: "Vietnam",
  //       price: 30000,
  //       image: Assets.png.png8.keyName,
  //     ),
  //     Product(
  //       key: 9,
  //       name: S.current.milk_tea_young_rice,
  //       country: "Vietnam",
  //       price: 30000,
  //       image: Assets.png.png9.keyName,
  //     ),
  //     Product(
  //       key: 10,
  //       name: S.current.milk_tea_taro,
  //       country: "Vietnam",
  //       price: 30000,
  //       image: Assets.png.png10.keyName,
  //     ),
  //     Product(
  //       key: 11,
  //       name: S.current.latte_matcha,
  //       country: "Vietnam",
  //       price: 30000,
  //       image: Assets.png.png11.keyName,
  //     ),
  //     Product(
  //       key: 12,
  //       name: S.current.latte_taro,
  //       country: "Vietnam",
  //       price: 30000,
  //       image: Assets.png.png12.keyName,
  //     ),
  //     Product(
  //       key: 13,
  //       name: S.current.latte_chocolate,
  //       country: "Vietnam",
  //       price: 30000,
  //       image: Assets.png.png13.keyName,
  //     ),
  //     Product(
  //       key: 14,
  //       name: S.current.latte_strawberry_matcha,
  //       country: "Vietnam",
  //       price: 35000,
  //       image: Assets.png.png14.keyName,
  //     ),
  //   ],
  //   S.current.fruit_drink: [
  //     Product(
  //       key: 15,
  //       name: S.current.fruit_tea_soursop,
  //       country: "Vietnam",
  //       price: 30000,
  //       image: Assets.png.png15.keyName,
  //     ),
  //     Product(
  //       key: 16,
  //       name: S.current.fruit_tea_pineapple_leaf,
  //       country: "Vietnam",
  //       price: 30000,
  //       image: Assets.png.png16.keyName,
  //     ),
  //     Product(
  //       key: 17,
  //       name: S.current.fruit_tea_peach_lemongrass,
  //       country: "Vietnam",
  //       price: 30000,
  //       image: Assets.png.png17.keyName,
  //     ),
  //     Product(
  //       key: 18,
  //       name: S.current.fruit_tea_lychee,
  //       country: "Vietnam",
  //       price: 30000,
  //       image: Assets.png.png18.keyName,
  //     ),
  //     Product(
  //       key: 19,
  //       name: S.current.fruit_tea_lipton_plum,
  //       country: "Vietnam",
  //       price: 20000,
  //       image: Assets.png.png19.keyName,
  //     ),
  //     Product(
  //       key: 20,
  //       name: S.current.fruit_tea_kumquat,
  //       country: "Vietnam",
  //       price: 20000,
  //       image: Assets.png.png20.keyName,
  //     ),
  //     Product(
  //       key: 21,
  //       name: S.current.fruit_tea_wintermelon,
  //       country: "Vietnam",
  //       price: 20000,
  //       image: Assets.png.png21.keyName,
  //     ),
  //   ],
  //   S.current.juice_drink: [
  //     Product(
  //       key: 22,
  //       name: S.current.juice_guava,
  //       country: "Vietnam",
  //       price: 30000,
  //       image: Assets.png.png22.keyName,
  //     ),
  //     Product(
  //       key: 23,
  //       name: S.current.juice_pineapple,
  //       country: "Vietnam",
  //       price: 30000,
  //       image: Assets.png.png23.keyName,
  //     ),
  //     Product(
  //       key: 24,
  //       name: S.current.juice_watermelon,
  //       country: "Vietnam",
  //       price: 30000,
  //       image: Assets.png.png24.keyName,
  //     ),
  //     Product(
  //       key: 25,
  //       name: S.current.juice_apple,
  //       country: "Vietnam",
  //       price: 35000,
  //       image: Assets.png.png25.keyName,
  //     ),
  //     Product(
  //       key: 26,
  //       name: S.current.juice_orange,
  //       country: "Vietnam",
  //       price: 20000,
  //       image: Assets.png.png26.keyName,
  //     ),
  //     Product(
  //       key: 27,
  //       name: S.current.juice_passion,
  //       country: "Vietnam",
  //       price: 20000,
  //       image: Assets.png.png27.keyName,
  //     ),
  //   ],
  //   S.current.smoothie_drink: [
  //     Product(
  //       key: 28,
  //       name: S.current.smoothie_avocado,
  //       country: "Vietnam",
  //       price: 30000,
  //       image: Assets.png.png28.keyName,
  //     ),
  //     Product(
  //       key: 29,
  //       name: S.current.smoothie_sapoche,
  //       country: "Vietnam",
  //       price: 30000,
  //       image: Assets.png.png29.keyName,
  //     ),
  //     Product(
  //       key: 30,
  //       name: S.current.smoothie_strawberry,
  //       country: "Vietnam",
  //       price: 30000,
  //       image: Assets.png.png30.keyName,
  //     ),
  //     Product(
  //       key: 31,
  //       name: S.current.smoothie_soursop,
  //       country: "Vietnam",
  //       price: 30000,
  //       image: Assets.png.png31.keyName,
  //     ),
  //   ],
  //   S.current.ice_blended_drink: [
  //     Product(
  //       key: 32,
  //       name: S.current.blend_blueberry,
  //       country: "Vietnam",
  //       price: 35000,
  //       image: Assets.png.png32.keyName,
  //     ),
  //     Product(
  //       key: 33,
  //       name: S.current.blend_cacao_milk,
  //       country: "Vietnam",
  //       price: 35000,
  //       image: Assets.png.png33.keyName,
  //     ),
  //   ],
  //   S.current.yaourt_soda_drink: [
  //     Product(
  //       key: 34,
  //       name: S.current.yaourt_crushed_ice,
  //       country: "Vietnam",
  //       price: 20000,
  //       image: Assets.png.png34.keyName,
  //     ),
  //     Product(
  //       key: 35,
  //       name: S.current.yaourt_blueberry,
  //       country: "Vietnam",
  //       price: 25000,
  //       image: Assets.png.png35.keyName,
  //     ),
  //     Product(
  //       key: 36,
  //       name: S.current.yaourt_passion,
  //       country: "Vietnam",
  //       price: 20000,
  //       image: Assets.png.png36.keyName,
  //     ),
  //     Product(
  //       key: 37,
  //       name: S.current.soda_lemon,
  //       country: "Vietnam",
  //       price: 35000,
  //       image: Assets.png.png37.keyName,
  //     ),
  //   ],
  // };

  Map<String, List<Product>> productsByFilter = {};

  /// Sync tất cả sản phẩm local lên Supabase
  Future<void> syncProductsToSupabase() async {
    _isSyncingToSupabase = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ProductService.syncAllProductsToSupabase(productsByFilter);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Lỗi sync sản phẩm: $e';
    } finally {
      _isSyncingToSupabase = false;
      notifyListeners();
    }
  }

  /// Lấy danh sách sản phẩm từ Supabase
  Future<void> loadProductsFromSupabase() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _supabaseProducts = await ProductService.getAllProducts();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Lỗi tải sản phẩm: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Lấy sản phẩm theo category từ Supabase
  Future<List<Map<String, dynamic>>> getProductsByCategory(
      String category) async {
    try {
      return await ProductService.getProductsByCategory(category);
    } catch (e) {
      _errorMessage = 'Lỗi lấy sản phẩm theo category: $e';
      notifyListeners();
      return [];
    }
  }

  /// Lấy sản phẩm best seller từ Supabase
  Future<List<Map<String, dynamic>>> getBestSellerProducts() async {
    try {
      return await ProductService.getBestSellerProducts();
    } catch (e) {
      _errorMessage = 'Lỗi lấy sản phẩm best seller: $e';
      notifyListeners();
      return [];
    }
  }

  /// Xóa tất cả sản phẩm trên Supabase (để reset)
  Future<void> clearSupabaseProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ProductService.clearAllProducts();
      _supabaseProducts.clear();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Lỗi xóa sản phẩm: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Xóa error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Debug: Test sync một sản phẩm đơn lẻ
  Future<void> debugSyncSingleProduct() async {
    _isSyncingToSupabase = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('=== DEBUG SINGLE PRODUCT SYNC ===');

      // Lấy sản phẩm đầu tiên từ juice_drink (png_24.png)
      final testProduct = productsByFilter[S.current.juice_drink]?.first;
      if (testProduct == null) {
        throw Exception('Không tìm thấy sản phẩm test');
      }

      print('Test product: ${testProduct.name}');
      print('Test product image: ${testProduct.image}');
      print('Test product id: ${testProduct.id}');

      // Test asset path
      try {
        final data = await rootBundle.load(testProduct.image);
        print(
            '✅ Asset exists: ${testProduct.image} (${data.lengthInBytes} bytes)');
      } catch (e) {
        print('❌ Asset load error: $e');
        throw Exception('Asset không tồn tại: ${testProduct.image}');
      }

      // Xóa sản phẩm test cũ nếu có
      try {
        await ProductService.deleteProduct(testProduct.id);
        print('Đã xóa sản phẩm test cũ');
      } catch (e) {
        print('Không có sản phẩm test cũ để xóa: $e');
      }

      // Sync sản phẩm
      await ProductService.addProduct(
        product: testProduct,
        category: S.current.juice_drink,
        categoryId: 1,
        imageAssetPath: testProduct.image,
        isBestSeller: false,
      );

      print('✅ Debug sync thành công!');
      _errorMessage = null;
    } catch (e) {
      print('❌ Debug sync lỗi: $e');
      _errorMessage = 'Debug sync lỗi: $e';
    } finally {
      _isSyncingToSupabase = false;
      notifyListeners();
    }
  }
}
