import 'dart:typed_data';

class ProductImage {
  final String imageId;
  final Uint8List image01;
  final Uint8List image02;

  ProductImage({
    required this.imageId,
    required this.image01,
    required this.image02
  });

  ProductImage.fromMap(Map<String,dynamic> res)
  :imageId = res['imageId'],
  image01 = res['image01'],
  image02 = res['image02'];
}