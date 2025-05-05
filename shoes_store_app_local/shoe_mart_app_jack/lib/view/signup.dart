import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // Property
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController emailController; 
  late TextEditingController passWordController; 
  late TextEditingController nameController; 
  late TextEditingController phoneController; 
  late TextEditingController addressController;

  late String adminDate;

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final phoneRegex = RegExp(r'^010-\d{4}-\d{4}$');
  final pwRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');

  @override
  void initState() {
    super.initState();
    adminDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    emailController = TextEditingController();
    passWordController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
          ),
        title: Row(
          children: [
            Icon(
              Icons.person_add,
              size: 30,
              color: Colors.white,
            ),
            SizedBox(width: 15),
            Text('회원가입 : 환영합니다!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            ),
          ],
        ),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        toolbarHeight: 100,
      ),
    );
  }
}