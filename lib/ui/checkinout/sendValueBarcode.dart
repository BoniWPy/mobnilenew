import 'dart:async';
import 'dart:convert';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:new_payrightsystem/ui/Home/dashboard.dart';
import 'package:new_payrightsystem/ui/Home/webviewMain.dart';
import 'package:new_payrightsystem/utils/toggle_shared.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:new_payrightsystem/ui/checkinout/checkIn.dart';
import 'package:new_payrightsystem/ui/checkinout/checkOut.dart';
import 'package:new_payrightsystem/utils/shared_preferences.dart';
import 'package:new_payrightsystem/utils/dialogs.dart';
import 'package:new_payrightsystem/utils/alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_payrightsystem/ui/Home/sampleList.dart';

//@imammtq create class for get response from RESTAPI
class SendingBarcode {
  final String status;
  final String message;

  SendingBarcode({this.status, this.message});

  factory SendingBarcode.fromJson(Map<String, dynamic> json) {
    return SendingBarcode(
      // status: json['status'],
      status: "guds brow!!!",
      message: json['message'],
    );
  }
}

//@imammtq END
String tipeAbsen;

int employee_id,
    company_id,
    user_id,
    employee_employ_id,
    config_location,
    config_barcode,
    config_macaddress,
    company_config_id;

var company_name,
    name,
    button_checkin,
    button_checkout,
    _visibleCheckIn,
    _visibleCheckOut;

String token;

Future<String> savedataCheckIn() async {
  var userinfo = await Data.getData();

  var _userinfo = {
    'token': token,
    'user_id': user_id,
    'name': name,
    'company_name': company_name,
    'company_id': company_id,
    'employee_id': employee_id,
    'employee_employ_id': employee_employ_id,
    'company_config_id': company_config_id,
    'config_location': config_location,
    'config_barcode': config_barcode,
    'config_macaddress': config_macaddress,
    'button_checkin': 'invisible',
    'button_checkout': 'visible',
  };
  Data.saveData(_userinfo);
}

Future<String> savedataCheckOut() async {
  var userinfo = await Data.getData();
  var _userinfo = {
    'token': token,
    'user_id': user_id,
    'name': name,
    'company_name': company_name,
    'company_id': company_id,
    'employee_id': employee_id,
    'employee_employ_id': employee_employ_id,
    'company_config_id': company_config_id,
    'config_location': config_location,
    'config_barcode': config_barcode,
    'config_macaddress': config_macaddress,
    'button_checkin': 'visible',
    'button_checkout': 'invisible',
  };
  print(_userinfo);
  Data.saveData(_userinfo);
}

var alertStyle = AlertStyle(
  animationType: AnimationType.fromTop,
  isCloseButton: true,
  isOverlayTapDismiss: false,
  descStyle: TextStyle(fontWeight: FontWeight.bold),
  animationDuration: Duration(milliseconds: 400),
  alertBorder: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(0.0),
    side: BorderSide(
      color: Colors.grey,
    ),
  ),
  titleStyle: TextStyle(color: Colors.grey),
);
var status;

Future<void> alertSuccessFailed(
    context, tipeAbsen, status, successFailed) async {
  chooseImage() {
    if (successFailed == "Success") {
      var imageName = 'verified.png';
      print(status);

      return imageName;
    } else {
      var imageName = 'cancel.png';
      print(status);
      return imageName;
    }
  }

  var image = chooseImage();

  await Alert(
    context: context,
    style: alertStyle,
    title: "Status Absen $tipeAbsen $status",
    image: Image.asset("assets/img/$image"),
    buttons: [
      DialogButton(
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () async {
          Navigator.of(context, rootNavigator: true).pop();
          // Navigator.of(context, rootNavigator: true).pop();
        },

        // color: Color.fromRGBO(0, 179, 134, 1.0),
        color: Colors.blue[300],
        radius: BorderRadius.circular(20.0),
      ),
    ],
  ).show();
  Navigator.pop(context);
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(builder: (context) => dashboard(true, true)),
  // );
}

Future<String> getSavedData() async {
  var userinfo = await Data.getData();

  token = userinfo['token'];
  company_name = userinfo['company_name'];
  company_id = userinfo['company_id'];
  user_id = userinfo['user_id'];
  name = userinfo['name'];
  employee_id = userinfo['employee_id'];
  employee_employ_id = userinfo['employee_employ_id'];
  config_location = userinfo['config_location'];
  config_barcode = userinfo['config_barcode'];
  config_macaddress = userinfo['config_macaddress'];
  company_config_id = userinfo['company_config_id'];
  button_checkin = userinfo['button_checkin'];
  button_checkout = userinfo['button_checkout'];

  return '_userinfo';
}

//@imammtq handling response
Future<SendingBarcode> post(
    String tipeAbsen, BuildContext context, String url, var body) async {
  var token = body['token'];
  print('data absen yang dikirim , $body , $url');

  return await http.post(Uri.encodeFull(url), body: body, headers: {
    "Accept": "application/json",
    'Authorization': token,
  }).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode > 400 || json == null) {
      var status = 'Gagal';
      if (tipeAbsen == 'Keluar') {
        alertSuccessFailed(context, tipeAbsen, status, 'Failed');
      } else {
        alertSuccessFailed(context, tipeAbsen, status, 'Failed');
      }
      throw new Exception("Error while fetching data gais");
    } else if (statusCode == 201) {
      var status = "Sukses";
      if (tipeAbsen == 'Keluar') {
        alertSuccessFailed(context, tipeAbsen, status, 'Success');
        getSavedData();
        savedataCheckOut();
      } else {
        alertSuccessFailed(context, tipeAbsen, status, 'Success');
        getSavedData();
        savedataCheckIn();
      }
      return SendingBarcode.fromJson(json.decode(response.body));
    } else if (statusCode < 200) {
      print('error koneksi');
    }
  });
}
//@imamtmq END handling response
