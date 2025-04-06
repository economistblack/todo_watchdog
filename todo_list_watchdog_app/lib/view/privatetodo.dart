import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:todo_list_watchdog_app/model/todolist.dart';
import 'package:todo_list_watchdog_app/model/users_info.dart';

class PrivateToDo extends StatefulWidget {
  const PrivateToDo({super.key});

  @override
  State<PrivateToDo> createState() => _PrivateToDoState();
}

class _PrivateToDoState extends State<PrivateToDo> {
  // Property
  int userIndex = Get.arguments[0] ?? 0;
  late String emailTypeId; // 사용자 이메일 아이디
  late String passKey; // 사용자 비밀번호
  late String profileImage; // 사용자가 선택한 프로파일 이미지
  late String nickName; // 사용자가 선택한 닉네임
  late int listNo; // todo 리스트 고유 번호
  String? date; // todo 리스트 날짜
  String? startTime; // todo 리스트 시작 시간
  String? endTime; // todo 리스트 끝나는 시간
  late String location; // todo 리스트 장소
  late String todoTitle; // todo 리스트 제목
  late String contentToDo; // todo 리스트 내용
  late int importance; // todo 리스트 중요도
  late bool isPrivate; // true가 기본 값이고 true 이면 프라이빗 todo 리스트임
  late List<int> friendsList; // 친구 리스트
  late List<List<dynamic>> todoDb; // todo 리스트 전체
  late bool switchValue; // false가 기본 값이고
  late List<List<dynamic>> privateToDoList; // 프라이빗 todo 리스트만 저장된 공간
  late String addMessage; // todo 리스트가 비어있을 때 todo 일정 추가 메시지
  late IconData? importanceIcon01; // 중요도 아이콘 01
  late IconData? importanceIcon02; // 중요도 아이콘 01
  late IconData? importanceIcon03; // 중요도 아이콘 01
  late Color importanceColor;

  @override
  void initState() {
    super.initState();
    emailTypeId = '';
    passKey = '';
    profileImage = '';
    nickName = '';
    listNo = 0;
    location = '';
    todoTitle = '';
    contentToDo = '';
    importance = 0;
    isPrivate = true;
    friendsList = [];
    switchValue = false;
    privateToDoList = [];
    addMessage = '';
    importanceIcon01 = null;
    importanceIcon02 = null;
    importanceIcon03 = null;
    importanceColor = Colors.white;

    print(userIndex);

    UsersInfo usersInfo = UsersInfo(
      userNo: userIndex,
      emailTypeId: emailTypeId,
      passKey: passKey,
    );

    TodoList todoList = TodoList(
      userNo: userIndex,
      listNo: listNo,
      date: date,
      startTime: startTime,
      endTime: endTime,
      location: location,
      todoTitle: todoTitle,
      contentToDo: contentToDo,
      importance: importance,
      isPrivate: isPrivate,
      friendsList: friendsList,
    );

    profileImage = usersInfo.userDb[userIndex][3];
    nickName = usersInfo.userDb[userIndex][4];
    todoDb = todoList.listDb;

    // print('${todoDb[0][2]}');
    // print(todoDb);

    // 프라이빗 todo 리스트 만들기
    for (int i = 0; i < todoDb.length; i++) {
      if (todoDb[i][9] == true && todoDb[i][0] == userIndex) {
        privateToDoList.add(todoDb[i]);
        // print(privateToDoList);
        // print(privateToDoList.length);
      }
    }
    if (privateToDoList.isEmpty) {
      addMessage = '일정을 추가하세요!';
    }
  } // initState()

  // Card에 중요도 아이콘과 색을 표시하는 함수

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
                      Icon(
                        Icons.alarm_add_outlined,
                        size: 40,
                        color: Color(0xFF38BDF8),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text('data'),
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
            child: Divider(color: Color(0xFFA3E635)),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  '최신일정',
                  style: TextStyle(
                    color: Color(0xFF38BDF8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FlutterSwitch(
                value: switchValue,
                activeColor: Color(0xFFA3E635),
                inactiveColor: Color(0xFF38BDF8),
                toggleSize: 20,
                onToggle: (value) {
                  switchValue = value;
                  // 필터 함수 만들어야 함
                },
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  '우선순위',
                  style: TextStyle(
                    color: Color(0xFFA3E635),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (addMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                addMessage,
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF334155),
                ),
              ),
            ),
          SizedBox.shrink(),
          Expanded(
            child: ListView.builder(
              itemCount: privateToDoList.length,
              itemBuilder: (context, index) {
                importanceCheck(index);
                return SizedBox(
                  height: 135,
                  child: Card(
                    color:
                        (index % 2 == 0)
                            ? Color(0xFFA3E635)
                            : Color(0xFFE9D5FF),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.lock,
                            color: Color(0xFF334155),
                            size: 35,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('날짜: ${privateToDoList[index][2]}'),
                                Text(
                                  '시간: ${privateToDoList[index][3]} - ${privateToDoList[index][4]}',
                                ),
                                Text('장소: ${privateToDoList[index][5]}'),
                                Text('제목: ${privateToDoList[index][6]}'),
                                Text(
                                  '내용: ${getLimitedText(index, privateToDoList[index][7], 20)}',
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(Icons.edit),
                            ),
                            SizedBox(height: 50),
                            Row(
                              children: [
                                Icon(
                                  importanceIcon01,
                                  //FontAwesomeIcons.fire,
                                  color: importanceColor,
                                  size: 15,
                                ),
                                Icon(
                                  importanceIcon02,
                                  //FontAwesomeIcons.fire,
                                  color: importanceColor,
                                  size: 15,
                                ),
                                Icon(
                                  importanceIcon03,
                                  //FontAwesomeIcons.fire,
                                  color: importanceColor,
                                  size: 15,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  } // build

  // Card에서 내용이 너무 길 때 20자가 넘으면 줄임처리하는 함수
  String getLimitedText(int index, String content, int charater) {
    String content = '';
    (privateToDoList[index][7].toString().length > 20)
        ? content = privateToDoList[index][7].toString().substring(0, charater)
        : content = privateToDoList[index][7].toString();

    return '$content...';
  }

  importanceCheck(int index) {
  // 모든 아이콘을 먼저 null로 초기화
  importanceIcon01 = null;
  importanceIcon02 = null;
  importanceIcon03 = null;

  int importance = privateToDoList[index][8];

  if (importance == 1) {
    importanceIcon01 = FontAwesomeIcons.fire;
    importanceColor = Colors.white;
  } else if (importance == 2) {
    importanceIcon01 = FontAwesomeIcons.fire;
    importanceIcon02 = FontAwesomeIcons.fire;
    importanceColor = Colors.orange;
  } else if (importance == 3) {
    importanceIcon01 = FontAwesomeIcons.fire;
    importanceIcon02 = FontAwesomeIcons.fire;
    importanceIcon03 = FontAwesomeIcons.fire;
    importanceColor = Colors.red;
  }
}
} // Class
