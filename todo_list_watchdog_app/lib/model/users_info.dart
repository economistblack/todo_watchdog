class UsersInfo {
  // 개별 사용자 정보
  final int userNo;
  final String emailTypeId;
  String passKey;
  String userImage;
  String userNickName;
  List<int> friendsGroup; // 친구 그룹, 기본적으로 비어있는 리스트

  // 생성자: 새로운 사용자를 만들 때 사용
  UsersInfo({
    required this.userNo,
    required this.emailTypeId,
    required this.passKey,
    this.userImage = '',
    this.userNickName = '',
    List<int>? friendsGroup,
  }) : friendsGroup = friendsGroup ?? [];

  // 내부적으로 userDb를 구성할 때 사용하는 private 생성자
  UsersInfo._internal(
    this.userNo,
    this.emailTypeId,
    this.passKey,
    this.userImage,
    this.userNickName,
    this.friendsGroup,
  );

  // 전체 사용자 데이터베이스를 정적 변수로 관리하여 앱 전역에서 공유
  static List<UsersInfo> userDb = [
    UsersInfo._internal(0, 'default@gmail.com', 'default', 'images/user01.png', 'human', []),
    UsersInfo._internal(1, 'washington@gmail.com', '1234567', 'images/user01.png', 'George', [9, 10]),
    UsersInfo._internal(2, 'lincoin@gmail.com', '1234567', 'images/user02.png', 'Abraham', []),
    UsersInfo._internal(3, 'roosevelt@gmail.com', '1234567', 'images/user03.png', 'Theodore', []),
    UsersInfo._internal(4, 'truman@gmail.com', '1234567', 'images/user04.png', 'Harry S', []),
    UsersInfo._internal(5, 'eisenhower@gmail.com', '1234567', 'images/user05.png', 'Dwight', []),
    UsersInfo._internal(6, 'kennedy@gmail.com', '1234567', 'images/user06.png', 'John F', []),
    UsersInfo._internal(7, 'nixon@gmail.com', '1234567', 'images/user07.png', 'Richard', []),
    UsersInfo._internal(8, 'reagan@gmail.com', '1234567', 'images/user08.png', 'Ronald', []),
    UsersInfo._internal(9, 'bush@gmail.com', '1234567', 'images/user09.png', 'George W', [1, 2]),
    UsersInfo._internal(10, 'obama@gmail.com', '1234567', 'images/user10.png', 'Barack', []),
  ];

  // 프로필 이미지 변경 메서드
  void updateProfileImage(String newImage) {
    userImage = newImage;
  }

  // 닉네임 변경 메서드
  void updateNickName(String newNickName) {
    userNickName = newNickName;
  }

  // 필요시 비밀번호 변경 등 다른 기능 추가 가능
}