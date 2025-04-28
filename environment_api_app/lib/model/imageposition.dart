import 'dart:typed_data';

class ImagePosition {
  final int? id;
  final double latitude;
  final double longtitude;
  final Uint8List image;

  ImagePosition(
    {
      this.id,
      required this.latitude,
      required this.longtitude,
      required this.image,
    }
  );

  ImagePosition.fromMap(Map<String, dynamic> res)
  : id = res['id'],
  latitude = res['latitude'],
  longtitude = res['longtitude'],
  image = res['image'];

}