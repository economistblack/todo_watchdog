class UsersInfo {
  String emailTypeId;
  String passKey;
  late String userImage;
  late String userNickName;
  late List<List<String>> userDb;

  UsersInfo({
    required this.emailTypeId,
    required this.passKey,
    this.userImage = '',
    this.userNickName = '',
  }) {
    userDb = [
      [emailTypeId, passKey,userImage,userNickName]
    ];
  }

  




}
