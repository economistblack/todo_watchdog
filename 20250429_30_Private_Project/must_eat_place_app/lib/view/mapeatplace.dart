import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as latlng;

class Mapeatplace extends StatefulWidget {
  const Mapeatplace({super.key});

  @override
  State<Mapeatplace> createState() => _MapeatplaceState();
}

class _MapeatplaceState extends State<Mapeatplace> {
  var value = Get.arguments ?? "__";
  
  late Position currentPosition;
  late double latData;
  late double longData;
  late MapController mapController;
  late bool canRun;
  late double currentLatData;
  late double currentLongData;
  late String location;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    canRun = false;
    latData = double.parse(value[4]);
    longData = double.parse(value[5]);
    currentLatData = 0;
    currentLongData = 0;
    location = value[1];
    checkLocationPermission();
  }

  checkLocationPermission() async{
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    if(permission == LocationPermission.deniedForever){
      return;
    }

    if(permission == LocationPermission.whileInUse || permission == LocationPermission.always){
      getCurrentLocation();
    }
  }

  getCurrentLocation() async{
    Position position = await Geolocator.getCurrentPosition(); // 반드시 await 필요하다.
    currentPosition = position;
    canRun = true;
    currentLatData = currentPosition.latitude;
    currentLongData = currentPosition.longitude;
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
          ),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.info, color: Colors.white, size: 30),
              ),
              Text(
                '${value[1]} :\n위치 및 정보 확인',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.deepOrange,
        toolbarHeight: 100,
      ),
      body: canRun
      ? SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  width: 500,
                  height: 400,
                  child: flutterMap()
                  ),
                
              ],
            ),
          ),
        ),
      )
      : Center(
        child: CircularProgressIndicator(),
      )
    );
  } // build

  Widget flutterMap(){
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: latlng.LatLng(latData, longData), 
        initialZoom: 15.0
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 80,
              height: 80,
              point: latlng.LatLng(latData, longData), 
              child: Column(
                children: [
                  SizedBox(
                    child: Text(
                      location,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.pin_drop,
                    size: 40,
                    color: Colors.red,
                  )
                ],
              )
            )
          ]
        ),
      ] 
      
    );
  }

} // class
