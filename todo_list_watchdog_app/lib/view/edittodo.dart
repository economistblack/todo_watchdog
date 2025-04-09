import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/todolist.dart';
import '../model/users_info.dart';

class EditToDo extends StatefulWidget {
  const EditToDo({super.key});

  @override
  State<EditToDo> createState() => _EditToDoState();
}

class _EditToDoState extends State<EditToDo> {
  late int userIndex; // 메인 페이지에서 넘어온 userIndex
  late String emailTypeId; // 사용자 이메일 아이디
  late String passKey; // 사용자 비밀번호
  late String profileImage; // 사용자가 선택한 프로파일 이미지
  late String nickName; // 사용자가 선택한 닉네임
  late int listNo; // todo 리스트 고유 번호
  late int importance; // todo 리스트 중요도
  late bool isPrivate; // true가 기본 값이고 true 이면 프라이빗 todo 리스트임
  late List<int> friendsList; // 친구 리스트
  late DateTime dateTime; // 현재 날짜
  late String selectedDateText; // 선택된 날짜
  late String selectedStartTimeText; // 선택된 시작 시간
  late String selectedEndTimeText; // 선택된 끝나는 시간
  late TextEditingController locationController; // todo 리스트 장소 입력
  late TextEditingController todoTitleController; // todo 리스트 제목
  late TextEditingController contentToDoController; // todo 리스트 내용
  late int radioImportance; // 중요도 라디오 인덱스 낮음이 기본값
  late int radioIsPrivate; // 프라이빗 여부 라디오 인덱스 프라이빗이 기본값
  late String infoSnackBarText; // 등록 버튼을 누를 때 스낵바 메시지가 표시
  late TodoList currentTodo; // 프라이빗 페이지 Card에서 넘어온 todo 리스트

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    userIndex = arguments[0] ?? 0;
    currentTodo = Get.arguments[1] as TodoList;

    emailTypeId = '';
    passKey = '';
    profileImage = '';
    nickName = '';
    listNo = currentTodo.listNo;
    importance = currentTodo.importance;
    isPrivate = currentTodo.isPrivate;
    friendsList = currentTodo.friendsList;
    dateTime = DateTime.now();
    selectedDateText = currentTodo.date.toString();
    selectedStartTimeText = currentTodo.startTime.toString();
    selectedEndTimeText = currentTodo.endTime.toString();
    locationController = TextEditingController(text: currentTodo.location);
    todoTitleController = TextEditingController(text: currentTodo.todoTitle);
    contentToDoController = TextEditingController(
      text: currentTodo.contentToDo,
    );
    radioImportance = importance - 1;
    radioIsPrivate = isPrivate ? 0 : 1;
    infoSnackBarText = '';


