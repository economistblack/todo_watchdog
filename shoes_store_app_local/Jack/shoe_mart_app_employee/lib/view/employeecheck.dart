import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:shoe_mart_app_employee/model/employee.dart';
import 'package:shoe_mart_app_employee/view/employeeedit.dart';
import 'package:shoe_mart_app_employee/vm/database_handler.dart';

class EmployeeCheck extends StatefulWidget {
  const EmployeeCheck({super.key});

  @override
  State<EmployeeCheck> createState() => _EmployeeCheckState();
}

class _EmployeeCheckState extends State<EmployeeCheck> {
  // Property
  DatabaseHandler handler = DatabaseHandler();
  TextEditingController searchController = TextEditingController();
  List<Employee> employeeData = [];

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
              Icon(Icons.group, size: 30, color: Colors.white),
              SizedBox(width: 15),
              Column(
                children: [
                  Text(
                    '직원 목록을 확인하세요.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                  width: 250,
                  child: TextField(
                    controller: searchController,
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) async{
                      handler.queryEmployeeSearch(value);
                      setState(() {
                        
                      });
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: Colors.white,),
                      hoverColor: Colors.white,
                      focusColor: Colors.white,
                      labelText: '직원 번호로 검색하세요.',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      floatingLabelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                )
                ],
              ),
            ],
          ),
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          toolbarHeight: 150,
        ),
        body: Column(
          children: [
            SizedBox(height: 30),
            Expanded(
              child: FutureBuilder(
                future: handler.queryEmployeeSearch(searchController.text),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FractionallySizedBox(
                            widthFactor: 0.9,
                            child: Slidable(
                              endActionPane: ActionPane(
                        motion: BehindMotion(),
                        children:[
                          SlidableAction(
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                            label: '삭제',
                            onPressed: (context) {
                              _showDialog('퇴사 처리하시겠습니까?', snapshot.data![index].employeeNo, index, snapshot.data!);
                            },
                            ),
                        ] 
                        ),
                        startActionPane: ActionPane(
                        motion: DrawerMotion(), 
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.green,
                            icon: Icons.edit,
                            label: '수정',
                            onPressed: (context) {
                              Get.to(EmployeeEdit(),
                              arguments: [
                                snapshot.data![index].employeeNo,
                                snapshot.data![index].pw,
                                snapshot.data![index].name,
                                snapshot.data![index].employeeDate,
                                snapshot.data![index].position,
                                snapshot.data![index].authority,
                                snapshot.data![index].storeCode,
                              ]
                              )!.then((value) => reloadData());
                            },),
                        ]
                        ),

                              child: Card(
                                color:
                                    (index % 2 == 0)
                                        ? Colors.blue[800]
                                        : Colors.orange[600],
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '직원 번호 : ${snapshot.data![index].employeeNo}',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            '  |  ',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            '입사 날짜 : ${snapshot.data![index].employeeDate}',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            '이름 : ${snapshot.data![index].name}',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            '  |  ',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            '직핵 : ${snapshot.data![index].position == 0
                                                ? '사원'
                                                : (snapshot.data![index].position == 1)
                                                ? '대리'
                                                : (snapshot.data![index].position == 2)
                                                ? '과장'
                                                : (snapshot.data![index].position == 3)
                                                ? '부장'
                                                : (snapshot.data![index].position == 4)
                                                ? '이사'
                                                : (snapshot.data![index].position == 5)
                                                ? '상무'
                                                : '대표이사'}',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            '  |  ',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            '권한 : ${snapshot.data![index].authority == 0
                                                ? '기안작성권한'
                                                : (snapshot.data![index].authority == 1)
                                                ? '중간결제권한'
                                                : '최종결제권한'}',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            '  |  ',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                        '근무처 코드 : ${snapshot.data![index].storeCode}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                        ],
                                      ),
                                            
                                      
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  } // build

   _showDialog(String message, String employeeNo, int index, List<Employee> data) {
    Get.defaultDialog(
      title: '퇴사 처리',
      middleText: message,
      backgroundColor: Colors.blue,
      barrierDismissible: false,
      actions: [
        TextButton.icon(
          icon: Icon(Icons.check),
          onPressed: () async {

            await handler.deleteEmployee(employeeNo);
            data.removeAt(index);
            setState(() {
            });

            Get.back(); // 다이얼로그 지움
          },
          label: Text('확인'),
        ),
      ],
    );
  }

  reloadData(){
    handler.queryEmployeeSearch(searchController.text);
    setState(() {});
  }


} // class
