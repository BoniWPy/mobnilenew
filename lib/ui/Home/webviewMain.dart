import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:new_payrightsystem/ui/checkinout/simpanLokasi.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:adv_fab/adv_fab.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:extended_navbar_scaffold/extended_navbar_scaffold.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ss_bottom_navbar/src/ss_bottom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:ss_bottom_navbar/ss_bottom_navbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_payrightsystem/utils/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:new_payrightsystem/ui/Home/dashboardzakir.dart';
import 'package:new_payrightsystem/utils/api/api.dart';
import 'package:new_payrightsystem/data/model/NotifikasiModel.dart';
import 'package:new_payrightsystem/data/DatabaseHelper.dart';
import 'package:new_payrightsystem/ui/checkinout/checkIn.dart';
import 'package:new_payrightsystem/ui/checkinout/checkOut.dart';

// import 'package:new_payrightsystem/utils/notification/notification_page.dart';
// import 'package:new_payrightsystem/ui/checkinout/checkIn.dart';
// import 'package:new_payrightsystem/ui/Home/sampleList.dart';
// import 'package:new_payrightsystem/utils/toggle_shared.dart';
// import 'package:new_payrightsystem/utils/notification_page.dart';
// import 'package:new_payrightsystem/utils/shared_preferences.dart';
// import 'package:new_payrightsystem/utils/push_notifications.dart';
// import 'package:new_payrightsystem/utils/customColors.dart';
// import 'package:new_payrightsystem/utils/shared_preferences.dart';
// import 'package:new_payrightsystem/utils/slide.dart';
// import 'package:new_payrightsystem/utils/fab.dart';
// import 'package:new_payrightsystem/utils/appBars.dart';
// import 'package:new_payrightsystem/utils/config.dart';
// import 'package:progress_dialog/progress_dialog.dart';
// import 'package:new_payrightsystem/utils/api/api.dart';
// import 'package:new_payrightsystem/ui/Home/notificationList.dart';
// import 'package:new_payrightsystem/ui/checkinout/webview/employeeDashboard.dart';

class InAppWebViewExampleScreen extends StatefulWidget {
  @override
  _InAppWebViewExampleScreenState createState() =>
      new _InAppWebViewExampleScreenState();
}

class _InAppWebViewExampleScreenState extends State<InAppWebViewExampleScreen> {
  InAppWebViewController webView;
  ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  CookieManager _cookieManager = CookieManager.instance();

  SSBottomBarState _state;
  bool _isVisible = true;

  var jwt;

  var absen_masuk =
      "https://payrightmobile.s3-ap-southeast-1.amazonaws.com/1.png";
  var absen_keluar =
      "https://payrightmobile.s3-ap-southeast-1.amazonaws.com/2.png";

