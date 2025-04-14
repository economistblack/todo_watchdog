import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Property
  ThemeMode _themeMode = ThemeMode.system;

  _changeThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    setState(() {});
  }

  static const seedColor = Color.fromARGB(255, 63, 153, 222);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      themeMode: _themeMode,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: seedColor,
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: seedColor,
      ),
      home: Home(onChangeTheme: _changeThemeMode),
    );
  }
}
