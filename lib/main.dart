import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:new_payrightsystem/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_payrightsystem/ui/loginPage.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// import 'package:new_payrightsystem/ui/Home/dashboardzakir.dart';
import 'package:new_payrightsystem/utils/network/conectivity.dart';
import 'package:new_payrightsystem/utils/notification_services.dart';
import 'package:new_payrightsystem/utils/push_notifications.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:new_payrightsystem/ui/Home/webviewMain.dart';

import 'dart:developer';
import 'dart:io';
import 'dart:convert' as JSON;
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'package:new_payrightsystem/utils/dynamiclink_service.dart';

// import 'package:overlay_support/overlay_support.dart';

// import 'package:device_info/device_info.dart';
// import 'package:trust_fall/trust_fall.dart';

import 'data/DatabaseHelper.dart';
import 'data/model/User.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:overlay_support/overlay_support.dart';
//import 'package:trust_fall/trust_fall.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(new MyApp());
}
// void main() =>
//     runApp(new MyApp());

//NotificationService notificationService = new NotificationService();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      color: Colors.blue,
      debugShowCheckedModeBanner: false,
      home: new Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
  var _isLogginShared;

  Future<bool> pageRouteCheck() async {
    var userinfo = await Data.getData();
    var userinfoEmpty = userinfo.isNotEmpty;
    print('apakah userinfo tidak kosong [diPageRouteChek], $userinfoEmpty');
    this.initDynamicLinks(context);
    checkFirstSeen(userinfoEmpty);
  }

  Future<String> checkFirstSeen(userinfoEmpty) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool _isLoggin = (prefs.getBool('isLogin') ?? false);
    bool _seen = (prefs.getBool('seen') ?? false);

    //debug
    var ceklogin = prefs.getBool('isLogin');
    var ceksplash = prefs.getBool('seen');

    bool _visibleCheckIn = true;
    bool _visibleCheckOut = true;
    //  bool _isLogginShared = false;

    _seen = false;
    if (userinfoEmpty) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) =>
              // new dashboard(_visibleCheckIn, _visibleCheckOut)
              new InAppWebViewExampleScreen("")));
    } else {
      if (_seen) {
        await prefs.setBool('isLogin', true);
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new LoginPage()));
        // new MaterialPageRoute(builder: (context) => new dashboard(_visibleCheckIn ,_visibleCheckOut)));
      } else {
        await prefs.setBool('seen', true);
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new SplashScreen()));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // FirebaseApp.initializeApp();
    new Timer(new Duration(milliseconds: 3000), () {
      //getSavedData();
      // this.initDynamicLinks(context);
      pageRouteCheck();
      // checkDevice();
      // print('pemanggilan class');
      //PushNotificationsManager();

      ///checkFirstSeen();
    });
  }

  initDynamicLinks(BuildContext context) async {
    await Future.delayed(Duration(seconds: 4));
    print('masuk ke dinamic link');
    var data = await FirebaseDynamicLinks.instance.getInitialLink();
    var deepLink = data?.link;
    print('ini deplink nya , $deepLink');
    final queryParams = deepLink.queryParameters;
    if (queryParams.length > 0) {
      print('tewak pram');
      // var userName = queryParams['userId'];
      var token = queryParams['token'];
    }
    FirebaseDynamicLinks.instance.onLink(onSuccess: (dynamicLink) async {
      var deepLink = dynamicLink?.link;
      debugPrint('DynamicLinks onLink $deepLink');
    }, onError: (e) async {
      debugPrint('DynamicLinks onError $e');
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
          child: SpinKitWave(
        color: Colors.blue[300],
        size: 40.0,
      )),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Container(
  //         padding: EdgeInsets.all(8.0),
  //         child: Center(
  //           // child: Shimmer.fromColors(
  //           //     direction: ShimmerDirection.rtl,
  //           //     period: Duration(seconds: 3),
  //           child: new Scaffold(
  //               appBar: AppBar(
  //                 centerTitle: true,
  //                 elevation: 3.0,
  //                 backgroundColor: Colors.grey[300],
  //                 title: Image.asset(
  //                   'assets/img/logo.png',
  //                   width: 120.0,
  //                   height: 120.0,
  //                 ),
  //               ),
  //               body: Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Column(children: <Widget>[
  //                     SizedBox(
  //                       width: MediaQuery.of(context).size.width,
  //                       height: 400.0,
  //                       child: Card(
  //                         color: Colors.grey,
  //                       ),
  //                     )
  //                   ]))),
  //           // baseColor: Colors.grey[200],
  //           // highlightColor: Colors.grey[400]),
  //         )),
  //   );
  // }
}

class SplashScreen extends StatelessWidget {
  static TextStyle style = TextStyle(
    fontSize: 20.0,
  );
//making list of pages needed to pass in IntroViewsFlutter constructor.
  final pages = [
    PageViewModel(
        pageColor: const Color(0XFFFFFFFF),
        bubble: Image.asset('assets/img/logo.png'),
        body: Text(
//          'Welcome  to  intro  slider  in  flutter  with  package  intro  views  flutter  latest  update',
          'Halo! Terima kasih sudah menggunakan aplikasi layanan mandiri PayRight.',
          style: TextStyle(fontSize: 20.0, fontFamily: "Poppins"),
        ),
        title: Text(
          'PayrightSystem',
          style: TextStyle(
              fontSize: 8.0,
              color: Colors.blue[300],
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins"),
        ),
        textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.blue[300]),
        mainImage: Image.asset(
          'assets/img/app.png',
          height: 300.0,
          width: 300.0,
          alignment: Alignment.center,
        )),
    PageViewModel(
      pageColor: const Color(0XFFFFFFFF),
      iconImageAssetPath: 'assets/img/logo.png',
      body: Text(
//        'Amazevalley  intoduce  you  with  the  latest  features  coming  in  flutter  with  practical  demos',
        'Dengan aplikasi ini, anda bisa mendapatkan kemudahan untuk terhubung dengan organisasi Anda.',
        style: TextStyle(fontSize: 20.0, fontFamily: "Poppins"),
      ),
      title: Text(
        'PayrightSystem',
        style: TextStyle(
            fontSize: 8.0,
            color: Colors.blue[300],
            fontWeight: FontWeight.w400,
            fontFamily: "Poppins"),
      ),
      mainImage: Image.asset(
        'assets/img/report.png',
        height: 300.0,
        width: 300.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.blue[300]),
    ),
    PageViewModel(
      pageColor: const Color(0XFFFFFFFF),
      iconImageAssetPath: 'assets/img/logo.png',
      body: Text(
//        'Amazevalley  give  you  brief  soluton  about  technology  where  you  fall  in  love',
        'Siapkan nomor HP Anda yang akan diverifikasi oleh admin di organisasi Anda.  Nomor PIN akan dikirimkan ke nomor tersebut.',
        style: TextStyle(fontSize: 19.0, fontFamily: "Poppins"),
      ),
      title: Text(
        'PayrightSystem',
        style: TextStyle(
            fontSize: 8.0,
            color: Colors.blue[300],
            fontWeight: FontWeight.w400,
            fontFamily: "Poppins"),
      ),
      mainImage: Image.asset(
        'assets/img/auth.png',
        height: 300.0,
        width: 300.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.blue[300]),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // navigatorKey: notificationService.navigatorKey,
      title: 'Intro of the application', //title of app
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ), //ThemeData
      home: Builder(
        builder: (context) => IntroViewsFlutter(
          pages,
          onTapDoneButton: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ), //MaterialPageRoute
            );
          },
          pageButtonTextStyles: TextStyle(
            color: Colors.blue[100],
            fontSize: 14.0,
          ),
        ), //IntroViewsFlutter
      ), //Builder
    ); //Material App
  }
}
