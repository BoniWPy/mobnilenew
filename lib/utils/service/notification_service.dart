// import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// //import 'package:skp/common/apidata.dart';
// import 'dart:convert' as JSON;

// // import 'package:skp/common/config.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path_provider/path_provider.dart';
// // import 'package:skp/modules/berita/screen/detailBeritaScreen.dart';
// // import 'package:skp/modules/kelas/screen/detailKelasScreenVideo.dart';
// // import 'package:skp/modules/kelas/screen/detailKelasScreenWebinar.dart';
// // import 'package:skp/modules/notification/model/notification_model.dart';
// // import 'package:skp/modules/pembayaran/screen/pembayaranScreen.dart';
// // import 'package:skp/service/DatabaseHelper.dart';
// import 'package:new_payrightsystem/utils/service/DatabaseHelper.dart';
// import 'package:new_payrightsystem/utils/config.dart';

// class NotificationService {
//   final GlobalKey<NavigatorState> navigatorKey =
//       new GlobalKey<NavigatorState>();
//   final firebaseMessaging = FirebaseMessaging();
//   final controllerTopic = TextEditingController();
//   String token;
//   bool isSubscribed = false;
//   var databaseHelper = new DatabaseHelper();

//   ConfigClass configClass = new ConfigClass();
//   var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   static final NotificationService _singleton = NotificationService._internal();

//   factory NotificationService() {
//     return _singleton;
//   }

//   NotificationService._internal() {
//     initializeFcmWithImage();
//   }
//   Future onSelectNotification(String dataPayLoad) async {
//     print("Payload : $dataPayLoad");
//     var extractdataPayload = JSON.jsonDecode(dataPayLoad);
//     Map<String, dynamic> dataContentNotifikasi = extractdataPayload;
//     var dbClient = await databaseHelper.db;
//     await dbClient.rawQuery(
//         "update notifikasi set status = 'read' where id = " +
//             dataContentNotifikasi['id_notifikasi'].toString() +
//             "  ");

//   //   if (dataContentNotifikasi['jenis_notifikasi'] == "KELAS BARU") {
//   //     if (dataContentNotifikasi['content_type'] == '1') {
//   //       navigatorKey
//   //         ..currentState.push(new MaterialPageRoute(
//   //           builder: (BuildContext context) => new DetailKelasScreenVideo(
//   //               dataContentNotifikasi['id'].toString()),
//   //         ));
//   //       // } else if (dataContentNotifikasi['content_type'] == '2') {
//   //       //   navigatorKey
//   //       //     ..currentState.push(new MaterialPageRoute(
//   //       //       builder: (BuildContext context) => new DetailKelasScreenWebinar(
//   //       //           dataContentNotifikasi['id'].toString()),
//   //       //     ));
//   //     }
//   //   // } else if (dataContentNotifikasi['jenis_notifikasi'] == "BERITA BARU") {
//   //   //   navigatorKey
//   //   //     ..currentState.push(new MaterialPageRoute(
//   //   //       builder: (BuildContext context) =>
//   //   //           new DetailBeritaScreen(dataContentNotifikasi['id'].toString()),
//   //   //     ));
//   //   // } else if (dataContentNotifikasi['jenis_notifikasi'] == "PAYMENT SUCCESS") {
//   //   //   navigatorKey
//   //   //     ..currentState.push(new MaterialPageRoute(
//   //   //       builder: (BuildContext context) => new PembayaranScreen(),
//   //   //     ));
//   //   // }
//   // }

//   Future<String> _downloadAndSaveFile(String url, String fileName) async {
//     final Directory directory = await getApplicationDocumentsDirectory();
//     final String filePath = '${directory.path}/$fileName';
//     final http.Response response = await http.get(url);
//     final File file = File(filePath);
//     await file.writeAsBytes(response.bodyBytes);
//     return filePath;
//   }

//   void initializeFcmWithImage() async {
//     var initializationSettingsAndroid = AndroidInitializationSettings('logo');
//     var initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: onSelectNotification);
//     firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         final DateTime now = DateTime.now();
//         final DateFormat formatTanggal = DateFormat('yyyy-MM-dd');
//         final DateFormat formatJam = DateFormat('H:m');
//         final String tanggal = formatTanggal.format(now);
//         final String jam = formatJam.format(now);
//         if (message["data"]["jenis_notifikasi"].toString() == "KELAS BARU") {
//           var dataNotifikasi = new NotifikasiModel(
//             message["data"]["id"].toString(),
//             message['data']['title'].toString(),
//             message['data']['body'].toString(),
//             tanggal.toString(),
//             jam,
//             message["data"]["jenis_notifikasi"].toString(),
//             "unread",
//             message["data"]["content_type"].toString(),
//           );
//           databaseHelper.saveNotification(dataNotifikasi);
//         } else {
//           var dataNotifikasi = new NotifikasiModel(
//             message["data"]["id"].toString(),
//             message['data']['title'].toString(),
//             message['data']['body'].toString(),
//             tanggal.toString(),
//             jam,
//             message["data"]["jenis_notifikasi"].toString(),
//             "unread",
//             "",
//           );
//           databaseHelper.saveNotification(dataNotifikasi);
//         }

