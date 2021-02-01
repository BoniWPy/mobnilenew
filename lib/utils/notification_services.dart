
// import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'dart:convert' as JSON;

// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path_provider/path_provider.dart';

// class NotificationService {
//   final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
//   final firebaseMessaging = FirebaseMessaging();
//   final controllerTopic = TextEditingController();
//   String token ;
//   bool isSubscribed = false;
  
//   var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   static final NotificationService _singleton =
//       NotificationService._internal();

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
    
//   }

//   void initializeFcmWithImage() async {
//     var initializationSettingsAndroid = AndroidInitializationSettings('logo');
//     var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
//     flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: onSelectNotification);
//     firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         final DateTime now = DateTime.now();
//         final DateFormat formatTanggal = DateFormat('yyyy-MM-dd');
//         final DateFormat formatJam = DateFormat('H:m');
//         final String tanggal = formatTanggal.format(now);
//         final String jam = formatJam.format(now);
//         if(message["data"]["jenis_notifikasi"].toString() == "KELAS BARU"){
//           var dataNotifikasi = 
//           new NotifikasiModel(
//                 message["data"]["id"].toString(),
//                 message['data']['title'].toString(),
//                 message['data']['body'].toString(),
//                 tanggal.toString(),
//                 jam,
//                 message["data"]["jenis_notifikasi"].toString(),
//                 "unread",
//                 message["data"]["content_type"].toString(),
//           );
//            databaseHelper.saveNotification(dataNotifikasi);
//         }else{
//           var dataNotifikasi = 
//           new NotifikasiModel(
//                 message["data"]["id"].toString(),
//                 message['data']['title'].toString(),
//                 message['data']['body'].toString(),
//                 tanggal.toString(),
//                 jam,
//                 message["data"]["jenis_notifikasi"].toString(),
//                 "unread",
//                 "",
//           );
//          databaseHelper.saveNotification(dataNotifikasi);
          
//         }
         
//         var dbClient = await databaseHelper.db;
//         List<Map> getMaxData = await dbClient.rawQuery('SELECT max(id) FROM notifikasi');
//         int idNotifikasi = int.parse(getMaxData[0]['max(id)'].toString());

//         print('onMessage: $message');
//         if(message["data"]["jenis_notifikasi"].toString() == "KELAS BARU"){
//           String titleNotifikasi = message['data']['title'];
//           String bodyNotifikasi = message['data']['body'];
//           String payload = '{ "id_notifikasi" : "'+idNotifikasi.toString()+'", "id" : "'+message["data"]["id"]+'" , "content_type" : "'+message["data"]["content_type"]+'", "jenis_notifikasi" : "'+message["data"]["jenis_notifikasi"]+'" }';
//           var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//           "SKP-LMS","SKP-LMS", 'your channel description',
//           importance: Importance.max, priority: Priority.high,
//           styleInformation: BigTextStyleInformation(''),
//           );
//           var platformChannelSpecifics = NotificationDetails( android: androidPlatformChannelSpecifics );
//           await flutterLocalNotificationsPlugin.show(
//             idNotifikasi,
//             titleNotifikasi,
//             bodyNotifikasi,
//             platformChannelSpecifics,
//             payload: payload
//           );
//         }

//       },
//       onBackgroundMessage: myBackgroundMessageHandler,
//       onResume: (Map<String, dynamic> message) async {

//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print('onLaunch: ');
//       },
//     );
//     saveDeviceToken();
        
//   }

//   saveDeviceToken() async {
//     String fcmToken = await firebaseMessaging.getToken();
//     this.token = fcmToken;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('sessionFireBaseToken',fcmToken);
//     print("INI TOKEN FIREBASE  $fcmToken");
    
//     try {
//       http.post(APIData.updateToken, body: {
//         "email": prefs.getString('sessionEmail').toString(),
//         "token": fcmToken,
//       }).then((response) async {
//           print(response.body);
//          }
//       );
//     } catch (e) {
//       print(e);
//     }


   
//   }
  


    
//   }
 

  
 
//   void showNotifBackground(Map<String, dynamic> message) async{
//       final DateTime now = DateTime.now();
//         final DateFormat formatTanggal = DateFormat('yyyy-MM-dd');
//         final DateFormat formatJam = DateFormat('H:m');
//         final String tanggal = formatTanggal.format(now);
//         final String jam = formatJam.format(now);
//          if(message["data"]["jenis_notifikasi"].toString() == "KELAS BARU"){
//           var dataNotifikasi = 
//           new NotifikasiModel(
//                 message["data"]["id"].toString(),
//                 message['data']['title'].toString(),
//                 message['data']['body'].toString(),
//                 tanggal.toString(),
//                 jam,
//                 message["data"]["jenis_notifikasi"].toString(),
//                 "unread",
//                 message["data"]["content_type"].toString(),
//           );
//           databaseHelper.saveNotification(dataNotifikasi);
//         }else{
//           var dataNotifikasi = 
//           new NotifikasiModel(
//                 message["data"]["id"].toString(),
//                 message['data']['title'].toString(),
//                 message['data']['body'].toString(),
//                 tanggal.toString(),
//                 jam,
//                 message["data"]["jenis_notifikasi"].toString(),
//                 "unread",
//                 "",
//           );
//           databaseHelper.saveNotification(dataNotifikasi);

//         }
//         var dbClient = await databaseHelper.db;
//         List<Map> getMaxData = await dbClient.rawQuery('SELECT max(id) FROM notifikasi');
//         int idNotifikasi = int.parse(getMaxData[0]['max(id)'].toString());

//         print('onMessage: $message');
        
//           String titleNotifikasi = message['data']['title'];
//           String bodyNotifikasi = message['data']['body'];
//           String payload = '{ "id_notifikasi" : "'+idNotifikasi.toString()+'", "id" : "'+message["data"]["id"]+'" , "content_type" : "'+message["data"]["content_type"]+'", "jenis_notifikasi" : "'+message["data"]["jenis_notifikasi"]+'" }';
//           var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//           "PayrightSystem","PayrightSystem", 'your channel description',
//           importance: Importance.max, priority: Priority.high,
//           styleInformation: BigTextStyleInformation(''),
//           );
//           var platformChannelSpecifics = NotificationDetails( android: androidPlatformChannelSpecifics );
//           await flutterLocalNotificationsPlugin.show(
//             idNotifikasi,
//             titleNotifikasi,
//             bodyNotifikasi,
//             platformChannelSpecifics,
//             payload: payload
//           );
        
        
       
//   }

// }

//  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
//         NotificationService notificationService = new NotificationService();
//         notificationService.showNotifBackground(message);
//   }