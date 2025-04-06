import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_watchdog_app/method/users_info.dart';

class PrivateToDo extends StatefulWidget {
  const PrivateToDo({super.key});

  @override
  State<PrivateToDo> createState() => _PrivateToDoState();
}

class _PrivateToDoState extends State<PrivateToDo> {
  // Property
  int userIndex = Get.arguments[0] ?? 0;
  late String emailTypeId;  // 사용자 이메일 아이디
  late String passKey;  // 사용자 비밀번호
  late String profileImage; // 사용자가 선택한 프로파일 이미지
  late String nickName; // 사용자가 선택한 닉네임

  @override
  void initState() {
    super.initState();
    emailTypeId = '';
    passKey = '';
    profileImage = '';
    nickName = '';

    UsersInfo usersInfo = UsersInfo(
      userNo: userIndex,
      emailTypeId: emailTypeId,
      passKey: passKey,
    );

    profileImage = usersInfo.userDb[userIndex][3];
    nickName = usersInfo.userDb[userIndex][4];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      body: Column(
        children: [
          SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 100,
                  child: Row(
                    children: [
                      Icon(Icons.alarm_add_outlined, size: 40, color:  Color(0xFF38BDF8)),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text('data', ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xFF334155),
                          width: 2.0,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: Color(0xFF38BDF8),
                        child: ClipOval(
                          child: Image.asset(profileImage, fit: BoxFit.contain),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(nickName),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Divider(
              color: Color(0xFFA3E635),
            ),
          )
        ],
      ),
    );
  }
}
