import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_watchdog_app/home.dart';
import 'package:todo_list_watchdog_app/view/login.dart';

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
      home: const Login(),
      getPages: [
        GetPage(
          name: '/home', 
          page: () => Home(),
          ),
      ],
    );
  }
}

