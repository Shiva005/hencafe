import 'dart:convert';

import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const bool HTTPS = true;

  static final navigationKey = GlobalKey<NavigatorState>();
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$#!%*?&_])[A-Za-z\d@#$!%*?&_].{7,}$',
  );

  static final RegExp phoneRegex = RegExp(r"^\d{10}$");
}
