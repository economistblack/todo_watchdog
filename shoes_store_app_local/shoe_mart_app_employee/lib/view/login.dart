import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_mart_app_employee/model/employee.dart';
import 'package:shoe_mart_app_employee/view/insertemployee.dart';
import 'package:shoe_mart_app_employee/vm/database_handler.dart';
import 'package:get_storage/get_storage.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Property
  DatabaseHandler handler = DatabaseHandler();
  final _formKey = GlobalKey<FormState>();
  final box = GetStorage();
  late List<Employee> employeeList;

  late TextEditingController employeeNoController; // 직원 아이디
  late TextEditingController passWordController; // 직원 비밀번호
  
  final RegExp _passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$'); // 비밀번호 정규식



  @override
  void initState() {
    super.initState();
    employeeNoController = TextEditingController();
    passWordController = TextEditingController();
    employeeList = [];
    handler.queryEmployeeLogin(employeeNoController.text);
    
    initStorage();
  }

  initStorage(){
    box.write('p_employeeId', "");
  }

  @override
  void dispose() {
    disposeStorage();
    super.dispose();
  }

  disposeStorage(){
    box.erase();
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
          backgroundColor: Colors.white,
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 300,
                    child: TextFormField(
                      controller: employeeNoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '직원 번호를 입력하세요.',
                        prefixIcon: Icon(
                          Icons.numbers_outlined,
                          color: Colors.brown[500],  
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)
                        )
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(width: 300,
                    child: TextFormField(
                        controller: passWordController,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "비밀번호를 입력하세요.",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.brown[500],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)
                          )
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
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.login),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[500],
                        foregroundColor: Colors.white,
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        minimumSize: Size(150, 40)
                      ),
                      onPressed: () async{
                        employeeList = await handler.queryEmployeeLogin(employeeNoController.text);
                        
                        if(employeeList.isNotEmpty && passWordController.text == employeeList.first.pw){
                          _showDialog('계정이 확인 되었습니다.');
                        }else if(employeeNoController.text == 'Shiraz' && passWordController.text == 'Shiraz@1999'){
                          Get.to(InsertEmployee());
                        }
                        
                        else{
                          errorSnackBar('계정 정보를 확인하세요.');
                        }
                      }, 
                      label:Text(
                        '로그인',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        ),
                      ), 
                      ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  } // build

  errorSnackBar(String message){
    Get.snackbar(
      '경고',
      message,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
      colorText: Colors.white,
      backgroundColor: Colors.red
      );
  }

  _showDialog(String message){
    Get.defaultDialog(
      title: '환영합니다.',
      middleText: message,
      backgroundColor: Colors.blue,
      barrierDismissible: false,
      actions: [
        TextButton.icon(
          icon: Icon(Icons.check),
          onPressed: () {
            Get.back(); // 다이얼로그 지움
            saveStorage();
            Get.to(Home()); // 페이지 넘어감
          }, 
          label: Text('확인'),
          ),
      ]
    );
  }

  saveStorage(){
    box.write('p_employeeId', employeeNoController.text);
  }




} // class