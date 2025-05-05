import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:must_eat_place_app/model/eatplace.dart';
import 'package:must_eat_place_app/model/favorite.dart';
import 'package:must_eat_place_app/view/class/currentlocationservice.dart';
import 'package:must_eat_place_app/vm/database_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Inserteatplace extends StatefulWidget {
  const Inserteatplace({super.key});

  @override
  State<Inserteatplace> createState() => _InserteatplaceState();
}

class _InserteatplaceState extends State<Inserteatplace> {
  // Property
  // create table eatplace(id integer primary key autoincrement,
  // name text, phone text, comment text, latitude text, logitude text, image01 blob, image02 blob)

  DatabaseHandler handler = DatabaseHandler();
  Currentlocationservice currentPosition = Currentlocationservice();

  late TextEditingController nameController; // 맛집 이름
  late TextEditingController phoneController; // 맛집 전화번호
  late TextEditingController commentController; // 맛집 평가
  late TextEditingController latitudeController; // 맛집 위도
  late TextEditingController longitudeController; // 맛집 경도
  late TextEditingController search01Controller; // 주소 기반 검색 01
  late TextEditingController search02Controller; // 주소 기반 검색 02
  late final MapController _mapController;

  XFile? imageFile01; // 맛집 사진
  XFile? imageFile02; // 맛집 사진

  final ImagePicker picker01 = ImagePicker();
  final ImagePicker picker02 = ImagePicker();

  late double initialLatitude;
  late double initialLogitude;
  late LatLng _markerPosition;


  late String addressDisplay;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    commentController = TextEditingController();
    latitudeController = TextEditingController();
    longitudeController = TextEditingController();
    search01Controller = TextEditingController();
    search02Controller = TextEditingController();
    _mapController = MapController();


