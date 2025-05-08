import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shoe_mart_app_jack/vm/database_handler.dart';



class FindId extends StatefulWidget {
  const FindId({super.key});

  @override
  State<FindId> createState() => _FindIdState();
}

class _FindIdState extends State<FindId> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHandler handler = DatabaseHandler();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: const [
            Icon(Icons.email_outlined, size: 30, color: Colors.white),
            SizedBox(width: 15),
            Text('아이디 찾기'),
          ],
        ),
        toolbarHeight: 100,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              const SizedBox(height: 10),
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
                decoration: const InputDecoration(
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
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _findId,
                icon: const Icon(Icons.search),
                label: const Text('아이디 찾기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 40),
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _findId() async {
    if (_formKey.currentState!.validate()) {
      final name = nameController.text.trim();
      final phone = phoneController.text.trim();

      try {
        final db = await handler.initializeDB();
        final result = await db.rawQuery(
          'SELECT id FROM user WHERE name = ? AND phone = ?',
          [name, phone],
        );

        if (result.isNotEmpty) {
          final foundId = result.first['id']?.toString() ?? '알 수 없음';
          _showDialog('아이디는 다음과 같습니다:\n\n$foundId');
        } else {
          _errorSnackBar('일치하는 계정을 찾을 수 없습니다.');
        }
      } catch (e) {
        _errorSnackBar('오류가 발생했습니다. 다시 시도해 주세요.');
      }
    }
  }

  void _showDialog(String message) {
    Get.defaultDialog(
      title: '아이디 확인',
      middleText: message,
      backgroundColor: Colors.blue,
      barrierDismissible: false,
      actions: [
        TextButton.icon(
          icon: const Icon(Icons.check),
          onPressed: () {
            Get.back(); // 다이얼로그 닫기
            Get.back(); // 페이지 닫기
          },
          label: const Text('확인'),
        ),
      ],
    );
  }

  void _errorSnackBar(String message) {
    Get.snackbar(
      '경고',
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      colorText: Colors.white,
      backgroundColor: Colors.red,
    );
  }
}