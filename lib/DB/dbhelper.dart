import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

import 'package:taskanglara/ResponseModel/Cart.dart';



class DbHelper{
  static Database? _db;
  static const String DB_Name = 'Cart.db';
  static const String Table_User = 'Cart1';
  static const int Version = 1;

  static const String id = 'id';
  static const String title = 'title';
  static const String quantity = 'quantity';
  static const String price = 'price';
  static const String email = 'email';
  static const String password = 'password';


  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_Name);
    var db = await openDatabase(path, version: Version, onCreate: _onCreate);
    return db;
  }
  _onCreate(Database db, int intVersion) async {
    await db.execute("CREATE TABLE $Table_User ("
        " $id TEXT, "
        " $title TEXT, "
        " $quantity TEXT, "
        " $price TEXT, "
        " $email TEXT, "
        " $password TEXT, "
        " PRIMARY KEY ($id)"
        ")");
  }
  Future<int> saveData(Cart cart) async {
    var dbClient = await db;
    var res = await dbClient.insert(Table_User, cart.toMap());
    return res;
  }
  Future<int> update(Cart cart) async {
    final dbClient = await db;
    var res = await dbClient.update(Table_User, cart.toMap(),
        where: "id = ?", whereArgs: [cart.id]);
    return res;
  }
  Future<List<Map>> RawQuery(String Query) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(Query);
    return list;
  }
  /*Future<cart?> getLoginUser(String userId, String password) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $Table_User WHERE "
        "$id = '$userId' AND "
        "$C_Password = '$password'");
    print("res"+res.toString());
    print(res.first);
    if (res.isNotEmpty) {
      return UserModel.fromMap(res.first);
    }

    return null;
  }*/

}