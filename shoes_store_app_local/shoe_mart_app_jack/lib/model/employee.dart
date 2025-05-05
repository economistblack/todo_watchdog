class Employee {
  final String employeeNo;
  final String pw;
  final String employeeDate;
  final String position;
  final String authority;
  final String storeCode;


  Employee({
    required this.employeeNo,
    required this.pw,
    required this.employeeDate,
    required this.position,
    required this.authority,
    required this.storeCode
  });

  Employee.fromMap(Map<String,dynamic> res)            
  : employeeNo = res['employeeNo'],
    pw = res['pw'],
    employeeDate = res['employeeDate'],
    position = res['position'],
    authority = res['authority'],
    storeCode = res['storeCode'];
  }