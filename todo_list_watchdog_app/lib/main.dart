import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:todo_list_watchdog_app/home.dart';
import 'package:todo_list_watchdog_app/view/addtodo.dart';
import 'package:todo_list_watchdog_app/view/edittodo.dart';
import 'package:todo_list_watchdog_app/view/login.dart';
import 'package:todo_list_watchdog_app/view/mypage.dart';

void main() {
  runApp(
    const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',

    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate
    ],
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Login(),
      getPages: [
        GetPage(
          name: '/home', 
          page: () => Home(),
          transition: Transition.circularReveal,
          transitionDuration: Duration(seconds: 1),
          ),
        GetPage(
          name: '/addtodo', 
          page: () => AddToDo(),
          transition: Transition.fade,
          transitionDuration: Duration(seconds: 1),
          ),
        GetPage(
          name: '/edittodo', 
          page: () => EditToDo(),
          transition: Transition.fade,
          transitionDuration: Duration(seconds: 1),
          ),
        GetPage(
          name: '/mypage', 
          page: () => MyPage(),
          transition: Transition.fade,
          transitionDuration: Duration(seconds: 1),
          ),
        GetPage(
          name: '/login', 
          page: () => Login(),
          transition: Transition.circularReveal,
          transitionDuration: Duration(seconds: 1),
          ),
      ],
    );
  }
}

