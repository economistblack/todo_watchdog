import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_watchdog_app/model/users_info.dart';

import '../model/todolist.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  // Property
  int userIndex = Get.arguments[0] ?? 0;
  late String emailTypeId; // 사용자 이메일 아이디
  late String passKey; // 사용자 비밀번호
  late String profileImage; // 사용자가 선택한 프로파일 이미지
  late String nickName; // 사용자가 선택한 닉네임
  late int listNo; // todo 리스트 고유 번호
  late List<int> userFriendList; // 로그인 사용자의 친구 리스트
  late String newProfileImage; // 새로 변경한 프로파일 이미지
  late String newNickName; // 새로 변경한 닉네임
  late String newPassKey; // 새로 변경한 비밀번호
  late TextEditingController nickNameController; // 닉네임 입력을 받는 변수
  late TextEditingController passKeyController; // 비밀번호 입력을 받는 변수
  late List<String> extraImageList;
  late String snackMessage;

  @override
  void initState() {
    super.initState();
    emailTypeId = '';
    passKey = '';
    profileImage = '';
    nickName = '';
    listNo = 0;
    userFriendList = [];
    newProfileImage = '';
    newNickName = '';
    newPassKey = '';
    extraImageList = [
      'images/user11.png',
      'images/user12.png',
      'images/user13.png',
      'images/user14.png',
      'images/user15.png',
    ];
    snackMessage = '';
    nickNameController = TextEditingController();
    passKeyController = TextEditingController();
    snackMessage = '';

    profileImage = UsersInfo.userDb[userIndex].userImage;
    nickName = UsersInfo.userDb[userIndex].userNickName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed('/home', arguments: [userIndex]);
                      },
                      child: Icon(Icons.arrow_back_ios_new_outlined),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF334155), width: 2.0),
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
                    child: Text(
                      nickName,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 80),
                  OutlinedButton.icon(
                    icon: Icon(Icons.logout, color: Colors.white),
                    onPressed: () {
                      Get.offAllNamed('/login');
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Color(0xFF334155),
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    label: Text(
                      '로그아웃',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Divider(color: Color(0xFF334155)),
              ),
              Text(
                '프로필 이미지 변경을 원하면 아래에서 이미지를 선택하세요!',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () {
                          changeProfileImage(extraImageList[0]);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFF334155),
                              width: 2.0,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFFF9FAFB),
                            child: ClipOval(
                              child: Image.asset(
                                extraImageList[0],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () {
                          changeProfileImage(extraImageList[1]);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFF334155),
                              width: 2.0,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFFF9FAFB),
                            child: ClipOval(
                              child: Image.asset(
                                extraImageList[1],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () {
                          changeProfileImage(extraImageList[2]);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFF334155),
                              width: 2.0,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFFF9FAFB),
                            child: ClipOval(
                              child: Image.asset(
                                extraImageList[2],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () {
                          changeProfileImage(extraImageList[3]);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFF334155),
                              width: 2.0,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFFF9FAFB),
                            child: ClipOval(
                              child: Image.asset(
                                extraImageList[3],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () {
                          changeProfileImage(extraImageList[4]);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFF334155),
                              width: 2.0,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFFF9FAFB),
                            child: ClipOval(
                              child: Image.asset(
                                extraImageList[4],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: nickNameController,
                  decoration: InputDecoration(labelText: '변경할 닉네임을 입력하세요!'),
                  maxLength: 9,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.cancel_outlined),
                    style: ElevatedButton.styleFrom(
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Color(0xFFA3E635),
                    ),
                    onPressed: () {
                      cancelProfileImage();
                    },
                    label: Text('취소'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    icon: Icon(Icons.check_circle_rounded),
                    style: ElevatedButton.styleFrom(
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Color(0xFFA3E635),
                    ),
                    onPressed: () {
                      newChangeCheck();
                    },
                    label: Text('변경'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  '$nickName 님의 친구는 ${UsersInfo.userDb[userIndex].friendsGroup.length}명 입니다.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF38BDF8),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: ListView.builder(
                    itemCount: UsersInfo.userDb[userIndex].friendsGroup.length,
                    itemBuilder: (context, index) {
                      int friendNo =
                          UsersInfo.userDb[userIndex].friendsGroup[index];
                      UsersInfo friend = UsersInfo.userDb[friendNo];

                      int todoCount = getFriendTodoCount(friendNo);

                      return SizedBox(
                        height: 110,
                        child: Dismissible(
                          direction: DismissDirection.endToStart,
                          key: ValueKey(friendNo),
                          background: Container(
                            color: Colors.red[300],
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(Icons.delete_forever, size: 70),
                          ),
                          onDismissed: (direction) {
                            UsersInfo.userDb[userIndex].friendsGroup.remove(
                              friendNo,
                            ); // 친구 삭제

                            // 스낵바 알림
                            Get.snackbar(
                              '',
                              '${friend.userNickName}님이 친구 목록에서 삭제되었습니다!',
                              snackPosition: SnackPosition.BOTTOM,
                              duration: const Duration(seconds: 2),
                              backgroundColor: const Color(0xFFE9D5FF),
                              colorText: const Color(0xFF334155),
                              titleText: const Text(
                                '🗑️ 삭제 완료',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            );

                            setState(() {}); // UI 갱신
                          },
                          child: Card(
                            color:
                                (index % 2 == 0)
                                    ? Colors.blueGrey[100]
                                    : Colors.grey[100],
                            child: Center(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Color(0xFF334155),
                                          width: 1.0,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Color(0xFFE9D5FF),
                                        child: ClipOval(
                                          child: Image.asset(
                                            friend.userImage,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${friend.userNickName} 님의 일정은 $todoCount개입니다!',
                                  ),
                                  SizedBox(width: 40),
                                  Icon(Icons.arrow_left, color: Colors.black),
                                  Icon(Icons.delete, color: Colors.black),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } // build

  // --- functions ---

  // 프로필 이미지 변경
  changeProfileImage(String image) {
    profileImage = image;
    newProfileImage = image;
    setState(() {});
  }

  // 이미지 선택 취소
  cancelProfileImage() {
    profileImage = UsersInfo.userDb[userIndex].userImage;
    setState(() {});
  }

  // 프로필 이미지 변경 확정
  newChangeCheck() {
    profileImage = newProfileImage;
    newNickName = nickNameController.text;
    nickName = newNickName;
    UsersInfo.userDb[userIndex].userImage = profileImage;
    UsersInfo.userDb[userIndex].userNickName = newNickName;

    snackMessage = '변경 내용이 모두 적용되었습니다!';

    snackBarMessage();
    setState(() {});
  }

  snackBarMessage() {
    Get.snackbar(
      '',
      snackMessage,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      backgroundColor: Color(0xFFE9D5FF),
      colorText: Color(0xFF334155),
      titleText: Text(
        '⚠️ 알림',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  // 친구의 일정
  int getFriendTodoCount(int friendUserNo) {
    return TodoList.listDb.where((todo) => todo.userNo == friendUserNo).length;
  }
} // Class
