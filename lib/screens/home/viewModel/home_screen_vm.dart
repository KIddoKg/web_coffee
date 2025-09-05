import 'dart:convert';

import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xanh_coffee/screens/home/home_screen.dart';
import 'package:xanh_coffee/screens/home/model/feedback_model.dart';
import 'package:xanh_coffee/screens/home/model/product_model.dart';
import 'package:xanh_coffee/screens/home/model/category_model.dart';
import 'package:xanh_coffee/screens/home/model/blog_model.dart';
import 'package:xanh_coffee/screens/home/model/qrcode_model.dart';
import 'package:xanh_coffee/services/supabase/product_service.dart';
import 'package:xanh_coffee/services/supabase/category_service.dart';
import 'package:xanh_coffee/services/supabase/feedback_service.dart';
import 'package:xanh_coffee/services/supabase/blog_service.dart';
import 'package:xanh_coffee/services/supabase/qrcode_service.dart';
import 'package:xanh_coffee/share/share_on_app.dart';

import '../../../app.dart';
import '../../../generated/l10n.dart';
import '../../../main.dart';
import '../../../share/app_imports.dart';

class HomeScreenVm extends ChangeNotifier {
  /// 🔄 Reset all data
  void reset() {}

  // Database-related properties
  List<Category> _categories = [];
  List<Product> _allProducts = [];
  List<FeedbackModel> _feedbacks = [];
  List<BlogModel> _blogs = [];
  List<QRCodeModel> _qrCodes = [];
  bool _isLoadingCategories = false;
  bool _isLoadingProducts = false;
  bool _isLoadingFeedbacks = false;
  bool _isLoadingBlogs = false;
  bool _isLoadingQRCodes = false;
  String? _errorMessage;

  // Getters for database data
  List<Category> get categories => _categories;

  List<Product> get allProducts => _allProducts;

  List<FeedbackModel> get feedbacks => _feedbacks;

  List<BlogModel> get blogs => _blogs;

  List<QRCodeModel> get qrCodes => _qrCodes;

  bool get isLoadingCategories => _isLoadingCategories;

  bool get isLoadingProducts => _isLoadingProducts;

  bool get isLoadingFeedbacks => _isLoadingFeedbacks;

  bool get isLoadingBlogs => _isLoadingBlogs;

  bool get isLoadingQRCodes => _isLoadingQRCodes;

  String? get errorMessage => _errorMessage;

  List<String> filters = [
    ""
  ];

  void init() {
    _selectedFilterIndex = 0;
    _currentPage = 0;
    _isNext = true;
    loadCartShop();
    resetFilter();
    // Load data from database
    _loadCategoriesFromDatabase();
    _loadProductsFromDatabase();
    _loadFeedbacksFromDatabase();
    _loadBlogsFromDatabase();
    _loadQRCodesFromDatabase();

    notifyListeners(); // báo cho UI update ngay lập tức
  }

