class UsersInfo {
  int userNo;
  String emailTypeId;
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
  }
}
