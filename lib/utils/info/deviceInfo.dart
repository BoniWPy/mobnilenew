// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:connectivity/connectivity.dart';

// var connectivityResult = await (Connectivity().checkConnectivity());
// if (connectivityResult == ConnectivityResult.mobile) {
//  print("using mobileDevices");
// } else if (connectivityResult == ConnectivityResult.wifi) {
//   print("using WifiConnection");
// }

// var wifiBSSID = await (Connectivity().getWifiBSSID());
// var wifiIP = await (Connectivity().getWifiIP());
// var wifiName = await (Connectivity().getWifiName());

// print(wifiBSSID);


import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:imei_plugin/imei_plugin.dart';

 bool mounted ;



class _GetImeiState {
  String _platformImei = 'Unknown';
  String uniqueId = "Unknown";

 

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformImei;
    String idunique;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      List<String> multiImei = await ImeiPlugin.getImeiMulti();
      print(multiImei);
      idunique = await ImeiPlugin.getId();
    } on PlatformException {
      platformImei = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    
  }

}
