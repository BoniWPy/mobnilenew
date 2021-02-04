import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:new_payrightsystem/ui/Home/dashboardzakir.dart';
import 'package:adv_fab/adv_fab.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:new_payrightsystem/ui/checkinout/checkIn.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:extended_navbar_scaffold/extended_navbar_scaffold.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ss_bottom_navbar/src/ss_bottom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:ss_bottom_navbar/ss_bottom_navbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  final _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.teal
  ];

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
  @override
  void initState() {
    _state = SSBottomBarState();
    super.initState();
    controller = AdvFabController();

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
          // title: Text("Payrightsystem"),
          actions: [
            Icon(
              Icons.notifications,
              color: Colors.grey[400],
              size: 30,
            ),
          ],
        ),

        // floatingActionButton: ,
        // floatingActionButton: Row(children: [
        //   RaisedButton(
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
            ringDiameter: MediaQuery.of(context).size.width * 0.75,
            ringWidth: MediaQuery.of(context).size.width * 0.75 * 0.3,
            alignment: Alignment.bottomLeft,
            fabSize: 32.0,
            fabElevation: 16.0,
            fabMargin: EdgeInsets.only(left: 45, bottom: 45),
            fabCloseColor: Colors.grey,
            fabOpenColor: Colors.blue[100],
            fabOpenIcon: Icon(Icons.home, color: Colors.white),
            fabCloseIcon: Icon(Icons.close, color: Colors.white),
            ringColor: Colors.blue[100],
            children: <Widget>[
              fabsinglemenuAbsenMasuk(Icons.home, () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => ScanScreenIn()));
              }),
              fabsinglemenuAbsenKeluar(Icons.alarm, () {
                //set action for this menu
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => ScanScreenIn()));
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
              child: InAppWebView(
                initialUrl: "https://new.payright.dev/d.html",
                initialHeaders: {
                  // 'access-control-request-headers': 'payright-webview',
                },
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    debuggingEnabled: false,
                    useShouldOverrideUrlLoading: true,
                    cacheEnabled: true,
                    javaScriptEnabled: true,
                  ),
                  // android: AndroidInAppWebViewOptions(
                  //   useHybridComposition: true
                  // )
                ),
                onWebViewCreated: (InAppWebViewController controller) {
                  webView = controller;
                  clearSessionCache:
                  false;
                },
                onLoadStart: (InAppWebViewController controller, String url) {
                  print("onLoadStart $url");
                  setState(() {
                    this.url = url;
                  });
                },
                shouldOverrideUrlLoading:
                    (controller, shouldOverrideUrlLoadingRequest) async {
                  var url = shouldOverrideUrlLoadingRequest.url;
                  var uri = Uri.parse(url);

                  if (![
                    "http",
                    "https",
                    "file",
                    "chrome",
                    "data",
                    "javascript",
                    "about"
                  ].contains(uri.scheme)) {
                    if (await canLaunch(url)) {
                      // Launch the App
                      await launch(
                        url,
                      );
                      // and cancel the request
                      return ShouldOverrideUrlLoadingAction.CANCEL;
                    }
                  }

                  return ShouldOverrideUrlLoadingAction.ALLOW;
                },
                onLoadStop:
                    (InAppWebViewController controller, String url) async {
                  print("onLoadStop $url");

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
                onUpdateVisitedHistory: (InAppWebViewController controller,
                    String url, bool androidIsReload) {
                  print("onUp dateVisitedHistory $url");
                  setState(() {
                    this.url = url;
                  });
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage);
                },
              ),
            ),
          ),
        ])));
  }

  Widget fabsinglemenuAbsenMasuk(IconData icon, Function onPressFunction) {
    return SizedBox(
        width: 85.0,
        height: 85.0,
        //height and width for menu button

        child: RaisedButton(
          color: Colors.white,
          child: Image.asset('assets/img/absorbed_in.png'),
          onPressed: onPressFunction,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ));
  }

  Widget fabsinglemenuAbsenKeluar(IconData icon, Function onPressFunction) {
    return SizedBox(
      width: 85.0,
      height: 85.0,
      //height and width for menu button

      child: RaisedButton(
        color: Colors.white,
        child: Image.asset('assets/img/going_home.png'),
        onPressed: onPressFunction,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  Widget fabsinglemenuAbsenKeluar2(IconData icon, Function onPressFunction) {
    return Column(children: [
      SizedBox(
        width: 85.0,
        height: 85.0,
        //height and width for menu button

        child: RaisedButton(
          color: Colors.white,
          child: Image.asset('assets/img/going_home.png'),
          onPressed: onPressFunction,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(40.0),
          ),
        ),
      ),
      Text("Absen Masuk")
    ]);
  }

  // Widget myAppBarIcon() {
  //   //you have to return the widget from builder method.
  //   //you can add logics inside your builder method. for example, if you don't want to show a badge when the value is 0.
  //   return ValueListenableBuilder(
  //     builder: (BuildContext context, int newNotificationCounterValue,
  //         Widget child) {
  //       print('jumlah notifikasi');
  //       print(newNotificationCounterValue.toString());
  //       //returns an empty container if the value is 0 and returns the Stack otherwise
  //       return newNotificationCounterValue == 0
  //           ? Container()
  //           : Stack(
  //               alignment: AlignmentDirectional.topCenter,
  //               children: [
  //                 Icon(
  //                   Icons.notifications,
  //                   color: Colors.grey[400],
  //                   size: 30,
  //                 ),
  //                 Container(
  //                   width: 30,
  //                   height: 30,
  //                   alignment: Alignment.topRight,
  //                   margin: EdgeInsets.only(right: 0.0),
  //                   child: Container(
  //                     width: 15,
  //                     height: 15,
  //                     decoration: BoxDecoration(
  //                         shape: BoxShape.circle,
  //                         color: Colors.blue[300],
  //                         border: Border.all(color: Colors.white, width: 1)),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(0.0),
  //                       child: Text(
  //                         newNotificationCounterValue.toString(),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             );
  //     },
  //     valueListenable: notificationCounterValueNotifer,
  //   );
  // }

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
}
