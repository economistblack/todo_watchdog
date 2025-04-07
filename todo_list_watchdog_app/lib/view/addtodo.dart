import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_watchdog_app/model/todolist.dart';
import 'package:todo_list_watchdog_app/model/users_info.dart';

class AddToDo extends StatefulWidget {
  const AddToDo({super.key});

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  int userIndex = Get.arguments[0] ?? 0; // 메인 페이지에서 넘어온 userIndex
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
  late DateTime dateTime; // 현재 날짜
  late String selectedDateText; // 선택된 날짜
  late String selectedStartTimeText; // 선택된 시작 시간
  late String selectedEndTimeText; // 선택된 끝나는 시간
  late TextEditingController locationController; // todo 리스트 장소 입력
  late TextEditingController todoTitleController; // todo 리스트 제목
  late TextEditingController contentToDoController;

  @override
  void initState() {
    super.initState();
    emailTypeId = '';
    passKey = '';
    profileImage = '';
    nickName = '';
    listNo = DateTime.now().microsecondsSinceEpoch;
    location = '';
    todoTitle = '';
    contentToDo = '';
    importance = 0;
    isPrivate = true;
    friendsList = [];
    dateTime = DateTime.now();
    selectedDateText = '아이콘 클릭 후 날짜를 선택하세요.';
    selectedStartTimeText = '아이콘 클릭 후 시작 시간을 선택하세요.\n(24시간 형식)';
    selectedEndTimeText = '아이콘 클릭 후 끝나는 시간을 선택하세요.\n(24시간 형식)';
    locationController = TextEditingController();
    todoTitleController = TextEditingController();
    contentToDoController = TextEditingController();

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                            child: Image.asset(
                              profileImage,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(nickName),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.campaign,
                          color: Color(0xFF38BDF8),
                          size: 40,
                        ),
                        SizedBox(width: 20),
                        Text(
                          '"일정을 추가하세요!"',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF38BDF8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Divider(color: Color(0xFFA3E635)),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            disDatePicker();
                          },
                          child: Image.asset(
                            'images/datepicker.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text('날짜 : $selectedDateText'),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              String? time = await disTimePicker(context);
                              if (time != null) {
                                selectedStartTimeText = '시작 시간 : $time';
                                setState(() {});
                              }
                            },
                            child: Icon(
                              Icons.access_time,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(selectedStartTimeText),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            String? time = await disTimePicker(context);
                            if (time != null) {
                              selectedEndTimeText = '끝나는 시간 : $time';
                              setState(() {});
                            }
                          },
                          child: Icon(
                            Icons.access_time,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(selectedEndTimeText),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                      child: Divider(

                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            String? time = await disTimePicker(context);
                            if (time != null) {
                              selectedEndTimeText = '끝나는 시간 : $time';
                              setState(() {});
                            }
                          },
                          child: Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: locationController,
                            maxLength: 20,
                            decoration: InputDecoration(
                              labelText: '장소를 입력하세요. (최대 20자)',
                              labelStyle: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            keyboardType:  TextInputType.text,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            String? time = await disTimePicker(context);
                            if (time != null) {
                              selectedEndTimeText = '끝나는 시간 : $time';
                              setState(() {});
                            }
                          },
                          child: Icon(
                            Icons.draw,
                            color: Color(0xFF38BDF8),
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: todoTitleController,
                            maxLength: 20,
                            decoration: InputDecoration(
                              labelText: '제목을 입력하세요. (최대 20자)',
                              labelStyle: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            keyboardType:  TextInputType.text,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            String? time = await disTimePicker(context);
                            if (time != null) {
                              selectedEndTimeText = '끝나는 시간 : $time';
                              setState(() {});
                            }
                          },
                          child: Icon(
                            Icons.menu_book,
                            color: Color(0xFF38BDF8),
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: contentToDoController,
                            maxLength: 30,
                            decoration: InputDecoration(
                              labelText: '내용을 입력하세요. (최대 30자)',
                              labelStyle: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            keyboardType:  TextInputType.text,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                      child: Divider(
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  } // build

  // --- functions ---

  // 날짜를 선택하는 함수
  disDatePicker() async {
    int firstYear = dateTime.year - 1;
    int lastYear = firstYear + 2;
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(firstYear),
      lastDate: DateTime(lastYear),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      locale: Locale('ko', 'KR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              surface: Color(0xFF38BDF8),
              primary: Color(0xFFE9D5FF),
              onSurface: Color(0xFF334155),
            ),
          ),
          child: child!,
        );
      },
    );
    if (selectedDate != null) {
      selectedDateText = selectedDate.toString().substring(0, 10);
      setState(() {});
    }
  }

  Future<String?> disTimePicker(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: 12, minute: 0),
    initialEntryMode: TimePickerEntryMode.input,
                
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), 
        child: child!,
      );
    },
  );

  if (picked != null) {
    final hour = picked.hour.toString().padLeft(2, '0');
    final minute = picked.minute.toString().padLeft(2, '0');
    return '$hour:$minute'; // 결과 예: "13:05"
  }

  return null; // 취소한 경우
}


} // Class
