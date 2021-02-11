import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/rendering.dart';
import 'package:new_payrightsystem/ui/Home/dashboard.dart';
import 'package:new_payrightsystem/ui/checkinout/sendValueBarcode.dart';
import 'package:geolocator/geolocator.dart';
import './sendValueBarcode.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:new_payrightsystem/utils/shared_preferences.dart';
import 'package:android_intent/android_intent.dart';

//TODO: sebelum mengklik absen masuk, location harus di dapat terlebih dahulu

void setState(Null Function() param0) {}

final String url = "https://api.payright.dev/v1/apiMobile/checkinout";

int user_id;
int company_id;

var config_barcode, config_location, config_macaddress;

String tipeAbsen = "Keluar";

class ScanScreenOut extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreenOut> {
  var result = "";

  //FIXME: some unsuseful script has been delete.

  @override
  initState() {
    new Timer(new Duration(milliseconds: 3000), () {
      getSavedData();
      _checkGps();
    });
    super.initState();
  }

  ProgressDialog get pr =>
      new ProgressDialog(context, type: ProgressDialogType.Normal);

  int employee_id, company_id, user_id, employee_employ_id;

  int config_location, config_barcode, config_macaddress, company_config_id;

  var company_name,
      name,
      button_checkin,
      button_checkout,
      _visibleCheckIn,
      _visibleCheckOut;

  var checktime_type = "check_out";

  double lat, long;
  GeolocationStatus vargeolocationStatus;

  var tappedYes = false;

  getSavedData() async {
    var userinfo = await Data.getData();
    token = userinfo['token'];
    company_name = userinfo['company_name'];
    user_id = userinfo['user_id'];
    employee_id = userinfo['employee_id'];
    company_id = userinfo['company_id'];
    employee_employ_id = userinfo['employee_employ_id'];
    config_location = userinfo['config_location'];
    config_barcode = userinfo['config_barcode'];
    config_macaddress = userinfo['config_macaddress'];
    company_config_id = userinfo['company_config_id'];
    button_checkin = userinfo['button_checkin'];
    button_checkout = userinfo['button_checkout'];

    print('configlocatoin di getsaved, $config_location');
  }

