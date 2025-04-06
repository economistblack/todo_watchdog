
import 'package:flutter/material.dart';

class TodoList {
  int userNo; // 사용자 고유 번호
  int listNo; // ToDo 리스트 고유 번호
  String? date; // 날짜
  String? startTime; // 시작 시간
  String? endTime; // 끝나는 시간
  String location; // 장소
  String todoTitle;
  String contentToDo; // 해야할 일
  int importance; // 중요도
  bool isPrivate; // 프라이빗 리스트 여부, 초기값은 true
  List<int> friendsList; // 친구의 사용자 고유 번호가 포함된
  late List<List<dynamic>> listDb; // todo 일정 리스트 
  

  TodoList({
    required this.userNo,
    required this.listNo,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.todoTitle,
    required this.contentToDo,
    required this.importance,
    required this.isPrivate,
    required this.friendsList
    
  }) {
    friendsList = [];
    listDb = [
      [userNo, listNo, date, startTime, endTime, location, todoTitle, contentToDo, 
      importance, isPrivate, friendsList]
    ];
    listDb = [
      [9, 1, '2025-04-16', '19:30', '21:30', '가락본동점 스타벅스', 'Economist Cover 모임', 
      '이 번주 The Economist 표지 기사 단락별 요약 및 단어 정리', 3, false, []],
      [9, 2, '2025-04-17', '10:00', '12:00', '홈', 'Economist Cover 준비', 
      '이 번주 The Economist 표지 기사 단락별 요약 및 단어 정리 공부', 2, true, []],
      [9, 3, '2025-04-18', '14:10', '16:20', '홈', 'Flutter 및 Python 정리', 
      '예제 복습 및 코드 반복 10번', 3, true, []],
      [9, 4, '2025-04-19', '10:00', '11:30', '문정동 스타벅스 2번 출구점', 'Economist Schumpeter 모임', 
      '이 번주 The Economist Schumpeter 기사 단락별 요약 및 단어 정리', 3, false, []],
      [9, 5, '2025-04-22', '19:30', '21:30', '가락본동점 스타벅스', 'Economist Cover 모임', 
      '이 번주 The Economist 표지 기사 단락별 요약 및 단어 정리', 3, false, []],
    ];
  } 
}
