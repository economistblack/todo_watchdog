import 'package:environment_api_app/model/imageposition.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> initializeDB()async{
    String path = await getDatabasesPath();
    return openDatabase(
      join(path,'imagepostion.db'),
      onCreate: (db, version) async {
        await db.execute(
          "create table imageposition(id integer primary key autoincrement, latitude real, longtitude real, image blob)"
        );
      },
      version: 1,
    );
  }

  Future<List<ImagePosition>> queryImagePosition()async{
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResults = await db.rawQuery(
      'select * from imageposition'
    );
    return queryResults.map((e) => ImagePosition.fromMap(e)).toList();
  }

  Future<int> insertImagePostion(ImagePosition imageposition)async{
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'insert into imageposition(latitude, longtitude, image) values (?,?,?)',
      [imageposition.latitude, imageposition.longtitude, imageposition.image]
    );
    return result;
  }

}