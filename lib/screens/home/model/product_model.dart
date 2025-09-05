class Product {
  final int id;
  final String name;
  final String nameEnglish;
  final String country;
  final double price;
  final String image;
  final String category;
  final int? categoryId;
  final bool isBestSeller;
  final bool isActive;
  int amount;

  Product({
    required this.id,
    required this.name,
    required this.nameEnglish,
    required this.country,
    required this.price,
    required this.image,
    required this.category,
    this.categoryId,
    this.isBestSeller = false,
    this.isActive = true,
    this.amount = 1,
  });

  /// Chuyển từ JSON sang đối tượng Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'],
      nameEnglish: json['name_english'],
      country: json['country'],
      price: (json['price'] as num).toDouble(),
      image: json['image'] ?? json['image_url'] ?? '',
      category: json['category'] ?? '',
      categoryId: json['category_id'],
      isBestSeller: json['is_best_seller'] ?? false,
      isActive: json['is_active'] ?? true,
      amount: json['amount'] ?? 1,
    );
  }

  /// Chuyển từ Product sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_english': nameEnglish,
      'country': country,
      'price': price,
      'image_url': image,
      'category': category,
      'category_id': categoryId,
      'is_best_seller': isBestSeller,
      'is_active': isActive,
      'amount': amount,
    };
  }

  /// Tạo copy của Product với một số trường thay đổi
  Product copyWith({
    int? id,
    String? name,
    String? nameEnglish,
    String? country,
    double? price,
    String? image,
    String? category,
    int? categoryId,
    bool? isBestSeller,
    bool? isActive,
    int? amount,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      country: country ?? this.country,
      price: price ?? this.price,
      image: image ?? this.image,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      isActive: isActive ?? this.isActive,
      amount: amount ?? this.amount,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, nameEnglish: $nameEnglish, category: $category, price: $price, isBestSeller: $isBestSeller, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
