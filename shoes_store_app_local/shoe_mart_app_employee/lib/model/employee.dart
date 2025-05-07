class Employee {
  final String employeeNo; // 사번 : yyyyMM + seqno(2)
  final String pw; // 비밀번호
  final String name; // 성명
  final String employeeDate; // 발령일자 (yyyy-MM-dd)
  final int position; // 직책 (0:사원, 1:대리, 2:과장, 3:부장, 4:이사, 5:상무, 6:대표이사)
  final int authority; // 권한 (0:기안작성권한, 1:중간결제권한, 2:최종결제권한)
  final String storeCode; // 근무처

  Employee({
    required this.employeeNo,
    required this.pw,
    required this.name,
    required this.employeeDate,
    required this.position,
    required this.authority,
    required this.storeCode,
  });

  Employee.fromMap(Map<String, dynamic> res)
    : employeeNo = res['employeeNo'],
      pw = res['pw'],
      name = res['name'],
      employeeDate = res['employeeDate'],
      position = res['position'],
      authority = res['authority'],
      storeCode = res['storeCode'];
}
