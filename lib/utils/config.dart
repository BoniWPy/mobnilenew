import 'package:flutter/material.dart';

// import 'package:flutter_money_formatter/flutter_money_formatter.dart';
// import 'package:progress_hud/progress_hud.dart';
// import 'package:skp/widgets/alert_dialog.dart';

class ConfigClass {
  String generateDate(tanggal) {
    List<String> arrayTanggal = tanggal.split("-");
    return arrayTanggal[2] + "-" + arrayTanggal[1] + "-" + arrayTanggal[0];
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

double baseHeight = 640.0;

double screenAwareSize(double size, BuildContext context) {
  return size * MediaQuery.of(context).size.height / baseHeight;
}

class PaypalColors {
  static const LightBlue = Color.fromRGBO(0, 154, 224, 1);
  static const DarkBlue = Color.fromRGBO(18, 106, 175, 1);
  static const LightGrey19 = Color.fromRGBO(112, 112, 112, 0.19);
  static const LightGrey = Color.fromRGBO(242, 242, 242, 1);
  static const Grey = Color.fromRGBO(157, 157, 157, 1);
  static const Black50 = Color.fromRGBO(0, 0, 0, 0.5);
  static const Green = Color.fromRGBO(61, 179, 158, 1);
}
