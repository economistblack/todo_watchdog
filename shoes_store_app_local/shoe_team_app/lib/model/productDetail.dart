import 'package:flutter/foundation.dart';

class ProductDetail {
  final String productCode;
  final String productName;
  final String description;
  final Uint8List image01;
  final Uint8List image02;
  final Uint8List image;
  final int price;

  ProductDetail({
    required this.productCode,
    required this.productName,
    required this.description,
    required this.image01,
    required this.image02,
    required this.image,
    required this.price
  });

  factory ProductDetail.fromMap(Map<String, dynamic> res) {
    return ProductDetail(
      productCode: res['productCode'],
      productName: res['productName'],
      description: res['description'],
      image01: res['image01'],
      image02: res['image02'],
      image: res['image'],
      price: res['price']
    );
  }
}