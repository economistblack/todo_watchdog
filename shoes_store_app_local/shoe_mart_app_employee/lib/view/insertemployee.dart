import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_mart_app_employee/view/employeecheck.dart';
import 'package:shoe_mart_app_employee/vm/database_handler.dart';

import '../model/employee.dart';

class InsertEmployee extends StatefulWidget {
  const InsertEmployee({super.key});

  @override
  State<InsertEmployee> createState() => _InsertEmployeeState();
}

class _InsertEmployeeState extends State<InsertEmployee> {
  // employeeNo text primary key, pw text, employeeDate date, position text, authority text, storeCode text
  final _formKey = GlobalKey<FormState>();
  final DatabaseHandler handler = DatabaseHandler();

  TextEditingController employeeNoController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController authorityController = TextEditingController();
  TextEditingController storeCodeController = TextEditingController();
  TextEditingController passWordCheckController = TextEditingController();

  final _employeeNoRegex = RegExp(r'^(19|20)\d{2}(0[1-9]|1[0-2])\d{2}$');
  final _passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$',
  );
  final _dateRegex = RegExp(
    r'^(19|20)\d{2}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$',
  );
  final _positionRegex = RegExp(r'^[1-6]$');
  final _authorityRegex = RegExp(r'^[0-2]$');

  final List<String> districtList = [
    '강남구',
    '강동구',
    '강서구',
    '관악구',
    '광진구',
    '구로구',
    '금천구',
    '노원구',
    '도봉구',
    '동대문구',
    '동작구',
    '마포구',
    '서대문구',
    '서초구',
    '성동구',
    '성북구',
    '송파구',
    '양천구',
    '영등포구',
    '용산구',
    '은평구',
    '종로구',
    '중구',
    '중랑구',
    '강북구',
    '본사',
  ];

  String? selectedDistrict;
  String? storeCode;

  @override
  void initState() {
    super.initState();
    handler.insertInitialStores();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Row(
            children: [
              Icon(Icons.person_add, size: 30, color: Colors.white),
              SizedBox(width: 15),
              Text(
                '직원 등록: 신중하세요!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          toolbarHeight: 100,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                onPressed: () {
                  Get.to(EmployeeCheck());
                }, 
                icon: Icon(Icons.group, size: 30)),
            )
          ],
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: employeeNoController,
                        maxLength: 8,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '직원 번호를 입력하세요.(필수)',
                          hintText: '사번 : yyyyMM + seqno(2)',
                          prefixIcon: Icon(
                            Icons.numbers_outlined,
                            color: Colors.brown[500],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '값을 입력해 주세요.';
                          } else if (!_employeeNoRegex.hasMatch(value)) {
                            return '유효한 직원번호 형식이 아닙니다.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Divider(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: passWordController,
                        maxLength: 50,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "비밀번호를 입력하세요.(필수)",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.brown[500],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력해 주십시오';
                          } else if (!_passwordRegex.hasMatch(value)) {
                            return '비밀번호는 대문자, 소문자, 숫자, 특수문자 포함 8자 이상이어야 합니다';
                          }
                          return null;
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: passWordCheckController,
                        maxLength: 50,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "비밀번호를 확인하세요.(필수)",
                          filled: true,
                          fillColor: Colors.amber[50],
                          prefixIcon: Icon(
                            Icons.check_circle_outline_rounded,
                            color: Colors.brown[500],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력해 주십시오';
                          } else if (value != passWordController.text) {
                            return '비밀번호가 일치하지 않습니다.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: nameController,
                        maxLength: 10,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "이름을 입력하세요.(필수)",
                          prefixIcon: Icon(
                            Icons.badge,
                            color: Colors.brown[500],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이름을 입력해 주십시오';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: dateController,
                        maxLength: 10,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: '입사 날짜를 입력하세요.(필수)',
                          hintText: 'yyyy-MM-dd',
                          prefixIcon: Icon(
                            Icons.calendar_month,
                            color: Colors.brown[500],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '값을 입력해 주세요.';
                          } else if (!_dateRegex.hasMatch(value)) {
                            return '유효한 날짜 형식이 아닙니다.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: positionController,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '직책을 입력하세요.(필수)',
                          hintText:
                              '(0:사원, 1:대리, 2:과장, 3:부장, 4:이사, 5:상무, 6:대표이사)',
                          prefixIcon: Icon(
                            Icons.numbers_outlined,
                            color: Colors.brown[500],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '값을 입력해 주세요.';
                          } else if (!_positionRegex.hasMatch(value)) {
                            return '유효한 구분자가 아닙니다.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: authorityController,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '권한을 입력하세요.(필수)',
                          hintText: '(0:기안작성권한, 1:중간결제권한, 2:최종결제권한)',
                          prefixIcon: Icon(
                            Icons.numbers_outlined,
                            color: Colors.brown[500],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '값을 입력해 주세요.';
                          } else if (!_authorityRegex.hasMatch(value)) {
                            return '유효한 구분자가 아닙니다.';
                          }
                          return null;
                        },
                      ),
                    ),
                    DropdownButton<String>(
                      hint: const Text("자치구를 선택하세요."),
                      dropdownColor: Colors.brown[50],
                      isExpanded: false,
                      value: selectedDistrict,
                      items:
                          districtList.map((String name) {
                            return DropdownMenuItem<String>(
                              value: name,
                              child: Text(name),
                            );
                          }).toList(),
                      onChanged: (value) async {
                        final String? code = await handler.queryStoreCodeChoice(
                          value!,
                        );
                        setState(() {
                          selectedDistrict = value;
                          storeCode = code;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    if (storeCode != null)
                      Text(
                        "선택된 스토어코드: $storeCode",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.cancel, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(120, 40),
                              backgroundColor: Colors.brown,
                              foregroundColor: Colors.white,
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Get.back();
                            },
                            label: Text('취소'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.check_circle, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(120, 40),
                              backgroundColor: Colors.brown,
                              foregroundColor: Colors.white,
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              if (employeeNoController.text.isEmpty ||
                                  storeCode!.isEmpty ||
                                  passWordCheckController.text.isEmpty ||
                                  authorityController.text.isEmpty ||
                                  dateController.text.isEmpty ||
                                  nameController.text.isEmpty ||
                                  positionController.text.isEmpty) {
                                errorSnackBar('필수 값을 입력하세요.');
                                return;
                              }
                              _showDialog('직원 등록을 진행하시겠습니까?');
                            },
                            label: Text('직원등록'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } // build
  errorSnackBar(String message) {
    Get.snackbar(
      '경고',
      message,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
      colorText: Colors.white,
      backgroundColor: Colors.red,
    );
  }
  _showDialog(String message) {
    Get.defaultDialog(
      title: '성공',
      middleText: message,
      backgroundColor: Colors.blue,
      barrierDismissible: false,
      actions: [
        TextButton.icon(
          icon: Icon(Icons.check),
          onPressed: () async {
            Employee employee = Employee(
              employeeNo: employeeNoController.text, 
              pw: passWordCheckController.text, 
              name: nameController.text,
              employeeDate: dateController.text, 
              position: int.parse(positionController.text), 
              authority: int.parse(authorityController.text), 
              storeCode: storeCode!);

            await handler.insertEmployee(employee);


            Get.back(); // 다이얼로그 지움
            Get.back(); // 뒤로 가기
          },
          label: Text('확인'),
        ),
      ],
    );
  }


} // class
