
import 'package:path/path.dart';
import 'package:shoe_team_project/model/basket.dart';
import 'package:shoe_team_project/model/product.dart';
import 'package:shoe_team_project/model/productDetail.dart';
import 'package:shoe_team_project/model/product_image.dart';
import 'package:sqflite/sqflite.dart';

import '../model/user.dart';

class DatabaseHandler {

  Future<Database>initializeDB()async{
    
    String path = await getDatabasesPath();
    return openDatabase(
      join(path,'shoestore.db'),
      onCreate: (db, version) async{
       await db.execute(   // 수량과 카테고리는 숫자지만 text로 받는다
          '''
        create table product(
          productCode text primary key,
          detailCode text,
          productName text,
          quantity integer,
          color text,
          rating text,
          marginRate integer,
          price integer,
          size integer,
          image blob,
          description text,
          category text,
          productionYear text,
          companyName text,
          companyCode text
        )
        '''
          );
      await db.execute(
        '''
        create table productimage(
          imageId text primary key,
          image01 blob,
          image02 blob
        )
        '''
          );
      await db.execute('''
        create table imageregister(
          productCode text,
          imageId text,
          primary key (productCode, imageId)
        )
        '''
        );
        await db.execute('''
        create table user(
          userid text primary key,
          pw text,
          phone text,
          adminDate date,
          address text,
          name text
        )
        ''');
        await db.execute('''
        create table basket(
          basketSeq integer primary key autoincrement,
          userid text,
          productCode text,
          buyProductPrice integer,
          buyProductQuantity integer,
          buyProductName text,
          image blob,
          ischeck integer,
          foreign key (userid) references user(userid),
          foreign key (productCode) references product(productCode)
        )
        ''');

      },
      version: 1,
    );
  }
  Future<List<Product>>queryProduct()async{
    final Database db = await initializeDB();
    final List<Map<String,Object?>>queryResults = await db.rawQuery("select * from product");
    return queryResults.map((e)=>Product.fromMap(e)).toList();
  }
  Future<List<Product>>queryProductsearch(String search)async{
    final Database db = await initializeDB();
    final List<Map<String,Object?>>queryResults = await db.rawQuery("select * from product where productName like ?",['%$search%']);
    return queryResults.map((e)=>Product.fromMap(e)).toList();
  }
  Future<List<ProductImage>>queryProductimage()async{
    final Database db = await initializeDB();
    final List<Map<String,Object?>>queryResults = await db.rawQuery("select * from productimage");
    return queryResults.map((e)=>ProductImage.fromMap(e)).toList();
  }
  Future<List<ProductImage>>queryUs()async{
    final Database db = await initializeDB();
    final List<Map<String,Object?>>queryResults = await db.rawQuery("select * from productimage");
    return queryResults.map((e)=>ProductImage.fromMap(e)).toList();
  }
  Future<List<ProductDetail>>queryImageregister(String productCode)async{
    final Database db = await initializeDB();
    final List<Map<String,Object?>>queryResults = await db.rawQuery(
      '''
      select  product.productCode,
              product.productName,
              product.description,
              product.image,
              productimage.image01,
              productimage.image02,
              product.price
      from imageregister,product,productimage
      where imageregister.productCode = product.productCode
      and imageregister.imageId = productimage.imageId
      and product.productCode = ?
      ''',
      [productCode]);
    return queryResults.map((e)=>ProductDetail.fromMap(e)).toList();
  }
  Future<List<Basket>>queryBasket()async{
    final Database db = await initializeDB();
    final List<Map<String,Object?>>queryRsult = await db.rawQuery(
      '''
      SELECT basket.*, product.productName, product.image
      FROM basket
      JOIN product ON basket.productCode = product.productCode
    '''
    );
    return queryRsult.map((e)=>Basket.fromMap(e)).toList();
  }
  Future<int>insertBasket(Basket basket)async{
    int result =0;
    final Database db = await initializeDB();
    result =  await db.rawInsert(
    '''
    insert into basket(
      userid, productCode, buyProductPrice, buyProductQuantity, buyProductName, image, ischeck
    ) values (?, ?, ?, ?, ?, ?, ?)
    ''',
    [
      basket.userid,
      basket.productCode,
      basket.buyProductPrice,
      basket.buyProductQuantity,
      basket.buyProductName,
      basket.image,
      basket.ischeck
    ]
  );
    return result;
  }

  Future<List<User>> queryUserLogin(String userid) async {
      final Database db = await initializeDB();
      final List<Map<String, Object?>> queryResult = await db.rawQuery(
        'select * from user where userid = ?',
        [userid]
      );
      return queryResult.map((e) => User.fromMap(e)).toList();
    }

  Future<int> insertUser(User user)async{
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'insert into user(userid, pw, phone, adminDate, address, name) values (?, ?, ?, ?, ?, ?)',
      [user.userid, user.pw, user.phone, user.adminDate, user.address, user.name]
    );
    return result;
  }

  Future<int> updateUserPassword(String userid, String newPassword)async{
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawUpdate(
      'update user set pw = ? WHERE userid = ?',
    [newPassword, userid]
    );
    return result;
  }
}//class