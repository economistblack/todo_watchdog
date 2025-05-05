import 'package:must_eat_place_app/model/eatplace.dart';
import 'package:must_eat_place_app/model/favorite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  Future<Database> initializeDB()async{
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'eatplace.db'),
      onCreate: (db, version) async{
        await db.execute(
          "create table eatplace(id integer primary key autoincrement, name text, phone text, comment text, latitude text, longitude text, image01 blob, image02 blob)"
        );
        await db.execute(
          "create table favorite(id integer primary key, date text, isfavorite integer default 0)"
        );
      },
      version: 1
    );
  }

  Future<List<Eatplace>> queryEatPlace(String keyword) async{
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery('select * from eatplace where name like "%$keyword%"');
    return queryResult.map((e) => Eatplace.fromMap(e)).toList();
  }

  Future<List<Favorite>> queryFavorite() async{
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery('select * from favorite');
    return queryResult.map((e) => Favorite.fromMap(e)).toList();
  }

  Future<List<Map<String, dynamic>>> queryEatplaceWithFavorite(String keyword) async{
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(
      '''
      select e.id, e.name, e.phone, e.comment, e.latitude, e.longitude, e.image01, e.image02,
         f.date, f.isfavorite
      from eatplace as e
      left join favorite as f
      on e.id = f.id
      where e.name like "%$keyword%"
      '''
    );
    return queryResult;
  }
  
  Future<List<Map<String, dynamic>>> queryFavoriteOnly() async {
  final Database db = await initializeDB();
  return await db.rawQuery(
    '''
    SELECT e.id, e.name, e.phone, e.comment, e.latitude, e.longitude,
           e.image01, e.image02, f.date, f.isfavorite
    FROM eatplace AS e
    LEFT JOIN favorite AS f ON e.id = f.id
    WHERE f.isfavorite = 1
    '''
  );
}

  Future<int> updateFavoriteStatus(int id, bool isFavorite) async {
  final Database db = await initializeDB();
  return await db.rawUpdate(
    'UPDATE favorite SET isfavorite = ? WHERE id = ?',
    [isFavorite ? 1 : 0, id]
  );
}

  Future<int> insertEatPlace(Eatplace eatplace)async{
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'insert into eatplace(name, phone, comment, latitude, longitude, image01, image02) values (?, ?, ?, ?, ?, ?, ?)',
      [eatplace.name, eatplace.phone, eatplace.comment, eatplace.latitude, eatplace.longitude, eatplace.image01, eatplace.image02]
    );
    return result;
  }

  Future<int> insertFavorite(Favorite favorite)async{
    int resultFavorite = 0;
    final Database db = await initializeDB();
    resultFavorite = await db.rawInsert(
      'insert into favorite(id, date, isfavorite) values (?, ?, ?)',
      [favorite.id, favorite.date, favorite.isfavorite ? 1 : 0]
    );
    return resultFavorite;
  }




  Future<int> updateEatPlace(Eatplace eatplace)async{
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawUpdate(
      'update eatplace set name = ?, phone = ?, comment = ?, latitude = ?, longitude = ? where id = ?',
      [eatplace.name, eatplace.phone, eatplace.comment, eatplace.latitude, eatplace.longitude, eatplace.id]
    );
    return result;
  }

  Future<int> updateEatPlaceAll(Eatplace eatplace)async{
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawUpdate(
      'update eatplace set name = ?, phone = ?, comment = ?, latitude = ?, longitude = ?, image01 = ?, image02 = ? where id = ?',
      [eatplace.name, eatplace.phone, eatplace.comment, eatplace.latitude, eatplace.longitude, eatplace.image01, eatplace.image02, eatplace.id]
    );
    return result;
  }


  Future<void> deleteEatPlace(int id) async{
    final Database db = await initializeDB();
    await db.rawDelete('delete from eatplace where id = ?',
          [id]
    );
  }


} //class