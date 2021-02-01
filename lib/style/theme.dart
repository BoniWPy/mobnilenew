import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Colors {
  const Colors();

  static const Color loginGradientStart = const Color(0xFFB3E5FC);
  static const Color loginGradientEnd = const Color(0xFFEF2FD);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 0.2],
    begin: Alignment.topCenter,
    end: Alignment.bottomLeft,
  );
}
