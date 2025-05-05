import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:must_eat_place_app/view/queryeatplace.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Queryeatplace(),
    );
  }
}

