// import 'dart:async';
// import 'dart:io' as io;

// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:new_payrightsystem/ui/Home/dashboardzakir.dart';
// import 'package:new_payrightsystem/utils/service/notification_service.dart';

// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   static final DatabaseHelper _instance = new DatabaseHelper.internal();

//   factory DatabaseHelper() => _instance;

//   static Database _db;

//   Future<Database> get db async {
//     if (_db != null) return _db;
//     _db = await initDb();
//     return _db;
//   }

//   DatabaseHelper.internal();

//   initDb() async {
//     io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, "main.db");
//     var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
//     return theDb;
//   }

//   void _onCreate(Database db, int version) async {
//     // await db.execute(
//     //     "CREATE TABLE t_user (email text, nama ,gender text, alamat text,nomor_telepon text , institution text, profession text, api_token text, firebase_token text )");
//     // await db.execute(
//     //     "CREATE TABLE cart (id INTEGER PRIMARY KEY, id_kelas text, nama_kelas text, kategori text, sub_kategori text,thumbnail text, harga INTEGER  )");
//     await db.execute(
//         "CREATE TABLE notifikasi (id INTEGER PRIMARY KEY,id_content text, title text, body text,tanggal text,jam text,jenis_notifikasi text,status text, type_content text )");
//   }

//   // Future<int> saveUser(User user) async {
//   //   var dbClient = await db;
//   //   int res = await dbClient.insert("t_user", user.toMap());
//   //   return res;
//   // }

//   // Future<int> addCart(Cart cart) async {
//   //   var dbClient = await db;
//   //   int res = await dbClient.insert("cart", cart.toMap());
//   //   return res;
//   // }

//   Future<int> sqlInsert(tableName, list) async {
//     var dbClient = await db;
//     int res = await dbClient.insert(tableName, list.toMap());
//     return res;
//   }

//   Future<int> accountRowCount() async {
//     int returnValue = 0;
//     var dbClient = await db;
//     List<Map> list = await dbClient.rawQuery('SELECT * FROM t_user');
//     returnValue = list.length;
//     return returnValue;
//   }

//   Future<int> deleteAccount() async {
//     var dbClient = await db;
//     int res = await dbClient.rawDelete('DELETE FROM t_user ');
//     return res;
//   }

//   Future<int> clearCart() async {
//     var dbClient = await db;
//     int res = await dbClient.rawDelete('DELETE FROM cart ');
//     return res;
//   }

//   // Future<bool> updateAccount(User user) async {
//   //   var dbClient = await db;
//   //   int res = await dbClient.update("t_user", user.toMap());
//   //   return res > 0 ? true : false;
//   // }

//   Future<int> saveNotification(NotifikasiModel notifikasi) async {
//     var dbClient = await db;
//     int res = await dbClient.insert("notifikasi", notifikasi.toMap());
//     return res;
//   }

//   void execute(String s) {}
// }
