import 'dart:developer';
import 'dart:io';
import 'dart:convert' as JSON;
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
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
import 'package:new_payrightsystem/utils/navigationService.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:new_payrightsystem/ui/Home/dashboardzakir.dart';
import 'package:new_payrightsystem/ui/Home/sampleList.dart';
import 'package:new_payrightsystem/utils/notification/notification_page.dart';
import 'package:flutter/src/foundation/change_notifier.dart';

import 'package:new_payrightsystem/utils/api/api.dart';
import 'package:new_payrightsystem/data/model/NotifikasiModel.dart';
import 'package:new_payrightsystem/data/DatabaseHelper.dart';
import 'package:new_payrightsystem/ui/checkinout/checkIn.dart';
import 'package:new_payrightsystem/ui/checkinout/checkOut.dart';

import 'package:flash/flash.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:new_payrightsystem/utils/notification/notification_meeting.dart';

import 'package:new_payrightsystem/utils/dynamiclink_service.dart';

Future<dynamic> backGroundHandler(Map<String, dynamic> message) async {
  print("ANJING");
  _InAppWebViewExampleScreenState notificationClass =
      new _InAppWebViewExampleScreenState();
  notificationClass.showNotifBackground(message);
}

void _getDataFcm(Map<String, dynamic> message) {
  var title = '-';
  var content = '-';
  if (Platform.isIOS) {
    title = message['title'];
    content = message['content'];
  } else {
    title = message['data']['title'];
    content = message['data']['content'];
  }
  // _showLocalNotification(title, content);
}

void _showLocalNotification(String title, String content) {
  var initializationSettingsAndroid = AndroidInitializationSettings('logo');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings();
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'PAYRIGHT',
    'PAYRIGHT',
    'test channel description',
    importance: Importance.max,
    priority: Priority.high,
  );
  var iosPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails();
  flutterLocalNotificationsPlugin.show(
      1, title, content, platformChannelSpecifics);
}

// ignore: must_be_immutable
class InAppWebViewExampleScreen extends StatefulWidget {
  String clickToAction;
  InAppWebViewExampleScreen(this.clickToAction);
  @override
  _InAppWebViewExampleScreenState createState() =>
      _InAppWebViewExampleScreenState();
}

