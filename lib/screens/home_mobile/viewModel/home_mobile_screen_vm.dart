import 'dart:convert';

import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xanh_coffee/screens/home/home_screen.dart';
import 'package:xanh_coffee/screens/home/model/feedback_model.dart';
import 'package:xanh_coffee/screens/home/model/product_model.dart';
import 'package:xanh_coffee/share/share_on_app.dart';

import '../../../app.dart';
import '../../../generated/l10n.dart';
import '../../../main.dart';
import '../../../share/app_imports.dart';

class HomeMobileScreenVm extends ChangeNotifier {


  /// 🔄 Reset all data
  void reset() {}

  List<String> filters = [
    S.current.best_seller,
    S.current.milk_tea_drink,
    S.current.coffee_drink,
    S.current.fruit_drink,
    S.current.juice_drink,
    S.current.smoothie_drink,
    S.current.ice_blended_drink,
    S.current.yaourt_soda_drink,
  ];

  void init( ) {
    _selectedFilterIndex = 0;
    _currentPage = 0;
    _isNext = true;
    loadCartShop();
    resetFilter();

    notifyListeners(); // báo cho UI update ngay lập tức
  }

  void resetFilter() {
    filters = [
      S.current.best_seller,
      S.current.milk_tea_drink,
      S.current.coffee_drink,
      S.current.fruit_drink,
      S.current.juice_drink,
      S.current.smoothie_drink,
      S.current.ice_blended_drink,
      S.current.yaourt_soda_drink,
    ];
    productsByFilter = {
      S.current.best_seller: [

        Product(
          key: 6,
          name: S.current.milk_tea_classic,
          country: "Vietnam",
          price: 25000,
          image: Assets.png.png6.keyName,
        ),
        Product(
          key: 7,
          name: S.current.milk_tea_chocolate,
          country: "Vietnam",
          price: 30000,
          image: Assets.png.png7.keyName,
        ),
        Product(
          key: 36,
          name: S.current.yaourt_passion,
          country: "Vietnam",
          price: 20000,
          image: Assets.png.png36.keyName,
        ),
        Product(
          key: 37,
          name: S.current.soda_lemon,
          country: "Vietnam",
          price: 35000,
          image: Assets.png.png37.keyName,),
        Product(
          key: 1,
          name: S.current.coffee_ice,
          country: "Vietnam",
          price: 20000,
          image: Assets.png.png1.keyName,
        ),
        Product(
          key: 2,
          name: S.current.milk_coffee_ice,
          country: "Vietnam",
          price: 25000,
          image: Assets.png.png2.keyName,
        ),
      ],
      S.current.coffee_drink: [
        Product(
          key: 1,
          name: S.current.coffee_ice,
          country: "Vietnam",
          price: 20000,
          image: Assets.png.png1.keyName,
        ),
        Product(
          key: 2,
          name: S.current.milk_coffee_ice,
          country: "Vietnam",
          price: 25000,
          image: Assets.png.png2.keyName,
        ),
        Product(
          key: 3,
          name: S.current.bac_xiu_ice,
          country: "Vietnam",
          price: 25000,
          image: Assets.png.png3.keyName,
        ),
        Product(
          key: 4,
          name: S.current.cacao_milk_ice,
          country: "Vietnam",
          price: 25000,
          image: Assets.png.png4.keyName,
        ),
        Product(
          key: 5,
          name: S.current.salted_coffee,
          country: "Vietnam",
          price: 25000,
          image: Assets.png.png5.keyName,
        ),
      ],
      S.current.milk_tea_drink: [
        Product(
          key: 6,
          name: S.current.milk_tea_classic,
          country: "Vietnam",
          price: 25000,
          image: Assets.png.png6.keyName,
        ),
        Product(
          key: 7,
          name: S.current.milk_tea_chocolate,
          country: "Vietnam",
          price: 30000,
          image: Assets.png.png7.keyName,
        ),
        Product(
          key: 8,
          name: S.current.milk_tea_butterfly_pea,
          country: "Vietnam",
          price: 30000,
          image: Assets.png.png8.keyName,
        ),
        Product(
          key: 9,
          name: S.current.milk_tea_young_rice,
          country: "Vietnam",
          price: 30000,
          image: Assets.png.png9.keyName,
        ),
        Product(
          key: 10,
          name: S.current.milk_tea_taro,
          country: "Vietnam",
          price: 30000,
          image: Assets.png.png10.keyName,
        ),
        Product(
          key: 11,
          name: S.current.latte_matcha,
          country: "Vietnam",
          price: 30000,
          image: Assets.png.png11.keyName,
        ),
        Product(
          key: 12,
          name: S.current.latte_taro,
          country: "Vietnam",
          price: 30000,
          image: Assets.png.png12.keyName,
        ),
        Product(
          key: 13,
          name: S.current.latte_chocolate,
          country: "Vietnam",
          price: 30000,
          image: Assets.png.png13.keyName,
        ),
        Product(
          key: 14,
          name: S.current.latte_strawberry_matcha,
          country: "Vietnam",
          price: 35000,
          image: Assets.png.png14.keyName,
        ),
      ],
      S.current.fruit_drink: [
        Product(
          key: 15,
          name: S.current.fruit_tea_soursop,
          country: "Vietnam",
          price: 30000,
          image: Assets.png.png15.keyName,
        ),
        Product(
          key: 16,
          name: S.current.fruit_tea_pineapple_leaf,
          country: "Vietnam",
          price: 30000,
          image: Assets.png.png16.keyName,
        ),
        Product(
          key: 17,
          name: S.current.fruit_tea_peach_lemongrass,
          country: "Vietnam",
          price: 30000,
          image: Assets.png.png17.keyName,
        ),
        Product(
          key: 18,
          name: S.current.fruit_tea_lychee,
          country: "Vietnam",
          price: 30000,
          image: Assets.png.png18.keyName,
        ),
        Product(
          key: 19,
          name: S.current.fruit_tea_lipton_plum,
          country: "Vietnam",
          price: 20000,
          image: Assets.png.png19.keyName,
        ),
        Product(
          key: 20,
          name: S.current.fruit_tea_kumquat,
          country: "Vietnam",
          price: 20000,
          image: Assets.png.png20.keyName,
        ),
        Product(
          key: 21,
          name: S.current.fruit_tea_wintermelon,
          country: "Vietnam",
          price: 20000,
          image: Assets.png.png21.keyName,
        ),
      ],
      S.current.juice_drink: [
        Product(
          key: 22,
          name: S.current.juice_guava,
          country: "Vietnam",
          price: 30000,
          image: Assets.png.png22.keyName,
        ),
        Product(
          key: 23,
          name: S.current.juice_pineapple,
          country: "Vietnam",
          price: 30000,
          image: Assets.png.png23.keyName,
        ),
        Product(
          key: 24,
          name: S.current.juice_watermelon,
          country: "Vietnam",
          price: 30000,
          image: Assets.png.png24.keyName,
        ),
        Product(
          key: 25,
          name: S.current.juice_apple,
          country: "Vietnam",
          price: 35000,
          image: Assets.png.png25.keyName,
        ),
        Product(
          key: 26,
          name: S.current.juice_orange,
          country: "Vietnam",
          price: 20000,
          image: Assets.png.png26.keyName,
        ),
        Product(
          key: 27,
          name: S.current.juice_passion,
          country: "Vietnam",
          price: 20000,
          image: Assets.png.png27.keyName,
        ),
      ],
      S.current.smoothie_drink: [
        Product(
          key: 28,
          name: S.current.smoothie_avocado,
          country: "Vietnam",
          price: 30000,
          image: Assets.png.png28.keyName,
        ),
        Product(
          key: 29,
          name: S.current.smoothie_sapoche,
          country: "Vietnam",
          price: 30000,
          image: Assets.png.png29.keyName,
        ),
        Product(
          key: 30,
          name: S.current.smoothie_strawberry,
          country: "Vietnam",
          price: 30000,
          image: Assets.png.png30.keyName,
        ),
        Product(
          key: 31,
          name: S.current.smoothie_soursop,
          country: "Vietnam",
          price: 30000,
          image: Assets.png.png31.keyName,
        ),
      ],
      S.current.ice_blended_drink: [
        Product(
          key: 32,
          name: S.current.blend_blueberry,
          country: "Vietnam",
          price: 35000,
          image: Assets.png.png32.keyName,
        ),
        Product(
          key: 33,
          name: S.current.blend_cacao_milk,
          country: "Vietnam",
          price: 35000,
          image: Assets.png.png33.keyName,
        ),
      ],
      S.current.yaourt_soda_drink: [
        Product(
          key: 34,
          name: S.current.yaourt_crushed_ice,
          country: "Vietnam",
          price: 20000,
          image: Assets.png.png34.keyName,
        ),
        Product(
          key: 35,
          name: S.current.yaourt_blueberry,
          country: "Vietnam",
          price: 25000,
          image: Assets.png.png35.keyName,
        ),
        Product(
          key: 36,
          name: S.current.yaourt_passion,
          country: "Vietnam",
          price: 20000,
          image: Assets.png.png36.keyName,
        ),
        Product(
          key: 37,
          name: S.current.soda_lemon,
          country: "Vietnam",
          price: 35000,
          image: Assets.png.png37.keyName,
        ),
      ],
    };


    notifyListeners();
  }

