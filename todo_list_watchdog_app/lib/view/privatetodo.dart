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
  late String emailTypeId;
  late String passKey;
  late String profileImage;
  late String nickName;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(''),
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFF38BDF8),
                    child: ClipOval(
                      child: Image.asset(profileImage, fit: BoxFit.contain),
                    ),
                  ),
                  Text(nickName),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
