import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color primaryColor = Color(0xff5F259F);
  static const Color lightBlue = Color(0xff0055bb);
  static const Color darkBlue = Color(0xff20007F);
  static const Color darkerBlue = Color(0xff152534);
  static const Color darkestBlue = Color(0xff0C1C2E);
  static const Color darkesttBlue = Color(0xff0a1a2a);

  static const Color informationScreenColor = Color(0xff3C2077);
  static const Color startColor = Color(0xff3C37B8);
  static const Color endColor = Color(0xff04CFDC);
  static const Color nextStartColor = Color(0xffFDA95A);
  static const Color nextEndColor = Color(0xffFF5E76);
  static Color backgroundColor = Colors.grey.shade100;
  static const Color pink = Color(0xffDF1BB1);

  //static Color backgroundColor = Colors.blue.shade500;

  static List<Color> defaultGradient = [
    backgroundColor,
    darkBlue,
  ];

  static const List<Color> buttonGradient = [
    startColor,
    endColor,
  ];
  static const List<Color> containerGradient = [
    startColor,
    pink,
  ];
  static const List<Color> prevButtonGradient = [
    endColor,
    startColor,
  ];
  static const List<Color> nextButtonGradient = [
    nextStartColor,
    nextEndColor,
  ];
}
