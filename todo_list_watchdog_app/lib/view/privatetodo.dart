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
  List<int> friendsList = []; // 친구 리스트
  List<TodoList> todoDb = []; // todo 리스트 전체
  late bool switchValue; // false가 기본 값이고
  List<TodoList> privateToDoList = []; // 프라이빗 todo 리스트만 저장된 공간
  late String addMessage; // todo 리스트가 비어있을 때 todo 일정 추가 메시지
  late IconData? importanceIcon01; // 중요도 아이콘 01
  late IconData? importanceIcon02; // 중요도 아이콘 01
  late IconData? importanceIcon03; // 중요도 아이콘 01
  late Color importanceColor; // 중요도 아이콘 색
  late String earliestScheduleContent; // 상단에 가장 빠른 일정 내용
  


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
      if (todoDb[i].isPrivate == true && todoDb[i].userNo == userIndex) {
        privateToDoList.add(todoDb[i]);
        // print(privateToDoList);
        // print(privateToDoList.length);
      }
    }
    if (privateToDoList.isEmpty) {
      addMessage = '일정을 추가하세요!';
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
                          Image.asset(
                            'images/schedule_logo.png',
                            width: 70,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text('빠른 일정'),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Text(
                              earliestScheduleContent, 
                              style: TextStyle(
                                color: Color(0xFF334155),
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold
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
                  privateToDoList.sort((a, b) =>
                  DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!)));
                  } else {
                  // 우선순위순 정렬 (중요도 높은 순)
                  privateToDoList.sort((a, b) => b.importance.compareTo(a.importance));
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
              SizedBox(
                width: 40,
              ),
              ElevatedButton.icon (
                onPressed: () async {
                  await Get.toNamed('/addtodo',
                  arguments: [userIndex]);
                  refreshPrivateToDoList();
                }, 
                icon: Icon(Icons.add),
                style: ElevatedButton.styleFrom(
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                backgroundColor: Color(0xFFE9D5FF),
                shadowColor: Colors.black54,
                ),
                label: Text(
                  '일정 추가',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
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
              itemCount: privateToDoList.length,
              itemBuilder: (context, index) {
                importanceCheck(index);
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  key: ValueKey(privateToDoList[index]),
                  onDismissed: (direction) {
                    TodoList deleted = privateToDoList[index];
                    TodoList.listDb.removeWhere((item) => item.listNo == deleted.listNo);
                    privateToDoList.remove(privateToDoList[index]);
                    refreshPrivateToDoList();
                    setState(() {});
                  },
                  background: Container(
                    color: Colors.red[300],
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                  
                    child: Icon(
                      Icons.delete_forever,
                      size: 70,
                    ),
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
                              Icons.lock,
                              color: Color(0xFF334155),
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
                                  Text('날짜: ${privateToDoList[index].date ?? ''}'),
                                  Text(
                                    '시간: ${privateToDoList[index].startTime ?? ''} - ${privateToDoList[index].endTime ?? ''}',
                                  ),
                                  Text('장소: ${privateToDoList[index].location}'),
                                  Text('제목: ${privateToDoList[index].todoTitle}'),
                                  Text(
                                    '내용: ${getLimitedText(index, privateToDoList[index].contentToDo, 20)}',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(Icons.edit_note,
                                size: 25,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_left,
                                      color: Colors.white,
                                    ),
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ],
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
  String getLimitedText(int index, String content, int charater) {
    String content = '';
    (privateToDoList[index].contentToDo.toString().length > 20)
        ? content = privateToDoList[index].contentToDo.toString().substring(0, charater)
        : content = privateToDoList[index].contentToDo.toString();

    return '$content...';
  }

  // 아이콘 중요도 삽입 및 색 변경
  importanceCheck(int index) {
  // 모든 아이콘을 먼저 null로 초기화
  importanceIcon01 = null;
  importanceIcon02 = null;
  importanceIcon03 = null;

  int importance = privateToDoList[index].importance;

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
  earliestScheduleMessage(){
    if (privateToDoList.isEmpty) {
      earliestScheduleContent = '일정 추가 필요함.';
      return;
    }
    DateTime date;
    DateTime? earliestDate;
    int? earliestIndex;

    for (int i =0 ; i < privateToDoList.length; i++){
      date = DateTime.parse(privateToDoList[i].date.toString());
      
      if (earliestDate == null || date.isBefore(earliestDate)){
        earliestDate = date;
        earliestIndex = i;
      }
      if (earliestIndex != null){
        earliestScheduleContent = ' 날짜 : ${privateToDoList[earliestIndex].date}\n 시간 : ${privateToDoList[earliestIndex].startTime}\n 확인하세요!';
      } 
    }
  }


  refreshPrivateToDoList(){
    todoDb = TodoList.listDb;
    privateToDoList = todoDb
    .where((todoDb) => todoDb.isPrivate && todoDb.userNo == userIndex).toList();

    privateToDoList.sort((a, b) =>
                  DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!)));

    if (privateToDoList.isEmpty){
      addMessage = '일정을 추가하세요!';
    } else {
      addMessage = '';
    }
    
    earliestScheduleMessage();
    setState(() {});
  }
} // Class
