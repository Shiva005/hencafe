import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static const textFormFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: Colors.grey, width: 1.6),
  );

  static final ThemeData themeData = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: AppColors.primaryColor,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 34,
        letterSpacing: 0.5,
      ),
      bodySmall: TextStyle(
        color: Colors.grey,
        fontSize: 14,
        letterSpacing: 0.5,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      errorStyle: TextStyle(fontSize: 12),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 14,
      ),
      border: textFormFieldBorder,
      errorBorder: textFormFieldBorder,
      focusedBorder: textFormFieldBorder,
      focusedErrorBorder: textFormFieldBorder,
      enabledBorder: textFormFieldBorder,
      labelStyle: TextStyle(
        fontSize: 17,
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        padding: const EdgeInsets.all(4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        minimumSize: const Size(double.infinity, 50),
        side: BorderSide(color: Colors.grey.shade200),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: AppColors.primaryColor,
        disabledBackgroundColor: Colors.grey.shade300,
        minimumSize: const Size(double.infinity, 52),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    ),
  );

  static Widget allButtonWidget(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: double.maxFinite,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.buttonGradient,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Text(
            text,
            style: AppTheme.appBarText,
          ),
        ),
      ),
    );
  }

  static Widget previousButtonWidget(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: double.maxFinite,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.containerGradient,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Text(
            text,
            style: AppTheme.appBarText,
          ),
        ),
      ),
    );
  }

  static Widget nextButtonWidget(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: double.maxFinite,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.nextButtonGradient,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Text(
            text,
            style: AppTheme.appBarText,
          ),
        ),
      ),
    );
  }

  static const TextStyle linkText = TextStyle(
    color: Colors.blue,
    fontSize: 14,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline,
  );

  static const TextStyle orangeLinkText = TextStyle(
    color: Colors.orange,
    fontSize: 14,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline,
  );

  static const TextStyle titleLarge = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize: 34,
    letterSpacing: 0.5,
  );

  static const TextStyle bodySmall = TextStyle(
    color: Colors.grey,
    letterSpacing: 0.5,
  );
  static const TextStyle primaryHeadingDrawer = TextStyle(
    color: Colors.white,
    letterSpacing: 0.5,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle debitedText = TextStyle(
    color: Colors.red,
    letterSpacing: 0.5,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle creditedText = TextStyle(
    color: Colors.green,
    letterSpacing: 0.5,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle secondaryHeadingDrawer = TextStyle(
    color: Colors.grey,
    letterSpacing: 0.5,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle starLineText = TextStyle(
    color: Colors.white,
    letterSpacing: 0.5,
    wordSpacing: 0.5,
    fontSize: 12,
  );

  static const TextStyle informationString = TextStyle(
    color: Colors.black,
    letterSpacing: 0.5,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle informationStringSecond = TextStyle(
    color: Colors.white,
    letterSpacing: 0.5,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle textFormFieldTitle = TextStyle(
    color: Colors.white,
    letterSpacing: 0.5,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle supportTitle = TextStyle(
    color: AppColors.primaryColor,
    letterSpacing: 0.5,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle rejectedTitle = TextStyle(
    color: Colors.red,
    letterSpacing: 0.5,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle gameResultText = TextStyle(
    color: Colors.orange,
    letterSpacing: 1,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle gameOpenCloseText = TextStyle(
    color: Colors.black45,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle appBarText = TextStyle(
    color: Colors.black,
    letterSpacing: 0.5,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle appBarTextLogin = TextStyle(
    color: Colors.white70,
    letterSpacing: 1.2,
    fontSize: 28,
    fontWeight: FontWeight.w500,
  );
}
