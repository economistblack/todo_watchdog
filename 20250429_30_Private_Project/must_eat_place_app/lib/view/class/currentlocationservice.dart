import 'package:geolocator/geolocator.dart';

class Currentlocationservice {
  // 현재 위치
  Position? currentPosition;

  // 위치 권한 체크 및 요청
  Future<bool> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return false; // 권한 영구 거부됨
    }

    return permission == LocationPermission.whileInUse ||
           permission == LocationPermission.always;
  }

  // 현재 위치 받아오기
  Future<Position?> getCurrentLocation() async{
    
    Position position = await Geolocator.getCurrentPosition(); // 반드시 await 필요하다.
    return currentPosition = position;
    
  }

}