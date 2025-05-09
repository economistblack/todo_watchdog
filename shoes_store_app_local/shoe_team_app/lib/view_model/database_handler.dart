import 'package:path/path.dart';
import 'package:shoe_team_project/model/basket.dart';
import 'package:shoe_team_project/model/order_history.dart';
import 'package:shoe_team_project/model/product.dart';
import 'package:shoe_team_project/model/productDetail.dart';
import 'package:shoe_team_project/model/product_image.dart';
import 'package:sqflite/sqflite.dart';

import '../model/user.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'shoestore.db'),
      onCreate: (db, version) async {
        await db.execute(
          // 수량과 카테고리는 숫자지만 text로 받는다
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
        ''',
        );
        await db.execute('''
        create table productimage(
          imageId text primary key,
          image01 blob,
          image02 blob
        )
        ''');
        await db.execute('''
        create table imageregister(
          productCode text,
          imageId text,
          primary key (productCode, imageId)
        )
        ''');
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
        await db.execute('''
        CREATE TABLE traninfo (
        transactionNo INTEGER primary key autoincrement,
        transactionDate TEXT,
        productCode TEXT,
        userId TEXT,
        storeCode TEXT,
        transactionState INTEGER,
        transactionPrice INTEGER,
        originDate TEXT,
        originNo TEXT,
        returnReason TEXT,
        productName TEXT,
        storeName TEXT,
        FOREIGN KEY (userId) REFERENCES user(userid),
        FOREIGN KEY (productCode) REFERENCES product(productCode),
        FOREIGN KEY (storeCode) REFERENCES store(storeCode)
      );
        ''');
        await db.execute('''
        create table store(
          storeCode text primary key,
          storeName text,
          longitude real,
          latitude real
        )
        ''');
        await db.execute('''
        create table tranitem(
        itemNo TEXT,
        transactionDate TEXT,
        transactionNo TEXT,
        storeCode TEXT,  
        buyProductCode TEXT, 
        buyProductName TEXT,
        buyProductPrice INTEGER,
        buyProductQuantity INTEGER,    
        sumPrice INTEGER,               

        PRIMARY KEY (itemNo, transactionDate, transactionNo),
        FOREIGN KEY (buyProductCode) REFERENCES product(productCode),
        FOREIGN KEY (storeCode) REFERENCES store(storeCode),
        FOREIGN KEY (transactionNo) REFERENCES tranInfo(transactionNo)
        )
        ''');
        await db.execute('''
        CREATE TABLE order_history (
        orderId TEXT PRIMARY KEY,
        userId TEXT,
        storeCode INTEGER,
        storeName TEXT,
        totalPrice INTEGER,
        orderDate TEXT,
        state INTEGER,
        returnReason Text
        )
        ''');
      },
      version: 1,
    );
  }

  Future<List<Product>> queryProduct() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResults = await db.rawQuery(
      "select * from product",
    );
    return queryResults.map((e) => Product.fromMap(e)).toList();
  }

  Future<List<Product>> queryProductsearch(String search) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResults = await db.rawQuery(
      '''
    SELECT * FROM product
    WHERE productName IN (
      SELECT productName FROM product
      WHERE productName LIKE ?
      GROUP BY productName
    )
    GROUP BY productName
    ''',
    ['%$search%'],
    );
    return queryResults.map((e) => Product.fromMap(e)).toList();
  }

  Future<List<ProductImage>> queryProductimage() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResults = await db.rawQuery(
      "select * from productimage",
    );
    return queryResults.map((e) => ProductImage.fromMap(e)).toList();
  }

  Future<List<ProductImage>> queryUs() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResults = await db.rawQuery(
      "select * from productimage",
    );
    return queryResults.map((e) => ProductImage.fromMap(e)).toList();
  }

  Future<List<ProductDetail>> queryImageregister(String productName) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResults = await db.rawQuery(
          '''
    SELECT 
      product.productCode,
      product.productName,
      product.description,
      product.image,
      product.quantity,
      product.color,
      product.size,
      productimage.image01,
      productimage.image02,
      product.price
    FROM imageregister
    JOIN product ON imageregister.productCode = product.productCode
    JOIN productimage ON imageregister.imageId = productimage.imageId
    WHERE product.productName LIKE ?
    ''',
    ['%$productName%'],
    );


    print('🟡 전달된 productName: $productName');
  print('🟢 쿼리 결과 수: ${queryResults.length}');
  for (var item in queryResults) {
    print('🧾 ${item['productCode']} | color: ${item['color']} | size: ${item['size']}');
  }



    return queryResults.map((e) => ProductDetail.fromMap(e)).toList();
  }

  Future<List<Basket>> queryBasket() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryRsult = await db.rawQuery('''
      SELECT basket.*, product.productName, product.image
      FROM basket
      JOIN product ON basket.productCode = product.productCode
    ''');
    return queryRsult.map((e) => Basket.fromMap(e)).toList();
  }

  Future<int> insertBasket(Basket basket) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
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
        basket.ischeck,
      ],
    );
    return result;
  }

  Future<List<User>> queryUserLogin(String userid) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * from user where userid = ?',
      [userid],
    );
    return queryResult.map((e) => User.fromMap(e)).toList();
  }

  Future<int> insertUser(User user) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'insert into user(userid, pw, phone, adminDate, address, name) values (?, ?, ?, ?, ?, ?)',
      [
        user.userid,
        user.pw,
        user.phone,
        user.adminDate,
        user.address,
        user.name,
      ],
    );
    return result;
  }

  Future<int> updateUserPassword(String userid, String newPassword) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawUpdate('update user set pw = ? WHERE userid = ?', [
      newPassword,
      userid,
    ]);
    return result;
  }
  Future<void>deletebasket(String basketSeq)async{
    final Database db = await initializeDB();
    await db.rawDelete("delete from basket where basketSeq = ?",
    [basketSeq]);
  }

  Future<int> deleteBasket(int id) async {
  final db = await initializeDB();
  return await db.delete('basket', where: 'basketSeq = ?', whereArgs: [id]);
}
  Future<void> insertInitialStores() async {
  final db = await initializeDB();

  List<Map<String, dynamic>> stores = [
    {'storeCode': 1168001, 'storeName': '강남구 1호점', 'lat': 37.5172363, 'lng': 127.0473248},
    {'storeCode': 1174001, 'storeName': '강동구 1호점', 'lat': 37.5305201, 'lng': 127.1205499},
    {'storeCode': 1150001, 'storeName': '강서구 1호점', 'lat': 37.5511119, 'lng': 126.849538},
    {'storeCode': 1162001, 'storeName': '관악구 1호점', 'lat': 37.4784063, 'lng': 126.9516134},
    {'storeCode': 1121501, 'storeName': '광진구 1호점', 'lat': 37.5384844, 'lng': 127.0822939},
    {'storeCode': 1153001, 'storeName': '구로구 1호점', 'lat': 37.4954856, 'lng': 126.8871003},
    {'storeCode': 1154501, 'storeName': '금천구 1호점', 'lat': 37.4562259, 'lng': 126.8953218},
    {'storeCode': 1135001, 'storeName': '노원구 1호점', 'lat': 37.6541917, 'lng': 127.0567939},
    {'storeCode': 1132001, 'storeName': '도봉구 1호점', 'lat': 37.6687685, 'lng': 127.0471634},
    {'storeCode': 1123001, 'storeName': '동대문구 1호점', 'lat': 37.574368, 'lng': 127.039552},
    {'storeCode': 1159001, 'storeName': '동작구 1호점', 'lat': 37.512398, 'lng': 126.939252},
    {'storeCode': 1144001, 'storeName': '마포구 1호점', 'lat': 37.5637561, 'lng': 126.9084211},
    {'storeCode': 1141001, 'storeName': '서대문구 1호점', 'lat': 37.579400, 'lng': 126.936600},
    {'storeCode': 1165001, 'storeName': '서초구 1호점', 'lat': 37.4837121, 'lng': 127.0324115},
    {'storeCode': 1120001, 'storeName': '성동구 1호점', 'lat': 37.563341, 'lng': 127.036559},
    {'storeCode': 1129001, 'storeName': '성북구 1호점', 'lat': 37.589400, 'lng': 127.016700},
    {'storeCode': 1171001, 'storeName': '송파구 1호점', 'lat': 37.514575, 'lng': 127.105399},
    {'storeCode': 1147001, 'storeName': '양천구 1호점', 'lat': 37.516988, 'lng': 126.866398},
    {'storeCode': 1156001, 'storeName': '영등포구 1호점', 'lat': 37.526371, 'lng': 126.896229},
    {'storeCode': 1117001, 'storeName': '용산구 1호점', 'lat': 37.532600, 'lng': 126.990000},
    {'storeCode': 1138001, 'storeName': '은평구 1호점', 'lat': 37.617612, 'lng': 126.922700},
    {'storeCode': 1111001, 'storeName': '종로구 1호점', 'lat': 37.573050, 'lng': 126.979189},
    {'storeCode': 1114001, 'storeName': '중구 1호점', 'lat': 37.5637561, 'lng': 126.997602},
    {'storeCode': 1126001, 'storeName': '중랑구 1호점', 'lat': 37.606320, 'lng': 127.092880},
    {'storeCode': 1135002, 'storeName': '강북구 1호점', 'lat': 37.639800, 'lng': 127.025500},
    {'storeCode': 1000001, 'storeName': '본사', 'lat': 37.566535, 'lng': 126.977969},
  ];

  for (var store in stores) {
    await db.insert(
      'store',
      {
        'storeCode': store['storeCode'],
        'storeName': store['storeName'],
        'latitude': store['lat'],
        'longitude': store['lng'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
Future<int> insertOrderHistory(OrderHistory order) async {
  final db = await initializeDB();
  return await db.insert(
    'order_history',
    order.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> decreaseProductQuantity(String productCode, int buyQuantity) async {
  final db = await initializeDB();
  await db.rawUpdate('''
    UPDATE product
    SET quantity = quantity - ?
    WHERE productCode = ?
  ''', [buyQuantity, productCode]);
}

Future<int> getCurrentProductQuantity(String productCode) async {
  final db = await initializeDB();
  final List<Map<String, Object?>> result = await db.rawQuery(
    'SELECT quantity FROM product WHERE productCode = ?',
    [productCode],
  );

  if (result.isNotEmpty) {
    return int.parse(result.first['quantity'].toString());
  }
  return 0;
}

Future<int> updateOrderHistory(OrderHistory orderhistory) async {
  int result = 0;
  final Database db = await initializeDB();
  result = await db.rawUpdate(
    '''
    UPDATE order_history 
    SET userId = ?, 
        storeCode = ?, 
        storeName = ?, 
        totalPrice = ?, 
        orderDate = ?, 
        state = ?, 
        returnReason = ?
    WHERE orderId = ?
    ''',
    [
      orderhistory.userId,
      orderhistory.storeCode,
      orderhistory.storeName,
      orderhistory.totalPrice,
      orderhistory.orderDate,
      orderhistory.state,
      orderhistory.returnReason,
      orderhistory.orderId
    ],
  );
  return result;
}


}//class