import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../model/user.dart';
import 'findid.dart';
import 'findpassword.dart';
import 'home.dart';
import 'signup.dart';
import 'view_model/database_handler.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Property
  DatabaseHandler handler = DatabaseHandler();
  final _formKey = GlobalKey<FormState>();
  final box = GetStorage();
  late List<User> userList;

  late TextEditingController emailController; // 고객 아이디
  late TextEditingController passWordController; // 고객 비밀번호
  final RegExp _emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$"); // 이메일 정규식
  final RegExp _passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$'); // 비밀번호 정규식


  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passWordController = TextEditingController();
    userList = [];
   
    
    initStorage();
  }

  initStorage(){
    box.write('p_userId', "");
    box.write('p_password', "");
  }

  @override
  void dispose() {
    disposeStorage();
    super.dispose();
  }

  disposeStorage(){
    box.erase();
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
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton.icon(
                onPressed: () {
                  Get.to(Signup());              
                },
                icon: Icon(
                  Icons.person_add_alt_rounded,
                  size: 20,
                  color: Colors.brown[500],
                ),
                label: Text('회원가입',
                style: TextStyle(
                  color: Colors.brown[500],
                ),
                ),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 300,
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: '아이디를 입력하세요.',
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.brown[500],  
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)
                          )
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty){
                            return '이메일을 입력해 주세요.';
                          } else if (!_emailRegex.hasMatch(value)){
                            return '올바른 이메일 형식이 아닙니다.';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(width: 300,
                      child: TextFormField(
                          controller: passWordController,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "비밀번호를 입력하세요.",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.brown[500],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)
                            )
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
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.login),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown[500],
                          foregroundColor: Colors.white,
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          minimumSize: Size(150, 40)
                        ),
                        onPressed: () async{
                          userList = await handler.queryUserLogin(emailController.text);
                          if(userList.isNotEmpty && passWordController.text == userList.first.pw){
                            _showDialog('계정이 확인 되었습니다.');
                          }else{
                            errorSnackBar('계정 정보를 확인하세요.');
                          }
                        }, 
                        label:Text(
                          '로그인',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        ), 
                        ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          icon: Icon(Icons.vpn_key),
                          onPressed: () {
                            Get.to(FindPassWord());
                          }, 
                          label: Text('비밀번호 찾기')
                          ),
                        Text('|'),
                        TextButton.icon(
                          icon: Icon(Icons.person_3_outlined),
                          onPressed: () {
                            Get.to(FindId());
                          }, 
                          label: Text('아이디 찾기')
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

  errorSnackBar(String message){
    Get.snackbar(
      '경고',
      message,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
      colorText: Colors.white,
      backgroundColor: Colors.red
      );
  }

  _showDialog(String message){
    Get.defaultDialog(
      title: '환영합니다.',
      middleText: message,
      backgroundColor: Colors.blue,
      barrierDismissible: false,
      actions: [
        TextButton.icon(
          icon: Icon(Icons.check),
          onPressed: () {
            Get.back(); // 다이얼로그 지움
            saveStorage();
            Get.to(Home()); // 페이지 넘어감
          }, 
          label: Text('확인'),
          ),
      ]
    );
  }

  saveStorage(){
    box.write('p_userId', emailController.text);
    box.write('p_password', passWordController.text);
  }




} // class