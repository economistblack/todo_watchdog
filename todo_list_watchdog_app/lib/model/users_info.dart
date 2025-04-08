class UsersInfo {
  final int userNo;
  final String emailTypeId;
  String passKey;
  late String userImage;
  late String userNickName;
  late List<List<dynamic>> userDb;

  UsersInfo({
    required this.userNo,
    required this.emailTypeId,
    required this.passKey,
    this.userImage = '',
    this.userNickName = '',
  }) {
    userDb = [
      [userNo, emailTypeId, passKey, userImage, userNickName],
    ];
    
    userDb = [
      [0, 'default@gmail.com', 'default', 'images/user01.png', 'human'],
      [1, 'washington@gmail.com', '1234567', 'images/user01.png', 'George'],
      [2, 'lincoin@gmail.com', '1234567', 'images/user02.png', 'Abraham'],
      [3, 'roosevelt@gmail.com', '1234567', 'images/user03.png', 'Theodore'],
      [4, 'truman@gmail.com', '1234567', 'images/user04.png', 'Harry S'],
      [5, 'eisenhower@gmail.com', '1234567', 'images/user05.png', 'Dwight'],
      [6, 'kennedy@gmail.com', '1234567', 'images/user06.png', 'John F'],
      [7, 'nixon@gmail.com', '1234567', 'images/user07.png', 'Richard'],
      [8, 'reagan@gmail.com', '1234567', 'images/user08.png', 'Ronald'],
      [9, 'bush@gmail.com', '1234567', 'images/user09.png', 'George W'],
      [10, 'obama@gmail.com', '1234567', 'images/user10.png', 'Barack'],
    ];
  }
}
