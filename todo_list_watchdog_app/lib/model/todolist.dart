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
        userNo: 8, 
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
        userNo: 7, 
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
      TodoList(
        userNo: 1, 
        listNo: 5, 
        date: '2025-04-30', 
        startTime: '10:00', 
        endTime: '12:30', 
        location: '집에서..', 
        todoTitle: '이더리움 추매하기', 
        contentToDo: '300만원 이하에서 무지성 추매', 
        importance: 3, 
        isPrivate: false, 
        friendsList: []),
      TodoList(
        userNo: 2, 
        listNo: 6, 
        date: '2025-05-05', 
        startTime: '10:00', 
        endTime: '18:30', 
        location: '롯데월드 잠실', 
        todoTitle: '어린이날 롯데월드 방문', 
        contentToDo: '회전목마 타기', 
        importance: 1, 
        isPrivate: false, 
        friendsList: []),
      TodoList(
        userNo: 3, 
        listNo: 7, 
        date: '2025-05-07', 
        startTime: '09:00', 
        endTime: '10:00', 
        location: '석촌호수 서호 수변무대', 
        todoTitle: 'Just Run', 
        contentToDo: '10km 러닝 후 게시판 인증하기', 
        importance: 2, 
        isPrivate: false, 
        friendsList: []),
      TodoList(
        userNo: 4, 
        listNo: 8, 
        date: '2025-05-10', 
        startTime: '13:00', 
        endTime: '17:00', 
        location: '더존컴퓨터학원', 
        todoTitle: 'Flutter 코딩', 
        contentToDo: 'Flutter로 To-Do List 프로젝트 고도화하기', 
        importance: 3, 
        isPrivate: false, 
        friendsList: []),
      TodoList(
        userNo: 5, 
        listNo: 9, 
        date: '2025-04-13', 
        startTime: '18:50', 
        endTime: '20:40', 
        location: '두툼횟집 강남역', 
        todoTitle: '위스키 및 와인 시음', 
        contentToDo: '펜폴즈 헨리 시라즈 및 발렌타인 준비', 
        importance: 2, 
        isPrivate: false, 
        friendsList: []),
      TodoList(
        userNo: 6, 
        listNo: 10, 
        date: '2025-05-02', 
        startTime: '09:00', 
        endTime: '11:30', 
        location: '재즈바 주옥 강변', 
        todoTitle: '라이브 재즈 관람', 
        contentToDo: '콜키지 비용 및 와인 준비', 
        importance: 2, 
        isPrivate: false, 
        friendsList: []),
      TodoList(
        userNo: 7, 
        listNo: 11, 
        date: '2025-05-03', 
        startTime: '09:00', 
        endTime: '10:00', 
        location: '비공개', 
        todoTitle: '비공개 러닝', 
        contentToDo: '15km 러닝 후 게시판에 인증', 
        importance: 3, 
        isPrivate: false, 
        friendsList: []),
      TodoList(
        userNo: 9, 
        listNo: 12, 
        date: '2025-04-13', 
        startTime: '09:00', 
        endTime: '11:00', 
        location: '스타벅스 문정역 2번 출구', 
        todoTitle: 'Shumpeter 모임', 
        contentToDo: 'Shumpeter 원격 회의 및 오프라인 모임', 
        importance: 3, 
        isPrivate: false, 
        friendsList: []),
      TodoList(
        userNo: 9, 
        listNo: 13, 
        date: '2025-04-20', 
        startTime: '09:00', 
        endTime: '9:45', 
        location: '스타벅스 문정역 2번 출구', 
        todoTitle: 'Bartleby 모임', 
        contentToDo: 'Bartleby 원격 회의 및 오프라인 모임', 
        importance: 1, 
        isPrivate: false, 
        friendsList: []),
        TodoList(
        userNo: 1, 
        listNo: 14, 
        date: '2025-05-30', 
        startTime: '10:00', 
        endTime: '12:30', 
        location: '비공개', 
        todoTitle: '블록체인 코딩', 
        contentToDo: '스텔라 네트워크로 국가간 송금하기', 
        importance: 2, 
        isPrivate: false, 
        friendsList: []),
    ];
    isInitialized = true;
  }
}

