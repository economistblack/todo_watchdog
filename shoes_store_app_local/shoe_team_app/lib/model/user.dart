class User {
  final String userid; // 이메일 정규식 사용 
  final String pw;
  final String name;
  final String phone; // 010 - xxxx - xxxx 정규식 사용
  final String adminDate;
  final String address;

  User({
    required this.userid,
    required this.pw,
    required this.name,
    required this.phone,
    required this.adminDate,
    required this.address
  });

  User.fromMap(Map<String,dynamic> res)
  : userid = res['userid'],
    pw = res['pw'],
    name = res['name'],
    phone = res['phone'],
    adminDate = res['adminDate'],
    address = res['address'];
}