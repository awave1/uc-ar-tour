import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Colors {
  const Colors();

// #ed1c24
  static const Color loginGradientStart = const Color(0xFFed1c24);
  static const Color loginGradientEnd = const Color(0xFFffcd00);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
