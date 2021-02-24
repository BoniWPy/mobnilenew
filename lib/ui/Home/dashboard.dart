import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:new_payrightsystem/ui/checkinout/checkIn.dart';
import 'package:new_payrightsystem/ui/checkinout/checkOut.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:new_payrightsystem/utils/toggle_shared.dart';
import 'package:new_payrightsystem/utils/shared_preferences.dart';
import 'package:new_payrightsystem/utils/notification_services.dart';
import 'package:new_payrightsystem/utils/push_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:new_payrightsystem/utils/api/api.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_payrightsystem/ui/checkinout/webview/employeeDashboard.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:screen_loader/screen_loader.dart';

void setState(Null Function() param0) {}

var _visibleCheckOut, _visibleCheckIn;
enum LegendShape { Circle, Rectangle }

class dashboard extends StatefulWidget with ChangeNotifier {
  dashboard(bool visibleCheckIn, bool visibleCheckOut);
  @override
  _dashboardState createState() =>
      _dashboardState(_visibleCheckIn, _visibleCheckOut);
}

class _dashboardState extends State<dashboard> {
  void enablePlatformOverrideForDesktop() {
    if (!kIsWeb &&
        (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
      debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    }
  }

  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animationIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  int _counter = 0;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  String _homeScreenText = "Waiting for token...";
  String _messageText = "Waiting for message...";

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _dashboardState(_visibleCheckOut, _visibleCheckIn);
  //progress dialog
  ProgressDialog get pr =>
      new ProgressDialog(context, type: ProgressDialogType.Normal);

  String company_name,
      username,
      name,
      employee_employe_id,
      button_checkin,
      button_checkout,
      webview_token;
  int company_id, user_id;
  bool config_location,
      config_barcode,
      config_macaddress,
      boolValue,
      config_ess,
      config_scan;
  double setHeight = 7350.0;
  double webHeight;

  // String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;

  String greating = "Selamat Datang";

  InAppWebViewController webView;
  String url = "";
  double progress = 0;

  ValueNotifier<int> notificationCounterValueNotifer = ValueNotifier(0);

  @override
  initState() {
    super.initState();
    // print('push dipanggil');
    // PushNotificationsManager();
    // enablePlatformOverrideForDesktop();
    Future.delayed(Duration(seconds: 5)).then((onValue) {
      pr.hide();
    });

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('logo');

    var initializationSettings = new InitializationSettings();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('isi pesan nya on message ${message}');
        // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
        displayNotification(message);

        notificationCounterValueNotifer.value++;
        notificationCounterValueNotifer
            .notifyListeners(); // notify listeners here so ValueListenableBuilder will build the widget.
        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //         content: ListTile(
        //           title: Text(message['notification']['title']),
        //           image: Image.asset("assets/img/new_notification.png"),
        //           subtitle: Text(message['notification']['body']),

        //         ),
        //         actions: <Widget>[
        //           FlatButton(
        //             color: Colors.blue[200],
        //             child: Text('Tutup'),
        //             onPressed: () => Navigator.of(context).pop(),
        //           ),
        //         ],
        //       ),
        // );
        Alert(
          context: context,
          style: alertStyle,
          title: message['notification']['body'],
          image: Image.asset("assets/img/new_notification.png"),
          buttons: [
            DialogButton(
              child: Text(
                message['notification']['title'],
                style: TextStyle(
                    color: Colors.white, fontSize: 14, fontFamily: "Poppins"),
              ),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              // color: Color.fromRGBO(0, 179, 134, 1.0),
              color: Colors.blue[300],
              radius: BorderRadius.circular(20.0),
            ),
          ],
        ).show();
        // _showItemDialog(message);
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
    // _firebaseMessaging.requestNotificationPermissions(
    //     const IosNotificationSettings(sound: true, badge: true, alert: true));
    // _firebaseMessaging.onIosSettingsRegistered
    //     .listen((IosNotificationSettings settings) {
    //   print("Settings registered: $settings");
    // });
    _firebaseMessaging.getToken().then((String token) async {
      assert(token != null);
      var userinfo = await Data.getData();
      var user_id = userinfo['user_id'];
      var data = {
        'fcm': token,
        'user_id': user_id,
      };
      var res = await CallApi().postUpdateFcm(data, 'updatefcm');
      // print('token di update, $token');
      var body = json.decode(res.body);
      print('response update token, $body');
    });
  }

  Future displayNotification(Map<String, dynamic> message) async {
    print('aa');
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'Payrightsystem', 'Payrightsystem', 'your channel description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails();

    final DateTime now = DateTime.now();
    final DateFormat formatTanggal = DateFormat('yyyy-MM-dd');
    final DateFormat formatJam = DateFormat('H:m');
    final String tanggal = formatTanggal.format(now);
    final String jam = formatJam.format(now);

    await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: 'hello',
    );
  }

