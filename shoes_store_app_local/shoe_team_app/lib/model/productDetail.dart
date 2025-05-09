import 'package:flutter/foundation.dart';

class ProductDetail {
  final String productCode;
  final String productName;
  final String description;
  final Uint8List image;
  final int quantity; 
  final String color;
  final int size;
  final Uint8List image01;
  final Uint8List image02;
  final int price;

  ProductDetail({
    required this.productCode,
    required this.productName,
    required this.description,
    required this.image,
    required this.quantity,
    required this.color,
    required this.size,
    required this.image01,
    required this.image02,
    required this.price
  });

  factory ProductDetail.fromMap(Map<String, dynamic> res) {
    return ProductDetail(
      productCode: res['productCode'],
      productName: res['productName'],
      description: res['description'],
      image: res['image'],
      quantity: res['quantity'],
      color: res['color'],
      size: res['size'],
      image01: res['image01'],
      image02: res['image02'],
      price: res['price']
    );
  }
}