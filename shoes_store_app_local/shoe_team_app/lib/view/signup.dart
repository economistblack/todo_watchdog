import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import '../../model/user.dart';
import '../view_model/database_handler.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // Property
  final _formKey = GlobalKey<FormState>();
  final DatabaseHandler handler = DatabaseHandler();

  // 카카오 주소 받기 위한 Property
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressDetailController =
      TextEditingController();
  Map<String, String> formData = {};

  late TextEditingController emailController;
  late TextEditingController passWordController;
  late TextEditingController passWordCheckController;
  late TextEditingController nameController;
  late TextEditingController phoneController;

  late String adminDate;
  late bool idConfirm;
  late String address; // DB에 들어갈 주소
  late List<User> userList;

  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final _phoneRegex = RegExp(r'^010-\d{3,4}-\d{4}$');
  final _passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$',
  );

  @override
  void initState() {
    super.initState();
    adminDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    emailController = TextEditingController();
    passWordController = TextEditingController();
    passWordCheckController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    idConfirm = false;
    userList = [];
    address = '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Row(
            children: [
              Icon(Icons.person_add, size: 30, color: Colors.white),
              SizedBox(width: 15),
              Text(
                '회원가입 : 환영합니다!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          toolbarHeight: 100,
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: emailController,
                        maxLength: 50,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: '아이디를 입력하세요.(필수)',
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.brown[500],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
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
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          icon: Icon(Icons.verified_user),
                          onPressed: () async {
                            String id = emailController.text.trim();
                            userList = await handler.queryUserLogin(id);

                            if (id.isEmpty || !_emailRegex.hasMatch(id)) {
                              errorSnackBar('유효한 이메일을 입력하십시오');
                              idConfirm = false;
                              return;
                            }

                            if (userList.isNotEmpty) {
                              errorSnackBar('이미 사용 중인 아이디입니다.');
                              idConfirm = false;
                              return;
                            } else {
                              passSnackBar('사용 가능한 아이디입니다.');
                              idConfirm = true;
                              return;
                            }
                          },
                          label: Text('아이디 중복 확인'),
                        ),
                      ],
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: passWordController,
                        maxLength: 50,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "비밀번호를 입력하세요.(필수)",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.brown[500],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력해 주십시오';
                          } else if (!_passwordRegex.hasMatch(value)) {
                            return '비밀번호는 대문자, 소문자, 숫자, 특수문자 포함 8자 이상이어야 합니다';
                          }
                          return null;
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: passWordCheckController,
                        maxLength: 50,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "비밀번호를 확인하세요.(필수)",
                          filled: true,
                          fillColor: Colors.amber[50],
                          prefixIcon: Icon(
                            Icons.check_circle_outline_rounded,
                            color: Colors.brown[500],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력해 주십시오';
                          } else if (value != passWordController.text) {
                            return '비밀번호가 일치하지 않습니다.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: nameController,
                        maxLength: 10,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "이름을 입력하세요.(필수)",
                          prefixIcon: Icon(
                            Icons.badge,
                            color: Colors.brown[500],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이름을 입력해 주십시오';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: phoneController,
                        maxLength: 20,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^[0-9\-]*$'),
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText: "전화번호를 입력하세요.(필수)",
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: Colors.brown[500],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '전화번호를 입력해 주십시오.';
                          } else if (!_phoneRegex.hasMatch(value)) {
                            return '핸드폰 번호만 입력해 주십시오.\n예: 010-1234-5678 또는 010-123-4567';
                          }
                          return null;
                        },
                      ),
                    ),

                    TextFormField(
                      controller: _postcodeController,
                      decoration: const InputDecoration(
                        hintText: '우편번호',
                        prefixIcon: Icon(Icons.confirmation_num_outlined),
                      ),
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '주소를 검색하세요.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        hintText: '기본주소',
                        prefixIcon: Icon(Icons.home_outlined),
                      ),
                      readOnly: true,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _addressDetailController,
                      decoration: const InputDecoration(
                        hintText: '상세주소 입력',
                        prefixIcon: Icon(Icons.home_outlined),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            icon: Icon(
                              Icons.search_outlined,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[200],
                              foregroundColor: Colors.white,
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => _searchAddress(context),
                            label: Text('주소검색'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.cancel, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(120, 40),
                              backgroundColor: Colors.brown,
                              foregroundColor: Colors.white,
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Get.back();
                            },
                            label: Text('취소'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.check_circle, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(120, 40),
                              backgroundColor: Colors.brown,
                              foregroundColor: Colors.white,
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              address = '${_postcodeController.text} ${_addressController.text} ${_addressDetailController.text}';

                              if (!idConfirm ||
                                  address.isEmpty ||
                                  passWordCheckController.text.isEmpty ||
                                  nameController.text.isEmpty ||
                                  phoneController.text.isEmpty) {
                                errorSnackBar('필수 값을 입력하세요.');
                                return;
                              }
                              _showDialog('회원가입이 완료되었습니다.');
                            },
                            label: Text('회원가입'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } // build

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

  _searchAddress(BuildContext context) async {
    KopoModel? model = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RemediKopo()),
    );

    if (model != null) {
      final postcode = model.zonecode ?? '';
      _postcodeController.value = TextEditingValue(text: postcode);
      formData['postcode'] = postcode;

      final address = model.address ?? '';
      _addressController.value = TextEditingValue(text: address);
      formData['address'] = address;

      final buildingName = model.buildingName ?? '';
      _addressDetailController.value = TextEditingValue(text: buildingName);
      formData['address_detail'] = buildingName;
    }
  }

  _showDialog(String message) {
    Get.defaultDialog(
      title: '성공',
      middleText: message,
      backgroundColor: Colors.blue,
      barrierDismissible: false,
      actions: [
        TextButton.icon(
          icon: Icon(Icons.check),
          onPressed: () async {
            address =
                '${_postcodeController.text} ${_addressController.text} ${_addressDetailController.text}';
            User user = User(
              userid: emailController.text,
              pw: passWordCheckController.text,
              name: nameController.text,
              phone: phoneController.text,
              adminDate: adminDate,
              address: address,
            );

            await handler.insertUser(user);
            Get.back(); // 다이얼로그 지움
            Get.back(); // 뒤로 가기
          },
          label: Text('확인'),
        ),
      ],
    );
  }
} // class