  /// Load categories from database
  Future<void> _loadCategoriesFromDatabase() async {
    try {
      _isLoadingCategories = true;
      _errorMessage = null;
      notifyListeners();

      _categories = await CategoryService.getAllCategories(isActive: true);

      // Update filters based on active categories
      _updateFiltersBasedOnActiveCategories();

      debugPrint('Loaded ${_categories.length} categories from database');

      _isLoadingCategories = false;
      notifyListeners();
    } catch (e) {
      _isLoadingCategories = false;
      _errorMessage = 'Lỗi tải danh mục: $e';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }

  /// Update filters based on active categories
  void _updateFiltersBasedOnActiveCategories() {
    List<String> activeFilters = [];

    if (selectedLang == "vi") {
      activeFilters = ["Bán chạy"];
    } else {
      activeFilters = ["Best Seller"];
    }

    // Add filters for active categories using current language
    for (final category in _categories) {
      if (category.isActive) {
        final filterKey = getCategoryDisplayName(category);
        if (!activeFilters.contains(filterKey)) {
          activeFilters.add(filterKey);
        }
      }
    }

    filters = activeFilters;
    debugPrint(
        'Updated filters based on active categories: ${filters.length} filters');
  }

  /// Load blogs from database
  Future<void> _loadBlogsFromDatabase() async {
    try {
      _isLoadingBlogs = true;
      _errorMessage = null;
      notifyListeners();

      _blogs = await BlogService.getAllBlogs();

      debugPrint('Loaded ${_blogs.length} blogs from database');

      _isLoadingBlogs = false;
      notifyListeners();
    } catch (e) {
      _isLoadingBlogs = false;
      _errorMessage = 'Lỗi tải blogs: $e';
      debugPrint(_errorMessage);

      // Set empty list if database fails
      _blogs = [];

      notifyListeners();
    }
  }

  /// Load QR codes from database
  Future<void> _loadQRCodesFromDatabase() async {
    try {
      _isLoadingQRCodes = true;
      _errorMessage = null;
      notifyListeners();

      _qrCodes = await QRCodeService.getAllQRCodes();

      debugPrint('Loaded ${_qrCodes.length} QR codes from database');

      _isLoadingQRCodes = false;
      notifyListeners();
    } catch (e) {
      _isLoadingQRCodes = false;
      _errorMessage = 'Lỗi tải QR codes: $e';
      debugPrint(_errorMessage);

      // Set empty list if database fails
      _qrCodes = [];

      notifyListeners();
    }
  }

  /// Load feedbacks from database
  Future<void> _loadFeedbacksFromDatabase() async {
    try {
      _isLoadingFeedbacks = true;
      _errorMessage = null;
      notifyListeners();

      _feedbacks = await FeedbackService.getTopFeedbacks(limit: 10);

      // Reset current index if necessary
      if (_feedbacks.isNotEmpty && _currentIndex >= _feedbacks.length) {
        _currentIndex = 0;
      }

      // Update locks based on new feedbacks
      _updateLocks();

      debugPrint('Loaded ${_feedbacks.length} feedbacks from database');

      _isLoadingFeedbacks = false;
      notifyListeners();
    } catch (e) {
      _isLoadingFeedbacks = false;
      _errorMessage = 'Lỗi tải feedbacks: $e';
      debugPrint(_errorMessage);

      // Load default feedback if database fails
      _feedbacks = [
        FeedbackModel(
          title: "AWESOME COFFEE",
          reviewer: "MICHAEL T",
          date: "03/10",
          comment:
              "fantastic, solid coffee! 10/10. highly recommend. this coffee is the best around",
          rating: 5.0,
        ),
      ];
      _currentIndex = 0;
      _updateLocks();

      notifyListeners();
    }
  }

  /// Load products from database
  Future<void> _loadProductsFromDatabase() async {
    try {
      _isLoadingProducts = true;
      _errorMessage = null;
      notifyListeners();

      // Load all products (only active ones)
      final allProductsData = await ProductService.getActiveProducts();
      _allProducts = allProductsData
          .map((data) => ProductService.fromSupabaseData(data))
          .toList(); // Already filtered for active products in database query

      // Load best seller products (only active ones)
      final bestSellerData = await ProductService.getBestSellerProducts();
      final bestSellerProducts = bestSellerData
          .map((data) => ProductService.fromSupabaseData(data))
          .toList(); // Already filtered for active products in database query

      // Reset productsByFilter and populate with database data
      productsByFilter.clear();
      productsByCategoryId.clear();

      // Add best sellers
      if (selectedLang == "vi") {
        productsByFilter["Bán chạy"] = bestSellerProducts;

        // Group products by category ID for easier language switching
        for (final product in _allProducts) {
          if (product.categoryId != null) {
            if (productsByCategoryId[product.categoryId!] == null) {
              productsByCategoryId[product.categoryId!] = [];
            }
            productsByCategoryId[product.categoryId!]!.add(product);
          }
        }

        // Map to display names for Vietnamese
        for (final category in _categories) {
          if (category.isActive && productsByCategoryId[category.id] != null) {
            productsByFilter[category.name] =
                productsByCategoryId[category.id]!;
          }
        }
      } else {
        productsByFilter["Best Seller"] = bestSellerProducts;

        // Group products by category ID for easier language switching
        for (final product in _allProducts) {
          if (product.categoryId != null) {
            if (productsByCategoryId[product.categoryId!] == null) {
              productsByCategoryId[product.categoryId!] = [];
            }
            productsByCategoryId[product.categoryId!]!.add(product);
          }
        }

        // Map to display names for English
        for (final category in _categories) {
          if (category.isActive &&
              category.nameEn != null &&
              productsByCategoryId[category.id] != null) {
            productsByFilter[category.nameEn!] =
                productsByCategoryId[category.id]!;
          }
        }
      }

      debugPrint('Loaded ${_allProducts.length} products from database');

      _isLoadingProducts = false;
      notifyListeners();
    } catch (e) {
      _isLoadingProducts = false;
      _errorMessage = 'Lỗi tải sản phẩm: $e';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }

  /// Refresh data from database
  Future<void> refreshData() async {
    await Future.wait([
      _loadCategoriesFromDatabase(),
      _loadProductsFromDatabase(),
      _loadFeedbacksFromDatabase(),
      _loadBlogsFromDatabase(),
      _loadQRCodesFromDatabase(),
    ]);
  }

  // /// Get featured blogs for current language
  // List<BlogModel> getFeaturedBlogs({int limit = 3}) {
  //   final featured = _blogs.take(limit).toList();
  //   return featured;
  // }
  //
  // /// Get latest blogs for current language
  // List<BlogModel> getLatestBlogs({int limit = 5}) {
  //   // Sort by created_at if available, otherwise by id
  //   final sorted = List<BlogModel>.from(_blogs);
  //   sorted.sort((a, b) {
  //     if (a.createdAt != null && b.createdAt != null) {
  //       return b.createdAt!.compareTo(a.createdAt!);
  //     }
  //     return (b.id ?? 0).compareTo(a.id ?? 0);
  //   });
  //   return sorted.take(limit).toList();
  // }
  //
  // /// Get blog by ID
  // BlogModel? getBlogById(int id) {
  //   try {
  //     return _blogs.firstWhere((blog) => blog.id == id);
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // }

  // QR Codes helper methods

  /// Get all QR codes
  // List<QRCodeModel> getAllQRCodes() {
  //   return _qrCodes;
  // }

  // /// Get QR codes by color
  // List<QRCodeModel> getQRCodesByColor(String color) {
  //   return _qrCodes.where((qr) => qr.color == color).toList();
  // }
  //
  // /// Get QR code by ID
  // QRCodeModel? getQRCodeById(int id) {
  //   try {
  //     return _qrCodes.firstWhere((qr) => qr.id == id);
  //   } catch (e) {
  //     return null;
  //   }
  // }
  //
  // /// Search QR codes by link URL
  // List<QRCodeModel> searchQRCodes(String query) {
  //   if (query.trim().isEmpty) return _qrCodes;
  //
  //   final lowerQuery = query.toLowerCase();
  //   return _qrCodes.where((qr) =>
  //     qr.linkUrl.toLowerCase().contains(lowerQuery)
  //   ).toList();
  // }
  //
  // /// Get QR codes with images
  // List<QRCodeModel> getQRCodesWithImages() {
  //   return _qrCodes.where((qr) =>
  //     qr.imageUrl != null && qr.imageUrl!.isNotEmpty
  //   ).toList();
  // }
  //
  // /// Get QR codes without images
  // List<QRCodeModel> getQRCodesWithoutImages() {
  //   return _qrCodes.where((qr) =>
  //     qr.imageUrl == null || qr.imageUrl!.isEmpty
  //   ).toList();
  // }
  //
  // /// Get random QR codes
  // List<QRCodeModel> getRandomQRCodes({int limit = 5}) {
  //   final shuffled = List<QRCodeModel>.from(_qrCodes)..shuffle();
  //   return shuffled.take(limit).toList();
  // }
  //
  // /// Get latest QR codes
  // List<QRCodeModel> getLatestQRCodes({int limit = 5}) {
  //   final sorted = List<QRCodeModel>.from(_qrCodes);
  //   sorted.sort((a, b) {
  //     if (a.createdAt != null && b.createdAt != null) {
  //       return b.createdAt!.compareTo(a.createdAt!);
  //     }
  //     return (b.id ?? 0).compareTo(a.id ?? 0);
  //   });
  //   return sorted.take(limit).toList();
  // }

  /// Refresh QR codes only
  // Future<void> refreshQRCodes() async {
  //   await _loadQRCodesFromDatabase();
  // }

  /// Sync hardcoded data to database (use this once to populate database)
  Future<void> syncHardcodedDataToDatabase() async {
    try {
      // Create default categories if not exist
      final existingCategories = await CategoryService.getAllCategories();
      final categoryNames = [];

      for (String categoryName in categoryNames) {
        bool exists = existingCategories.any((cat) => cat.name == categoryName);
        if (!exists) {
          await CategoryService.addCategory(
            name: categoryName,
            description: 'Danh mục $categoryName',
            isActive: true,
          );
          debugPrint('Added category: $categoryName');
        }
      }

      // Note: Product syncing should be done carefully to avoid duplicates
      // You can uncomment and modify this if you have hardcoded products to sync
      /*
      if (productsByFilter.isNotEmpty) {
        await ProductService.syncAllProductsToSupabase(productsByFilter);
        debugPrint('Synced all products to database');
      }
      */

      await refreshData();
    } catch (e) {
      debugPrint('Error syncing data to database: $e');
      _errorMessage = 'Lỗi đồng bộ dữ liệu: $e';
      notifyListeners();
    }
  }

  void resetFilter() {
    // Don't override filters if they've been updated based on active categories
    // Only reset if categories haven't been loaded yet
    if (_categories.isEmpty) {
      filters = [
        "Best Seller",
        "Trà sữa",
        "Đồ uống cà phê",
        "Trà trái cây",
        "Nước ép",
        "Sinh tố",
        "Đá xay",
        "Yaourt & Soda",
      ];
    }

    productsByFilter = {};
    productsByCategoryId = {};

    notifyListeners();
  }

  int _selectedFilterIndex = 0;
  int _currentPage = 0;
  bool _isNext = true;

  Map<String, List<Product>> productsByFilter = {};
  Map<int, List<Product>> productsByCategoryId =
      {}; // New: Filter by category ID

  int get selectedFilterIndex => _selectedFilterIndex;

  int get currentPage => _currentPage;

  bool get isNext => _isNext;

  String get currentFilter => filters[_selectedFilterIndex];

  List<Product> get filteredProducts => productsByFilter[currentFilter] ?? [];

  int get totalPages => (filteredProducts.length / 6).ceil();

  List<Product> get currentProducts {
    final startIndex = _currentPage * 6;
    final endIndex = (startIndex + 6).clamp(0, filteredProducts.length);
    return filteredProducts.sublist(startIndex, endIndex);
  }

  bool isLoading = false;

  Future<void> selectFilter(int index) async {
    _selectedFilterIndex = index;
    _currentPage = 0;
    isLoading = true;
    notifyListeners();

    // Load products for selected filter if not already loaded
    await _loadProductsForCurrentFilter();

    await Future.delayed(const Duration(milliseconds: 1100));
    isLoading = false;

    notifyListeners();
  }

  /// Load products for current filter from database
  Future<void> _loadProductsForCurrentFilter() async {
    try {
      final filterKey = filters[_selectedFilterIndex];

      // If already loaded, skip
      if (productsByFilter[filterKey] != null &&
          productsByFilter[filterKey]!.isNotEmpty) {
        return;
      }

      if (filterKey == "Best Seller" || filterKey == "Bán chạy") {
        // Load best seller products (only active ones)
        final bestSellerData = await ProductService.getBestSellerProducts();
        productsByFilter[filterKey] = bestSellerData
            .map((data) => ProductService.fromSupabaseData(data))
            .toList();
      } else {
        // Find category by current language display name
        final category = findCategoryByDisplayName(filterKey);

        if (category != null && category.isActive && category.id != -1) {
          // Use products already grouped by category ID
          if (productsByCategoryId[category.id] != null) {
            productsByFilter[filterKey] = productsByCategoryId[category.id]!;
          } else {
            productsByFilter[filterKey] = [];
          }
        } else {
          // Category is not active, set empty list
          productsByFilter[filterKey] = [];
          debugPrint(
              'Category $filterKey is not active, skipping products load');
        }
      }

      debugPrint(
          'Loaded ${productsByFilter[filterKey]?.length ?? 0} products for filter: $filterKey');
    } catch (e) {
      debugPrint('Error loading products for filter: $e');
      _errorMessage = 'Lỗi tải sản phẩm: $e';
    }
  }

  /// Get category display name by current language
  String getCategoryDisplayName(Category category) {
    if (selectedLang == "vi") {
      return category.name;
    } else {
      return category.nameEn ??
          category.name; // Fallback to Vietnamese if English not available
    }
  }

  /// Find category by display name in current language
  Category? findCategoryByDisplayName(String displayName) {
    if (selectedLang == "vi") {
      return _categories.firstWhere(
        (cat) => cat.name == displayName && cat.isActive,
        orElse: () => Category(id: -1, name: '', isActive: false),
      );
    } else {
      return _categories.firstWhere(
        (cat) => cat.nameEn == displayName && cat.isActive,
        orElse: () => Category(id: -1, name: '', isActive: false),
      );
    }
  }

  void nextPage() {
    if (_currentPage < totalPages - 1) {
      _isNext = true;
      _currentPage++;
      notifyListeners();
    }
  }

  void prevPage() {
    if (_currentPage > 0) {
      _isNext = false;
      _currentPage--;
      notifyListeners();
    }
  }

  var _cartQuantityItems = 0;

  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();

  // final GlobalKey widgetKey = GlobalKey();

  late Function(GlobalKey) runAddToCartAnimation;

  List<Product> cartShop = [];

  /// 👆 Khi user click vào item
  void listClick(Product product, GlobalKey key) async {
    final index = cartShop.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      cartShop[index].amount += 1;
    } else {
      cartShop.add(product);
    }
    totalPrice = cartShop.fold(
      0.0,
      (sum, item) => sum + item.price * item.amount,
    );

    notifyListeners();

    await runAddToCartAnimation(key); // animation cần GlobalKey
    await cartKey.currentState!
        .runCartAnimation((++_cartQuantityItems).toString());
    await saveCartShop();
  }

  double totalPrice = 0;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  Future<void> removeItem(int index) async {
    final removedProduct = cartShop[index];
    cartShop.removeAt(index);
    totalPrice = cartShop.fold(
      0.0,
      (sum, item) => sum + item.price * item.amount,
    );

    notifyListeners();
    listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: CartItemWidget(
          vm:null,
          product: removedProduct,
          onRemove: () {},
          totalMoney: 0, // Không cần xoá lại nữa
        ),
      ),
      duration: const Duration(milliseconds: 300),
    );

