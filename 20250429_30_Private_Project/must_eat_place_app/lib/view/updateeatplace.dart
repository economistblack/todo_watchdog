import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';

import '../model/eatplace.dart';
import '../vm/database_handler.dart';

class Updateeatplace extends StatefulWidget {
  const Updateeatplace({super.key});

  @override
  State<Updateeatplace> createState() => _UpdateeatplaceState();
}

class _UpdateeatplaceState extends State<Updateeatplace> {
  DatabaseHandler handler = DatabaseHandler();
  var value = Get.arguments ?? "__";

  late TextEditingController nameController; // 맛집 이름
  late TextEditingController phoneController; // 맛집 전화번호
  late TextEditingController commentController; // 맛집 평가
  late TextEditingController latitudeController; // 맛집 위도
  late TextEditingController longitudeController; // 맛집 경도

  XFile? imageFile01; // 맛집 사진
  XFile? imageFile02; // 맛집 사진

  final ImagePicker picker01 = ImagePicker();
  final ImagePicker picker02 = ImagePicker();

  late double initialLatitude;
  late double initialLogitude;
  late LatLng markerPosition;

  late int firstDisp;
  late int secondDisp;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    commentController = TextEditingController();
    latitudeController = TextEditingController();
    longitudeController = TextEditingController();

    nameController.text = value[1];
    phoneController.text = value[2];
    commentController.text = value[3];
    latitudeController.text = value[4];
    longitudeController.text = value[5];

    initialLatitude = double.parse(latitudeController.text);
    initialLogitude = double.parse(longitudeController.text);

    markerPosition = LatLng(initialLatitude, initialLogitude);

    firstDisp = 0;
    secondDisp = 0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              '내가 경험한 맛집 내용 수정하기',
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
                                ? Image.memory(value[6])
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
                                ? Image.memory(value[7])
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
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: '맛집 이름'),
                          maxLength: 30,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: phoneController,
                          decoration: InputDecoration(labelText: '맛집 전화번호'),
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
                            labelText: '맛집 평가',
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
                                decoration: InputDecoration(labelText: '위도'),
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
                                decoration: InputDecoration(labelText: '경도'),
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
                            if (firstDisp == 0 || secondDisp == 0) {
                              updateAction();
                            } else {
                              updateActionAll();
                            }
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
                            '내용을 수정합니다.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 400,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: FlutterMap(
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
                                DragMarkers(
                                  markers: [
                                    DragMarker(
                                      point: markerPosition,
                                      size: const Size(80, 80),
                                      offset: const Offset(0, -20),
                                      builder: (ctx, point, isDragging) {
                                        return Icon(
                                          Icons.location_on,
                                          size: isDragging ? 60 : 50,
                                          color:
                                              isDragging
                                                  ? Colors.green
                                                  : Colors.red,
                                        );
                                      },
                                      onDragEnd: (details, newPosition) {
                                        setState(() {
                                          markerPosition = newPosition;
                                          latitudeController.text =
                                              newPosition.latitude.toString();
                                          longitudeController.text =
                                              newPosition.longitude.toString();
                                        });
                                      },
                                    ),
                                  ],
                                ),

                                // MarkerLayer(
                                //   markers: [
                                //     Marker(
                                //       width: 80,
                                //       height: 80,
                                //       point: LatLng(initialLatitude, initialLogitude),
                                //       child: Column(
                                //         children: [
                                //           SizedBox(
                                //             child: Text(nameController.text,
                                //             style: TextStyle(
                                //               fontSize: 10,
                                //               fontWeight: FontWeight.bold,
                                //               color: Colors.green,
                                //             ),
                                //             ),
                                //           ),
                                //           Icon(
                                //             Icons.pin_drop,
                                //             size: 50,
                                //             color: Colors.red,
                                //           )
                                //         ],
                                //       ),

                                //     ),
                                //   ]

                                //   ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
      firstDisp += 1;
      setState(() {});
    }
  }

  Future getImageFromGallery02(ImageSource imageSource) async {
    final XFile? pickedFile = await picker02.pickImage(source: imageSource);
    if (pickedFile == null) {
      return;
    } else {
      imageFile02 = XFile(pickedFile.path);
      secondDisp += 1;
      setState(() {});
    }
  }

  updateAction() async {
    var eatplaceInsert = Eatplace(
      id: value[0],
      name: nameController.text,
      phone: phoneController.text,
      comment: commentController.text,
      latitude: latitudeController.text,
      longitude: longitudeController.text,
      image01: value[6],
      image02: value[7],
    );

    int result = await handler.updateEatPlace(eatplaceInsert);
    if (result == 0) {
    } else {
      _showDialog();
    }
  }

  updateActionAll() async {
    File imageFileA = File(imageFile01!.path);
    Uint8List getImageA = await imageFileA.readAsBytes();

    File imageFileB = File(imageFile02!.path);
    Uint8List getImageB = await imageFileB.readAsBytes();

    var eatplaceInsert = Eatplace(
      id: value[0],
      name: nameController.text,
      phone: phoneController.text,
      comment: commentController.text,
      latitude: latitudeController.text,
      longitude: longitudeController.text,
      image01: getImageA,
      image02: getImageB,
    );

    int result = await handler.updateEatPlaceAll(eatplaceInsert);
    if (result == 0) {
    } else {
      _showDialog();
    }
  }

  _showDialog() {
    Get.defaultDialog(
      title: '수정 완료',
      middleText: '맛집 내용이 수정 되었습니다.',
      backgroundColor: Colors.amber,
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
} // class