  int _selectedFilterIndex = 0;
  int _currentPage = 0;
  bool _isNext = true;

  Map<String, List<Product>> productsByFilter = {
    S.current.best_seller: [

      Product(
        key: 6,
        name: S.current.milk_tea_classic,
        country: "Vietnam",
        price: 25000,
        image: Assets.png.png6.keyName,
      ),
      Product(
        key: 7,
        name: S.current.milk_tea_chocolate,
        country: "Vietnam",
        price: 30000,
        image: Assets.png.png7.keyName,
      ),
      Product(
        key: 36,
        name: S.current.yaourt_passion,
        country: "Vietnam",
        price: 20000,
        image: Assets.png.png36.keyName,
      ),
      Product(
        key: 37,
        name: S.current.soda_lemon,
        country: "Vietnam",
        price: 35000,
        image: Assets.png.png37.keyName,),
      Product(
        key: 1,
        name: S.current.coffee_ice,
        country: "Vietnam",
        price: 20000,
        image: Assets.png.png1.keyName,
      ),
      Product(
        key: 2,
        name: S.current.milk_coffee_ice,
        country: "Vietnam",
        price: 25000,
        image: Assets.png.png2.keyName,
      ),
    ],
    S.current.coffee_drink: [
      Product(
        key: 1,
        name: S.current.coffee_ice,
        country: "Vietnam",
        price: 20000,
        image: Assets.png.png1.keyName,
      ),
      Product(
        key: 2,
        name: S.current.milk_coffee_ice,
        country: "Vietnam",
        price: 25000,
        image: Assets.png.png2.keyName,
      ),
      Product(
        key: 3,
        name: S.current.bac_xiu_ice,
        country: "Vietnam",
        price: 25000,
        image: Assets.png.png3.keyName,
      ),
      Product(
        key: 4,
        name: S.current.cacao_milk_ice,
        country: "Vietnam",
        price: 25000,
        image: Assets.png.png4.keyName,
      ),
      Product(
        key: 5,
        name: S.current.salted_coffee,
        country: "Vietnam",
        price: 25000,
        image: Assets.png.png5.keyName,
      ),
    ],
    S.current.milk_tea_drink: [
      Product(
        key: 6,
        name: S.current.milk_tea_classic,
        country: "Vietnam",
        price: 25000,
        image: Assets.png.png6.keyName,
      ),
      Product(
        key: 7,
        name: S.current.milk_tea_chocolate,
        country: "Vietnam",
        price: 30000,
        image: Assets.png.png7.keyName,
      ),
      Product(
        key: 8,
        name: S.current.milk_tea_butterfly_pea,
        country: "Vietnam",
        price: 30000,
        image: Assets.png.png8.keyName,
      ),
      Product(
        key: 9,
        name: S.current.milk_tea_young_rice,
        country: "Vietnam",
        price: 30000,
        image: Assets.png.png9.keyName,
      ),
      Product(
        key: 10,
        name: S.current.milk_tea_taro,
        country: "Vietnam",
        price: 30000,
        image: Assets.png.png10.keyName,
      ),
      Product(
        key: 11,
        name: S.current.latte_matcha,
        country: "Vietnam",
        price: 30000,
        image: Assets.png.png11.keyName,
      ),
      Product(
        key: 12,
        name: S.current.latte_taro,
        country: "Vietnam",
        price: 30000,
        image: Assets.png.png12.keyName,
      ),
      Product(
        key: 13,
        name: S.current.latte_chocolate,
        country: "Vietnam",
        price: 30000,
        image: Assets.png.png13.keyName,
      ),
      Product(
        key: 14,
        name: S.current.latte_strawberry_matcha,
        country: "Vietnam",
        price: 35000,
        image: Assets.png.png14.keyName,
      ),
    ],
    S.current.fruit_drink: [
      Product(
        key: 15,
        name: S.current.fruit_tea_soursop,
        country: "Vietnam",
        price: 30000,
        image: Assets.png.png15.keyName,
      ),
      Product(
        key: 16,
        name: S.current.fruit_tea_pineapple_leaf,
        country: "Vietnam",
        price: 30000,
        image: Assets.png.png16.keyName,
      ),
      Product(
        key: 17,
        name: S.current.fruit_tea_peach_lemongrass,
        country: "Vietnam",
        price: 30000,
        image: Assets.png.png17.keyName,
      ),
      Product(
        key: 18,
        name: S.current.fruit_tea_lychee,
        country: "Vietnam",
        price: 30000,
        image: Assets.png.png18.keyName,
      ),
      Product(
        key: 19,
        name: S.current.fruit_tea_lipton_plum,
        country: "Vietnam",
        price: 20000,
        image: Assets.png.png19.keyName,
      ),
      Product(
        key: 20,
        name: S.current.fruit_tea_kumquat,
        country: "Vietnam",
        price: 20000,
        image: Assets.png.png20.keyName,
      ),
      Product(
        key: 21,
        name: S.current.fruit_tea_wintermelon,
        country: "Vietnam",
        price: 20000,
        image: Assets.png.png21.keyName,
      ),
    ],
    S.current.juice_drink: [
      Product(
        key: 22,
        name: S.current.juice_guava,
        country: "Vietnam",
        price: 30000,
        image: Assets.png.png22.keyName,
      ),
      Product(
        key: 23,
        name: S.current.juice_pineapple,
        country: "Vietnam",
        price: 30000,
        image: Assets.png.png23.keyName,
      ),
      Product(
        key: 24,
        name: S.current.juice_watermelon,
        country: "Vietnam",
        price: 30000,
        image: Assets.png.png24.keyName,
      ),
      Product(
        key: 25,
        name: S.current.juice_apple,
        country: "Vietnam",
        price: 35000,
        image: Assets.png.png25.keyName,
      ),
      Product(
        key: 26,
        name: S.current.juice_orange,
        country: "Vietnam",
        price: 20000,
        image: Assets.png.png26.keyName,
      ),
      Product(
        key: 27,
        name: S.current.juice_passion,
        country: "Vietnam",
        price: 20000,
        image: Assets.png.png27.keyName,
      ),
    ],
    S.current.smoothie_drink: [
      Product(
        key: 28,
        name: S.current.smoothie_avocado,
        country: "Vietnam",
        price: 30000,
        image: Assets.png.png28.keyName,
      ),
      Product(
        key: 29,
        name: S.current.smoothie_sapoche,
        country: "Vietnam",
        price: 30000,
        image: Assets.png.png29.keyName,
      ),
      Product(
        key: 30,
        name: S.current.smoothie_strawberry,
        country: "Vietnam",
        price: 30000,
        image: Assets.png.png30.keyName,
      ),
      Product(
        key: 31,
        name: S.current.smoothie_soursop,
        country: "Vietnam",
        price: 30000,
        image: Assets.png.png31.keyName,
      ),
    ],
    S.current.ice_blended_drink: [
      Product(
        key: 32,
        name: S.current.blend_blueberry,
        country: "Vietnam",
        price: 35000,
        image: Assets.png.png32.keyName,
      ),
      Product(
        key: 33,
        name: S.current.blend_cacao_milk,
        country: "Vietnam",
        price: 35000,
        image: Assets.png.png33.keyName,
      ),
    ],
    S.current.yaourt_soda_drink: [
      Product(
        key: 34,
        name: S.current.yaourt_crushed_ice,
        country: "Vietnam",
        price: 20000,
        image: Assets.png.png34.keyName,
      ),
      Product(
        key: 35,
        name: S.current.yaourt_blueberry,
        country: "Vietnam",
        price: 25000,
        image: Assets.png.png35.keyName,
      ),
      Product(
        key: 36,
        name: S.current.yaourt_passion,
        country: "Vietnam",
        price: 20000,
        image: Assets.png.png36.keyName,
      ),
      Product(
        key: 37,
        name: S.current.soda_lemon,
        country: "Vietnam",
        price: 35000,
        image: Assets.png.png37.keyName,
      ),
    ],
  };

