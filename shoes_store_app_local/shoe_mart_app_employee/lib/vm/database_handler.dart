import 'package:shoe_mart_app_employee/model/employee.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async{
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, "shoestore.db"),
      onCreate: (db, version) async{
        await db.execute("create table user(id text primary key, pw text, name text, phone text, adminDate date, address text)"
        );
        await db.execute("create table employee(employeeNo text primary key, pw text, name text, employeeDate date, position int, authority int, storeCode text)"
        );
        await db.execute("create table store(storeCode text primary key, storeName text,longitude real, latitude real)"
        );
      },
      version: 1
    );
}

  Future<List<Employee>> queryEmployeeLogin(String employeeNo) async {
      final Database db = await initializeDB();
      print(await db.rawQuery('SELECT name FROM sqlite_master WHERE type = "table"'));
      final List<Map<String, Object?>> queryResult = await db.rawQuery(
        'select * from employee where employeeNo = ?',
        [employeeNo]
      );
      return queryResult.map((e) => Employee.fromMap(e)).toList();
      
    }

  Future<List<Employee>> queryEmployeeSearch(String keyword) async {
      final Database db = await initializeDB();
      print(await db.rawQuery('SELECT name FROM sqlite_master WHERE type = "table"'));
      final List<Map<String, Object?>> queryResult = await db.rawQuery(
        "select * from employee where employeeNo like '%$keyword%'",
      );
      return queryResult.map((e) => Employee.fromMap(e)).toList();
  
    }




  Future<void> insertInitialStores() async {
  final Database db = await initializeDB();

  final List<Map<String, dynamic>> stores = [
    {'storeCode': 1168001, 'storeName': '강남구', 'latitude': 37.501, 'longitude': 127.001},
    {'storeCode': 1168101, 'storeName': '강동구', 'latitude': 37.502, 'longitude': 127.002},
    {'storeCode': 1168201, 'storeName': '강서구', 'latitude': 37.503, 'longitude': 127.003},
    {'storeCode': 1168301, 'storeName': '관악구', 'latitude': 37.504, 'longitude': 127.004},
    {'storeCode': 1168401, 'storeName': '광진구', 'latitude': 37.505, 'longitude': 127.005},
    {'storeCode': 1168501, 'storeName': '구로구', 'latitude': 37.506, 'longitude': 127.006},
    {'storeCode': 1168601, 'storeName': '금천구', 'latitude': 37.507, 'longitude': 127.007},
    {'storeCode': 1168701, 'storeName': '노원구', 'latitude': 37.508, 'longitude': 127.008},
    {'storeCode': 1168801, 'storeName': '도봉구', 'latitude': 37.509, 'longitude': 127.009},
    {'storeCode': 1168901, 'storeName': '동대문구', 'latitude': 37.510, 'longitude': 127.010},
    {'storeCode': 1169001, 'storeName': '동작구', 'latitude': 37.511, 'longitude': 127.011},
    {'storeCode': 1169101, 'storeName': '마포구', 'latitude': 37.512, 'longitude': 127.012},
    {'storeCode': 1169201, 'storeName': '서대문구', 'latitude': 37.513, 'longitude': 127.013},
    {'storeCode': 1169301, 'storeName': '서초구', 'latitude': 37.514, 'longitude': 127.014},
    {'storeCode': 1169401, 'storeName': '성동구', 'latitude': 37.515, 'longitude': 127.015},
    {'storeCode': 1169501, 'storeName': '성북구', 'latitude': 37.516, 'longitude': 127.016},
    {'storeCode': 1169601, 'storeName': '송파구', 'latitude': 37.517, 'longitude': 127.017},
    {'storeCode': 1169701, 'storeName': '양천구', 'latitude': 37.518, 'longitude': 127.018},
    {'storeCode': 1169801, 'storeName': '영등포구', 'latitude': 37.519, 'longitude': 127.019},
    {'storeCode': 1169901, 'storeName': '용산구', 'latitude': 37.520, 'longitude': 127.020},
    {'storeCode': 1170001, 'storeName': '은평구', 'latitude': 37.521, 'longitude': 127.021},
    {'storeCode': 1170101, 'storeName': '종로구', 'latitude': 37.522, 'longitude': 127.022},
    {'storeCode': 1170201, 'storeName': '중구', 'latitude': 37.523, 'longitude': 127.023},
    {'storeCode': 1170301, 'storeName': '중랑구', 'latitude': 37.524, 'longitude': 127.024},
    {'storeCode': 1170401, 'storeName': '강북구', 'latitude': 37.525, 'longitude': 127.025},
    {'storeCode': 1000001, 'storeName': '본사', 'latitude': 37.526, 'longitude': 127.026},
  ];

  for (var store in stores) {
    await db.insert(
      'store',
      store,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
  print(stores);
}

Future<String?> queryStoreCodeChoice(String storeName) async {
  final Database db = await initializeDB();
  try {
    final List<Map<String, Object?>> result = await db.rawQuery(
      'SELECT storeCode FROM store WHERE storeName = ?',
      [storeName],
    );

    if (result.isNotEmpty) {
      final code = result.first['storeCode'];
      return code?.toString(); // int든 String이든 안전하게 문자열로 반환
    } else {
      return null; // 매장명 일치 없음
    }
  } catch (e) {
    print("🚨 오류 발생: $e");
    return null;
  }
}

Future<int> insertEmployee(Employee employee)async{
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'insert into employee(employeeNo, pw, name, employeeDate, position, authority, storeCode) values (?, ?, ?, ?, ?, ?, ?)',
      [employee.employeeNo, employee.pw, employee.name, employee.employeeDate, employee.position, employee.authority, employee.storeCode]
    );
    return result;
  }

  Future<void> deleteEmployee(String employeeNo) async{
    final Database db = await initializeDB();
    await db.rawDelete('delete from employee where employeeNo = ?',
          [employeeNo]
    );
  }

  Future<int> updateEmployee(Employee employee)async{
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawUpdate(
      'update employee set employeeNo = ?, pw = ?, name = ?, employeeDate = ?, position = ?, authority = ?, storeCode =?',
      [employee.employeeNo, employee.pw, employee.name, employee.employeeDate, employee.position, employee.authority, employee.storeCode]
    );
    return result;
  }


}