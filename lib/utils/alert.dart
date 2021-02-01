// import 'package:flutter/material.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';

// var alertStyle = AlertStyle(
//   animationType: AnimationType.fromTop,
//   isCloseButton: true,
//   isOverlayTapDismiss: false,
//   descStyle: TextStyle(fontWeight: FontWeight.bold),
//   animationDuration: Duration(milliseconds: 400),
//   alertBorder: RoundedRectangleBorder(
//     borderRadius: BorderRadius.circular(0.0),
//     side: BorderSide(
//       color: Colors.grey,
//     ),
//   ),
//   titleStyle: TextStyle(color: Colors.grey),
// );

// Alert(
//         context: context,
//         style: alertStyle,
//         title: "Masukan Kode OTP Anda",
//         image: Image.asset("assets/img/mobile_pay.png"),
//         buttons: [
//           DialogButton(
//             child: Text(
//               "OK",
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
//             // color: Color.fromRGBO(0, 179, 134, 1.0),
//             color: Colors.blue[300],
//             radius: BorderRadius.circular(20.0),
//           ),
//         ],
//       ).show();