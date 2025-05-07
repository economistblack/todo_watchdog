import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final box = GetStorage();
  late String employeeId;

  @override
  void initState() {
    super.initState();
    employeeId = '';
    initStorage();
  }

  initStorage(){
    employeeId = box.read('p_employeeId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('직원 아이디 : $employeeId'),
      ),

    );
  }
} 