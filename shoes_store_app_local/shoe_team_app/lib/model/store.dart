
class Store {
  final int storeCode;
  final String storeName;
  final double latitude;
  final double longitude;

  Store({
    required this.storeCode,
    required this.storeName,
    required this.latitude,
    required this.longitude,
  });

  factory Store.fromMap(Map<String, dynamic> res) {
    return Store(
      storeCode: int.parse(res['storeCode'].toString()), // 핵심 수정
      storeName: res['storeName'],
      latitude: res['latitude'] is double
          ? res['latitude']
          : double.parse(res['latitude'].toString()),
      longitude: res['longitude'] is double
          ? res['longitude']
          : double.parse(res['longitude'].toString()),
    );
  }
}