  final _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.teal
  ];

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
  bool config_ess = true;
  bool config_scan = true;

  final items = [
    SSBottomNavItem(text: 'Home', iconData: Icons.home),
    SSBottomNavItem(text: 'Absen Masuk', iconData: Icons.login),
    SSBottomNavItem(text: 'Absen Keluar', iconData: Icons.logout),
    // SSBottomNavItem(text: 'Absen Keluar', iconData: Icons.add, isIconOnly: true),
    SSBottomNavItem(text: 'Notifikasi', iconData: Icons.notifications),
  ];

  AdvFabController controller;
  AdvFabController mabialaFABController;
  bool useFloatingSpaceBar = false;
  bool useAsFloatingActionButton = false;
  bool useNavigationBar = true;

  //block var notification

  ValueNotifier<int> notificationCounterValueNotifer = ValueNotifier(0);
  var databaseHelper = new DatabaseHelper();
  List<String> myListNotif = [];
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  //block var notification end

  @override
  void initState() {
    _state = SSBottomBarState();
    super.initState();
    controller = AdvFabController();

    //firebase
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
        var dataNotifikasi = new NotifikasiModel(
          "1", // id data ( absen, pengumuman, dan lain lain )
          message['notification']['title'],
          message['notification']['body'],
          tanggal.toString(),
          jam,
          message['notification']['title'],
          "unread",
        );
        databaseHelper.saveNotification(dataNotifikasi);

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
    //firebase end

    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await webView.getSelectedText());
                await webView.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: true),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webView.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
          print("onContextMenuActionItemClicked: " +
              id.toString() +
              " " +
              contextMenuItemClicked.title);
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            elevation: 3.0,
            backgroundColor: Colors.white,
            title: Image.asset(
              'assets/img/logo.png',
              width: 120.0,
              height: 120.0,
            ),
            // title: Text("Payrightsystem"),
            actions: <Widget>[
              FlatButton(
                child: myAppBarIcon(),
                onPressed: () => showMyDialogNotification(context),
              ),
            ]

            // [
            //   Icon(
            //     Icons.notifications,
            //     color: Colors.grey[400],
            //     size: 30,
            //   ),
            // ],
            ),

        // floatingActionButton: ,
        // floatingActionButton: Row(children: [
        //   FlatButton(
        //       child: Icon(
        //         Icons.home,
        //         color: Colors.grey[400],
        //         size: 30,
        //       ),
        //       onPressed: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => dashboard(true, true)));
        //       }),
        // ]),
        // floatingActionButton: FloatingActionButton.extended(
        //   backgroundColor: Colors.blue[100],
        //   onPressed: () {
        //     print('menu ditekan');
        //   },
        //   label: Text('menu',
        //       style: TextStyle(
        //           color: Colors.grey,
        //           fontWeight: FontWeight.w600,
        //           fontSize: 15.0,
        //           fontFamily: "Poppins")),
        //   icon: Icon(Icons.menu),
        // ),

        // floatingActionButton: FabCircularMenu(
        //     fabCloseColor: Colors.deepOrangeAccent,
        //     children: <Widget>[
        //       IconButton(
        //           icon: Icon(Icons.login),
        //           onPressed: () {
        //             print('Home');
        //           }),
        //       IconButton(
        //           icon: Icon(Icons.logout),
        //           iconSize: 48,
        //           onPressed: () {
        //             Navigator.of(context).push(
        //                 MaterialPageRoute(builder: (_) => ScanScreenIn()));
        //           })
        //     ]),
        floatingActionButton: FabCircularMenu(
            // ringDiameter: MediaQuery.of(context).size.width * 0.75,
            // ringWidth: MediaQuery.of(context).size.width * 0.75 * 0.3,
            ringDiameter: MediaQuery.of(context).size.width * 1.95,
            ringWidth: MediaQuery.of(context).size.width * 1.95 * 0.3,
            alignment: Alignment.bottomRight,
            fabSize: 100.0,
            fabElevation: 25.0,
            fabColor: Colors.white,
            fabMargin: EdgeInsets.only(right: 15, bottom: 35),
            fabCloseColor: Colors.blue[200],
            fabOpenColor: Colors.grey[200],
            fabOpenIcon: Icon(Icons.home, color: Colors.white),
            fabCloseIcon: Icon(Icons.close, color: Colors.white),
            // ringColor: Colors.blue[100],
            ringColor: Colors.white,
            children: <Widget>[
              fabsinglemenuAbsenMasuk(Icons.home, () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => ScanScreenIn()));
              }),
              fabsinglemenuSimpanLokasi(Icons.alarm, () {
                //set action for this menu
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => SimpanLokasi()));
              }),
              fabsinglemenuAbsenKeluar(Icons.alarm, () {
                //set action for this menu
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => ScanScreenOut()));
              }),
            ]), //FAB circular Menu

        // floatingActionButton: FloatingActionButton(
        //   child: Icon(
        //       _isVisible ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
        //   onPressed: () {
        //     _state.setSelected(1);
        //     _state.setSelected(2);
        //     _state.setSelected(3);
        //     _state.setSelected(4);
        //   },
        // ),
        // bottomNavigationBar: SSBottomNav(
        //   items: items,
        //   state: _state,
        //   color: Colors.black,
        //   selectedColor: Colors.white,
        //   unselectedColor: Colors.black,
        //   visible: _isVisible,
        //   bottomSheetWidget: _bottomSheet(),
        //   showBottomSheetAt: 2,
        // ),
        body: SafeArea(
            child: Column(children: <Widget>[
          Expanded(
            child: Container(
              child: FutureBuilder(
                  future: postRequest(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return InAppWebView(
                        initialUrl:
                            "https://go.payrightsystem.com/v1/api/webviewlogin?jwt=$jwt",
                        // "https://new.payright.dev/v1/api/av/webviewlogin?jwt=$jwt",

                        initialHeaders: {
                          'access-control-request-headers': 'payright-webview',
                          // 'content-type' :'application/x-www-form-urlencoded'
                        },
                        initialOptions: InAppWebViewGroupOptions(
                            crossPlatform: InAppWebViewOptions(
                          // debuggingEnabled: false,
                          cacheEnabled: true,
                          javaScriptEnabled: true,
                        )),
                        onWebViewCreated: (InAppWebViewController controller) {
                          clearSessionCache:
                          false;
                          webView = controller;
                        },
                        onLoadError: (InAppWebViewController controller,
                            String url, int i, String s) async {
                          print('CUSTOM_HANDLER atas: $i, $s');
                          webView.loadFile(assetFilePath: "assets/error.html");
                        },
                        /** instead of printing the console message i want to render a static page or display static message **/
                        // showError();

                        onLoadHttpError: (InAppWebViewController controller,
                            String url, int i, String s) async {
                          var response_code = i.toString();
                          print(
                              'ini interger nya, $i, ini response code nya, $response_code');
                          print('CUSTOM HANDLER bawah: $i, $s');
                          webView.loadFile(assetFilePath: "assets/error.html");
                          if (response_code == '404') {
                            print('masuk ke kondisi error');
                          }
                          // showError();
                        },

                        onLoadStart:
                            (InAppWebViewController controller, String url) {
                          // setState(() {
                          //   this.url = url;
                          // });
                          pr.show();
                          if (url ==
                                  'https://go.payrightsystem.com/home/notloggedin' ||
                              url == 'https://go.payrightsystem.com/login') {
                            // Navigator.of(context).pushReplacementNamed("dashboard");
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        InAppWebViewExampleScreen()));
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
                            // webHeight = double.parse('$value');

                            // setState(() {
                            //   // webHeight = double.parse('$value');
                            // });
                            // print('isi webheight, $webHeight');
                          });
                          Future.delayed(Duration(seconds: 1)).then((onValue) {
                            pr.hide();
                          });
                          // setState(() {
                          //   this.url = url;
                          //   print('on load stop , ${this.url}');
                          // });

                          if (url ==
                                  'https://go.payrightsystem.com/home/notloggedin' ||
                              url == 'https://go.payrightsystem.com/login') {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        dashboard(true, true)));
                          }
                          ;
                        },
                        onProgressChanged: (InAppWebViewController controller,
                            int progress) {},
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
          ),
        ])));
  }

  Widget fabsinglemenuAbsenMasuk(IconData icon, Function onPressFunction) {
    return SizedBox(
        width: 90.0,
        height: 90.0,
        //height and width for menu button

        child: FlatButton(
          color: Colors.white,
          child: Image.asset('assets/img/absenmasuk.png'),
          onPressed: onPressFunction,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(45.0),
          ),
        ));
  }

  Widget fabsinglemenuAbsenKeluar(IconData icon, Function onPressFunction) {
    return SizedBox(
      width: 90.0,
      height: 90.0,
      //height and width for menu button

      child: FlatButton(
        color: Colors.white,
        child: Image.asset('assets/img/absenkeluar.png'),
        // child: Image.network(
        //   absen_keluar,
        //   fit: BoxFit.cover,
        // ),
        onPressed: onPressFunction,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(45.0),
        ),
      ),
    );
  }

  Widget fabsinglemenuSimpanLokasi(IconData icon, Function onPressFunction) {
    return SizedBox(
      width: 90.0,
      height: 90.0,
      //height and width for menu button

      child: FlatButton(
        color: Colors.white,
        child: Image.asset('assets/img/simpanlokasi.png'),
        // child: Image.network(
        //   absen_keluar,
        //   fit: BoxFit.cover,
        // ),
        onPressed: onPressFunction,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(45.0),
        ),
      ),
    );
  }

  Widget _page(Color color) => Container(color: color);

  List<Widget> _buildPages() => _colors.map((color) => _page(color)).toList();

  Widget _bottomSheet() => Container(
        color: Colors.white,
        child: Column(
          children: [
            // ListTile(
            //   leading: Icon(Icons.camera_alt),
            //   title: Text('Absen Keluar'),
            // ),
            // ListTile(
            //   leading: Icon(Icons.photo_library),
            //   title: Text('Choose from Gallery'),
            // ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Absen Keluar'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => ScanScreenIn()));
              },
              // onTap: ()   Navigator.of(context)
              //       .push(MaterialPageRoute(builder: (_) => ScanScreenIn());
              //     ;}
            ),
          ],
        ),
      );

  //list usefull var

  //var for alertStyle
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

  //var for postRequest
  Future<String> postRequest() async {
    var userinfo = await Data.getData();
    company_name = userinfo['company_name'];
    company_id = userinfo['company_id'];
    name = userinfo['name'];
    company_id = userinfo['company_id'];
    employee_employe_id = userinfo['employee_employe_id'];
    button_checkin = userinfo['button_checkin'];
    button_checkout = userinfo['button_checkout'];
    // config_ess = userinfo['button_checkout'];
    // config_scan = userinfo['button_checkout'];
    // print('halow , $config_ess, $config_scan');

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

  //var for dialog notification
  void showMyDialogNotification(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return AlertDialog(
          //     scrollable: true,
          //     content: Stack(
          //       alignment: Alignment.center,
          //       children: <Widget>[
          //         Image.asset(
          //           'assets/img/notification_2.png',
          //           height: 200,
          //           fit: BoxFit.cover,
          //         ),
          //         Text(
          //           'Notifikasi',
          //           style: TextStyle(
          //               color: Colors.black87,
          //               fontWeight: FontWeight.w400,
          //               fontFamily: "Poppins"),
          //         ),
          //       ],
          //     ));
          return AlertDialog(
            backgroundColor: Colors.white, //.grey[200],
            titlePadding: EdgeInsets.all(10.0),
            contentPadding: EdgeInsets.all(0.0),
            scrollable: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                side: BorderSide(color: Colors.grey)),
            title: Text(
              "Notifikasi",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontFamily: "Poppins",
              ),
              textAlign: TextAlign.center,
            ),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Image.asset(
                'assets/img/notification_1.png',
                height: 75,
                fit: BoxFit.cover,
              ),
              Divider(
                height: 1.0,
                color: Colors.grey,
              ),
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
                      child: RaisedButton(
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

  //var for widget handling notificaiton on appbar
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

  //var for get the notification from tables
  getNotification() async {
    print('akui di panggil : getnotificaiton');
    getNotifTerload = 1;
    var dbClient = await databaseHelper.db;
    List<Map> listNotifikasi = await dbClient.rawQuery(
        "SELECT * FROM notifikasi where status ='unread' order by tanggal desc, jam desc");
    for (var i = 0; i < listNotifikasi.length; i++) {
      myListNotif
          .add(listNotifikasi[i]['title'] + " : " + listNotifikasi[i]['body']);
    }
    var gemessage = await dbClient
        .rawQuery('select * from notifikasi order by tanggal desc, jam desc');
    print(' "gemessage =>",$gemessage');
    return myListNotif;
  }

  //var for get the list notification from the list
  int getNotifTerload = 0;
  List<Widget> getMyList() {
    print('terload nyah');
    print(getNotifTerload);
    // if (getNotifTerload == 1) {
    //   getNotification();
    // }

    getNotification();
    var totalPesan = myListNotif.length;
    print("'total list di getmylist => ', $totalPesan");

    return myListNotif.map((x) {
      return Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          Text(
            x,
            style: TextStyle(
                color: Colors.grey[800], fontSize: 16, fontFamily: "Poppins"),
          )
        ]),
      );
    }).toList();
  }

  // //var for get the notification from tables
  // getNotification() async {
  //   print('akui di panggil : getnotificaiton');

  //   var dbClient = await databaseHelper.db;
  //   List<Map> listNotifikasi = await dbClient.rawQuery(
  //       "SELECT * FROM notifikasi where status ='unread' order by tanggal desc, jam desc");
  //   for (var i = 0; i < listNotifikasi.length; i++) {
  //     myListNotif
  //         .add(listNotifikasi[i]['title'] + " : " + listNotifikasi[i]['body']);
  //   }
  //   var gemessage = await dbClient
  //       .rawQuery('select * from notifikasi order by tanggal desc, jam desc');
  //   print(' "gemessage =>",$gemessage');
  //   return myListNotif;
  // }

  // //var for get the list notification from the list
  // List<Widget> getMyList() {
  //   getNotification();
  //   var totalPesan = myListNotif.length;
  //   print("'total list di getmylist => ', $totalPesan");

  //   return myListNotif.map((x) {
  //     return Padding(
  //       padding: EdgeInsets.all(10.0),
  //       child: Column(children: <Widget>[
  //         Icon(Icons.notifications, color: Colors.grey),
  //         Text(x)
  //       ]),
  //     );
  //   }).toList();
  // }
}
