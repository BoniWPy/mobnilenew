// import 'package:new_payrightsystem/utils/notification/task.dart';
// import 'package:flutter/material.dart';
// //for notifiaction
// import 'package:new_payrightsystem/data/model/NotifikasiModel.dart';
// import 'package:new_payrightsystem/data/DatabaseHelper.dart';
// import 'package:new_payrightsystem/utils/shared_preferences.dart';

// var databaseHelper = new DatabaseHelper();

// Future<String> getNotification() async {
//   List<Task> tasks = [];
//   var userinfo = await Data.getData();
//   var dbClient = await databaseHelper.db;
//   var getNotification = await dbClient
//       .rawQuery('select * from notifikasi order by tanggal desc, jam desc');

//   // String _id_content;
//   // String _title;
//   // String _body;
//   // String _tanggal;
//   // String _jam;
//   // String _jenis_notifikasi;
//   // String _status;
//   // String _group;
//   // String _click_action;

//   for (var i = 0; i < getNotification.length; i++) {
//     tasks.add(
//       new Task(
//           title: getNotification[i]['nama'],
//           message: getNotification[i]['kategori'],
//           time: getNotification[i]['jam'],
//           color: Colors.orange,
//           comment: false),
//     );
//   }
//   return "hai";
// }

// // List<Task> tasks = [
// //   new Task(
// //       title: "Reminder for Upcoming Closing Date",
// //       message: "Tutup buku periode :string :date -",
// //       time: "08:55",
// //       color: Colors.orange,
// //       comment: false),
// //   new Task(
// //       title: "Irvandy Goutama completed this task",
// //       message: "Project Notification",
// //       time: "09:16",
// //       color: Colors.cyan,
// //       comment: true),
// //   new Task(
// //       title: "Reminder for Upcoming Closing Date",
// //       message: "Tutup buku periode :string :date -",
// //       time: "13:55",
// //       color: Colors.orange,
// //       comment: false),
// //   new Task(
// //       title: "Irvandy Goutama completed this task",
// //       message: "Project Notification",
// //       time: "14:16",
// //       color: Colors.cyan,
// //       comment: true),
// //   new Task(
// //       title: "Reminder for Upcoming Closing Date",
// //       message: "Tutup buku periode :string :date -",
// //       time: "15:55",
// //       color: Colors.orange,
// //       comment: false),
// //   new Task(
// //       title: "Irvandy Goutama completed this task",
// //       message: "Project Notification",
// //       time: "19:16",
// //       color: Colors.cyan,
// //       comment: true),
// // ];
