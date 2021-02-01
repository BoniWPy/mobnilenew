import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:new_payrightsystem/data/model/NotifikasiModel.dart';
import 'package:new_payrightsystem/data/model/User.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY, mobile TEXT, otp TEXT)");

    // await db.execute(
    //     "CREATE TABLE info_account (id INTEGER PRIMARY KEY, jumlah_trade_point INTEGER, jumlah_absen int,jam )");
    //     print("database created");

    await db.execute(
        "CREATE TABLE notifikasi (id INTEGER PRIMARY KEY,id_content text, title text, body text,tanggal text,jam text,jenis_notifikasi text,status text )");
  }

  Future<int> saveUser(User account) async {
    var dbClient = await db;
    int res = await dbClient.insert("user", account.toMap());
    return res;
  }

  Future<int> sqlInsert(tableName, list) async {
    var dbClient = await db;
    int res = await dbClient.insert(tableName, list.toMap());
    return res;
  }

  Future<List<User>> getUser() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM user');
    List<User> employees = new List();
    for (int i = 0; i < list.length; i++) {
      // var account =
      //     new User(list[i]["email"], list[i]["password"], list[i]["nama"], list[i]["nomor_telepon"], list[i]["saldo"], list[i]["status"] );
      // account.setUserId(list[i]["id"]);
      // employees.add(account);
    }
    print(employees.length);
    return employees;
  }

  Future<int> accountRowCount() async {
    int returnValue = 0;
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM user');
    returnValue = list.length;
    return returnValue;
  }

  Future<int> deleteUser() async {
    var dbClient = await db;
    int res = await dbClient.rawDelete('DELETE FROM user ');
    return res;
  }

  Future<bool> updateUser(User account) async {
    var dbClient = await db;
    int res = await dbClient.update("user", account.toMap());
    return res > 0 ? true : false;
  }

  Future<int> saveNotification(NotifikasiModel notifikasi) async {
    var dbClient = await db;
    int res = await dbClient.insert("notifikasi", notifikasi.toMap());
    return res;
  }

  void execute(String s) {}
}
