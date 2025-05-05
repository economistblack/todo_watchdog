import 'dart:typed_data';

class Eatplace {
  // create table eatplace(id integer primary key autoincrement, 
  // name text, phone text, comment text, latitude text, logitude text, image01 blob, image02 blob)

  final int? id;
  final String name;
  final String phone;
  final String comment;
  final String latitude;
  final String longitude;
  final Uint8List image01;
  final Uint8List image02;
  

  Eatplace(
    {
      this.id,
      required this.name,
      required this.phone,
      required this.comment,
      required this.latitude,
      required this.longitude,
      required this.image01,
      required this.image02
    }
  );

  Eatplace.fromMap(Map<String, dynamic> res)
  : id = res['id'],
  name = res['name'],
  phone = res['phone'],
  comment = res['comment'],
  latitude = res['latitude'],
  longitude = res['longitude'],
  image01 = res['image01'],
  image02 = res['image02'];

}