class _InAppWebViewExampleScreenState extends State<InAppWebViewExampleScreen>
    with WidgetsBindingObserver {
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
  List<Widget> listWidgetNotif = [];
  ProgressDialog get pr =>
      new ProgressDialog(context, type: ProgressDialogType.Normal);

  String company_name,
      username,
      name,
      employee_employe_id,
      button_checkin,
      button_checkout,
      jenis_notifikasi;

  var totalMessage;
  int company_id, user_id;
  bool config_location, config_barcode, config_macaddress, boolValue;
  bool config_ess = true;
  bool config_scan = true;

  var color = const Color(0xFF2196F3);

  AdvFabController controller;
  AdvFabController mabialaFABController;
  bool useFloatingSpaceBar = false;
  bool useAsFloatingActionButton = false;
  bool useNavigationBar = true;

  //block var notification

  ValueNotifier<int> notificationCounterValueNotifer = ValueNotifier(0);
  var databaseHelper = new DatabaseHelper();
  List<Widget> myListNotif = [];
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  //block var notification end
  //

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      initDynamicLinks();
      var userinfoTembak = await Data.getData();
      var user_idTembak = userinfoTembak['user_id'];
      var tokenTembak = userinfoTembak['token'];
      var dataTembak = {
        'user_id': user_idTembak,
        'token': tokenTembak,
      };

      print('postdata,$dataTembak');
      var resTembak =
          await CallApi().postCheckNotifBackground(dataTembak, 'templink');
      Map<String, dynamic> decodeTembak = json.decode(resTembak.body);
      print('URL TEMBAKAN , ' + decodeTembak['link_notif']);
      if (decodeTembak['link_notif'] != "") {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) =>
                InAppWebViewExampleScreen(decodeTembak['link_notif'])));
      }
      print("aplikasi di resume");
    }
  }

  @override
  void initState() {
    _state = SSBottomBarState();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = AdvFabController();
    pr.hide();

    //read db
    queryDB();

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

    var initializationSettings = new InitializationSettings();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    Future displayNotification(Map<String, dynamic> message) async {
      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          'PAYRIGHT', 'PAYRIGHT', 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          timeoutAfter: 5000,
          styleInformation: DefaultStyleInformation(true, true),
          visibility: NotificationVisibility.public);
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

    _firebaseMessaging.configure(
      // ignore: missing_return
      onMessage: (Map<String, dynamic> message) {
        // print(message['data']['notification_group'].toString());
        DateTime now = DateTime.now();
        DateFormat formatTanggal = DateFormat('yyyy-MM-dd');
        DateFormat formatJam = DateFormat('H:m');
        String tanggal = formatTanggal.format(now);
        String jam = formatJam.format(now);
        var isidata = message['data'];

        // _showTopFlash(style: FlashStyle.grounded);

        var extractdata = JSON.jsonDecode(isidata['data']);
        Map<String, dynamic> dataContent = extractdata;

        if (dataContent['notif_list_type'] == 'private') {
          jenis_notifikasi = 'private';
        } else {
          jenis_notifikasi = 'group';
        }

        var group_id = dataContent['notification_group'];
        var group_name = dataContent['notification_group'];
        var click_action = dataContent['click_action'];
        var href = dataContent['href_notification'];
        var param = dataContent['parameters'];

        var dataNotifikasi = new NotifikasiModel(
            "1", // id data ( absen, pengumuman, dan lain lain )
            message['notification']['title'].toString(),
            message['notification']['body'].toString(),
            tanggal.toString(),
            jam.toString(),
            jenis_notifikasi,
            'unread',
            group_id,
            group_name,
            click_action,
            href,
            param);

        databaseHelper.saveNotification(dataNotifikasi);

        print('database ke save');

        // notif toast
        var pesan = message['notification']['body'].toString();
        showInfo(context, pesan);

        // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
        displayNotification(message);

        notificationCounterValueNotifer.value++;
        notificationCounterValueNotifer
            .notifyListeners(); // notify listeners here so ValueListenableBuilder will build the widget.
      },
      onBackgroundMessage: Platform.isAndroid ? backGroundHandler : null,

      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        print('BACKGROUND');

        DateTime now = DateTime.now();
        DateFormat formatTanggal = DateFormat('yyyy-MM-dd');
        DateFormat formatJam = DateFormat('H:m');
        String tanggal = formatTanggal.format(now);
        String jam = formatJam.format(now);
        var isidata = message['data'];

        var extractdata = JSON.jsonDecode(isidata['data']);
        Map<String, dynamic> dataContent = extractdata;

        if (dataContent['notif_list_type'] == 'private') {
          jenis_notifikasi = 'private';
        } else {
          jenis_notifikasi = 'group';
        }
        var group_id = dataContent['notification_group'];
        var group_name = dataContent['notification_group'];
        var click_action = dataContent['click_action'];
        var href = dataContent['href_notification'];
        var param = dataContent['parameters'];
        var title = dataContent['title'];
        var pesan = dataContent['message'];

        var dataNotifikasi = new NotifikasiModel(
            "1", // id data ( absen, pengumuman, dan lain lain )

            title,
            pesan,
            tanggal.toString(),
            jam.toString(),
            jenis_notifikasi,
            'unread',
            group_id,
            group_name,
            click_action,
            href,
            param);

        databaseHelper.saveNotification(dataNotifikasi);

        print('database ke save di BACKGROUND');

        // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
        displayNotification(message);

        notificationCounterValueNotifer.value++;
        notificationCounterValueNotifer
            .notifyListeners(); // notify listeners here so ValueListenableBuilder will build the widget.

        // print('akhir BACKGROUND');
        // backGroundHandler(message);
      },

      onLaunch: (Map<String, dynamic> message) async {
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
      print('UPDATE TOKEN, $body');
    });
  }

  // initDynamicLinks(BuildContext context) async {
  //   await Future.delayed(Duration(seconds: 2));
  //   print('masuk ke dinamic link');
  //   var data = await FirebaseDynamicLinks.instance.getInitialLink();
  //   var deepLink = data?.link;
  //   print('ini deplink nya , $deepLink');
  //   final queryParams = deepLink.queryParameters;
  //   if (queryParams.length > 0) {
  //     print('tewak pram');
  //     // var userName = queryParams['userId'];
  //     var token = queryParams['token'];
  //   }
  //   FirebaseDynamicLinks.instance.onLink(onSuccess: (dynamicLink) async {
  //     var deepLink = dynamicLink?.link;
  //     debugPrint('DynamicLinks onLink $deepLink');
  //   }, onError: (e) async {
  //     debugPrint('DynamicLinks onError $e');
  //   });
  // }
  //
  void initDynamicLinks() async {
    print('GAIS');
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        Navigator.pushNamed(context, deepLink.path);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path);
    }
  }

  Future<String> queryDB() async {
    //cek isi database
    var dbClient = await databaseHelper.db;
    var isidb = await dbClient
        .rawQuery('select * from notifikasi order by tanggal desc, jam desc');
    print('isi db nya');
    print(isidb);
  }

  Future onSelectNotification(String payload) async {
    print('payload di background , $payload');
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
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
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
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            // builder: (context) => notificationPage()));
                            builder: (context) => LoginPage()));
                  }),
              // onPressed: () => showMyDialogNotification(context),
              // ),
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
        // Navigator.of(context).push(
        //     MaterialPageRoute(builder: (_) => ScanScreenIn()));
        //           })
        //     ]),

        //start edit visible
        floatingActionButton: Visibility(
          visible: !keyboardIsOpen,
          child: FabCircularMenu(
              // ringDiameter: MediaQuery.of(context).size.width * 0.75,
              // ringWidth: MediaQuery.of(context).size.width * 0.75 * 0.3,
              ringDiameter:
                  MediaQuery.of(context).size.width * 1.80, //ukuran bulatan
              ringWidth:
                  MediaQuery.of(context).size.width * 1.60 * 0.3, //lebar ring
              alignment: Alignment.bottomLeft,
              fabSize: 80.0, //ukuran bulatan float button nya
              fabElevation: 10.0, //ketinggian dari button float *tdk berguna
              fabColor: Colors.black, //warna float button *tdk berguna
              fabMargin: EdgeInsets.only(
                  left: 10,
                  right: 5,
                  bottom: 10), //jarak bulartan kecil ke kanan kiri
              fabCloseColor: Colors.white, //warna pada saat di tutup
              fabOpenColor: Colors.white54, //warna pada saat di buka
              fabOpenIcon: Icon(
                Icons.fingerprint_outlined,
                color: Colors.grey,
                size: 60,
              ),
              //           fabOpenIcon:  ImageIcon(
              //   AssetImage('assets/img/fingerprint.png'),
              //   size: 12,
              // ),
              //     fabOpenIcon: Container(
              //   child: Image(
              //     image: AssetImage(
              //      ' assets/img/fingerprint.png',
              //     ),
              //     fit: BoxFit.cover,
              //   ),
              //   height: 100,
              //   width: 100,
              // ),

              fabCloseIcon:
                  Icon(Icons.close, color: Colors.white), //icon untuk menutup
              // ringColor: Colors.blue[100],
              ringColor: Colors.grey[100],
              animationCurve: Curves.easeInOut,
              // onDisplayChange: print('print'),
              children: <Widget>[
                fabsinglemenuAbsenKeluar(() {
                  //set action for this menu
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => ScanScreenOut()));
                }),
                fabsinglemenuSimpanLokasi(() {
                  //set action for this menu
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => SimpanLokasi()));
                }),
                fabsinglemenuAbsenMasuk(() {
                  //set action for this menu
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => ScanScreenIn()));
                }),
              ]), //FAB circular Menu
        ),

        //end edit visible
        // floatingActionButton: FabCircularMenu(
        //     // ringDiameter: MediaQuery.of(context).size.width * 0.75,
        //     // ringWidth: MediaQuery.of(context).size.width * 0.75 * 0.3,
        //     ringDiameter:
        //         MediaQuery.of(context).size.width * 1.80, //ukuran bulatan
        //     ringWidth:
        //         MediaQuery.of(context).size.width * 1.60 * 0.3, //lebar ring
        //     alignment: Alignment.bottomLeft,
        //     fabSize: 80.0, //ukuran bulatan float button nya
        //     fabElevation: 10.0, //ketinggian dari button float *tdk berguna
        //     fabColor: Colors.black, //warna float button *tdk berguna
        //     fabMargin: EdgeInsets.only(
        //         left: 10,
        //         right: 5,
        //         bottom: 10), //jarak bulartan kecil ke kanan kiri
        //     fabCloseColor: Colors.white, //warna pada saat di tutup
        //     fabOpenColor: Colors.white54, //warna pada saat di buka
        //     fabOpenIcon: Icon(
        //       Icons.fingerprint_outlined,
        //       color: Colors.grey,
        //       size: 60,
        //     ),
        //     //           fabOpenIcon:  ImageIcon(
        //     //   AssetImage('assets/img/fingerprint.png'),
        //     //   size: 12,
        //     // ),
        //     //     fabOpenIcon: Container(
        //     //   child: Image(
        //     //     image: AssetImage(
        //     //      ' assets/img/fingerprint.png',
        //     //     ),
        //     //     fit: BoxFit.cover,
        //     //   ),
        //     //   height: 100,
        //     //   width: 100,
        //     // ),

        //     fabCloseIcon:
        //         Icon(Icons.close, color: Colors.white), //icon untuk menutup
        //     // ringColor: Colors.blue[100],
        //     ringColor: Colors.grey[100],
        //     animationCurve: Curves.easeInOut,
        //     // onDisplayChange: print('print'),
        //     children: <Widget>[
        //       fabsinglemenuAbsenKeluar(() {
        //         //set action for this menu
        //         Navigator.of(context)
        //             .push(MaterialPageRoute(builder: (_) => ScanScreenOut()));
        //       }),
        //       fabsinglemenuSimpanLokasi(() {
        //         //set action for this menu
        //         Navigator.of(context)
        //             .push(MaterialPageRoute(builder: (_) => SimpanLokasi()));
        //       }),
        //       fabsinglemenuAbsenMasuk(() {
        //         //set action for this menu
        //         Navigator.of(context)
        //             .push(MaterialPageRoute(builder: (_) => ScanScreenIn()));
        //       }),
        //     ]), //FAB circular Menu

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
                        initialUrl: widget.clickToAction == ""
                            ? "https://go.payrightsystem.com/v1/api/webviewlogin?jwt=$jwt"
                            : widget.clickToAction,
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
                              debuggingEnabled: false,
                              javaScriptCanOpenWindowsAutomatically: true,
                            ),
                            android: AndroidInAppWebViewOptions(
                              disableDefaultErrorPage: true,
                            )),
                        onWebViewCreated: (InAppWebViewController controller) {
                          clearSessionCache:
                          false;

                          webView = controller;
                          withLocalStorage:
                          true;
                        },
                        androidOnPermissionRequest:
                            (InAppWebViewController controller, String origin,
                                List<String> resources) async {
                          return PermissionRequestResponse(
                              resources: resources,
                              action: PermissionRequestResponseAction.GRANT);
                        },
                        androidOnRequestFocus:
                            (InAppWebViewController controller) {
                          androidOnRequestFocus:
                          true;
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
                                        InAppWebViewExampleScreen(widget
                                                    .clickToAction ==
                                                ""
                                            ? "https://go.payrightsystem.com/v1/api/webviewlogin?jwt=$jwt"
                                            : widget.clickToAction)));
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
                          });
                          Future.delayed(Duration(seconds: 1)).then((onValue) {
                            pr.hide();
                          });

                          if (url ==
                                  'https://go.payrightsystem.com/home/notloggedin' ||
                              url == 'https://go.payrightsystem.com/login') {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        InAppWebViewExampleScreen(widget
                                                    .clickToAction ==
                                                ""
                                            ? "https://go.payrightsystem.com/v1/api/webviewlogin?jwt=$jwt"
                                            : widget.clickToAction)));
                            print('reload lagi');
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

  Widget fabsinglemenuAbsenMasuk(Function onPressFunction) {
    return SizedBox(
        width: 120,
        height: 120,
        //height and width for menu button

        child: FlatButton(
          color: color,
          child: Image.asset('assets/img/absenmasuk.png'),
          onPressed: onPressFunction,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(45.0),
          ),
        ));
  }

  Widget fabsinglemenuAbsenKeluar(Function onPressFunction) {
    return SizedBox(
      width: 120,
      height: 120,
      //height and width for menu button

      child: FlatButton(
        color: color,
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

  Widget fabsinglemenuSimpanLokasi(Function onPressFunction) {
    return SizedBox(
      width: 120,
      height: 120,
      //height and width for menu button

      child: FlatButton(
        color: color,
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

  //var for alertStyle
  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: true,
    isOverlayTapDismiss: true,
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
    var dbClient = await databaseHelper.db;
    var gemessage = await dbClient
        .rawQuery('select * from notifikasi order by tanggal desc, jam desc');

    //showNotifUper();

    // print('isi pesan nya on message ${message}');
    // print(' "gemessage  sssss =>",$gemessage');

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
            titlePadding: EdgeInsets.all(3.0),
            contentPadding: EdgeInsets.all(0.0),
            scrollable: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                side: BorderSide(color: Colors.grey)),
            title: Text(
              "",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontFamily: "Poppins",
              ),
              textAlign: TextAlign.center,
            ),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Image.asset(
                'assets/img/notifications.png',
                height: 125,
                fit: BoxFit.cover,
              ),
              Divider(
                height: 5.0,
                color: Colors.grey,
              ),
              Flexible(
                  child: SingleChildScrollView(
                      child: FutureBuilder<bool>(
                          future: getMyList(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: listWidgetNotif);
                            } else {
                              return Container();
                            }
                          }))),
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
        // print('jumlah notifikasi');
        // print(newNotificationCounterValue.toString());
        //returns an empty container if the value is 0 and returns the Stack otherwise
        // return newNotificationCounterValue == 0
        //     ? Container()
        //     :
        return Stack(
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
                    newNotificationCounterValue == 0
                        ? '0'
                        : newNotificationCounterValue.toString(),
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
    print('get notifikasi');
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

  Future<bool> getMyList() async {
    print('terload nyah');
    print(getNotifTerload);
    // if (getNotifTerload == 0) {
    // getNotification();
    // }

    var dbClient = await databaseHelper.db;
    List<Map> listNotifikasi = await dbClient.rawQuery(
        "SELECT * FROM notifikasi where status ='unread' order by tanggal desc, jam desc");
    print(listNotifikasi);
    print("panjangg : " + listNotifikasi.length.toString());
    listWidgetNotif = [];
    List<Widget> listPrivate = [];
    List<Widget> listGroup = [];
    for (var i = 0; i < listNotifikasi.length; i++) {
      if (listNotifikasi[i]['grup'] == 'private') {
        listPrivate.add(GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(children: <Widget>[
                Text(
                  listNotifikasi[i]['body'],
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                      fontFamily: "Poppins"),
                ),
                Text(
                  listNotifikasi[i]['tanggal'] +
                      " Jam " +
                      listNotifikasi[i]['jam'],
                  style: TextStyle(
                      color: Colors.grey[350],
                      fontSize: 8,
                      fontFamily: "Poppins"),
                ),
              ]),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => InAppWebViewExampleScreen(
                      listNotifikasi[i]['click_action'].toString())));
            }));
      } else {
        listGroup.add(GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(children: <Widget>[
                Text(
                  listNotifikasi[i]['body'],
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                      fontFamily: "Poppins"),
                ),
                Text(
                  listNotifikasi[i]['tanggal'] +
                      " Jam " +
                      listNotifikasi[i]['jam'],
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 8,
                      fontFamily: "Poppins"),
                ),
              ]),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => InAppWebViewExampleScreen(
                      listNotifikasi[i]['click_action'].toString())));
            }));
      }
    }

    if (listPrivate.length != 0) {
      listWidgetNotif.add(Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          Text(
            "PRIVATE ",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontFamily: "Poppins"),
          ),
          Divider(
            height: 5.0,
            color: Colors.black,
          ),
        ]),
      ));
      listWidgetNotif.add(Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(children: listPrivate),
      ));
    }
    if (listGroup.length != 0) {
      listWidgetNotif.add(Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          Text(
            "GROUP ",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontFamily: "Poppins"),
          ),
          Divider(
            height: 5.0,
            color: Colors.black,
          ),
        ]),
      ));
      listWidgetNotif.add(Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(children: listGroup),
      ));
    }

    // myListNotif.map((x) {
    // return Padding(
    //   padding: EdgeInsets.all(10.0),
    //   child: Column(children: <Widget>[
    //     Text(
    //       x ,
    //       style: TextStyle(
    //           color: Colors.grey[800], fontSize: 16, fontFamily: "Poppins"),
    //     )
    //   ]),
    // );
    // }).toList();
    return true;
  }

  void showDefaultSnackbar(BuildContext context) {
    print('000snackbar');
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Hello from the default snackbar'),
        action: SnackBarAction(
          label: 'Click Me',
          onPressed: () {},
        ),
      ),
    );
  }

  void _showBasicsFlash({
    Duration duration,
    flashStyle = FlashStyle.floating,
  }) {
    showFlash(
      context: context,
      duration: duration,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          style: flashStyle,
          boxShadows: kElevationToShadow[4],
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          child: FlashBar(
            message: Text('This is a basic flash'),
          ),
        );
      },
    );
  }

  void _showTopFlash({FlashStyle style = FlashStyle.floating}) {
    showFlash(
      context: context,
      duration: const Duration(seconds: 2),
      persistent: false,
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          boxShadows: [BoxShadow(blurRadius: 4)],
          barrierBlur: 3.0,
          barrierColor: Colors.black38,
          barrierDismissible: true,
          style: style,
          position: FlashPosition.top,
          child: FlashBar(
            title: Text('Title'),
            message: Text('Hello world!'),
            showProgressIndicator: true,
            primaryAction: FlatButton(
              onPressed: () => controller.dismiss(),
              child: Text('DISMISS', style: TextStyle(color: Colors.amber)),
            ),
          ),
        );
      },
    );
  }

  Future showNotifBackground(Map<String, dynamic> message) async {
    print(message.toString());
    DateTime now = DateTime.now();
    DateFormat formatTanggal = DateFormat('yyyy-MM-dd');
    DateFormat formatJam = DateFormat('H:m');
    String tanggal = formatTanggal.format(now);
    String jam = formatJam.format(now);
    // var isidata = message['data'];
    // var extractdata = JSON.jsonDecode(isidata['data']);
    // Map<String, dynamic> dataContent = extractdata;
    // String jenis_notifikasi = dataContent['jenis_notifikasi'];
    // String group_id = dataContent['notification_group'];
    // String group_name = dataContent['notification_group'];
    // String click_action = dataContent['click_action'];
    // String href = dataContent['href_notification'];
    // String param = dataContent['parameters'];
    String jenisNotifikasi = "group";
    if (message['data'] == 'private') {
      jenisNotifikasi = 'private';
    }
    var dataNotifikasi = new NotifikasiModel(
        "1",
        message['data']['title'].toString(),
        message['data']['body'].toString(),
        tanggal.toString(),
        jam.toString(),
        jenisNotifikasi,
        'unread',
        message['data']['notification_group'].toString(),
        message['data']['notif_group_name'].toString(),
        message['data']['click_action'].toString(),
        message['data']['href_notification'].toString(),
        message['data']['parameters'].toString());
    databaseHelper.saveNotification(dataNotifikasi);
    print('database ke save ' + message['data']['title'].toString());

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/logo');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'PAYRIGHT', 'PAYRIGHT', 'your channel description',
        importance: Importance.max, priority: Priority.high, showWhen: false);

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      message['data']['title'].toString(),
      message['data']['body'].toString(),
      platformChannelSpecifics,
      payload: 'background',
    );
  }

  void _showBottomFlash(String title, String pesan) {
    bool persistent = false;
    // EdgeInsets margin = EdgeInsets.zero;
    Duration duration;
    print('dalam botom flash');

    showFlash(
      context: context,
      duration: duration,
      builder: (context, controller) {
        return Flash(
            controller: controller,
            style: FlashStyle.floating,
            boxShadows: kElevationToShadow[4],
            horizontalDismissDirection: HorizontalDismissDirection.horizontal,
            child: FlashBar(
                title: Text(title),
                message: Text(pesan),
                leftBarIndicatorColor: Colors.grey,
                icon: Icon(Icons.notifications),
                primaryAction: FlatButton(
                  onPressed: () => controller.dismiss(),
                  child: Text(
                    'Lihat Notifikasi',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontFamily: "Poppins"),
                  ),
                )));
      },
    );

    print('masuk pa eko Flash');
  }

  //toast

  void showInfo(BuildContext context, String message,
      {bool shouldDismiss = true}) {
    Timer.run(() => _showAlert(context, message, Color(0xFFE7EDFB),
        Icons.notifications, Color.fromRGBO(54, 105, 214, 1), shouldDismiss));
  }

  void showError(BuildContext context, String message,
      {bool shouldDismiss = true}) {
    Timer.run(() => _showAlert(context, message, Color(0xFFFDE2E1),
        Icons.error_outline, Colors.red, shouldDismiss));
  }

  void _showAlert(BuildContext context, String message, Color color,
      IconData icon, Color iconColor, bool shouldDismiss) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          if (shouldDismiss) {
            Future.delayed(const Duration(milliseconds: 1000), () {
              Navigator.of(context, rootNavigator: true).pop(true);
            });
          }
          return Material(
            type: MaterialType.transparency,
            child: WillPopScope(
              onWillPop: () async => false,
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10),
                              bottom: Radius.circular(10)),
                          color: color),
                      width: MediaQuery.of(context).size.width - 40,
                      height: MediaQuery.of(context).size.height / 9,
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            icon,
                            size: 30,
                            color: iconColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              message,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.black),
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ),
          );
        });
  }

  void _showMessage(String message) {
    if (!mounted) return;
    showFlash(
        context: context,
        duration: Duration(seconds: 3),
        builder: (_, controller) {
          return Flash(
            controller: controller,
            position: FlashPosition.top,
            style: FlashStyle.grounded,
            child: FlashBar(
              icon: Icon(
                Icons.face,
                size: 36.0,
                color: Colors.black,
              ),
              message: Text(message),
            ),
          );
        });
  }
}

// Future<dynamic> backGroundHandler(Map<String, dynamic> message) async {
//   print("DING");
//   _InAppWebViewExampleScreenState notificationClass =
//       new _InAppWebViewExampleScreenState();
//   notificationClass.showNotifBackground(message);
// }
