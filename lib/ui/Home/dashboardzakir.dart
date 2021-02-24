import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:new_payrightsystem/data/DatabaseHelper.dart';
import 'package:new_payrightsystem/data/model/NotifikasiModel.dart';
import 'package:new_payrightsystem/ui/checkinout/checkIn.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:badges/badges.dart';
import 'package:new_payrightsystem/utils/notification/notification_page.dart';
import 'package:new_payrightsystem/ui/Home/webviewMain.dart';

import 'package:new_payrightsystem/ui/checkinout/checkOut.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:new_payrightsystem/utils/toggle_shared.dart';
import 'package:new_payrightsystem/utils/notification_page.dart';
import 'package:new_payrightsystem/utils/shared_preferences.dart';
// import 'package:new_payrightsystem/utils/notification_services.dart';
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
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:new_payrightsystem/utils/customColors.dart';
import 'package:new_payrightsystem/utils/shared_preferences.dart';
import 'package:new_payrightsystem/utils/slide.dart';
import 'package:new_payrightsystem/utils/fab.dart';
import 'package:new_payrightsystem/utils/appBars.dart';
import 'package:new_payrightsystem/utils/api/api.dart';
import 'package:new_payrightsystem/utils/config.dart';

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

import 'package:new_payrightsystem/utils/notification/animated_fab.dart';
import 'package:new_payrightsystem/utils/notification/diagonal_clipper.dart';
import 'package:new_payrightsystem/utils/notification/list_model.dart';
import 'package:new_payrightsystem/utils/notification/initial_list.dart';
import 'package:new_payrightsystem/utils/notification/task_row.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void setState(Null Function() param0) {}

var _visibleCheckOut, _visibleCheckIn;
enum LegendShape { Circle, Rectangle }

class dashboard extends StatefulWidget with ChangeNotifier {
  dashboard(bool visibleCheckIn, bool visibleCheckOut);
  @override
  _dashboardState createState() =>
      _dashboardState(_visibleCheckIn, _visibleCheckOut);
}

class _dashboardState extends State<dashboard> with TickerProviderStateMixin {
  void enablePlatformOverrideForDesktop() {
    if (!kIsWeb &&
        (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
      debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    }
  }

  //loader ngikutin paypal
  bool showAddNote = false;
  bool showPageLoader = false;
  bool showSpinner = false;
  bool showChecked = false;
  AnimationController animationController;
  //end loader ngikutin paypal

  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animationIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  List<Widget> listViewHistory = [];
  int _counter = 0;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

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
      button_checkout;

  var totalMessage;
  int company_id, user_id;
  bool config_location, config_barcode, config_macaddress, boolValue;
  bool config_ess = false;
  bool config_scan = true;

  double setHeight = 2000.0;
  double webHeight;

  final DateTime now = DateTime.now();

  // String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;

  String greating = "Selamat Datang";

  InAppWebViewController webView;
  String url = "";
  double progress = 0;

  ValueNotifier<int> notificationCounterValueNotifer = ValueNotifier(0);
  var databaseHelper = new DatabaseHelper();
  List<String> myListNotif = [];

  @override
  initState() {
    // //loading ngikutin payupal
    _startPayment();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 10));

    print('animation start');

    animationController.addListener(() {
      if (animationController.status.toString() ==
          'AnimationStatus.completed') {
        setState(() {
          showSpinner = false;
          showChecked = true;
        });
        Timer(
          Duration(seconds: 1),
          () => setState(() {
            showPageLoader = false;
            Navigator.of(context).pop();
          }),
        );
      }
    });
    // //loading ngikutin paypal

    super.initState();

    // print('push dipanggil');
    // PushNotificationsManager();
    // enablePlatformOverrideForDesktop();
    //shimmer time delay

    Future.delayed(Duration(seconds: 1)).then((onValue) {
      pr.hide();
    });

    ValueListenableBuilder(
      builder: (BuildContext context, int newNotificationCounterValue,
          Widget child) {
        // This builder will only get called when the notificationCounterValueNotifer is updated.
        return Text(
            newNotificationCounterValue.toString()); //return your badge here
      },
      valueListenable: notificationCounterValueNotifer,
    );

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('logo');

