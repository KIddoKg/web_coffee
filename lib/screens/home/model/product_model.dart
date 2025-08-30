import 'package:flutter/material.dart';

class Product {
  final int key;
  final String name;
  final String country;
  final int price;
  final String image;
  int amount;

  Product({
    required this.key,
    required this.name,
    required this.country,
    required this.price,
    required this.image,
    this.amount = 1,
  });

  /// Chuyển từ JSON sang đối tượng Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      key: json['key'],
      name: json['name'],
      country: json['country'],
      price: json['price'],
      image: json['image'],
      amount: json['amount'],
    );
  }

  /// Chuyển từ Product sang JSON
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': name,
      'country': country,
      'price': price,
      'image': image,
      'amount': amount,
    };
  }
  @override
  String toString() {
    return 'Product(key: $key, name: $name, country: $country, price: $price, image: $image, amount: $amount)';
  }
}
