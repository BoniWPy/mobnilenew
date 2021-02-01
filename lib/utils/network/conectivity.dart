// import 'dart:async';
// import 'dart:io';
// import 'package:connectivity/connectivity.dart';
// import 'package:new_payrightsystem/main.dart';

// class MyConnectivity {

//   Connectivity connectivity = Connectivity();

//   void checkConnectivity() async {
//     var connectivityResult = await connectivity.checkConnectivity();
//     var conn = getConnectionValue(connectivityResult);
//   }

//   Future getConnectionValue(var connectivityResult) async {
//     String status = '';

//     try {
//       final result = await InternetAddress.lookup('google.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         print('connected');
//         switch (connectivityResult) {
//       case ConnectivityResult.mobile:
//         status = 'Mobile';
//         break;
//       case ConnectivityResult.wifi:
//         status = 'Wi-Fi';
//         break;
//       case ConnectivityResult.none:
//         status = 'None';
//         break;
//       default:
//         status = 'None';
//         break;
//     }

//     return status;
//       }
//     } on SocketException catch (_) {
//       print('not connected');
//     }

//     switch (connectivityResult) {
//       case ConnectivityResult.mobile:
//         status = 'Mobile';
//         break;
//       case ConnectivityResult.wifi:
//         status = 'Wi-Fi';
//         break;
//       case ConnectivityResult.none:
//         status = 'None';
//         break;
//       default:
//         status = 'None';
//         break;
//     }

//     return status;
//   }

//   StreamController controller = StreamController.broadcast();
//   Stream get myStream => controller.stream;

//   void initialise() async {
//     ConnectivityResult result = await connectivity.checkConnectivity();
//     _checkStatus(result);
//     connectivity.onConnectivityChanged.listen((result) {
//       _checkStatus(result);
//     });
//   }

//   void _checkStatus(ConnectivityResult result) async {
//     bool isOnline = false;
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         isOnline = true;
//       } else
//         isOnline = false;
//     } on SocketException catch (_) {
//       isOnline = false;
//     }

//     controller.sink.add({result: isOnline});
//   }

//   void disposeStream() => controller.close();
// }