    var initializationSettings = new InitializationSettings();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _firebaseMessaging.configure(
      // ignore: missing_return
      onMessage: (Map<String, dynamic> message) {
        print('isi pesan nya on message ${message}');

        final DateTime now = DateTime.now();
        final DateFormat formatTanggal = DateFormat('yyyy-MM-dd');
        final DateFormat formatJam = DateFormat('H:m');
        final String tanggal = formatTanggal.format(now);
        final String jam = formatJam.format(now);
        // var dataNotifikasi = new NotifikasiModel(
        //   "1", // id data ( absen, pengumuman, dan lain lain )
        //   message['notification']['title'],
        //   message['notification']['body'],
        //   tanggal.toString(),
        //   jam,
        //   message['notification']['title'],
        //   "grup",
        //   "unread",
        //   "private",
        //   ' https://go.payrightsystem.com/shareurl?token=yR53ityMI3lS3Z4txG1c26rs29g1LPt38Ovo1F2SSN7ad3KGwakrE3psGeicfgfyDUv-S4Tmi2p2eSutOdKpO9dUiEtwRaOP',
        // );
        // databaseHelper.saveNotification(dataNotifikasi);

        // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
        displayNotification(message);

        notificationCounterValueNotifer.value++;
        notificationCounterValueNotifer
            .notifyListeners(); // notify listeners here so ValueListenableBuilder will build the widget.

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
      // ignore: missing_return
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      // ignore: missing_return
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );

    _firebaseMessaging.getToken().then((String token) async {
      assert(token != null);
      var userinfo = await Data.getData();
      var user_id = userinfo['user_id'];
      var data = {
        'fcm': token,
        'user_id': user_id,
      };
      var res = await CallApi().postUpdateFcm(data, 'updatefcm');
      var body = json.decode(res.body);
      print('response update token, $body');
    });
  }

  Future displayNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'Payrightsystem', 'Payrightsystem', 'your channel description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails();

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

