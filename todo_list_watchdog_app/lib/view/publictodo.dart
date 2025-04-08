import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../model/todolist.dart';
import '../model/users_info.dart';

class PublicToDo extends StatefulWidget {
  const PublicToDo({super.key});

  @override
  State<PublicToDo> createState() => _PublicToDoState();
}

class _PublicToDoState extends State<PublicToDo> {
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
  List<int> friendsList = []; // 친구 리스트
  List<TodoList> todoDb = []; // todo 리스트 전체
  late bool switchValue; // false가 기본 값이고
  List<TodoList> publicToDoList = []; // 프라이빗 todo 리스트만 저장된 공간
  late String addMessage; // todo 리스트가 비어있을 때 todo 일정 추가 메시지
  late IconData? importanceIcon01; // 중요도 아이콘 01
  late IconData? importanceIcon02; // 중요도 아이콘 01
  late IconData? importanceIcon03; // 중요도 아이콘 01
  late Color importanceColor; // 중요도 아이콘 색
  late String earliestScheduleContent; // 상단에 가장 빠른 일정 내용
  late String profileImageCard;
  late String nickNameCard;

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
    publicToDoList = [];
    addMessage = '';
    importanceIcon01 = null;
    importanceIcon02 = null;
    importanceIcon03 = null;
    importanceColor = Colors.white;
    earliestScheduleContent = '';

    TodoList.initializeDummySchedule();

    UsersInfo usersInfo = UsersInfo(
      userNo: userIndex,
      emailTypeId: emailTypeId,
      passKey: passKey,
    );

    profileImage = usersInfo.userDb[userIndex][3];
    nickName = usersInfo.userDb[userIndex][4];
    todoDb = TodoList.listDb;

    // print('${todoDb[0][2]}');
    // print(todoDb);

    // 프라이빗 todo 리스트 만들기
    for (int i = 0; i < todoDb.length; i++) {
      if (todoDb[i].isPrivate == false) {
        publicToDoList.add(todoDb[i]);
        // print(publicToDoList);
        // print(publicToDoList.length);
      }
    }
    if (publicToDoList.isEmpty) {
      addMessage = '퍼블릭 일정이 없습니다.!';
    }

    earliestScheduleMessage();
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('images/schedule_logo.png', width: 70),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text('빠른 일정'),
                          ),
                        ],
                      ),
                      SizedBox(width: 7),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Text(
                              earliestScheduleContent,
                              style: TextStyle(
                                color: Color(0xFF334155),
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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
                  if (switchValue == false) {
                    // 최신일정순 정렬 (날짜 오름차순)
                    publicToDoList.sort(
                      (a, b) => DateTime.parse(
                        a.date!,
                      ).compareTo(DateTime.parse(b.date!)),
                    );
                  } else {
                    // 우선순위순 정렬 (중요도 높은 순)
                    publicToDoList.sort(
                      (a, b) => b.importance.compareTo(a.importance),
                    );
                  }
                  setState(() {});
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
              SizedBox(width: 40),
              ElevatedButton.icon(
                onPressed: () async {
                  await Get.toNamed('/addtodo', arguments: [userIndex]);
                  refreshpublicToDoList();
                },
                icon: Icon(Icons.person),
                style: ElevatedButton.styleFrom(
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Color(0xFFE9D5FF),
                  shadowColor: Colors.black54,
                ),
                label: Text(
                  '내 일정',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          if (addMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(30.0),
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
              itemCount: publicToDoList.length,
              itemBuilder: (context, index) {
                importanceCheck(index);
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  key: ValueKey(publicToDoList[index]),
                  onDismissed: (direction) {
                    TodoList deleted = publicToDoList[index];
                    TodoList.listDb.removeWhere(
                      (item) => item.listNo == deleted.listNo,
                    );
                    publicToDoList.remove(publicToDoList[index]);
                    refreshpublicToDoList();
                    setState(() {});
                  },
                  background: Container(
                    color: Colors.red[300],
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),

                    child: Icon(Icons.delete_forever, size: 70),
                  ),
                  child: SizedBox(
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
                              Icons.public,
                              color: Color(0xFF38BDF8),
                              size: 40,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 250,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '날짜: ${publicToDoList[index].date ?? ''}',
                                  ),
                                  Text(
                                    '시간: ${publicToDoList[index].startTime ?? ''} - ${publicToDoList[index].endTime ?? ''}',
                                  ),
                                  Text('장소: ${publicToDoList[index].location}'),
                                  Text(
                                    '제목: ${publicToDoList[index].todoTitle}',
                                  ),
                                  Text(
                                    '내용: ${getLimitedText(publicToDoList[index].contentToDo, 20)}',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 15, 10, 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xFF334155),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Color(0xFFF9FAFB),
                                    child: ClipOval(
                                      child: Image.asset(
                                        profileImage,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  nickName,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold
                                  ),
                                  ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
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
                              ),
                            ],
                          ),
                        ],
                      ),
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
  String getLimitedText(String? content, int charater) {
    if (content == null || content.isEmpty) return '';
    if (content.length > charater) {
      return '${content.substring(0, charater)}...';
    }
    return '$content ...';
  }

  // 아이콘 중요도 삽입 및 색 변경
  importanceCheck(int index) {
    // 모든 아이콘을 먼저 null로 초기화
    importanceIcon01 = null;
    importanceIcon02 = null;
    importanceIcon03 = null;

    int importance = publicToDoList[index].importance;

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

  // 상단에 보여주는 가장 빠른 일정을 알리는 메시지
  earliestScheduleMessage() {
    if (publicToDoList.isEmpty) {
      earliestScheduleContent = '퍼블릭 일정이 없음.';
      return;
    }
    DateTime date;
    DateTime? earliestDate;
    int? earliestIndex;

    for (int i = 0; i < publicToDoList.length; i++) {
      date = DateTime.parse(publicToDoList[i].date.toString());

      if (earliestDate == null || date.isBefore(earliestDate)) {
        earliestDate = date;
        earliestIndex = i;
      }
      if (earliestIndex != null) {
        earliestScheduleContent =
            ' 날짜 : ${publicToDoList[earliestIndex].date}\n 시간 : ${publicToDoList[earliestIndex].startTime}\n 확인하세요!';
      }
    }
  }

  refreshpublicToDoList() {
    todoDb = TodoList.listDb;
    publicToDoList =
        todoDb
            .where((todoDb) => todoDb.isPrivate && todoDb.userNo == userIndex)
            .toList();

    publicToDoList.sort(
      (a, b) => DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!)),
    );

    if (publicToDoList.isEmpty) {
      addMessage = '퍼블릭 일정이 없습니다!';
    } else {
      addMessage = '';
    }

    earliestScheduleMessage();
    setState(() {});
  }
} // Class
