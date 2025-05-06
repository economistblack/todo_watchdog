import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class StoreMap extends StatefulWidget {
  const StoreMap({super.key});

  @override
  State<StoreMap> createState() => _StoreMapState();
}

class _StoreMapState extends State<StoreMap> {
  final List<Map<String, dynamic>> locations = const [
    {'name': '강남구', 'lat': 37.5172, 'lng': 127.0473},
    {'name': '강동구', 'lat': 37.5302, 'lng': 127.1238},
    {'name': '강서구', 'lat': 37.5509, 'lng': 126.8495},
    {'name': '관악구', 'lat': 37.4784, 'lng': 126.9516},
    {'name': '광진구', 'lat': 37.5384, 'lng': 127.0823},
    {'name': '구로구', 'lat': 37.4955, 'lng': 126.8878},
    {'name': '금천구', 'lat': 37.4569, 'lng': 126.8957},
    {'name': '노원구', 'lat': 37.6542, 'lng': 127.0568},
    {'name': '도봉구', 'lat': 37.6688, 'lng': 127.0471},
    {'name': '동대문구', 'lat': 37.5744, 'lng': 127.0396},
    {'name': '동작구', 'lat': 37.5124, 'lng': 126.9392},
    {'name': '마포구', 'lat': 37.5638, 'lng': 126.9084},
    {'name': '서대문구', 'lat': 37.5791, 'lng': 126.9368},
    {'name': '서초구', 'lat': 37.4836, 'lng': 127.0327},
    {'name': '성동구', 'lat': 37.5633, 'lng': 127.0364},
    {'name': '성북구', 'lat': 37.5894, 'lng': 127.0167},
    {'name': '송파구', 'lat': 37.5145, 'lng': 127.1059},
    {'name': '양천구', 'lat': 37.5169, 'lng': 126.8664},
    {'name': '영등포구', 'lat': 37.5264, 'lng': 126.8963},
    {'name': '용산구', 'lat': 37.5324, 'lng': 126.9908},
    {'name': '은평구', 'lat': 37.6028, 'lng': 126.9291},
    {'name': '종로구', 'lat': 37.5729, 'lng': 126.9794},
    {'name': '중구', 'lat': 37.5636, 'lng': 126.997},
    {'name': '중랑구', 'lat': 37.5985, 'lng': 127.0927},
    {'name': '강북구', 'lat': 37.6396, 'lng': 127.0256},
    {'name': '본사(강남)', 'lat': 37.4980, 'lng': 127.0276},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('서울 자치구 및 본사 마커'),
        backgroundColor: Colors.brown,
        
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(37.5665, 126.9780), // 서울 시청 중심
          initialZoom: 11.5,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: locations.map((location) {
              return Marker(
                width: 50,
                height: 50,
                point: LatLng(location['lat'], location['lng']),
                child: Tooltip(
                  message: location['name'],
                  child: const Icon(Icons.location_on, color: Colors.red, size: 30),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}