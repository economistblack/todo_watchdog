import 'dart:io';
import 'package:environment_api_app/model/imageposition.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:environment_api_app/vm/database_handler.dart';
import 'package:flutter/material.dart';


class Insertimageposition extends StatefulWidget {
  const Insertimageposition({super.key});

  @override
  State<Insertimageposition> createState() => _InsertimagepositionState();
}

class _InsertimagepositionState extends State<Insertimageposition> {
  DatabaseHandler handler = DatabaseHandler();
  XFile? imageFile;
  final ImagePicker picker = ImagePicker();
  late Position currentPosition;
  late double latData;
  late double longData;
  late MapController mapController;
  late bool canRun;


  @override
  void initState() {
    super.initState();
    mapController = MapController();
    canRun = false;
    checkLocationPermission();
  }

  checkLocationPermission()async{
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
    Position position = await Geolocator.getCurrentPosition();
    currentPosition = position;
    canRun = true;
    latData = currentPosition.latitude;
    longData = currentPosition.longitude;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insert Image & Position'),
      ),
      body: Center(
        child: Column(
          children: [ 
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              color: Colors.blue,
              child: Center(
                child: imageFile == null
                ? Text('Image is not selected!')
                : Image.file(File(imageFile!.path)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                getImageFromGallery(ImageSource.gallery);
              },
              child: Text('갤러리에서 이미지 선택')),
             ElevatedButton(
                onPressed: () => insertAction(), 
                child: Text('입력')
                )
    
          ],
        ),
      ),
    );
  } // build

  // --- Functions ---
  Future getImageFromGallery(ImageSource imageSource)async{
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if(pickedFile == null){
      return;
    }else{
      imageFile = XFile(pickedFile.path);
      setState(() {});
    }
  }

  insertAction()async{
    File imageFile1 = File(imageFile!.path);
    Uint8List getImage = await imageFile1.readAsBytes();
    print(latData);
    print(longData);
    var imagePositionInsert = ImagePosition(
      latitude: latData, 
      longtitude: longData, 
      image: getImage
      );

    int result = await handler.insertImagePostion(imagePositionInsert);
    if(result == 0){
      // errorsnackbar
    }else{
      _showDialog();
    }
  }
    _showDialog(){
    Get.defaultDialog(
      title: '입력 완료',
      middleText: '입력이 완료 되었습니다.',
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          }, 
          child: Text('OK')),
      ]
    );
  }

} // class