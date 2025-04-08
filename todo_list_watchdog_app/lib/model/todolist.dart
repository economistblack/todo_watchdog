class TodoList {
  final int userNo; // 사용자 고유 번호
  final int listNo; // ToDo 리스트 고유 번호
  String? date; // 날짜
  String? startTime; // 시작 시간
  String? endTime; // 끝나는 시간
  String location; // 장소
  String todoTitle; // 해야할 일 제목
  String contentToDo; // 해야할 일
  int importance; // 중요도
  bool isPrivate; // 프라이빗 리스트 여부, 초기값은 true
  List<int> friendsList; // 친구의 사용자 고유 번호가 포함된
  static List<TodoList> listDb = []; // todo 일정 리스트
  static bool isInitialized = false; // 한 번만 초기화 하는 인덱스


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
    required this.friendsList,
  }); 

  static initializeDummySchedule(){
    if (isInitialized) return;
    listDb = [
      TodoList(
        userNo: 9, 
        listNo: 1, 
        date: '2025-04-16', 
        startTime: '19:30', 
        endTime: '21:30', 
        location: '가락본동점 스타벅스', 
        todoTitle: 'Economist Cover 모임', 
        contentToDo: '이 번주 The Economist 표지 기사 단락별 요약 및 단어 정리', 
        importance: 3, 
        isPrivate: false, 
        friendsList: []),
      TodoList(
        userNo: 9, 
        listNo: 2, 
        date:  '2025-04-17', 
        startTime: '10:00', 
        endTime: '12:00', 
        location: '홈', 
        todoTitle: 'Economist Cover 모임', 
        contentToDo: '이 번주 The Economist 표지 기사 단락별 요약 및 단어 정리 공부', 
        importance: 2, 
        isPrivate: true, 
        friendsList: []),
      TodoList(
        userNo: 9, 
        listNo: 3, 
        date: '2025-04-18', 
        startTime: '14:10', 
        endTime: '16:20', 
        location: '홈', 
        todoTitle: 'Flutter 및 Python 정리', 
        contentToDo: '이 번주 The Economist 표지 기사 단락별 요약 및 단어 정리', 
        importance: 3, 
        isPrivate: true, 
        friendsList: []),
      TodoList(
        userNo: 9, 
        listNo: 4, 
        date: '2025-04-19', 
        startTime: '10:00', 
        endTime: '11:30', 
        location: '문정동 스타벅스 2번 출구점', 
        todoTitle: 'Economist Shumpeter 모임', 
        contentToDo: '이 번주 The Economist Schumpeter 기사 단락별 요약 및 단어 정리', 
        importance: 3, 
        isPrivate: false, 
        friendsList: []),
    ];
    isInitialized = true;
  }
}