    await saveCartShop();
    notifyListeners();
  }

  /// Lưu cartShop vào SharedPreferences
  Future<void> saveCartShop() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = cartShop.map((p) => p.toJson()).toList();
    prefs.setString('cartShop', jsonEncode(jsonList));
  }

  /// Load cartShop từ SharedPreferences
  Future<void> loadCartShop() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('cartShop');
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      cartShop = decoded.map((e) => Product.fromJson(e)).toList();
      totalPrice =
          cartShop.fold(0.0, (sum, item) => sum + item.price * item.amount);
      notifyListeners();
    }
  }

  Future<void> clearCartShop() async {
    cartShop.clear();
    totalPrice = 0;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cartShop', jsonEncode([]));

    notifyListeners();
  }

  int _currentIndex = 0;

  // _feedbacks sẽ được load từ database

  int get currentIndex => _currentIndex;

  FeedbackModel get currentFeedback => _feedbacks.isNotEmpty
      ? _feedbacks[_currentIndex]
      : FeedbackModel(
          title: "LOADING...",
          reviewer: "System",
          date: DateTime.now().toString().split(' ')[0],
          comment: "Loading feedbacks from database...",
          rating: 5.0);

  bool lockNext = false;
  bool lockPre = true; // ban đầu ở index 0 thì ko thể previous

  // int _currentIndex = 0;

  void nextFeedback() {
    if (_currentIndex < _feedbacks.length - 1) {
      _currentIndex++;
    }
    _updateLocks();
    notifyListeners();
  }

  void previousFeedback() {
    if (_currentIndex > 0) {
      _currentIndex--;
    }
    _updateLocks();
    notifyListeners();
  }

  /// 🔒 Update trạng thái khóa nút
  void _updateLocks() {
    lockPre = _currentIndex == 0;
    lockNext = _currentIndex == _feedbacks.length - 1;
  }

  String selectedLang = 'vi';

  final languages = ['en', 'vi'];

  Locale _locale = const Locale('vi');

  Future<void> loadSavedLocale(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString('locale') ?? 'vi';
    await setLang(context, savedCode);
  }

  Future<void> setLang(BuildContext context, String langCode) async {
    showSplashFor(Duration(seconds: 1));

    selectedLang = langCode;
    final newLocale = Locale(langCode);
    if (!S.delegate.isSupported(newLocale)) return;

    _locale = newLocale;

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', langCode);

    // Load S + update MaterialApp
    await S.load(_locale);
    MyApp.setLocale(context, _locale);
    // html.window.location.reload();

    init();

    scrollToTarget(home);
    await clearCartShop();

    // Refresh data from database with new language
    await refreshData();

    notifyListeners();
  }

  final GlobalKey home = GlobalKey();
  final GlobalKey about = GlobalKey();
  final GlobalKey product = GlobalKey();
  final GlobalKey ads = GlobalKey();
  final GlobalKey feedback = GlobalKey();
  final GlobalKey<ExpandableRevealPanelState> panelKey =
      GlobalKey<ExpandableRevealPanelState>();

  Future<void> scrollToTarget(GlobalKey key) async {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
    await Future.delayed(const Duration(milliseconds: 400), () {
      panelKey.currentState?.collapse();
    });
  }

  Future<void> openMap(double latitude, double longitude) async {
    final Uri googleMapUrl = Uri.parse(
        'https://www.google.com/maps/place/Xanh+coffee/@10.7261546,106.6128085,17z/data=!3m1!4b1!4m6!3m5!1s0x31752d003025a9cb:0xd6a68050f611e50d!8m2!3d10.7261493!4d106.6153834!16s%2Fg%2F11xtmnrkyt?entry=ttu&g_ep=EgoyMDI1MDgyNS4wIKXMDSoASAFQAw%3D%3D');

    if (await canLaunchUrl(googleMapUrl)) {
      await launchUrl(googleMapUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  Future<void> callPhoneNumber(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  Future<void> openLink(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Không mở được link: $url');
    }
  }
}