    initialLatitude = 37.497329;
    initialLogitude = 127.02932;
    _markerPosition = LatLng(initialLatitude, initialLogitude);
    addressDisplay = '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white
          ),
          title: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              '내가 경험한 맛집 입력하기',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Colors.deepOrange,
          toolbarHeight: 100,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      color: Colors.grey[200],
                      child: Center(
                        child:
                            imageFile01 == null
                                ? Text('첫 번째 이미지를 선택하세요!')
                                : Image.file(File(imageFile01!.path)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        getImageFromGallery01(ImageSource.gallery);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange[300],
                        foregroundColor: Colors.white,
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(150, 40),
                      ),
                      child: Text('첫 번째 이미지 선택'),
                    ),
                  ),
                  SizedBox(width: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      color: Colors.grey[200],
                      child: Center(
                        child:
                            imageFile02 == null
                                ? Text('두 번째 이미지를 선택하세요!')
                                : Image.file(File(imageFile02!.path)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        getImageFromGallery02(ImageSource.gallery);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange[300],
                        foregroundColor: Colors.white,
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(150, 40),
                      ),
                      child: Text('두 번째 이미지 선택'),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  labelText: '맛집 이름을 입력하세요.',
                                ),
                                maxLength: 30,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (nameController.text.trim().isNotEmpty) {
                                  searchLocation(nameController.text.trim()
                                  ,search01Controller.text.trim(), search02Controller.text.trim()
                                  );

                                } else {
                                  _showErrorDialog('검색어를 입력하세요.');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                                foregroundColor: Colors.white,
                                shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                                )
                              ),
                              child: Text('검색하기'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 400,
                          child: Row(
                            children: [
                              Expanded(
                                      child: TextField(
                                        controller: search01Controller,
                                        decoration: InputDecoration(
                                          labelText: '추가 검색어 (옵션)',
                                        ),
                                        maxLength: 10,
                                        keyboardType: TextInputType.text,
                                      ),
                                    ),
                                    SizedBox(width: 20,),
                              Expanded(
                                      child: TextField(
                                        controller: search02Controller,
                                        decoration: InputDecoration(
                                          labelText: '추가 검색어 (옵션)',
                                        ),
                                        maxLength: 10,
                                        keyboardType: TextInputType.text,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 400,
                          child: Text(
                            addressDisplay,
                            style: TextStyle(
                              color: Colors.blue
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.amber[100],
                          child: Row(
                            children: [
                              Icon(
                                Icons.place_outlined,
                                color: Colors.red,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('검색에 없으면 현재 위치 사용 : '),
                              ),
                              SizedBox(width: 20,),
                              ElevatedButton(
                                      onPressed: () async{
                                        final pos = await currentPosition.getCurrentLocation();
                                        if (pos != null){
                                          latitudeController.text = currentPosition.currentPosition!.latitude.toString();
                                          longitudeController.text = currentPosition.currentPosition!.longitude.toString();
                                          _markerPosition = LatLng(pos.latitude, pos.longitude);
                                          _mapController.move(_markerPosition, _mapController.camera.zoom);
                                          setState(() {});
                                        } else {
                                          _showErrorDialog('위치를 가져올 수 없습니다.');
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueGrey,
                                        foregroundColor: Colors.white,
                                        shape: ContinuousRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                        )
                                      ),
                                      child: Text('현재 위치 받기'),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelText: '맛집 전화번호를 입력하세요. (숫자만 입력됩니다.)',
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9\-;]'),
                            ),
                          ],
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.deepOrange[50],
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 50.0,
                              horizontal: 10.0,
                            ),
                            labelText: '맛집 평가를 입력하세요.',
                            border: OutlineInputBorder(),
                          ),
                          maxLength: 150,
                          textAlignVertical: TextAlignVertical.top,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: latitudeController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: '위도를 입력하세요.',
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9\.;]'),
                                  ),
                                ],
                                maxLength: 30,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: longitudeController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: '경도를 입력하세요.',
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9\.;]'),
                                  ),
                                ],
                                maxLength: 30,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            insertAction();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange[400],
                            foregroundColor: Colors.white,
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(300, 55),
                          ),
                          child: Text(
                            '맛집을 추가합니다.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                                        Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 400,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                initialCenter: LatLng(
                                  initialLatitude,
                                  initialLogitude,
                                ),
                                initialZoom: 15,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                ),

                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      width: 80,
                                      height: 80,
                                      point: _markerPosition,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            child: Text(nameController.text,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.pin_drop,
                                            size: 50,
                                            color: Colors.red,
                                          )
                                        ],
                                      ),

                                    ),
                                  ]

                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  } // builder

  // --- functions ---
  Future getImageFromGallery01(ImageSource imageSource) async {
    final XFile? pickedFile = await picker01.pickImage(source: imageSource);
    if (pickedFile == null) {
      return;
    } else {
      imageFile01 = XFile(pickedFile.path);
      setState(() {});
    }
  }

  Future getImageFromGallery02(ImageSource imageSource) async {
    final XFile? pickedFile = await picker02.pickImage(source: imageSource);
    if (pickedFile == null) {
      return;
    } else {
      imageFile02 = XFile(pickedFile.path);
      setState(() {});
    }
  }

  insertAction() async {
      if (imageFile01 == null || imageFile02 == null) {
      _showErrorDialog('이미지를 모두 선택해 주세요.');
      return;
    }

    if (nameController.text.trim().isEmpty ||
        latitudeController.text.trim().isEmpty ||
        longitudeController.text.trim().isEmpty) {
      _showErrorDialog('맛집 이름과 위치 정보를 입력해 주세요.');
      return;
    }
    File imageFileA = File(imageFile01!.path);
    Uint8List getImageA = await imageFileA.readAsBytes();

    File imageFileB = File(imageFile02!.path);
    Uint8List getImageB = await imageFileB.readAsBytes();

    var eatplaceInsert = Eatplace(
      name: nameController.text,
      phone: phoneController.text,
      comment: commentController.text,
      latitude: latitudeController.text,
      longitude: longitudeController.text,
      image01: getImageA,
      image02: getImageB,
    );

    int result = await handler.insertEatPlace(eatplaceInsert);
  

    DateTime now = DateTime.now();
    String formattedToday = DateFormat('yyyy-MM-dd').format(now);

    print(result);

    var favoriteInsert = Favorite(
      id: result, 
      date: formattedToday, 
      isfavorite: false,
      );
    
    int resultFavorite = await handler.insertFavorite(favoriteInsert);

    print(resultFavorite);

    if (resultFavorite == 0) {
      _showErrorDialog('DB에 추가되지 않았습니다.');
    } else {
      _showDialog();
    }
  }

  _showDialog() {
    Get.defaultDialog(
      title: '추가 완료',
      middleText: '맛집 추가가 완료 되었습니다.',
      backgroundColor: Colors.blue,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: Text('OK'),
        ),
      ],
    );
  }

  Future<void> searchLocation(String name, String search01, String search02) async {
    try {
      final query = Uri.encodeComponent('$name $search01 $search02');
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=10',
      );
      final response = await http.get(
        url,
        headers: {'User-Agent': 'must-eat-place-app'},
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes); // UTF-8로 디코딩!!
        final data = json.decode(decodedBody);

        if (data.isNotEmpty) {
          String lat = data[0]['lat'];
          String lon = data[0]['lon'];
          addressDisplay = data[0]['display_name'];

          setState(() {
            latitudeController.text = lat;
            longitudeController.text = lon;
            _markerPosition = LatLng(double.parse(lat), double.parse(lon));

            _mapController.move(_markerPosition, _mapController.camera.zoom);
          });
        } else {
          _showErrorDialog('검색 결과가 없습니다.');
        }
      } else {
        _showErrorDialog('HTTP 오류: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('에러 발생: $e');
    }
  }

  _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('오류'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('확인'),
              ),
            ],
          ),
    );
  }
} // class