  Future onSelectNotification(String payload) async {
    print('ab , $payload');
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Fluttertoast.showToast(
      msg: "Notification Clicked",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    /*Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
    );*/
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    print('abc');
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Fluttertoast.showToast(
                msg: "Notification Clicked",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            },
          ),
        ],
      ),
    );
  }

  Map<String, double> dataMap = {
    "Masuk": 28,
    "Cuti": 0,
    "Alpha": 1,
    "Telat": 4,
  };

  List<Color> colorList = [
    Colors.blue[300],
    Colors.green,
    Colors.red,
    Colors.yellow,
  ];

  ChartType _chartType = ChartType.disc;
  bool _showCenterText = true;
  double _ringStrokeWidth = 32;
  double _chartLegendSpacing = 32;

  bool _showLegendsInRow = false;
  bool _showLegends = true;

  bool _showChartValueBackground = true;
  bool _showChartValues = true;
  bool _showChartValuesInPercentage = false;
  bool _showChartValuesOutside = false;

  LegendShape _legendShape = LegendShape.Circle;
  LegendPosition _legendPosition = LegendPosition.right;

  int key = 0;

  bool inVisibleButton = false;

  var buttonStatus;
  var jwt;
  // var jwt;

  Future<String> getDataButton() async {
    var visibleButton = await Button.getDataButton();
    buttonStatus = visibleButton;

    return 'hasil toglle';
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Apkah yakin anda akan keluar?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => SystemNavigator.pop(),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  // Future<String> getSavedData() async {

  // }

  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: true,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 300),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
      side: BorderSide(color: Colors.transparent),
    ),
    titleStyle: TextStyle(color: Colors.grey[800]),
  );

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
          color: Colors.black,
          fontSize: 13.0,
          fontWeight: FontWeight.w400,
          fontFamily: "Poppins"),
      messageTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 19.0,
          fontWeight: FontWeight.w600,
          fontFamily: "Poppins"),
    );

    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text("Loading"),
          onPressed: () {},
        ),
      ),
    );
  }

  //! load must be global
  void load() {
    Future.delayed(Duration(seconds: 5)).then((onValue) {
      pr.hide();
    });
  }

  Future<String> postRequest() async {
    var userinfo = await Data.getData();
    company_name = userinfo['company_name'];
    company_id = userinfo['company_id'];
    name = userinfo['name'];
    company_id = userinfo['company_id'];
    employee_employe_id = userinfo['employee_employe_id'];
    button_checkin = userinfo['button_checkin'];
    button_checkout = userinfo['button_checkout'];
    config_ess = userinfo['config_ess'];
    config_scan = userinfo['config_scan'];
    print('halow , $config_ess, $config_scan');

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

  bool showErrorPage = false;

  @override
  Widget build(BuildContext context) {
    print('confignya, $config_ess');
    print('tinggi yang ter detect , $webHeight');
    var stack = new Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 15.0, top: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // _buildIconBadge(
              //     Icons.notifications, '5', Colors.grey[100]),
            ],
          ),
          // child: new Container(
          padding: EdgeInsets.all(2),
          decoration: new BoxDecoration(
            color: Colors.grey[500],
            borderRadius: BorderRadius.circular(6),
          ),
          constraints: BoxConstraints(
            minWidth: 14,
            minHeight: 14,
          ),
        )
      ],
    );
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 3.0,
            backgroundColor: Colors.white,
            title: Image.asset(
              'assets/img/logo.png',
              width: 120.0,
              height: 120.0,
            ),
            actions: <Widget>[stack],
          ),
          body: FutureBuilder<String>(
            future: postRequest(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return StaggeredGridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  children: <Widget>[
                    _buildTile(
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(config_ess == true ? '' : greating,
                                      style:
                                          TextStyle(color: Colors.blueAccent)),
                                  Text('$name' ?? " ",
                                      style: TextStyle(color: Colors.black)),
                                  Text('$company_name' ?? ' ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.0,
                                          fontFamily: "Poppins"))
                                ],
                              ),
                              Material(
                                  color: Colors.blue[200],
                                  borderRadius: BorderRadius.circular(0.0),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child:
                                        Image.asset('assets/img/dashboard.png'),
                                  )))
                            ]),
                      ),
                    ),
                    //* kotak pertama
                    _buildTile(
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    child: Container(
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              1.0), //kotak kedua kiri
                                          child: Image.asset(
                                              'assets/img/absorbed_in.png'),
                                        ))),
                                Padding(padding: EdgeInsets.only(bottom: 5.0)),
                                Text('Absen Masuk',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17.0,
                                        fontFamily: "Poppins")),
                              ]),
                        ), onTap: () {
                      print('button_checkin ,$button_checkin');
                      if (button_checkin == 'visible' ||
                          button_checkin == 'invisble') {
                        Navigator.of(context).push(
                            // MaterialPageRoute(builder: (_) => ScanScreenIn()));
                            MaterialPageRoute(
                                builder: (_) => EmployeeDashboard()));
                      } else {
                        print('tombol cekin TIDAK bisa di click');
                      }
                    }),
                    //* kotak pertama kanan
                    _buildTile(
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    child: Container(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: EdgeInsets.all(1.0),
                                          child: Image.asset(
                                              'assets/img/going_home.png'),
                                        ))),
                                Padding(padding: EdgeInsets.only(bottom: 5.0)),
                                Text('Absen Keluar',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17.0,
                                        fontFamily: "Poppins"))
                                //style: GoogleFonts.lato(fontStyle: FontStyle.italic)),
                              ]),
                        ), onTap: () {
                      print('button_checkout, $button_checkout');
                      if (button_checkout == 'visible') {
                        print('tombil cekout bisa di click');
                        print(button_checkout);
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => ScanScreenOut()));
                      } else {
                        print('tombol Cekout TIDAK bisa di click');
                      }
                    }),
                    //* kotak kedua webview

                    _buildWebview(Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Stack(children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(0.0),
                          //           child:
                          // new Image.network('https://blog.hubspot.com/hubfs/HTTP-500-Internal-Server-Error.jpg' , width: 400.0, height: 400.0,),
                          child: InAppWebView(
                            initialUrl:
                                "https://go.payrightsystem.com/v1/api/webviewlogin?jwt=$jwt",
                            // "https://new.payright.dev/v1/api/av/webviewlogin?jwt=$jwt",

                            initialHeaders: {
                              'access-control-request-headers':
                                  'payright-webview',
                              // 'content-type' :'application/x-www-form-urlencoded'
                            },
                            initialOptions: InAppWebViewGroupOptions(
                                crossPlatform: InAppWebViewOptions(
                              // debuggingEnabled: false,
                              cacheEnabled: true,
                              javaScriptEnabled: true,
                            )),
                            onWebViewCreated:
                                (InAppWebViewController controller) {
                              clearSessionCache:
                              false;
                              webView = controller;
                            },
                            onLoadError: (InAppWebViewController controller,
                                String url, int i, String s) async {
                              print('CUSTOM_HANDLER atas: $i, $s');
                              webView.loadFile(
                                  assetFilePath: "assets/error.html");
                            },
                            /** instead of printing the console message i want to render a static page or display static message **/
                            // showError();

                            onLoadHttpError: (InAppWebViewController controller,
                                String url, int i, String s) async {
                              var response_code = i.toString();
                              print(
                                  'ini interger nya, $i, ini response code nya, $response_code');
                              print('CUSTOM HANDLER bawah: $i, $s');
                              webView.loadFile(
                                  assetFilePath: "assets/error.html");
                              if (response_code == '404') {
                                print('masuk ke kondisi error');
                              }
                              showError();
                            },

                            onLoadStart: (InAppWebViewController controller,
                                String url) {
                              setState(() {
                                this.url = url;
                              });
                              pr.show();
                              if (url ==
                                      'https://go.payrightsystem.com/home/notloggedin' ||
                                  url ==
                                      'https://go.payrightsystem.com/login') {
                                // Navigator.of(context).pushReplacementNamed("dashboard");
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            dashboard(true, true)));
                                print('reload lagi');
                              }
                              ;
                            },
                            onLoadStop: (InAppWebViewController controller,
                                String url) async {
                              controller.evaluateJavascript(
                                  source:
                                      '''(() => { return document.body.scrollHeight;})()''').then(
                                  (value) {
                                if (value == null || value == '') {
                                  return;
                                }
                                webHeight = double.parse('$value');

                                setState(() {
                                  webHeight = double.parse('$value');
                                });
                                print('isi webheight, $webHeight');
                              });
                              Future.delayed(Duration(seconds: 1))
                                  .then((onValue) {
                                pr.hide();
                              });
                              setState(() {
                                this.url = url;
                                print('on load stop , ${this.url}');
                              });

                              if (url ==
                                      'https://go.payrightsystem.com/home/notloggedin' ||
                                  url ==
                                      'https://go.payrightsystem.com/login') {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            dashboard(true, true)));
                              }
                              ;
                            },
                            onProgressChanged:
                                (InAppWebViewController controller,
                                    int progress) {
                              setState(() {
                                this.progress = progress / 100;
                              });
                              print('setelan tinggingingya , $webHeight');
                            },
                          ),
                        ),
                        showErrorPage
                            ? Center(
                                child: Container(
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  height: double.infinity,
                                  width: double.infinity,
                                  child: Text('Page failed to open (WIDGET)'),
                                ),
                              )
                            : SizedBox(height: 0, width: 0),
                      ]),
                    )),
                  ],
                  staggeredTiles: [
                    StaggeredTile.extent(2, 110.0),
                    StaggeredTile.extent(1, 150.0),
                    StaggeredTile.extent(1, 150.0),
                    StaggeredTile.extent(
                        2, webHeight != null ? webHeight : setHeight),
                  ],
                );
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.grey[350]),
                ));
              }
            },
          ),
        ));
  }

  @override
  Widget backButton(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            "On Back pressed",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        body: new Center(
          child: new Text("Home Page"),
        ),
      ),
    );
  }

  Widget _buildTile(Widget child, {Function() onTap, Alert onPressed}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        // shadowColor: Color(0x802196F3),
        // shadowColor: Color(0x00000000),
        shadowColor: Color.fromRGBO(69, 65, 78, 0.08),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                    Alert(
                      context: context,
                      style: alertStyle,
                      title: "Under Maintenance",
                      image: Image.asset("assets/img/mobile_pay.png"),
                      buttons: [
                        DialogButton(
                          child: Text(
                            "OK",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "Poppins"),
                          ),
                          onPressed: () =>
                              Navigator.of(context, rootNavigator: true).pop(),
                          // color: Color.fromRGBO(0, 179, 134, 1.0),
                          color: Colors.blue[300],
                          radius: BorderRadius.circular(20.0),
                        ),
                      ],
                    );
                  },
            child: child));
  }

  Widget _buildWebview(Widget child, {Function() onTap, Alert onPressed}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        //shadowColor: Color(0x802196F3),
        shadowColor: Color(0x00000000),
        //shadowColor: Color.fromRGBO(69, 65, 78, 0.08),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                    Alert(
                      context: context,
                      style: alertStyle,
                      title: "Under Maintenance",
                      image: Image.asset("assets/img/mobile_pay.png"),
                      buttons: [
                        DialogButton(
                          child: Text(
                            "OK",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "Poppins"),
                          ),
                          onPressed: () =>
                              Navigator.of(context, rootNavigator: true).pop(),
                          // color: Color.fromRGBO(0, 179, 134, 1.0),
                          color: Colors.blue[300],
                          radius: BorderRadius.circular(20.0),
                        ),
                      ],
                    );
                  },
            child: child));
  }

  Widget iconNotifications() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          print("Button Notif Click");
        },
        tooltip: "Pemberitahuan",
        child: Icon(Icons.notifications),
      ),
    );
  }

  Widget buttonToggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: "Toggle",
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animationIcon,
        ),
      ),
    );
  }

  Widget _buildIconBadge(
    IconData icon,
    String badgeText,
    Color badgeColor,
  ) {
    return Stack(
      children: <Widget>[
        Icon(
          icon,
          size: 25.0,
        ),
        Positioned(
            top: 4.0,
            right: 4.0,
            child: Container(
              padding: EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
              ),
              constraints: BoxConstraints(
                minWidth: 10.0,
                minHeight: 10.0,
              ),
              child: Center(
                child: Text(
                  badgeText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins"),
                ),
              ),
            ))
      ],
    );
  }

  void showError() {
    setState(() {
      print('show error dipanggil');
      showErrorPage = true;
    });
  }

  void hideError() {
    setState(() {
      showErrorPage = false;
    });
  }

  void animate() {
    if (!isOpened)
      _animationController.forward();
    else
      _animationController.reverse();
    isOpened = !isOpened;
  }

  // List<staggeredTile> staggeredTiles = [
  //     StaggeredTile.extent(2, 110.0),
  //     StaggeredTile.extent(1, 150.0),
  //     StaggeredTile.extent(1, 150.0) ,
  // ];

  // List<staggeredTile> staggeredTiles2 = [
  //     StaggeredTile.extent(2, 110.0),
  //     StaggeredTile.extent(1, 150.0),
  //     StaggeredTile.extent(1, 150.0),
  //      StaggeredTile.extent(2, 2000.0),
  //     // 'StaggeredTile.extent("2, $webHeight != null ? $webHeight : $setHeight")',
  // ];

  @override
  void dispose() {
    _animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
