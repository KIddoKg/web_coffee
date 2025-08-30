// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `New coffee`
  String get title_coffee {
    return Intl.message(
      'New coffee',
      name: 'title_coffee',
      desc: '',
      args: [],
    );
  }

  /// `Xanh Coffee`
  String get name_coffee {
    return Intl.message(
      'Xanh Coffee',
      name: 'name_coffee',
      desc: '',
      args: [],
    );
  }

  /// `We’re excited to introduce our new spring drinks a refreshing mix of tropical fruits and herbal notes to celebrate the vibrant season.`
  String get detail_name {
    return Intl.message(
      'We’re excited to introduce our new spring drinks a refreshing mix of tropical fruits and herbal notes to celebrate the vibrant season.',
      name: 'detail_name',
      desc: '',
      args: [],
    );
  }

  /// `Who we are`
  String get about_us {
    return Intl.message(
      'Who we are',
      name: 'about_us',
      desc: '',
      args: [],
    );
  }

  /// `The Xanh Coffee experience is about more than just coffee it’s about offering a refreshing variety of drinks and warm hospitality for everyone who visits.`
  String get about_detail_one {
    return Intl.message(
      'The Xanh Coffee experience is about more than just coffee it’s about offering a refreshing variety of drinks and warm hospitality for everyone who visits.',
      name: 'about_detail_one',
      desc: '',
      args: [],
    );
  }

  /// `At Xanh Coffee, we craft a diverse menu of beverages from bold coffee to fresh fruit drinks and teas each prepared with care to brighten your day.`
  String get about_detail_two {
    return Intl.message(
      'At Xanh Coffee, we craft a diverse menu of beverages from bold coffee to fresh fruit drinks and teas each prepared with care to brighten your day.',
      name: 'about_detail_two',
      desc: '',
      args: [],
    );
  }

  /// `All products`
  String get all_product {
    return Intl.message(
      'All products',
      name: 'all_product',
      desc: '',
      args: [],
    );
  }

  /// `Xanh Coffee carefully curates a wide variety of refreshing drinks, from coffee and tea to fresh juices and smoothies, each crafted with care to brighten your day.`
  String get all_product_detail {
    return Intl.message(
      'Xanh Coffee carefully curates a wide variety of refreshing drinks, from coffee and tea to fresh juices and smoothies, each crafted with care to brighten your day.',
      name: 'all_product_detail',
      desc: '',
      args: [],
    );
  }

  /// `Best Seller`
  String get best_seller {
    return Intl.message(
      'Best Seller',
      name: 'best_seller',
      desc: '',
      args: [],
    );
  }

  /// `Coffee & Cocoa`
  String get coffee_drink {
    return Intl.message(
      'Coffee & Cocoa',
      name: 'coffee_drink',
      desc: '',
      args: [],
    );
  }

  /// `Fruit Tea`
  String get fruit_drink {
    return Intl.message(
      'Fruit Tea',
      name: 'fruit_drink',
      desc: '',
      args: [],
    );
  }

  /// `Fresh Juice`
  String get juice_drink {
    return Intl.message(
      'Fresh Juice',
      name: 'juice_drink',
      desc: '',
      args: [],
    );
  }

  /// `Smoothies`
  String get smoothie_drink {
    return Intl.message(
      'Smoothies',
      name: 'smoothie_drink',
      desc: '',
      args: [],
    );
  }

  /// `Ice Blended`
  String get ice_blended_drink {
    return Intl.message(
      'Ice Blended',
      name: 'ice_blended_drink',
      desc: '',
      args: [],
    );
  }

  /// `Yogurt & Soda`
  String get yaourt_soda_drink {
    return Intl.message(
      'Yogurt & Soda',
      name: 'yaourt_soda_drink',
      desc: '',
      args: [],
    );
  }

  /// `Milk Tea`
  String get milk_tea_drink {
    return Intl.message(
      'Milk Tea',
      name: 'milk_tea_drink',
      desc: '',
      args: [],
    );
  }

  /// `Iced Coffee`
  String get coffee_ice {
    return Intl.message(
      'Iced Coffee',
      name: 'coffee_ice',
      desc: '',
      args: [],
    );
  }

  /// `Iced Milk Coffee`
  String get milk_coffee_ice {
    return Intl.message(
      'Iced Milk Coffee',
      name: 'milk_coffee_ice',
      desc: '',
      args: [],
    );
  }

  /// `Sweet Milk Coffee`
  String get bac_xiu_ice {
    return Intl.message(
      'Sweet Milk Coffee',
      name: 'bac_xiu_ice',
      desc: '',
      args: [],
    );
  }

  /// `Iced Cacao with Milk`
  String get cacao_milk_ice {
    return Intl.message(
      'Iced Cacao with Milk',
      name: 'cacao_milk_ice',
      desc: '',
      args: [],
    );
  }

  /// `Salted Coffee`
  String get salted_coffee {
    return Intl.message(
      'Salted Coffee',
      name: 'salted_coffee',
      desc: '',
      args: [],
    );
  }

  /// `Guava Juice`
  String get juice_guava {
    return Intl.message(
      'Guava Juice',
      name: 'juice_guava',
      desc: '',
      args: [],
    );
  }

  /// `Pineapple Juice`
  String get juice_pineapple {
    return Intl.message(
      'Pineapple Juice',
      name: 'juice_pineapple',
      desc: '',
      args: [],
    );
  }

  /// `Watermelon Juice`
  String get juice_watermelon {
    return Intl.message(
      'Watermelon Juice',
      name: 'juice_watermelon',
      desc: '',
      args: [],
    );
  }

  /// `Apple Juice`
  String get juice_apple {
    return Intl.message(
      'Apple Juice',
      name: 'juice_apple',
      desc: '',
      args: [],
    );
  }

  /// `Fresh Orange Juice`
  String get juice_orange {
    return Intl.message(
      'Fresh Orange Juice',
      name: 'juice_orange',
      desc: '',
      args: [],
    );
  }

  /// `Passion Fruit Juice`
  String get juice_passion {
    return Intl.message(
      'Passion Fruit Juice',
      name: 'juice_passion',
      desc: '',
      args: [],
    );
  }

  /// `Blended Blueberry`
  String get blend_blueberry {
    return Intl.message(
      'Blended Blueberry',
      name: 'blend_blueberry',
      desc: '',
      args: [],
    );
  }

  /// `Blended Cacao Milk`
  String get blend_cacao_milk {
    return Intl.message(
      'Blended Cacao Milk',
      name: 'blend_cacao_milk',
      desc: '',
      args: [],
    );
  }

  /// `Soursop Tea`
  String get fruit_tea_soursop {
    return Intl.message(
      'Soursop Tea',
      name: 'fruit_tea_soursop',
      desc: '',
      args: [],
    );
  }

  /// `Pineapple Leaf Tea`
  String get fruit_tea_pineapple_leaf {
    return Intl.message(
      'Pineapple Leaf Tea',
      name: 'fruit_tea_pineapple_leaf',
      desc: '',
      args: [],
    );
  }

  /// `Peach Lemongrass Tea`
  String get fruit_tea_peach_lemongrass {
    return Intl.message(
      'Peach Lemongrass Tea',
      name: 'fruit_tea_peach_lemongrass',
      desc: '',
      args: [],
    );
  }

  /// `Lychee Tea`
  String get fruit_tea_lychee {
    return Intl.message(
      'Lychee Tea',
      name: 'fruit_tea_lychee',
      desc: '',
      args: [],
    );
  }

  /// `Lipton Plum Tea`
  String get fruit_tea_lipton_plum {
    return Intl.message(
      'Lipton Plum Tea',
      name: 'fruit_tea_lipton_plum',
      desc: '',
      args: [],
    );
  }

  /// `Kumquat Tea`
  String get fruit_tea_kumquat {
    return Intl.message(
      'Kumquat Tea',
      name: 'fruit_tea_kumquat',
      desc: '',
      args: [],
    );
  }

  /// `Wintermelon Tea`
  String get fruit_tea_wintermelon {
    return Intl.message(
      'Wintermelon Tea',
      name: 'fruit_tea_wintermelon',
      desc: '',
      args: [],
    );
  }

  /// `Avocado Smoothie`
  String get smoothie_avocado {
    return Intl.message(
      'Avocado Smoothie',
      name: 'smoothie_avocado',
      desc: '',
      args: [],
    );
  }

  /// `Sapodilla Smoothie`
  String get smoothie_sapoche {
    return Intl.message(
      'Sapodilla Smoothie',
      name: 'smoothie_sapoche',
      desc: '',
      args: [],
    );
  }

  /// `Strawberry Smoothie`
  String get smoothie_strawberry {
    return Intl.message(
      'Strawberry Smoothie',
      name: 'smoothie_strawberry',
      desc: '',
      args: [],
    );
  }

  /// `Soursop Smoothie`
  String get smoothie_soursop {
    return Intl.message(
      'Soursop Smoothie',
      name: 'smoothie_soursop',
      desc: '',
      args: [],
    );
  }

  /// `Classic Milk Tea`
  String get milk_tea_classic {
    return Intl.message(
      'Classic Milk Tea',
      name: 'milk_tea_classic',
      desc: '',
      args: [],
    );
  }

  /// `Chocolate Milk Tea`
  String get milk_tea_chocolate {
    return Intl.message(
      'Chocolate Milk Tea',
      name: 'milk_tea_chocolate',
      desc: '',
      args: [],
    );
  }

  /// `Butterfly Pea Milk Tea`
  String get milk_tea_butterfly_pea {
    return Intl.message(
      'Butterfly Pea Milk Tea',
      name: 'milk_tea_butterfly_pea',
      desc: '',
      args: [],
    );
  }

  /// `Young Rice Milk Tea`
  String get milk_tea_young_rice {
    return Intl.message(
      'Young Rice Milk Tea',
      name: 'milk_tea_young_rice',
      desc: '',
      args: [],
    );
  }

  /// `Taro Milk Tea`
  String get milk_tea_taro {
    return Intl.message(
      'Taro Milk Tea',
      name: 'milk_tea_taro',
      desc: '',
      args: [],
    );
  }

  /// `Matcha Latte`
  String get latte_matcha {
    return Intl.message(
      'Matcha Latte',
      name: 'latte_matcha',
      desc: '',
      args: [],
    );
  }

  /// `Taro Latte`
  String get latte_taro {
    return Intl.message(
      'Taro Latte',
      name: 'latte_taro',
      desc: '',
      args: [],
    );
  }

  /// `Chocolate Latte`
  String get latte_chocolate {
    return Intl.message(
      'Chocolate Latte',
      name: 'latte_chocolate',
      desc: '',
      args: [],
    );
  }

  /// `Strawberry Matcha Latte`
  String get latte_strawberry_matcha {
    return Intl.message(
      'Strawberry Matcha Latte',
      name: 'latte_strawberry_matcha',
      desc: '',
      args: [],
    );
  }

  /// `Crushed Ice Yogurt`
  String get yaourt_crushed_ice {
    return Intl.message(
      'Crushed Ice Yogurt',
      name: 'yaourt_crushed_ice',
      desc: '',
      args: [],
    );
  }

  /// `Blueberry Yogurt`
  String get yaourt_blueberry {
    return Intl.message(
      'Blueberry Yogurt',
      name: 'yaourt_blueberry',
      desc: '',
      args: [],
    );
  }

  /// `Passion Fruit Yogurt`
  String get yaourt_passion {
    return Intl.message(
      'Passion Fruit Yogurt',
      name: 'yaourt_passion',
      desc: '',
      args: [],
    );
  }

  /// `Lemon Soda`
  String get soda_lemon {
    return Intl.message(
      'Lemon Soda',
      name: 'soda_lemon',
      desc: '',
      args: [],
    );
  }

  /// `from`
  String get from {
    return Intl.message(
      'from',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `Always-fresh Beverage Blends`
  String get ads_first_one {
    return Intl.message(
      'Always-fresh Beverage Blends',
      name: 'ads_first_one',
      desc: '',
      args: [],
    );
  }

  /// `At Xanh Coffee, we craft drinks that match your vibe whether it’s a bold iced coffee, a soothing fruit tea, or a refreshing smoothie.`
  String get ads_first_two {
    return Intl.message(
      'At Xanh Coffee, we craft drinks that match your vibe whether it’s a bold iced coffee, a soothing fruit tea, or a refreshing smoothie.',
      name: 'ads_first_two',
      desc: '',
      args: [],
    );
  }

  /// `Choose your daily favorite from our wide range of house blends, chilled teas, and tropical juices.`
  String get ads_first_three {
    return Intl.message(
      'Choose your daily favorite from our wide range of house blends, chilled teas, and tropical juices.',
      name: 'ads_first_three',
      desc: '',
      args: [],
    );
  }

  /// `Order Now`
  String get order_now {
    return Intl.message(
      'Order Now',
      name: 'order_now',
      desc: '',
      args: [],
    );
  }

  /// `Xanh Signature Drinks`
  String get ads_second_one {
    return Intl.message(
      'Xanh Signature Drinks',
      name: 'ads_second_one',
      desc: '',
      args: [],
    );
  }

  /// `Experience our best-sellers from Salted Coffee to Passionfruit Soda. Handcrafted, ice-cold, and unforgettable.`
  String get ads_second_two {
    return Intl.message(
      'Experience our best-sellers from Salted Coffee to Passionfruit Soda. Handcrafted, ice-cold, and unforgettable.',
      name: 'ads_second_two',
      desc: '',
      args: [],
    );
  }

  /// `Perfect for morning focus or afternoon chill.`
  String get ads_second_three {
    return Intl.message(
      'Perfect for morning focus or afternoon chill.',
      name: 'ads_second_three',
      desc: '',
      args: [],
    );
  }

  /// `Try Now`
  String get try_now {
    return Intl.message(
      'Try Now',
      name: 'try_now',
      desc: '',
      args: [],
    );
  }

  /// `our coffee`
  String get ads_title_one {
    return Intl.message(
      'our coffee',
      name: 'ads_title_one',
      desc: '',
      args: [],
    );
  }

  /// `SIGNATURE LINE`
  String get ads_title_two {
    return Intl.message(
      'SIGNATURE LINE',
      name: 'ads_title_two',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get about {
    return Intl.message(
      'About Us',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `About Store`
  String get about_store {
    return Intl.message(
      'About Store',
      name: 'about_store',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get products {
    return Intl.message(
      'Products',
      name: 'products',
      desc: '',
      args: [],
    );
  }

  /// `Advertisement`
  String get advertisement {
    return Intl.message(
      'Advertisement',
      name: 'advertisement',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get feedback {
    return Intl.message(
      'Feedback',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Vietnamese`
  String get vietnamese {
    return Intl.message(
      'Vietnamese',
      name: 'vietnamese',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get languages {
    return Intl.message(
      'Languages',
      name: 'languages',
      desc: '',
      args: [],
    );
  }

  /// `No.200, Street 1, F. An Lạc, Ho Chi Minh City, VietNam`
  String get address {
    return Intl.message(
      'No.200, Street 1, F. An Lạc, Ho Chi Minh City, VietNam',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Total products`
  String get total_product {
    return Intl.message(
      'Total products',
      name: 'total_product',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Paste to order in Zalo`
  String get paste {
    return Intl.message(
      'Paste to order in Zalo',
      name: 'paste',
      desc: '',
      args: [],
    );
  }

  /// `Total pay`
  String get total_pay {
    return Intl.message(
      'Total pay',
      name: 'total_pay',
      desc: '',
      args: [],
    );
  }

  /// `Order in Zalo`
  String get zalo {
    return Intl.message(
      'Order in Zalo',
      name: 'zalo',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
