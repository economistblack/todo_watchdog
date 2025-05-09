import 'package:flutter/foundation.dart';

class Basket {
  final int? basketSeq;
  final String productCode;
  final String buyProductName;
  final int buyProductPrice;
  final int buyProductQuantity;
  final String userid;
  final Uint8List image;
  int ischeck;


  Basket({
    this.basketSeq,
    required this.productCode,
    required this.buyProductName,
    required this.buyProductPrice,
    required this.buyProductQuantity,
    required this.userid,
    required this.image,
    required this.ischeck
  });

  Basket.fromMap(Map<String,dynamic> res)
  :basketSeq = res['basketSeq'],
  productCode = res['productCode'],
  buyProductName = res['buyProductName'],
  buyProductPrice = res['buyProductPrice'],
  buyProductQuantity = res['buyProductQuantity'],
  userid = res['userid'],
  image = res['image'],
  ischeck = res ['ischeck'];
}