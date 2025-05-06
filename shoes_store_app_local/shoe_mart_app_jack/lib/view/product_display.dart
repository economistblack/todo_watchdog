import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shoe_mart_app_jack/view/store_map.dart';

class ProductDisplay extends StatefulWidget {
  const ProductDisplay({super.key});

  @override
  State<ProductDisplay> createState() => _ProductDisplayState();
}

class _ProductDisplayState extends State<ProductDisplay> {
  // Property
  late String userId;
  late String password;

  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    userId = '';
    password = '';
    initStorage();
  }

  initStorage(){
    userId = box.read('p_userId');
    password = box.read('p_password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$userId : $password'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(StoreMap());
            }, 
            icon: Icon(Icons.map))
        ],
      ),
    );
  }
}