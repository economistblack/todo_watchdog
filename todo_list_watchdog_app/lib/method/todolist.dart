class Todolist {
  int listNo; // ToDo 리스트 고유 번호
  int userNo; // 사용자 고유 번호
  DateTime date; // 날짜
  String startTime; // 시작 시간
  late String endTime; // 끝나는 시간
  String location; // 장소
  String contentToDo; // 해야할 일
  int importance; // 중요도
  bool isPrivate; // 프라이빗 리스트 여부, 초기값은 true
  late List<int> friendsList;

  Todolist({
    required this.listNo,
    required this.userNo,
    required this.date,
    required this.startTime,
    this.endTime = '',
    required this.location,
    required this.contentToDo,
    required this.importance,
    required this.isPrivate,
  }) {
    friendsList = [];
  }
}
