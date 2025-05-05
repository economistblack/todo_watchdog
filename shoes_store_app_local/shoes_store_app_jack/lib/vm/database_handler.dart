import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async{
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, "shoestore.db"),
      onCreate: (db, version) async{
        await db.execute("create table user(id text primary key, pw text, phone text, adminDate date, address text, name text)"
        );
        // await db.execute(
        //   '''
        //   create table employee(
        //     employeeNo text primary key,
        //     pw text,
        //     employeeDate date,
        //     position text,
        //     authority text,
        //     storeCode text
        //   )
        //   '''
        // );
        // await db.execute(
        // '''
        // create table store(
        //   storeCode text primary key,
        //   storeName text,
        //   longitude real,
        //   latitude real
        // )
        // '''
        // );
      },
      version: 1
    );
}
}