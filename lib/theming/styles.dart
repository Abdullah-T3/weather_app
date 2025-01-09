import 'package:flutter/material.dart';
import 'colors.dart';

class TextStyles {
  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const subtitle = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  static const appBarStyle = TextStyle(
    fontWeight: FontWeight.w900,
    color: Colors.white,
  );

  static const body = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
  static const primaryButton = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const textGray = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: ColorsManager.textGray,
  );
  static const logOutTextStyle = TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Poppins");
}

class ButtonStyles {
  static const primaryButton = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const secondaryButton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
}
