// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'dart:io' as io;
// import 'dart:async';
// import 'package:new_payrightsystem/utils/model/userInfo.dart';

//     class DBHelper{
//       static final DBHelper _instance = new DBHelper.internal();

//       DBHelper.internal();

//       factory DBHelper() => _instance;

//       static Database _db;

//       Future<Database> get db async{
//         if(_db != null) return _db;

//         _db = await setDB();
//         return _db;
//       }

//     setDB()async{
//       io.Directory directory = await getApplicationDocumentsDirectory();
//       String path = join(directory.path, "mobilePayright");

//       await deleteDatabase(path); // just for testing

//       var dB = await openDatabase(path, version : 1, onCreate : _onCreate);
//       return dB;
//     }

//     void _onCreate(Database db, int version) async{
//       await db.execute("CREATE TABLE userinfo(id INTEGER PRIMARY KEY, name TEXT, companyName TEXT, company_id INTEGER , employee_id INTEGER , createDate TEXT)");
//       print("db created");
//     }

//     }
