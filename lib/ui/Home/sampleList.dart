import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:new_payrightsystem/utils/customColors.dart';
import 'package:new_payrightsystem/utils/shared_preferences.dart';
import 'package:new_payrightsystem/utils/slide.dart';
import 'package:new_payrightsystem/utils/fab.dart';
import 'package:new_payrightsystem/utils/appBars.dart';
import 'package:new_payrightsystem/utils/api/api.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final bottomNavigationBarIndex = 0;

  Map<String, dynamic> check_out = {};
  var check_in = List();

  Future<List<dynamic>> _getHistoryAbsence() async {
    List<dynamic> check_in;
    var userinfo = await Data.getData();
    var user_id = userinfo['user_id'];
    var data = {'user_id': user_id};
    var response = await CallApi().getHistoryAbsence(data, 'historyabsence');
    var body = json.decode(response.body);

    Map<String, dynamic> arrayCheck_in = body;
    check_in = arrayCheck_in['check_in'];
    print(check_in);
  }

  @override
  Widget build(BuildContext context) {
    _getHistoryAbsence();
    // print('$check_in, $check_out');
    return Scaffold(
      appBar: fullAppbar(context),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 15, left: 20, bottom: 15),
              child: Text(
                'Hari ini',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: CustomColors.TextSubHeader),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
              padding: EdgeInsets.fromLTRB(5, 18, 5, 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset('assets/img/mini_absorded_in.png'),
                  Text(
                    ' 08.38',
                    style: TextStyle(color: CustomColors.TextGrey),
                  ),
                  Container(
                    width: 180,
                    child: Text(
                      'Absen Masuk',
                      style: TextStyle(
                          color: CustomColors.TextGrey,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ),
                  Image.asset('assets/img/checked.png'),
                ],
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: [0.015, 0.015],
                  colors: [CustomColors.BlueIcon, Colors.white],
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
            Container(
              margin: EdgeInsets.only(left: 20, bottom: 15),
              child: Text(
                'Kemarin',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: CustomColors.TextSubHeader),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
              padding: EdgeInsets.fromLTRB(5, 18, 5, 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset('assets/img/mini_going_home'),
                  Text(
                    '17.40',
                    style: TextStyle(color: CustomColors.TextGrey),
                  ),
                  Container(
                    width: 180,
                    child: Text(
                      'Absen Keluar',
                      style: TextStyle(
                          color: CustomColors.TextHeader,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Image.asset('assets/img/checked.png'),
                  ////Image.asset('assets/images/bell-small.png'),
                ],
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: [0.015, 0.015],
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
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
              padding: EdgeInsets.fromLTRB(5, 18, 5, 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //Image.asset('assets/images/checked-empty.png'),
                  Text(
                    '08.50',
                    style: TextStyle(color: CustomColors.BlueIcon),
                  ),
                  Container(
                    width: 180,
                    child: Text(
                      'Absen Masuk',
                      style: TextStyle(
                          color: CustomColors.TextHeader,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  ////Image.asset('assets/images/bell-small.png'),
                ],
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: [0.015, 0.015],
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
            ),
            Container(
              margin: EdgeInsets.only(left: 20, bottom: 15),
              child: Text(
                '04 Januari 2021',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: CustomColors.TextSubHeader),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
              padding: EdgeInsets.fromLTRB(5, 18, 5, 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //Image.asset('assets/images/checked-empty.png'),
                  Text(
                    '17.33',
                    style: TextStyle(color: CustomColors.TextGrey),
                  ),
                  Container(
                    width: 180,
                    child: Text(
                      'Absen Keluar',
                      style: TextStyle(
                          color: CustomColors.TextHeader,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  ////Image.asset('assets/images/bell-small.png'),
                ],
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: [0.015, 0.015],
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
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
              padding: EdgeInsets.fromLTRB(5, 18, 5, 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //Image.asset('assets/images/checked-empty.png'),
                  Text(
                    '08.00',
                    style: TextStyle(color: CustomColors.TextGrey),
                  ),
                  Container(
                    width: 180,
                    child: Text(
                      'Absen Masuk',
                      style: TextStyle(
                          color: CustomColors.TextHeader,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  ////Image.asset('assets/images/bell-small.png'),
                ],
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: [0.015, 0.015],
                  colors: [CustomColors.GreenIcon, Colors.white],
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
            SizedBox(height: 15)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: customFab(context),
      bottomNavigationBar:
          BottomNavigationBarApp(context, bottomNavigationBarIndex),
    );
    //get histroy absence
  }
}