//         var dbClient = await databaseHelper.db;
//         List<Map> getMaxData =
//             await dbClient.rawQuery('SELECT max(id) FROM notifikasi');
//         int idNotifikasi = int.parse(getMaxData[0]['max(id)'].toString());

//         print('onMessage: $message');
//         if (message["data"]["jenis_notifikasi"].toString() == "KELAS BARU") {
//           String titleNotifikasi = message['data']['title'];
//           String bodyNotifikasi = message['data']['body'];
//           String payload = '{ "id_notifikasi" : "' +
//               idNotifikasi.toString() +
//               '", "id" : "' +
//               message["data"]["id"] +
//               '" , "content_type" : "' +
//               message["data"]["content_type"] +
//               '", "jenis_notifikasi" : "' +
//               message["data"]["jenis_notifikasi"] +
//               '" }';
//           var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//             "SKP-LMS",
//             "SKP-LMS",
//             'your channel description',
//             importance: Importance.max,
//             priority: Priority.high,
//             styleInformation: BigTextStyleInformation(''),
//           );
//           var platformChannelSpecifics =
//               NotificationDetails(android: androidPlatformChannelSpecifics);
//           await flutterLocalNotificationsPlugin.show(idNotifikasi,
//               titleNotifikasi, bodyNotifikasi, platformChannelSpecifics,
//               payload: payload);
//         } else if (message["data"]["jenis_notifikasi"].toString() ==
//             "BERITA BARU") {
//           String titleNotifikasi = message['data']['title'];
//           String bodyNotifikasi = message['data']['body'];
//           String payload = '{ "id_notifikasi" : "' +
//               idNotifikasi.toString() +
//               '", "id" : "' +
//               message["data"]["id"] +
//               '", "jenis_notifikasi" : "' +
//               message["data"]["jenis_notifikasi"] +
//               '" }';
//           var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//             "SKP-LMS",
//             "SKP-LMS",
//             'your channel description',
//             importance: Importance.max,
//             priority: Priority.high,
//             styleInformation: BigTextStyleInformation(''),
//           );
//           var platformChannelSpecifics =
//               NotificationDetails(android: androidPlatformChannelSpecifics);
//           await flutterLocalNotificationsPlugin.show(idNotifikasi,
//               titleNotifikasi, bodyNotifikasi, platformChannelSpecifics,
//               payload: payload);
//         } else if (message["data"]["jenis_notifikasi"].toString() ==
//             "PAYMENT SUCCESS") {
//           String titleNotifikasi = message['data']['title'];
//           String bodyNotifikasi = message['data']['body'];
//           String payload = '{ "id_notifikasi" : "' +
//               idNotifikasi.toString() +
//               '", "id" : "' +
//               message["data"]["id"] +
//               '", "jenis_notifikasi" : "' +
//               message["data"]["jenis_notifikasi"] +
//               '" }';
//           var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//             "SKP-LMS",
//             "SKP-LMS",
//             'your channel description',
//             importance: Importance.max,
//             priority: Priority.high,
//             styleInformation: BigTextStyleInformation(''),
//           );
//           var platformChannelSpecifics =
//               NotificationDetails(android: androidPlatformChannelSpecifics);
//           await flutterLocalNotificationsPlugin.show(idNotifikasi,
//               titleNotifikasi, bodyNotifikasi, platformChannelSpecifics,
//               payload: payload);
//         }
//       },
//       onBackgroundMessage: myBackgroundMessageHandler,
//       onResume: (Map<String, dynamic> message) async {},
//       onLaunch: (Map<String, dynamic> message) async {
//         print('onLaunch: ');
//       },
//     );
//     // firebaseMessaging.requestNotificationPermissions(
//     //   const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true),
//     // );

//     saveDeviceToken();
//   }

//   saveDeviceToken() async {
//     String fcmToken = await firebaseMessaging.getToken();
//     this.token = fcmToken;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('sessionFireBaseToken', fcmToken);
//     print("INI TOKEN FIREBASE  $fcmToken");

//     try {
//       http.post(APIData.updateToken, body: {
//         "email": prefs.getString('sessionEmail').toString(),
//         "token": fcmToken,
//       }).then((response) async {
//         print(response.body);
//         // var extractdata = JSON.jsonDecode(response.body);
//         // Map<String, dynamic> dataContent = extractdata ;
//         // prefs.setString('sessionIdToken',dataContent['idToken'].toString());
//         // print("ID TOKEN : "+prefs.getString("sessionIdToken"));
//       });
//     } catch (e) {
//       print(e);
//     }

//     //Subscribe to FCM Topic Here
//   }

//   refreshAPIToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     try {
//       http.post(APIData.login, body: {
//         "email": prefs.getString('sessionEmail').toString(),
//         "password": prefs.getString('sessionPassword').toString(),
//       }).then((response) async {
//         print(response.body);
//         var extractdata = JSON.jsonDecode(response.body);
//         Map<String, dynamic> dataContent = extractdata;
//         if (dataContent['status'].toString() == "true") {
//           prefs.setString('sessionAPIToken', dataContent['token'].toString());
//         }
//       });
//     } catch (e) {
//       print(e);
//     }