  Future _checkGps() async {
    var userinfo = await Data.getData();
    config_location = userinfo['config_location'];
    config_barcode = userinfo['config_barcode'];
    config_macaddress = userinfo['config_macaddress'];
    company_config_id = userinfo['company_config_id'];

    print('config ocation di futuer _checkGps, $config_location');

    if (config_location == 0) {
      var isGpsEnabled = true;
      long = 0.0;
      lat = 0.0;
      scan(lat, long);
    } else {
      Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
      GeolocationStatus geolocationStatus =
          await Geolocator().checkGeolocationPermissionStatus();

      //TODO: this problem, the geolocationStatus Granted but, cant get the long and lang
      // masybe next task to allow permision for get location

      var isGpsEnabled = await Geolocator().isLocationServiceEnabled();

      if (isGpsEnabled == false) {
        if (Theme.of(context).platform == TargetPlatform.android) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Can't get current location"),
                content:
                    const Text('Please make sure you enable GPS and try again'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      final AndroidIntent intent = AndroidIntent(
                          action: 'android.settings.LOCATION_SOURCE_SETTINGS');
                      intent.launch();
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        _getUserLocation(isGpsEnabled);
        //print('dari _getGPS ke _getUserLocation');
      }
    }
  }

  _getUserLocation(isGpsEnabled) async {
    //force if config_location = 0
    if (config_location == 0) {
      long = 0.0;
      lat = 0.0;
      scan(lat, long);
    } else {
      if (isGpsEnabled = true) {
        //print('masuk lagi di isGps = true');
        Geolocator geolocator = Geolocator();
        Position userLocation;

        Position position = await Geolocator().getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation);

        lat = position.latitude;
        long = position.longitude;

        double distanceInMeters = await Geolocator()
            .distanceBetween(107.597749, -6.904357, lat, long);
        //logt lang disdik jabar -6.904357,107.597749
        //logt lat tabulasi -6.904357, 107.597749
        //     print("jarak dalam meter ${distanceInMeters}");
        //TODO: *Harvesine = give condition if out of location.
        // print('cek value');

        if (long == null) {
          print('lokasi belom nemu euy, jadi loading lagi');
          pr.show();
          _getUserLocation(isGpsEnabled);
        } else if (long != null) {
          print('loading di tutup karena lokasi udah dapet');
          pr.hide();
          Future.delayed(Duration(seconds: 1)).then((onValue) {
            scan(lat, long);
          });
        }
      } else {
        print("location service not enabled, di else line 154");
        // _checkGps();
      }
    }
  } //async

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Finding Location..'),
        ),
        body: Center(child: Image.asset('assets/animations/track.gif')));
    // body: new Center(
    //   child: new Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.stretch,
    //     children: <Widget>[
    //       Padding(
    //         padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    //         child: RaisedButton(
    //           color: Colors.blue[200],
    //           textColor: Colors.white,
    //           splashColor: Colors.blueGrey,
    //           onPressed: scan, //alert,//scan, // _Alert,
    //           //child: const Text('Absen Masuk'),
    //           child: Image.asset('assets/img/location_tracking.png'),
    //         ),
    //       ),

    //       //#/@imammtq 180919 The readable string from qr code disabled,
    //       Padding(
    //         padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    //       )
    //     ],
    //   ),
    // ));
  }

  @override
  Widget loading(BuildContext context) {
    pr.style(
      message: 'Menunggu...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text("Loading Get Location"),
          onPressed: () {},
        ),
      ),
    );
  }

  Future scan(lat, long) async {
    pr.hide();
    if (config_location == 1 && long == null) {
      // print("masuk ke scan..long lat tidak nemu");
      // print('lokasi tidak nemu jadi loading dulu');
      // pr.show();
      Future.delayed(Duration(seconds: 10)).then((onValue) {
        print('loading ditutup');
        Future.delayed(Duration(seconds: 1)).then((onValue) {
          pr.hide();
        });
        Future.delayed(Duration(seconds: 1)).then((onValue) {
          alert(context);
        });
      });
      print('sambil loading BACKEND');
      _checkGps();
      var isGpsEnabled = true;
      print('manggil algi _getuserlocation');
      _getUserLocation(isGpsEnabled);
    } else {
      print('config bargode => , $config_barcode');
      if (config_barcode != null) {
        print('config barcode false');
        // pr.show();
        // Future.delayed(Duration(seconds: )).then((onValue) {
        //             pr.hide();

        //           });

        try {
          print('kalo masuk kesini config barcode = 0');
          // var result = await BarcodeScanner.scan();
          // setState(() => this.result = result as String);
          if (config_location != 0) {
            pr.show();
            pr.hide();
          }
          FutureBuilder(
              future: post(
                tipeAbsen,
                context,
                url,
                {
                  "token": '${token}',
                  "user_id": '${user_id}',
                  "company_id": '${company_id}',
                  "employee_id": '${employee_id}',
                  "employee_employ_id": '${employee_employ_id}',
                  "latitude": '${long}',
                  "longitude": '${lat}',
                  "company_config_id": '${company_config_id}',
                  "checktime_type": checktime_type,
                },
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Future.delayed(Duration(seconds: 1)).then((onValue) {
                    pr.hide();
                  });
                  print('mestinya di tutup');

                  return Text(snapshot.data.status);
                } else if (snapshot.hasError) {
                  Future.delayed(Duration(seconds: 1)).then((onValue) {
                    pr.hide();
                  });
                  print('mestinya di tutup');
                  return Text("${snapshot.error}");
                }
                print('mestinya di tutup');
                pr.hide();
                return null;
              });
          pr.hide();
        } catch (e) {
          Future.delayed(Duration(seconds: 1)).then((onValue) {
            pr.hide();
          });
          // setState(() => this.result = 'Unknown error: $e');
        }
      }
    }
  }

  Future alert(context) async {
    AlertDialog alertDialog = new AlertDialog(
      content: new Container(
        height: 300.0,
        child: new Center(
          child: Image.asset("assets/img/error_location.png"),
        ),
      ),
    );
    showDialog(context: context, child: alertDialog);
  }
}
