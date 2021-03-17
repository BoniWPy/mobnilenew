import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_payrightsystem/data/DatabaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:new_payrightsystem/utils/api/api.dart';
import 'package:new_payrightsystem/style/theme.dart' as Theme;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:new_payrightsystem/ui/Home/dashboardzakir.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_payrightsystem/ui/Home/webviewMain.dart';

// import 'package:new_payrightsystem/utils/validations.dart';
//add progress dialog, animation loading
import 'package:progress_dialog/progress_dialog.dart';
//make shared preferences global as helper
import 'package:new_payrightsystem/utils/shared_preferences.dart';

//TODO: error hint dimatikan, masuh memikirkan ukuran nya

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

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var email, name, password, token;

  final FocusNode myFocusNodeOtp = FocusNode();
  final FocusNode myFocusNodePhone = FocusNode();

  TextEditingController loginPhonController = new TextEditingController();
  TextEditingController loginOtpController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _validationPhoneNumber = false;
  bool _validationOtp = false;

  PageController _pageController;

  bool _visibleCheckIn, _visibleCheckOut;

  Color left = Colors.black;
  Color right = Colors.white;

  ProgressDialog get pr =>
      new ProgressDialog(context, type: ProgressDialogType.Normal);

  var nextRoute;
  bool _isLogginShared;

  Future<dynamic> getSavedData() async {
    var userinfo = await Data.getData();

    if (!userinfo.isEmpty) {
      nextRoute = Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) =>
                  dashboard(_visibleCheckIn, _visibleCheckOut)));
      print('dilogin, masuk ke nextroute, langsung ke DASHBOARD');
      return nextRoute;
    }
    print('di login, gagal nextrout KARENA ISI SHARED KOSONG');
  }

  @override
  Widget build(BuildContext context) {
    // return new Scaffold(
    //   body: new Center(
    //     child:SpinKitWave(
    //       color: Colors.blue[300],
    //       size: 40.0,
    //     )
    //   )
    // );
    return new Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height >= 450.0
                ? MediaQuery.of(context).size.height
                : 450.0,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Theme.Colors.loginGradientEnd,
                    Theme.Colors.loginGradientStart
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 100.0),
                  child: new Image(
                      width: 250.0,
                      height: 200.0,
                      fit: BoxFit.fill,
                      image: new AssetImage('assets/img/mobileApps.png')),
                ),
                Padding(
                  //image atas dengan box
                  padding: EdgeInsets.only(top: 30.0),
                  // child: _buildMenuBar(context),
                ),
                Expanded(
                  flex: 2,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (i) {
                      if (i == 0) {
                        setState(() {
                          right = Colors.white;
                          left = Colors.blue[300];
                        });
                      } else if (i == 1) {
                        setState(() {
                          right = Colors.blue[300];
                          left = Colors.white;
                        });
                      }
                    },
                    children: <Widget>[
                      new ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: _buildSignIn(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    myFocusNodePhone.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // getSavedData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 250.0,
                  height: 180.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          //DONE: validation before click
                          //TODO: color validation not exited

                          onChanged: (value) {
                            _validationPhoneNumber = value.length < 10;
                            setState(() {});
                          },
                          focusNode: myFocusNodePhone,
                          controller: loginPhonController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.mobile,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: "Phone Number",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 17.0),

                            // errorStyle: TextStyle(fontSize: 8.0) ,
                            // errorText: _validationPhoneNumber
                            //     ? "Masukan Nomor Handphone "
                            //     : null,
                          ),
                        ),
                      ),
                      Container(
                        width: 200.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          //DONE:validation for otp Kode before input
                          onChanged: (value) {
                            _validationOtp = value.length != 6;
                            setState(() {});
                          },
                          focusNode: myFocusNodeOtp,
                          controller: loginOtpController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),

                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.sms,
                              size: 22.0,
                              color: Colors.black,
                            ),
                            // errorStyle: TextStyle(fontSize: 4.0) ,
                            // errorText:
                            //     _validationOtp ? "Masukan Kode OTP" : null,
                            hintText: "Kode OTP",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: Icon(
                                _obscureTextLogin
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 180.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.Colors.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: Theme.Colors.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: new LinearGradient(
                      colors: [
                        Theme.Colors.loginGradientEnd,
                        Theme.Colors.loginGradientStart
                      ],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                  highlightColor: Colors.blue[200],
                  splashColor: Theme.Colors.loginGradientEnd,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      "Masuk",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 22.0,
                          fontFamily: "WorkSansBold"),
                    ),
                  ),
                  onPressed: _login,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
          child: Text("Loading"),
          onPressed: () {},
        ),
      ),
    );
  }

  void _login() async {
    var data = {
      'mobile': loginPhonController.text,
      'otp': loginOtpController.text
    };
    print(data);
    //print("test Data asup teu");
    // var databaseHelper = new DatabaseHelper();
    // var dbClient = await databaseHelper.db;
    // List<Map> list = await dbClient.rawQuery('SELECT * FROM user');
    // print("ini mobile "+list[0]["mobile"]);
    // print(data);
    //TODO: fixing validation,
    /*      1. if phonenumber < 10
            2. if otp != 6
            3. if phonenumber > 10 and otp != 6
    */
    //FIXME: done validation

    //FIXME: validation for much images, based by wrong type

    if (loginPhonController.text.length <= 10 &&
        loginOtpController.text.length != 6) {
      // Future.delayed(Duration(seconds: 1)).then((onValue) {
      //   Navigator.push(
      //       context,
      //       new MaterialPageRoute(
      //           builder: (context) => InAppWebViewExampleScreen()));
      // });
      print("kurang dari sepuluh");
      Alert(
        context: context,
        style: alertStyle,
        title: "Masukan No Handphone",
        image: Image.asset("assets/img/mobile_pay.png"),
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            // color: Color.fromRGBO(0, 179, 134, 1.0),
            color: Colors.blue[300],
            radius: BorderRadius.circular(20.0),
          ),
        ],
      ).show();
    } else if (loginPhonController.text.length <= 10 &&
        loginOtpController.text.length == 6) {
      //validatiion befor typing mobile number and otp
      print("kurang dari sepuluh");
      Alert(
        context: context,
        style: alertStyle,
        title: "Masukan No Handphone",
        image: Image.asset("assets/img/mobile_pay.png"),
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            // color: Color.fromRGBO(0, 179, 134, 1.0),
            color: Colors.blue[300],
            radius: BorderRadius.circular(20.0),
          ),
        ],
      ).show();
    } else if (loginPhonController.text.length >= 10 &&
        loginOtpController.text.length != 6) {
      print("kode otp kurang");
      Alert(
        context: context,
        style: alertStyle,
        title: "Masukan Kode OTP Anda",
        image: Image.asset("assets/img/mobile_pay.png"),
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            // color: Color.fromRGBO(0, 179, 134, 1.0),
            color: Colors.blue[300],
            radius: BorderRadius.circular(20.0),
          ),
        ],
      ).show();
    } else if (loginPhonController.text.length >= 10 &&
        loginOtpController.text.length == 6) {
      var res = await CallApi().postDataLogin(data, 'loginmobile');
      var body = json.decode(res.body);

      print(body);
      if (body["token"] != null) {
        savedata() {
          if (body['last_checktime_type'] == 'check_in') {
            var userinfo = {
              'name': body['name'],
              'username': body['username'],
              'user_id': body['user_id'],
              'company_name': body['company_name'],
              'token': body['token'],
              'company_id': body['company_id'],
              'employee_id': body['employee_id'],
              'employee_employ_id': body['employee_employ_id'],
              'company_config_id': body['company_config_id'],
              'config_location': body['config_location'],
              'config_barcode': body['config_barcode'],
              'config_macaddress': body['config_macaddress'],
              'is_login_shared': true,
              'button_checkin': 'visible',
              'button_checkout': 'invisible',
              'config_ess': body['config_ess'],
              'config_scan': body['config_scan'],
              'config_barcode_value': body['config_barcode_value'],
            };
            Data.saveData(userinfo);
          } else {
            var userinfo = {
              'name': body['name'],
              'username': body['username'],
              'user_id': body['user_id'],
              'company_name': body['company_name'],
              'token': body['token'],
              'company_id': body['company_id'],
              'employee_id': body['employee_id'],
              'employee_employ_id': body['employee_employ_id'],
              'company_config_id': body['company_config_id'],
              'config_location': body['config_location'],
              'config_barcode': body['config_barcode'],
              'config_macaddress': body['config_macaddress'],
              'is_login_shared': true,
              'button_checkin': 'visible',
              'button_checkout': 'invisible',
              'config_ess': body['config_ess'],
              'config_scan': body['config_scan'],
              'config_barcode_value': body['config_barcode_value'],
            };
            Data.saveData(userinfo);
          }
        }

        savedata();

        //TODO: *rapihinshared = must be more efecient. "write once, used everywhere !!!"

        //loading loader
        pr.show();

        Future.delayed(Duration(seconds: 1)).then((onValue) {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) =>
                      // dashboard(_visibleCheckIn, _visibleCheckOut)
                      InAppWebViewExampleScreen("")));
        });
      } else {
        print('gagal login');
        Alert(
          context: context,
          title: "No Handphone atau Kode OTP anda salah",
          style: alertStyle,
          image: Image.asset("assets/img/cncl.png"),
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              color: Colors.blue[300],
              radius: BorderRadius.circular(20.0),
            ),
          ],
        ).show();
        print('Unauthorized');
      }
    } //end if else validation
  } //end of void _login

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ProgressDialog>('pr', pr));
  }
}
