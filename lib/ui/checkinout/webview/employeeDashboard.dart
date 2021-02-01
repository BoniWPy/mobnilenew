import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart';
import 'package:new_payrightsystem/utils/shared_preferences.dart';

String username, api_webview_token;
var user_id;

class EmployeeDashboard extends StatefulWidget {
  @override
  _EmployeeDashboardState createState() => new _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  InAppWebViewController webView;
  String url = "";
  double progress = 0;

  @override
  void initState() {
    // getSavedData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // var username, user_id , jwt;

  // Future<String> getSavedData() async {
  //   var userinfo = await Data.getData();
  //   username = userinfo['username'];
  //   user_id  = userinfo['user_id'];
  //   return "hasil";
  // }
  String company_name,
      username,
      name,
      employee_employe_id,
      button_checkin,
      button_checkout,
      webview_token,
      jwt;
  int company_id, user_id;
  bool config_location,
      config_barcode,
      config_macaddress,
      boolValue,
      config_ess,
      config_scan;
  double setHeight = 7350.0;
  double webHeight;

  Future<String> postRequest() async {
    var userinfo = await Data.getData();
    company_name = userinfo['company_name'];
    company_id = userinfo['company_id'];
    name = userinfo['name'];
    company_id = userinfo['company_id'];
    employee_employe_id = userinfo['employee_employe_id'];
    button_checkin = userinfo['button_checkin'];
    button_checkout = userinfo['button_checkout'];

    var url = 'https://api.payright.dev/v1/api/requestotp';

    var user_id = userinfo['user_id'];

    Map data = {'user_id': user_id.toString()};

    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    var result = json.decode(response.body);
    jwt = result['message'];

    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Employee Dashboard'),
        ),
        body: FutureBuilder<String>(
          future: postRequest(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                  child: Column(children: <Widget>[
                Container(
                    padding: EdgeInsets.all(10.0),
                    child: progress < 1.0
                        ? LinearProgressIndicator(value: progress)
                        : Container()),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    child: InAppWebView(
                      // initialUrl: "https://new.payright.dev/v1/api/webviewlogin?$jwt",
                      initialUrl:
                          "https://go.payrightsystem.com/v1/api/webviewlogin?jwt=$jwt",

                      initialHeaders: {
                        'access-control-request-headers': 'payright-webview',
                      },

                      initialOptions: InAppWebViewGroupOptions(
                          crossPlatform: InAppWebViewOptions(
                        debuggingEnabled: false,
                        cacheEnabled: true,
                        javaScriptEnabled: true,
                      )),
                      onWebViewCreated: (InAppWebViewController controller) {
                        webView = controller;
                        clearSessionCache:
                        false;
                      },
                      onLoadStart:
                          (InAppWebViewController controller, String url) {
                        setState(() {
                          this.url = url;
                        });
                      },
                      onLoadStop: (InAppWebViewController controller,
                          String url) async {
                        setState(() {
                          this.url = url;
                        });
                      },
                      onProgressChanged:
                          (InAppWebViewController controller, int progress) {
                        setState(() {
                          this.progress = progress / 100;
                        });
                      },
                    ),
                  ),
                ),
              ]));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