    profileImage = UsersInfo.userDb[userIndex].userImage;
    nickName = UsersInfo.userDb[userIndex].userNickName;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.amber[100],
        body: SingleChildScrollView(
          child: Center(
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
                              '"일정을 수정하세요!"',
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
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  String? time = await disTimePicker(context);
                                  if (time != null) {
                                    selectedStartTimeText = time;
                                    setState(() {});
                                  }
                                },
                                child: Icon(Icons.access_time, size: 30),
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
                                  selectedEndTimeText = time;
                                  setState(() {});
                                }
                              },
                              child: Icon(Icons.access_time, size: 30),
                            ),
                            SizedBox(width: 10),
                            Text(selectedEndTimeText),
                          ],
                        ),
                        SizedBox(height: 30, child: Divider()),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 30,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: locationController,
                                maxLength: 20,
                                decoration: InputDecoration(
                                  labelText: '장소를 입력하세요. (최대 20자)',
                                  labelStyle: TextStyle(fontSize: 13),
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.draw,
                              color: Color(0xFF38BDF8),
                              size: 30,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: todoTitleController,
                                maxLength: 20,
                                decoration: InputDecoration(
                                  labelText: '제목을 입력하세요. (최대 20자)',
                                  labelStyle: TextStyle(fontSize: 13),
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.menu_book,
                              color: Color(0xFF38BDF8),
                              size: 30,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: contentToDoController,
                                maxLength: 45,
                                decoration: InputDecoration(
                                  labelText: '내용을 입력하세요. (최대 45자)',
                                  labelStyle: TextStyle(fontSize: 13),
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30, child: Divider()),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Icon(
                                Icons.priority_high,
                                color: Colors.red,
                                size: 25,
                              ),
                            ),
                            Text(
                              '우선순위 :',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Radio(
                              value: 0,
                              groupValue: radioImportance,
                              onChanged: (value) {
                                importanceValue(value);
                              },
                            ),
                            Text('낮음'),
                            Radio(
                              value: 1,
                              groupValue: radioImportance,
                              onChanged: (value) {
                                importanceValue(value);
                              },
                            ),
                            Text('보통'),
                            Radio(
                              value: 2,
                              groupValue: radioImportance,
                              onChanged: (value) {
                                importanceValue(value);
                              },
                            ),
                            Text('높음'),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Icon(
                                Icons.lock,
                                color: Color(0xFF334155),
                                size: 25,
                              ),
                            ),
                            Text(
                              '일정 노출 :',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Radio(
                              value: 0,
                              groupValue: radioIsPrivate,
                              onChanged: (value) {
                                isPrivateValue(value);
                              },
                            ),
                            Text('프라이빗'),
                            Radio(
                              value: 1,
                              groupValue: radioIsPrivate,
                              onChanged: (value) {
                                isPrivateValue(value);
                              },
                            ),
                            Text('퍼블릭'),
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
                                  shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Color(0xFF334155),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                label: Text(
                                  '취소',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.done, color: Colors.white),
                                style: ElevatedButton.styleFrom(
                                  shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Color(0xFF38BDF8),
                                ),
                                onPressed: () {
                                  editToDoList();
                                },
                                label: Text(
                                  '수정',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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

  // 시간을 선택하는 함수
  Future<String?> disTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 24, minute: 0),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF334155), // 선택된 색상
              onPrimary: Colors.white, // 선택된 텍스트 색
              surface: Color(0xFF38BDF8), // 배경색
              onSurface: Color(0xFF334155), // 일반 텍스트 색
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF334155), // 확인, 취소 버튼 색
              ),
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: Localizations.override(
              context: context,
              locale: const Locale('ko', 'KR'), // ✅ 한국어 설정
              child: child!,
            ),
          ),
        );
      },
    );
    if (picked != null) {
      final hour = picked.hour.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    return null; // 취소한 경우
  }

  // 중요도를 입력 함수
  importanceValue(int? value) {
    radioImportance = value!;
    importance = radioImportance + 1;

    setState(() {});
  }

  // 일정공개 타입 선택 함수
  isPrivateValue(int? value) {
    radioIsPrivate = value!;
    if (radioIsPrivate == 0) {
      isPrivate = true;
    } else {
      isPrivate = false;
    }
    setState(() {});
  }

  // todo 리스트 추가 버튼
  editToDoList() {
    int index = TodoList.listDb.indexWhere(
      (todo) => todo.listNo == currentTodo.listNo,
    );

    if (index != -1) {
      TodoList updatedTodo = TodoList(
        userNo: userIndex,
        listNo: listNo,
        date: selectedDateText,
        startTime: selectedStartTimeText,
        endTime: selectedEndTimeText,
        location: locationController.text,
        todoTitle: todoTitleController.text,
        contentToDo: contentToDoController.text,
        importance: importance,
        isPrivate: isPrivate,
        friendsList: friendsList,
      );

      TodoList.listDb[index] = updatedTodo;
    }
    Navigator.pop(context);
  }

  infoSnackBar() {
    Get.snackbar(
      '⚠️ 알림',
      infoSnackBarText,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      backgroundColor: Color(0xFFE9D5FF),
      colorText: Colors.black,
    );
  }
}

// Class
