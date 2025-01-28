import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hencafe/screens/dahboard_screen.dart';
import 'package:hencafe/values/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../values/app_icons.dart';
import '../values/app_theme.dart';
import 'login_screen_mobile.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    var prefs = await SharedPreferences.getInstance();
    final String? loginUUID = prefs.getString(AppStrings.prefUserID);

    Timer(Duration(seconds: 1), () {
      if (loginUUID != null && loginUUID.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DashboardScreen()), // Your home screen
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPageMobile()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200, // Set a fixed width
              height: 200, // Set a fixed height
              child: Image.asset(
                AppIconsData.splash_gif,
                fit: BoxFit.contain, // Ensure the image fits within its bounds
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.orange,
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome to',
                    style: AppTheme.supportTitle,
                  ),
                  SizedBox(width: 10),
                  const Text(
                    'HenCafe',
                    style: AppTheme.rejectedTitle,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
