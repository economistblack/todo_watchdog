import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_list_watchdog_app/method/users_info.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController emailTypeIdController;   // eamil 형식의 ID 텍스트로 받는 값
  late TextEditingController passKeyController;       // 비밀번호 텍스트로 받는 값
  late String emailTypeId;                            // email 형식의 ID
  late String passKey;                                // 비밀번호
  late String bannerImage;                            // 로그인 페이지 하단 이미지 경로
  late Timer timer;                                   // 로그인 페이지 하단 이미지 타이머
  late RegExp emailRegex;                             // 이메일 정규식
  late String loginInfo;                              // 로그인 실패시 표시되는 정보
  late List<List<UsersInfo>> loginDb;                 // 사용자 정보가 들어간 DB 리스트
  late bool emailTypeValid;                           // ID가 이메일 정규식과 일치하는지 여부의 구분 값


  @override
  void initState() {
    super.initState();
    emailTypeIdController = TextEditingController();
    passKeyController = TextEditingController();
    emailTypeId = '';
    passKey = '';
    bannerImage = 'images/frontbanner01.png';
    emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

    UsersInfo usersInfo = UsersInfo(emailTypeId: emailTypeId, passKey: passKey);
    usersInfo.userDb = [
      ['washington@gmail.com', '1234567', 'images/user01.png', 'George'],
      ['lincoin@gmail.com', '1234567', 'images/user02.png', 'Abraham'],
      ['roosevelt@gmail.com', '1234567', 'images/user03.png', 'Theodore'],
      ['truman@gmail.com', '1234567', 'images/user04.png', 'HarryS'],
      ['eisenhower@gmail.com', '1234567', 'images/user05.png', 'Dwight'],
      ['kennedy@gmail.com', '1234567', 'images/user06.png', 'John'],
      ['nixon@gmail.com', '1234567', 'images/user07.png', 'Richard'],
      ['reagan@gmail.com', '1234567', 'images/user08.png', 'Ronald'],
      ['bush@gmail.com', '1234567', 'images/user09.png', 'GeorgeW'],
      ['obama@gmail.com', '1234567', 'images/user10.png', 'Barack'],
    ];

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      chagneBanner();
    },);
  }

  // 로그인 페이지 하단 이미지 변경 함수
  chagneBanner(){
    if(bannerImage == 'images/frontbanner01.png'){
      bannerImage = 'images/frontbanner02.png';
    }else if(bannerImage == 'images/frontbanner02.png'){
      bannerImage = 'images/frontbanner01.png';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF38BDF8),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 110,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/logo.png',
                    width: 70,
                    height: 70,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Make Myself Great Again!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF9FAFB),
                  ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: emailTypeIdController,
                  decoration: InputDecoration(
                    labelText: '이메일 아이디를 입하세요.(*필수 입력)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFF334155)),
                    ),
                    filled: true,
                    fillColor: Color(0xFFF9FAFB),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: passKeyController,
                  decoration: InputDecoration(
                    labelText: '사용자 비밀번호를 입하세요.(*필수 입력)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFF334155)),
                    ),
                    filled: true,
                    fillColor: Color(0xFFF9FAFB),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    // timer.cancel(); // 로그인 성공 시 들어가야 함
                    // super.dispose();  // 로그인 성공 시 들어가야 함
                    loginCheck();
                    //Get.toNamed('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA3E635),
                    foregroundColor: Color(0xFF334155),
                    minimumSize: Size(150, 50),
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  ),
                  child: Text('로그인',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 90,
              ),
              Image.asset(
                bannerImage,
              ),
            ],
          ),
        ),
      )
    );
  } // build

  // 정규식 일치 및 로그인을 검증 후 'home'으로 이동하는 함수 

  loginCheck(){
    emailTypeValid = emailRegex.hasMatch(emailTypeIdController.text);
    if(emailTypeIdController.text.trim().isEmpty || passKeyController.text.trim().isEmpty){
      loginInfo = '아이디와 패스워드를 입력하세요!';
    }else if(emailTypeValid == false){
      loginInfo = '이메일 형식의 아이디를 입력하세요!';
      loginInfoSnack();
    }
  }

  // 로그인 실패 시 표시되는 스낵바 정보
  loginInfoSnack(){
    
    Get.snackbar(
      '', 
      loginInfo,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      backgroundColor: Color(0xFFE9D5FF),
      colorText: Color(0xFF334155),
      titleText: Text(
        '⚠️ 주의',
      style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      letterSpacing: 1.5,
      ),
      ),
    );
  }


} // Class