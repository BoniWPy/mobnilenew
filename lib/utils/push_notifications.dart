// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:new_payrightsystem/utils/shared_preferences.dart';

// class PushNotificationsManager {

//   PushNotificationsManager._();

//   factory PushNotificationsManager() => _instance;

//   static final PushNotificationsManager _instance = PushNotificationsManager._();

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   bool _initialized = false;

//   Future<void> init() async {
//     if (!_initialized) {
//   print('ke class firebase');

//       // For iOS request permission first.
//       _firebaseMessaging.requestNotificationPermissions();
//       _firebaseMessaging.configure();

//       // For testing purposes print the Firebase Messaging token
//       String token = await _firebaseMessaging.getToken();

//       var userInfo = {
//         'fcm' : token,
//       };
//       Data.saveData(userInfo);
//       print('fcm di update di shared');

//       print("FirebaseMessaging token: $token");

//       _initialized = true;
//     }
//   }
// }