//     //Subscribe to FCM Topic Here
//   }

//   void showNotifBackground(Map<String, dynamic> message) async {
//     final DateTime now = DateTime.now();
//     final DateFormat formatTanggal = DateFormat('yyyy-MM-dd');
//     final DateFormat formatJam = DateFormat('H:m');
//     final String tanggal = formatTanggal.format(now);
//     final String jam = formatJam.format(now);
//     if (message["data"]["jenis_notifikasi"].toString() == "KELAS BARU") {
//       var dataNotifikasi = new NotifikasiModel(
//         message["data"]["id"].toString(),
//         message['data']['title'].toString(),
//         message['data']['body'].toString(),
//         tanggal.toString(),
//         jam,
//         message["data"]["jenis_notifikasi"].toString(),
//         "unread",
//         message["data"]["content_type"].toString(),
//       );
//       databaseHelper.saveNotification(dataNotifikasi);
//     } else {
//       var dataNotifikasi = new NotifikasiModel(
//         message["data"]["id"].toString(),
//         message['data']['title'].toString(),
//         message['data']['body'].toString(),
//         tanggal.toString(),
//         jam,
//         message["data"]["jenis_notifikasi"].toString(),
//         "unread",
//         "",
//       );
//       databaseHelper.saveNotification(dataNotifikasi);
//     }
//     var dbClient = await databaseHelper.db;
//     List<Map> getMaxData =
//         await dbClient.rawQuery('SELECT max(id) FROM notifikasi');
//     int idNotifikasi = int.parse(getMaxData[0]['max(id)'].toString());

//     print('onMessage: $message');
//     if (message["data"]["jenis_notifikasi"].toString() == "KELAS BARU") {
//       String titleNotifikasi = message['data']['title'];
//       String bodyNotifikasi = message['data']['body'];
//       String payload = '{ "id_notifikasi" : "' +
//           idNotifikasi.toString() +
//           '", "id" : "' +
//           message["data"]["id"] +
//           '" , "content_type" : "' +
//           message["data"]["content_type"] +
//           '", "jenis_notifikasi" : "' +
//           message["data"]["jenis_notifikasi"] +
//           '" }';
//       var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         "SKP-LMS",
//         "SKP-LMS",
//         'your channel description',
//         importance: Importance.max,
//         priority: Priority.high,
//         styleInformation: BigTextStyleInformation(''),
//       );
//       var platformChannelSpecifics =
//           NotificationDetails(android: androidPlatformChannelSpecifics);
//       await flutterLocalNotificationsPlugin.show(idNotifikasi, titleNotifikasi,
//           bodyNotifikasi, platformChannelSpecifics,
//           payload: payload);
//     } else if (message["data"]["jenis_notifikasi"].toString() ==
//         "BERITA BARU") {
//       String titleNotifikasi = message['data']['title'];
//       String bodyNotifikasi = message['data']['body'];
//       String payload = '{ "id_notifikasi" : "' +
//           idNotifikasi.toString() +
//           '", "id" : "' +
//           message["data"]["id"] +
//           '", "jenis_notifikasi" : "' +
//           message["data"]["jenis_notifikasi"] +
//           '" }';
//       var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         "SKP-LMS",
//         "SKP-LMS",
//         'your channel description',
//         importance: Importance.max,
//         priority: Priority.high,
//         styleInformation: BigTextStyleInformation(''),
//       );
//       var platformChannelSpecifics =
//           NotificationDetails(android: androidPlatformChannelSpecifics);
//       await flutterLocalNotificationsPlugin.show(idNotifikasi, titleNotifikasi,
//           bodyNotifikasi, platformChannelSpecifics,
//           payload: payload);
//     } else if (message["data"]["jenis_notifikasi"].toString() ==
//         "PAYMENT SUCCESS") {
//       String titleNotifikasi = message['data']['title'];
//       String bodyNotifikasi = message['data']['body'];
//       String payload = '{ "id_notifikasi" : "' +
//           idNotifikasi.toString() +
//           '", "id" : "' +
//           message["data"]["id"] +
//           '", "jenis_notifikasi" : "' +
//           message["data"]["jenis_notifikasi"] +
//           '" }';
//       var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         "SKP-LMS",
//         "SKP-LMS",
//         'your channel description',
//         importance: Importance.max,
//         priority: Priority.high,
//         styleInformation: BigTextStyleInformation(''),
//       );
//       var platformChannelSpecifics =
//           NotificationDetails(android: androidPlatformChannelSpecifics);
//       await flutterLocalNotificationsPlugin.show(idNotifikasi, titleNotifikasi,
//           bodyNotifikasi, platformChannelSpecifics,
//           payload: payload);
//     }
//   }
// }

// Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
//   NotificationService notificationService = new NotificationService();
//   notificationService.showNotifBackground(message);
// }
