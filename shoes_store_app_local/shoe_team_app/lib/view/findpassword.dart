import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../model/user.dart';

import '../view_model/database_handler.dart';

class FindPassWord extends StatefulWidget {
  const FindPassWord({super.key});

  @override
  State<FindPassWord> createState() => _FindPassWordState();
}

class _FindPassWordState extends State<FindPassWord> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHandler handler = DatabaseHandler();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPwController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final _passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.lock_reset, size: 30, color: Colors.white),
            SizedBox(width: 15),
            Text('비밀번호 초기화'),
          ],
        ),
        toolbarHeight: 100,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: '이메일(아이디)',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력해 주세요.';
                  } else if (!_emailRegex.hasMatch(value)) {
                    return '유효한 이메일 형식이 아닙니다.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: '이름',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름을 입력해 주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: phoneController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9\-]*$')),
                ],
                decoration: InputDecoration(
                  labelText: '전화번호',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '전화번호를 입력해 주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 20),
              TextFormField(
                controller: newPwController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '새 비밀번호',
                  prefixIcon: Icon(Icons.lock_reset),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해 주세요.';
                  } else if (!_passwordRegex.hasMatch(value)) {
                    return '대소문자, 숫자, 특수문자 포함 8자 이상이어야 합니다.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: confirmPwController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.amber[50],
                  labelText: '비밀번호 확인',
                  prefixIcon: const Icon(Icons.check_circle_outline),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != newPwController.text) {
                    return '비밀번호가 일치하지 않습니다.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _resetPassword,
                icon: Icon(Icons.refresh),
                label: Text('비밀번호 초기화'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(200, 40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } // build

  _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final newPw = newPwController.text.trim();
      final name = nameController.text.trim();
      final phone = phoneController.text.trim();

      // ID로 조회
      List<User> user = await handler.queryUserLogin(email);

      // 존재하지 않거나 정보 불일치 시 거부
      if (user.isEmpty ||
          user.first.name.trim() != name ||
          user.first.phone.trim() != phone) {
        errorSnackBar('입력한 정보와 일치하는 계정을 찾을 수 없습니다.');
        return;
      }

      // 비밀번호 업데이트
      final result = await handler.updateUserPassword(email, newPw);
      if(result != 0){
        _showDialog('비밀번호가 정상적으로 변경되었습니다.');
      }else{
        errorSnackBar('비밀번호 변경에 실패했습니다.');
      }
    }
  }

  errorSnackBar(String message) {
    Get.snackbar(
      '경고',
      message,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
      colorText: Colors.white,
      backgroundColor: Colors.red,
    );
  }

  passSnackBar(String message) {
    Get.snackbar(
      '성공',
      message,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
      colorText: Colors.white,
      backgroundColor: Colors.blue,
    );
  }

  _showDialog(String message){
    Get.defaultDialog(
      title: '완료',
      middleText: message,
      backgroundColor: Colors.blue,
      barrierDismissible: false,
      actions: [
        TextButton.icon(
          icon: Icon(Icons.check),
          onPressed: () {
            Get.back();
            Get.back();
          }, 
          label: Text('확인'),
          ),
      ]
    );
  }

} // class
