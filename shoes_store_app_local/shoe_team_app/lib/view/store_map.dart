import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shoe_team_project/model/store.dart';
import 'package:shoe_team_project/view_model/database_handler.dart';

class StoreMap extends StatefulWidget {
  const StoreMap({super.key});

  @override
  State<StoreMap> createState() => _StoreMapState();
}

class _StoreMapState extends State<StoreMap> {
  late DatabaseHandler handler;
  List<Store> storeList = [];
  LatLng? currentPosition;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    loadStores();
    getCurrentLocation();
  }

  Future<void> loadStores() async {
    final db = await handler.initializeDB();
    final result = await db.query('store');
    setState(() {
      storeList = result.map((e) => Store.fromMap(e)).toList();
    });
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('매장 위치 및 현재 위치'),
        backgroundColor:  const Color.fromARGB(221, 230, 107, 107),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(37.5665, 126.9780),
          initialZoom: 11.5,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
  markers: [
    ...storeList.map((store) => Marker(
      width: 80,
      height: 80,
      point: LatLng(store.latitude, store.longitude),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              store.storeName,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const Icon(Icons.location_on, color: Colors.red, size: 30),
        ],
      ),
    )),
    if (currentPosition != null)
      Marker(
        width: 80,
        height: 80,
        point: currentPosition!,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                "현재 위치",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const Icon(Icons.my_location, color: Colors.blue, size: 32),
          ],
        ),
      ),
  ],
)
        ],
      ),
    );
  }
}