    // var dbClient = await databaseHelper.db;
    // await dbClient
    //     .rawQuery("update notifikasi set status = 'read' where id = 1 " + "  ");
  }

  //loading ngikutin paypal
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  _startPayment() {
    setState(() {
      showPageLoader = true;
      showSpinner = true;
      animationController.forward();
    });
  }

  Widget _showPageLoader() {
    print('show load page dipanggil');
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: BackdropFilter(
            // filter: ImageFilter.blur(
            //   sigmaY: 10,
            //   sigmaX: 10,
            // ),
            child: Container(
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ),
        showSpinner
            ? Align(
                alignment: Alignment.center,
                child: Image.asset('assets/images/logo.png', height: 35),
              )
            : Container(),
        showSpinner
            ? Align(
                alignment: Alignment.center,
                child: RotationTransition(
                  turns:
                      Tween(begin: 0.0, end: 2.0).animate(animationController),
                  child: Image.asset('assets/images/loading.png'),
                ),
              )
            : Container(),
        showChecked
            ? Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/checked.png'),
                    SizedBox(height: 25),
                    Material(
                      child: Text(
                        'Transaction Successful',
                        style: TextStyle(
                            fontFamily: "worksans",
                            fontSize: 17,
                            color: PaypalColors.Green),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }

  //end loading ngikutin paypal

  List<dynamic> arrayCheckTime = [];

  Future<bool> _getHistoryAbsence() async {
    print('masuk ke history');
    var userinfo = await Data.getData();
    var user_id = userinfo['user_id'];
    var data = {'user_id': user_id};
    // var response = await CallApi().getHistoryAbsence(data, 'historyabsence');

    // var body = json.decode(response.body);
    var response =
        '{"message":[{"date":"2021-01-12","check_in":"09:09:29","check_out":"17:29:05"},{"date":"2021-01-11","check_in":"09:19:22","check_out":"17:15:29"},{"date":"2021-01-10","check_in":"09:09:29","check_out":"09:09:29"},{"date":"2021-01-09","check_in":"09:09:29","check_out":"09:09:29"},{"date":"2021-01-08","check_in":"09:09:29","check_out":"09:09:29"}, {"date":"2021-01-07","check_in":"09:09:29","check_out":"09:09:29"}, {"date":"2021-01-06","check_in":"09:09:29","check_out":"09:09:29"}]}';
    var body = json.decode(response);
    // print(response);
    Map<String, dynamic> jsonResponse = body;
    arrayCheckTime = jsonResponse['message'];

    for (var i = 0; i < arrayCheckTime.length; i++) {
      listViewHistory.add(widgetHistory(arrayCheckTime[i]));
    }

    return true;
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

  int counter = 0;

  List<Color> colorList = [
    Colors.blue[400],
    Colors.green,
    Colors.red,
    Colors.yellow,
  ];

  int key = 0;

  bool inVisibleButton = false;

  var jwt;

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
    Future.delayed(Duration(seconds: 2)).then((onValue) {
      pr.hide();
    });
  }

  widgetHistory(Map<String, dynamic> dataHistory) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, top: 5, bottom: 15),
            height: 50,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                width: 3.0,
                color: Colors.grey[200],
              ),
            ),
            child: Text(
              dataHistory['date'].toString(),
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 15.0,
                  fontFamily: "Poppins"),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
            padding: EdgeInsets.fromLTRB(5, 18, 5, 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10),
                  width: 30,
                  child: Image.asset('assets/img/bell.png'),
                ),
                Text(
                  dataHistory['check_out'].toString(),
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                      fontFamily: "Poppins"),
                ),

                Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  width: 140,
                  child: Text(
                    'Absen Keluar',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.0,
                        fontFamily: "Poppins"),
                  ),
                ),
                Image.asset('assets/img/checked.png'),
                ////Image.asset('assets/images/bell-small.png'),
              ],
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: [0.015, 0.020],
                colors: [CustomColors.BlueShadow, Colors.white],
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: CustomColors.GreyBorder,
                  blurRadius: 10.0,
                  spreadRadius: 5.0,
                  offset: Offset(0.0, 0.0),
                ),
              ],
            ),
          ),
          //end absen
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
            padding: EdgeInsets.fromLTRB(5, 18, 5, 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  width: 30,
                  child: Image.asset('assets/img/bell-right.png'),
                ),
                Text(
                  dataHistory['check_in'].toString(),
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                      fontFamily: "Poppins"),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  width: 140,
                  child: Text(
                    'Absen Masuk',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.0,
                        fontFamily: "Poppins"),
                  ),
                ),
                Image.asset('assets/img/checked.png'),
              ],
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: [0.015, 0.020],
                colors: [CustomColors.BlueLight, Colors.white],
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: CustomColors.GreyBorder,
                  blurRadius: 10.0,
                  spreadRadius: 5.0,
                  offset: Offset(0.0, 0.0),
                ),
              ],
            ),
          )
        ]);
  }

  Future<String> postRequest() async {
    var userinfo = await Data.getData();
    // company_name = userinfo['company_name'];
    // company_id = userinfo['company_id'];
    // name = userinfo['name'];
    // company_id = userinfo['company_id'];
    // employee_employe_id = userinfo['employee_employe_id'];
    // button_checkin = userinfo['button_checkin'];
    // button_checkout = userinfo['button_checkout'];
    // // config_ess = userinfo['button_checkout'];
    // // config_scan = userinfo['button_checkout'];
    // // print('halow , $config_ess, $config_scan');

    // var url = 'https://api.payright.dev/v1/api/requestotp';

    // var user_id = userinfo['user_id'];

    // Map data = {'user_id': user_id.toString()};

    // //encode Map to JSON
    // var body = json.encode(data);

    // var response = await http.post(url,
    //     headers: {"Content-Type": "application/json"}, body: body);

    // var result = json.decode(response.body);
    // jwt = result['message'];
    jwt = 'jshdfkjshdfkjsdhfkjsdhfkjsdfhksjdf';

    return jwt;
  }

  bool showErrorPage = false;

  //widget handling badge
  Widget myAppBarIcon() {
    //you have to return the widget from builder method.
    //you can add logics inside your builder method. for example, if you don't want to show a badge when the value is 0.
    return ValueListenableBuilder(
      builder: (BuildContext context, int newNotificationCounterValue,
          Widget child) {
        print('jumlah notifikasi');
        print(newNotificationCounterValue.toString());
        //returns an empty container if the value is 0 and returns the Stack otherwise
        return newNotificationCounterValue == 0
            ? Container()
            : Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Icon(
                    Icons.notifications,
                    color: Colors.grey[400],
                    size: 30,
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(right: 0.0),
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue[300],
                          border: Border.all(color: Colors.white, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          newNotificationCounterValue.toString(),
                        ),
                      ),
                    ),
                  ),
                ],
              );
      },
      valueListenable: notificationCounterValueNotifer,
    );
  }

  @override
  Widget build(BuildContext context) {
    var stack = new Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 15.0, top: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[],
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
        ),
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
                actions: <Widget>[
                  FlatButton(
                    child: myAppBarIcon(),
                    onPressed: () => showMyDialogNotification(context),
                  ),
                ]),
            body: SingleChildScrollView(
              child: FutureBuilder<String>(
                future: postRequest(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(children: [
                      SizedBox(
                          child: StaggeredGridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 12.0,
                              mainAxisSpacing: 12.0,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 4.0),
                              children: <Widget>[
                            _buildTile(
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              config_ess == true
                                                  ? ''
                                                  : greating,
                                              style: TextStyle(
                                                  color: Colors.blueAccent)),
                                          Text(name ?? " ",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          Text(company_name ?? ' ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Poppins",
                                                fontSize: 13.0,
                                              ))
                                        ],
                                      ),
                                      Material(
                                          //color: Colors.blue[200],
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          child: Center(
                                              child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0, top: 7),
                                            // child: Image.asset(
                                            //     'assets/img/dashboard.png'),
                                            child: Image.asset(
                                                'assets/img/logo.png',
                                                width: 100,
                                                height: 100),
                                            // child: Image.network(
                                            //     'http://www.sinarparataruna.co.id/images/logo_horizontal.jpg',
                                            //     width: 100,
                                            //     height: 100),
                                          )))
                                    ]),
                              ),
                            ),
                            //* kotak pertama
                            _buildTile(
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                            child: Container(
                                                color: Colors.transparent,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .only(
                                                      left:
                                                          25), //kotak kedua kiri
                                                  child: Image.asset(
                                                      'assets/img/absorbed_in.png'),
                                                ))),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 5.0)),
                                        Text('Absen Masuk',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17.0,
                                                fontFamily: "Poppins")),
                                      ]),
                                ), onTap: () {
                              Navigator.of(context).push(
                                  // MaterialPageRoute(
                                  //   builder: (_) => ScanScreenIn()));
                                  MaterialPageRoute(
                                      builder: (_) => notificationPage()));
                            }),
                            //* kotak pertama kanan
                            _buildTile(
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                            child: Container(
                                                color: Colors.white,
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 20),
                                                  child: Image.asset(
                                                      'assets/img/going_home.png'),
                                                ))),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 5.0)),
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
                              if (button_checkout == 'visible' ||
                                  button_checkout == 'invisible') {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => notificationPage()));
                              } else {
                                print('tombol Cekout TIDAK bisa di click');
                                Alert(
                                  context: context,
                                  style: alertStyle,
                                  title: "Anda Belum Absen Masuk",
                                  image: Image.asset("assets/img/mobile.png"),
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.of(context,
                                              rootNavigator: true)
                                          .pop(),
                                      // color: Color.fromRGBO(0, 179, 134, 1.0),
                                      color: Colors.blue[300],
                                      radius: BorderRadius.circular(20.0),
                                    ),
                                  ],
                                ).show();
                              }
                            }),

                            //kotak mockup]
                            // _buildTile(
                            //     Padding(
                            //       padding: const EdgeInsets.all(20.0),
                            //       child: Column(
                            //           mainAxisAlignment: MainAxisAlignment.start,
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: <Widget>[
                            //             Expanded(
                            //                 child: Container(
                            //                     color: Colors.white,
                            //                     child: Padding(
                            //                       padding:
                            //                           EdgeInsets.only(left: 20),
                            //                       child: Image.asset(
                            //                           'assets/img/going_home.png'),
                            //                     ))),
                            //             Padding(
                            //                 padding:
                            //                     EdgeInsets.only(bottom: 5.0)),
                            //             Text('Absen Keluar',
                            //                 style: TextStyle(
                            //                     color: Colors.black54,
                            //                     fontWeight: FontWeight.w600,
                            //                     fontSize: 17.0,
                            //                     fontFamily: "Poppins"))
                            //             //style: GoogleFonts.lato(fontStyle: FontStyle.italic)),
                            //           ]),
                            //     ), onTap: () {
                            //   print('button_checkout, $button_checkout');
                            //   if (button_checkout == 'visible') {
                            //     Navigator.of(context).push(MaterialPageRoute(
                            //         builder: (_) => ScanScreenOut()));
                            //   } else {
                            //     print('tombol Cekout TIDAK bisa di click');
                            //     Alert(
                            //       context: context,
                            //       style: alertStyle,
                            //       title: "Anda Belum Absen Masuk",
                            //       image: Image.asset("assets/img/mobile.png"),
                            //       buttons: [
                            //         DialogButton(
                            //           child: Text(
                            //             "OK",
                            //             style: TextStyle(
                            //                 color: Colors.white, fontSize: 20),
                            //           ),
                            //           onPressed: () => Navigator.of(context,
                            //                   rootNavigator: true)
                            //               .pop(),
                            //           // color: Color.fromRGBO(0, 179, 134, 1.0),
                            //           color: Colors.blue[300],
                            //           radius: BorderRadius.circular(20.0),
                            //         ),
                            //       ],
                            //     ).show();
                            //   }
                            // }),

                            //* kotak untuk riwayat kehadiran
                            // _buildTile(
                            //   SizedBox(
                            //     child: ListView.count(
                            //       scrollDirection: Axis.vertical,
                            //       shrinkWrap: true,
                            //       crossAxisCount: 2,
                            //       physics: NeverScrollableScrollPhysics(),
                            //       children: List.generate(check_in.length, (index{
                            //         return  Container(
                            //       height: 20,
                            //       margin: EdgeInsets.only(left:16,right:16,top: 10,bottom: 10),
                            //         padding: EdgeInsets.fromLTRB(16, 6, 16, 0),
                            //         child: Text(listProfesi[index]['name'], style: TextStyle(
                            //           color: Color(0xFFffffff), fontFamily: "Medium",fontSize: 12
                            //           )
                            //         ),
                            //         decoration: boxDecorationBadge(bgColor: Color(0xFF0060D5), radius: 6)
                            //     ));
                            //       })

                            //     )
                            //   )
                            // ),

                            // // //blok chart
                            // // _buildTile(
                            // //   Padding(
                            // //     padding: const EdgeInsets.all(20.0),
                            // //     child: Column(
                            // //         mainAxisAlignment: MainAxisAlignment.start,
                            // //         crossAxisAlignment: CrossAxisAlignment.start,
                            // //         children: <Widget>[
                            // //           //edit
                            // //           Expanded(
                            // //               child: Container(
                            // //                   //color: Colors.white10,
                            // //                   child: Padding(
                            // //             padding: EdgeInsets.only(
                            // //               left: 48.0,
                            // //             ),
                            // //             child:
                            // //                 Image.asset('assets/img/chart.png'),
                            // //           ))),
                            // //           Padding(
                            // //               padding: EdgeInsets.only(bottom: 10.0)),

                            //add chart
                            PieChart(
                              dataMap: dataMap,
                              animationDuration: Duration(milliseconds: 3500),
                              chartLegendSpacing: 12.8,
                              // chartRadius: MediaQuery.of(context).size.width / 3.2,
                              chartRadius:
                                  MediaQuery.of(context).size.width / 4.8,

                              colorList: colorList,
                              initialAngleInDegree: 0,
                              chartType: ChartType.ring,
                              ringStrokeWidth: 12.8,
                              // centerText: "HYBRID",
                              legendOptions: LegendOptions(
                                showLegendsInRow: true,
                                legendPosition: LegendPosition.bottom,
                                showLegends: true,
                                //legendShape: _BoxShape.circle,
                                legendTextStyle: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 8.0,
                                    fontFamily: "Poppins"),
                              ),
                              chartValuesOptions: ChartValuesOptions(
                                showChartValueBackground: false,
                                showChartValues: true,
                                showChartValuesInPercentage: false,
                                showChartValuesOutside: false,
                              ),
                            ),
                            _buildTile(
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                            child: Container(
                                                color: Colors.white,
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 20),
                                                  child: Image.asset(
                                                      'assets/img/dashboard.png'),
                                                ))),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 5.0)),
                                        Text('Employee Dashboard',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17.0,
                                                fontFamily: "Poppins"))
                                        //style: GoogleFonts.lato(fontStyle: FontStyle.italic)),
                                      ]),
                                ), onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) =>
                                      InAppWebViewExampleScreen("")));
                            }),

                            // //           //end chart
                            // //           // Text('Chart Riwayat Kehadiran',
                            // //           //     style: TextStyle(
                            // //           //         color: Colors.black54,
                            // //           //         fontWeight: FontWeight.w600,
                            // //           //         fontSize: 17.0,
                            // //           //         fontFamily: "Poppins"))
                            // //           //style: GoogleFonts.lato(fontStyle: FontStyle.italic)),
                            // //         ]),
                            // //   ),
                            // ),
                            //* kotak kedua webview

                            // _buildHistory(FutureBuilder<bool>(
                            //     future: _getHistoryAbsence(),
                            //     builder: (context, snapshot) {
                            //       if (snapshot.hasData) {
                            //         return Padding(
                            //           padding: const EdgeInsets.all(0.0),
                            //           child: Row(children: <Widget>[
                            //             Column(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.start,
                            //               crossAxisAlignment:
                            //                   CrossAxisAlignment.start,
                            //               children: <Widget>[
                            //                 Container(
                            //                   margin: EdgeInsets.only(
                            //                       top: 5, left: 20, bottom: 0),
                            //                   child: Text(
                            //                     'Riwayat Kehadiran',
                            //                     style: TextStyle(
                            //                         color: Colors.black54,
                            //                         fontWeight: FontWeight.w700,
                            //                         fontSize: 17.0,
                            //                         fontFamily: "Poppins"),
                            //                   ),
                            //                 ),
                            //                 Column(
                            //                   children: listViewHistory,
                            //                 ),
                            //                 SizedBox(height: 15)
                            //               ],
                            //             ),
                            //             Material(
                            //                 color: Colors.blue[200],
                            //                 borderRadius:
                            //                     BorderRadius.circular(0.0),
                            //                 child: Center(
                            //                     child: Padding(
                            //                   padding: const EdgeInsets.all(0.0),
                            //                   // child:
                            //                   //     Image.asset('assets/img/dashboard.png'),
                            //                 )))
                            //           ]),
                            //         );
                            //       }
                            //     }))
                          ],
                              // staggeredTiles: config_scan
                              //     ? [
                              staggeredTiles: [
                            StaggeredTile.extent(2, 110.0),
                            StaggeredTile.extent(1, 150.0),
                            StaggeredTile.extent(1, 150.0),
                            StaggeredTile.extent(2, 150.0),
                            StaggeredTile.extent(2, 150.0),
                          ]))
                    ]);
                    // config_ess
                    //     ? _buildWebview(Padding(
                    //         padding: const EdgeInsets.all(10.0),
                    //         child: Stack(children: <Widget>[
                    //           Container(
                    //             margin: const EdgeInsets.only(
                    //                 left: 20, right: 20),
                    //             height: 1000,
                    //             child: InAppWebView(
                    //               initialUrl:
                    //                   "https://go.payrightsystem.com/v1/api/webviewlogin?jwt=$jwt",
                    //               // "https://new.payright.dev/v1/api/av/webviewlogin?jwt=$jwt",

                    //               initialHeaders: {
                    //                 'access-control-request-headers':
                    //                     'payright-webview',
                    //                 // 'content-type' :'application/x-www-form-urlencoded'
                    //               },
                    //               initialOptions: InAppWebViewGroupOptions(
                    //                   crossPlatform: InAppWebViewOptions(
                    //                     // debuggingEnabled: false,
                    //                     cacheEnabled: true,
                    //                     javaScriptEnabled: true,
                    //                     horizontalScrollBarEnabled: true,
                    //                   ),
                    //                   android: AndroidInAppWebViewOptions(
                    //                     useShouldInterceptRequest: true,
                    //                     useWideViewPort: true,
                    //                   )),

                    //               onWebViewCreated:
                    //                   (InAppWebViewController controller) {
                    //                 clearSessionCache:
                    //                 false;
                    //                 webView = controller;
                    //               },
                    //               onLoadError:
                    //                   (InAppWebViewController controller,
                    //                       String url, int i, String s) async {
                    //                 print('CUSTOM_HANDLER atas: $i, $s');
                    //                 webView.loadFile(
                    //                     assetFilePath: "assets/error.html");
                    //               },
                    //               /** instead of printing the console message i want to render a static page or display static message **/
                    //               // showError();

                    //               onLoadHttpError:
                    //                   (InAppWebViewController controller,
                    //                       String url, int i, String s) async {
                    //                 var response_code = i.toString();
                    //                 print(
                    //                     'ini interger nya, $i, ini response code nya, $response_code');
                    //                 print('CUSTOM HANDLER bawah: $i, $s');
                    //                 webView.loadFile(
                    //                     assetFilePath: "assets/error.html");
                    //                 if (response_code == '404') {
                    //                   print('masuk ke kondisi error');
                    //                 }
                    //                 showError();
                    //               },

                    //               onLoadStart:
                    //                   (InAppWebViewController controller,
                    //                       String url) {
                    //                 setState(() {
                    //                   this.url = url;
                    //                 });
                    //               },
                    //               onLoadStop:
                    //                   (InAppWebViewController controller,
                    //                       String url) async {
                    //                 controller.evaluateJavascript(
                    //                     source:
                    //                         '''(() => { return document.body.scrollHeight;})()''').then(
                    //                     (value) {
                    //                   if (value == null || value == '') {
                    //                     return;
                    //                   }
                    //                   webHeight = double.parse('$value');

                    //                   setState(() {
                    //                     webHeight = double.parse('$value');
                    //                   });
                    //                   print(
                    //                       'isi webheight webview pertama, $webHeight');
                    //                 });

                    //                 setState(() {
                    //                   this.url = url;
                    //                   print('on load stop , ${this.url}');
                    //                 });
                    //               },
                    //               onProgressChanged:
                    //                   (InAppWebViewController controller,
                    //                       int progress) {
                    //                 setState(() {
                    //                   this.progress = progress / 100;
                    //                 });
                    //               },
                    //             ),
                    //           ),
                    //           showErrorPage
                    //               ? Center(
                    //                   child: Container(
                    //                     color: Colors.white,
                    //                     alignment: Alignment.center,
                    //                     height: double.infinity,
                    //                     width: double.infinity,
                    //                     child: Text(
                    //                         'Page failed to open (WIDGET)'),
                    //                   ),
                    //                 )
                    //               : SizedBox(height: 0, width: 0),
                    //         ]),
                    //       ))
                    //     : SizedBox(),

                    //webview start
                    //   config_ess
                    //       ? _buildWebview(Padding(
                    //           padding: const EdgeInsets.all(5.0),
                    //           child: Stack(children: <Widget>[
                    //             Container(
                    //               margin: const EdgeInsets.only(
                    //                   left: 40, right: 40),
                    //               height:
                    //                   webHeight != null ? webHeight : setHeight,
                    //               child: InAppWebView(
                    //                 initialUrl:
                    //                     "https://go.payrightsystem.com/v1/api/webviewlogin?jwt=$jwt",
                    //                 // "https://new.payright.dev/v1/api/av/webviewlogin?jwt=$jwt",

                    //                 initialHeaders: {
                    //                   'access-control-request-headers':
                    //                       'payright-webview',
                    //                   // 'content-type' :'application/x-www-form-urlencoded'
                    //                 },
                    //                 initialOptions: InAppWebViewGroupOptions(
                    //                     crossPlatform: InAppWebViewOptions(
                    //                       // debuggingEnabled: false,
                    //                       cacheEnabled: true,
                    //                       javaScriptEnabled: true,
                    //                       horizontalScrollBarEnabled: true,
                    //                     ),
                    //                     android: AndroidInAppWebViewOptions(
                    //                       useShouldInterceptRequest: true,
                    //                       useWideViewPort: true,
                    //                     )),

                    //                 onWebViewCreated:
                    //                     (InAppWebViewController controller) {
                    //                   clearSessionCache:
                    //                   false;
                    //                   webView = controller;
                    //                 },
                    //                 onLoadError:
                    //                     (InAppWebViewController controller,
                    //                         String url, int i, String s) async {
                    //                   print('CUSTOM_HANDLER atas: $i, $s');
                    //                   webView.loadFile(
                    //                       assetFilePath: "assets/error.html");
                    //                 },
                    //                 /** instead of printing the console message i want to render a static page or display static message **/
                    //                 // showError();

                    //                 onLoadHttpError:
                    //                     (InAppWebViewController controller,
                    //                         String url, int i, String s) async {
                    //                   var response_code = i.toString();
                    //                   print(
                    //                       'ini interger nya, $i, ini response code nya, $response_code');
                    //                   print('CUSTOM HANDLER bawah: $i, $s');
                    //                   webView.loadFile(
                    //                       assetFilePath: "assets/error.html");
                    //                   if (response_code == '404') {
                    //                     print('masuk ke kondisi error');
                    //                   }
                    //                   showError();
                    //                 },

                    //                 onLoadStart:
                    //                     (InAppWebViewController controller,
                    //                         String url) {
                    //                   setState(() {
                    //                     this.url = url;
                    //                   });
                    //                   pr.show();
                    //                   if (url ==
                    //                           'https://go.payrightsystem.com/home/notloggedin' ||
                    //                       url ==
                    //                           'https://go.payrightsystem.com/login') {
                    //                     // Navigator.of(context).pushReplacementNamed("dashboard");
                    //                     Navigator.push(
                    //                         context,
                    //                         new MaterialPageRoute(
                    //                             builder: (context) =>
                    //                                 dashboard(true, true)));
                    //                     print('reload lagi');
                    //                   }
                    //                   ;
                    //                 },
                    //                 onLoadStop:
                    //                     (InAppWebViewController controller,
                    //                         String url) async {
                    //                   controller.evaluateJavascript(
                    //                       source:
                    //                           '''(() => { return document.body.scrollHeight;})()''').then(
                    //                       (value) {
                    //                     if (value == null || value == '') {
                    //                       return;
                    //                     }
                    //                     webHeight = double.parse('$value');

                    //                     setState(() {
                    //                       webHeight = double.parse('$value');
                    //                     });
                    //                   });
                    //                   Future.delayed(Duration(seconds: 1))
                    //                       .then((onValue) {
                    //                     pr.hide();
                    //                   });
                    //                   setState(() {
                    //                     this.url = url;
                    //                     print('on load stop , ${this.url}');
                    //                   });

                    //                   if (url ==
                    //                           'https://go.payrightsystem.com/home/notloggedin' ||
                    //                       url ==
                    //                           'https://go.payrightsystem.com/login') {
                    //                     Navigator.push(
                    //                         context,
                    //                         new MaterialPageRoute(
                    //                             builder: (context) =>
                    //                                 dashboard(true, true)));
                    //                   }
                    //                   ;
                    //                 },
                    //                 onProgressChanged:
                    //                     (InAppWebViewController controller,
                    //                         int progress) {
                    //                   setState(() {
                    //                     this.progress = progress / 100;
                    //                   });
                    //                 },
                    //               ),
                    //             ),
                    //             showErrorPage
                    //                 ? Center(
                    //                     child: Container(
                    //                       color: Colors.white,
                    //                       alignment: Alignment.center,
                    //                       height: double.infinity,
                    //                       width: double.infinity,
                    //                       child: Text(
                    //                           'Page failed to open (WIDGET)'),
                    //                     ),
                    //                   )
                    //                 : SizedBox(height: 0, width: 0),
                    //           ]),
                    //         ))
                    //       : SizedBox(),
                    // ]);
                  } else {
                    return Center(
                        child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.grey[350]),
                    ));
                  }
                },
              ),
            )));
    //  showPageLoader ? _showPageLoader() : Container());
  }

  //floating baru
  final GlobalKey<AnimatedListState> _listKey =
      new GlobalKey<AnimatedListState>();
  final double _imageHeight = 256.0;
  //ListModel listModel;
  bool showOnlyComment = false;

  Widget _buildFab() {
    return new Positioned(
        top: _imageHeight - 100.0,
        right: -40.0,
        child: new AnimatedFab(
          onClick: _changeFilterState,
        ));
  }

  void _changeFilterState() {
    showOnlyComment = !showOnlyComment;
    tasks.where((task) => !task.comment).forEach((task) {
      // if (showOnlyComment) {
      //   listModel.removeAt(listModel.indexOf(task));
      // } else {
      //   listModel.insert(tasks.indexOf(task), task);
      // }
    });
  }

  Widget _buildTasksList() {
    return new Expanded(
      child: new AnimatedList(
        initialItemCount: tasks.length,
        key: _listKey,
        itemBuilder: (context, index, animation) {
          return new TaskRow(
            // task: listModel[index],
            animation: animation,
          );
        },
      ),
    );
  }

  Widget _buildBottomPart() {
    return new Padding(
      padding: new EdgeInsets.only(top: _imageHeight),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTasksList(),
        ],
      ),
    );
  }
  //end floating baru

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
  //  Widget _buildTileChart(Widget child, {Function() onTap, Alert onPressed}) {
  //   return Material(
  //       elevation: 14.0,
  //       borderRadius: BorderRadius.circular(12.0),
  //       // shadowColor: Color(0x802196F3),
  //       // shadowColor: Color(0x00000000),
  //       // shadowColor: Color.fromRGBO(69, 65, 78, 0.08),
  //       shadowColor: Colors.white,
  //       child: InkWell(
  //           // Do onTap() if it isn't null, otherwise do print()
  //           onTap: onTap != null
  //               ? () => onTap()
  //               : () {
  //                   print('Not set yet');
  //                   Alert(
  //                     context: context,
  //                     style: alertStyle,
  //                     title: "Under Maintenance",
  //                     image: Image.asset("assets/img/mobile_pay.png"),
  //                     buttons: [
  //                       DialogButton(
  //                         child: Text(
  //                           "OK",
  //                           style: TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 20,
  //                               fontFamily: "Poppins"),
  //                         ),
  //                         onPressed: () =>
  //                             Navigator.of(context, rootNavigator: true).pop(),
  //                         // color: Color.fromRGBO(0, 179, 134, 1.0),
  //                         color: Colors.blue[300],
  //                         radius: BorderRadius.circular(20.0),
  //                       ),
  //                     ],
  //                   );
  //                 },
  //           child: child));
  // }

  Widget _buildHistory(Widget child, {Function() onTap, Alert onPressed}) {
    return Material(
        elevation: 0.0,
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

  // Future<bool> getjumlah() async {
  //   //  notificationCounterValueNotifer = ValueNotifier(10);
  //   // totalMessage = notificationCounterValueNotifer.toString();

  //   var dbClient = await databaseHelper.db;
  //   List<Map> listNotifikasi = await dbClient.rawQuery(
  //       "SELECT * FROM notifikasi where status ='unread' order by tanggal desc, jam desc");
  //   for (var i = 0; i < listNotifikasi.length; i++) {
  //     myListNotif
  //         .add(listNotifikasi[i]['title'] + " : " + listNotifikasi[i]['body']);
  //   }
  //   totalMessage = listNotifikasi.length.toString();
  //   notificationCounterValueNotifer = ValueNotifier(listNotifikasi.length);

  //   return true;
  // }

  Widget _buildWebview(Widget child) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x00000000),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()

            child: child));
  }

  getNotification() async {
    print('akui di panggil : getnotificaiton');
    var dbClient = await databaseHelper.db;
    List<Map> listNotifikasi = await dbClient.rawQuery(
        "SELECT * FROM notifikasi where status ='read' order by tanggal desc, jam desc");
    for (var i = 0; i < listNotifikasi.length; i++) {
      myListNotif
          .add(listNotifikasi[i]['title'] + " : " + listNotifikasi[i]['body']);
    }
    var gemessage =
        dbClient.rawQuery('select * from notification order by desc, jam desc');
    print(gemessage);
    return myListNotif;
  }

  List<Widget> getMyList() {
    print('total list di getmylist');
    print(myListNotif.length);
    return myListNotif.map((x) {
      return Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          Icon(Icons.notifications, color: Colors.grey),
          Text(x)
        ]),
      );
    }).toList();
  }

  void showMyDialogNotification(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[200],
            titlePadding: EdgeInsets.all(10.0),
            contentPadding: EdgeInsets.all(0.0),
            scrollable: true,
            title: Text("Notifikasi",
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins")),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              // Divider(
              //   height: 1.0,
              //   color: Colors.grey,
              // ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: getMyList()),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 2.0, bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        shape: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Text("OK"),
                        onPressed: () {
                          // newNotificationCounterValue == 0;
                          //function update db
                          // updateAsread();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ]),
          );
        });
  }

  void updateAsread() async {
    var dbClient = await databaseHelper.db;
    await dbClient.rawQuery("update notifikasi set status = 'read'");
    // var cek = await dbClient.rawQuery("select * from notifikasi");
    // print(cek);
    print('data di rubah jadi read');
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
}
