import 'dart:io';
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
              child: Text('Gallery'))
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



} // class