  int get selectedFilterIndex => _selectedFilterIndex;

  int get currentPage => _currentPage;

  bool get isNext => _isNext;

  String get currentFilter => filters[_selectedFilterIndex];

  List<Product> get allProducts =>
      productsByFilter[currentFilter] ?? [];

  int get totalPages => (allProducts.length / 4).ceil();

  List<Product> get currentProducts {
    final startIndex = _currentPage * 4;
    final endIndex = (startIndex + 4).clamp(0, allProducts.length);
    return allProducts.sublist(startIndex, endIndex);
  }

  bool isLoading = false;

  Future<void> selectFilter(int index) async {
    _selectedFilterIndex = index;
    _currentPage = 0;
    isLoading =true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1100));
    isLoading =false;

    notifyListeners();
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
    final index = cartShop.indexWhere((item) => item.key == product.key);
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
    await cartKey.currentState!.runCartAnimation((++_cartQuantityItems).toString());
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
          product: removedProduct,
          onRemove: () {},
          totalMoney: 0,// Không cần xoá lại nữa
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
      totalPrice = cartShop.fold(0.0, (sum, item) => sum + item.price * item.amount);
      notifyListeners();
    }
  }


  int _currentIndex = 0;

  final List<FeedbackModel> _feedbacks = [
    FeedbackModel(
      title: "AWESOME COFFEE",
      reviewer: "MICHAEL T",
      date: "03/10",
      comment:
      "fantastic, solid coffee! 10/10. highly recommend. this coffee is the best around",
      rating: 5.0,
    ),
    FeedbackModel(
      title: "OK ",
      reviewer: "SARAH J",
      date: "05/10",
      comment: "loved the smooth flavor. would definitely buy again.",
      rating: 4.5,
    ),
    FeedbackModel(
      title: "Nice Coffee",
      reviewer: "DAVID K",
      date: "08/10",
      comment: "nice coffee, but a bit too strong for me.",
      rating: 3.5,
    ),

    /// Thêm mới
    FeedbackModel(
      title: "Excellent Aroma",
      reviewer: "EMILY R",
      date: "10/10",
      comment: "the aroma was amazing, felt like a coffee shop at home!",
      rating: 5.0,
    ),
    FeedbackModel(
      title: "Good but Pricey",
      reviewer: "JAMES L",
      date: "12/10",
      comment: "good flavor, but I think the price is a bit high.",
      rating: 4.0,
    ),
    FeedbackModel(
      title: "Không tệ",
      reviewer: "NGUYỄN VĂN A",
      date: "14/10",
      comment: "Cà phê uống ổn, nhưng hơi đắng hơn mình mong đợi.",
      rating: 3.0,
    ),
    FeedbackModel(
      title: "Rất ngon",
      reviewer: "TRẦN THỊ B",
      date: "16/10",
      comment: "Cà phê thơm ngon, vị đậm đà. Sẽ mua lại nhiều lần.",
      rating: 4.5,
    ),
    FeedbackModel(
      title: "Perfect Morning Coffee",
      reviewer: "CHRIS P",
      date: "18/10",
      comment: "this coffee makes my mornings perfect. smooth and strong.",
      rating: 5.0,
    ),
    FeedbackModel(
      title: "Ổn áp",
      reviewer: "PHẠM MINH C",
      date: "20/10",
      comment: "Uống khá ổn, giao hàng nhanh, sẽ ủng hộ tiếp.",
      rating: 4.0,
    ),
    FeedbackModel(
      title: "Too Bitter",
      reviewer: "LINDA M",
      date: "22/10",
      comment: "coffee was too bitter for my taste, but still drinkable.",
      rating: 2.5,
    ),
  ];



  List<FeedbackModel> get feedbacks => _feedbacks;

  int get currentIndex => _currentIndex;

  FeedbackModel get currentFeedback => _feedbacks[_currentIndex];

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

  final languages = [
    'en',
    'vi'
  ];


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

    init( );

    scrollToTarget(home);
    await clearCartShop();
    init();
    notifyListeners();
  }
  Future<void> clearCartShop() async {
    cartShop.clear();
    totalPrice = 0;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cartShop', jsonEncode([]));

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
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

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
