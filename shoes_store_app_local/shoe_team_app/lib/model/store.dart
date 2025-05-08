
class Store {
  final int storeCode; // 지자체 코드(5), 순번(2) - miro에 있는 매장코드 보고 작성하시면 됩니다.
  final String storeName;
  final double latitude;
  final double longitude;

  Store({
    required this.storeCode,
    required this.storeName,
    required this.latitude,
    required this.longitude
  });

  Store.fromMap(Map<String,dynamic> res)
: storeCode = res['storeCode'],
  storeName = res['storeName'],
  latitude = res['latitude'],
  longitude = res['longitude'];
} 