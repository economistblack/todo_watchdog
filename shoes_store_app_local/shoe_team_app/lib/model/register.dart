class ImageRegister {
  final String productCode;
  final String imageId;


  ImageRegister({
    required this.productCode,
    required this.imageId
  });

  ImageRegister.fromMap(Map<String,dynamic> res)
  :productCode = res['productCode'],
  imageId = res['imageId'];
}