import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/user.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async{
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, "shoestore.db"),
      onCreate: (db, version) async{
        await db.execute("create table user(id text primary key, pw text, name text, phone text, adminDate date, address text)"
        );
        await db.execute(
          '''
          create table employee(
            employeeNo text primary key,
            pw text,
            employeeDate date,
            position text,
            authority text,
            storeCode text
          )
          '''
        );
        await db.execute(
        '''
        create table store(
          storeCode text primary key,
          storeName text,
          longitude real,
          latitude real
        )
        '''
        );
      },
      version: 1
    );
}
  Future<List<User>> queryUserLogin(String id) async {
      final Database db = await initializeDB();
      final List<Map<String, Object?>> queryResult = await db.rawQuery(
        'select * from user where id = ?',
        [id]
      );
      return queryResult.map((e) => User.fromMap(e)).toList();
    }

  Future<int> insertUser(User user)async{
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'insert into user(id, pw, name, phone, adminDate, address) values (?, ?, ?, ?, ?, ?)',
      [user.id, user.pw, user.name, user.phone, user.adminDate, user.address]
    );
    return result;
  }

  Future<int> updateUserPassword(String id, String newPassword)async{
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawUpdate(
      'update user set pw = ? WHERE id = ?',
    [newPassword, id]
    );
    return result;
  }
}