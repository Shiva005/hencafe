import 'package:flutter/material.dart';
import 'package:hencafe/values/app_routes.dart';
import 'package:hencafe/values/app_strings.dart';
import 'package:hencafe/values/app_theme.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'helpers/navigation_helper.dart';
import 'helpers/snackbar_helper.dart';
import 'routes.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(builder: (context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: AppTheme.themeData,
        initialRoute: AppRoutes.registerCreatePin,
        scaffoldMessengerKey: SnackbarHelper.key,
        navigatorKey: NavigationHelper.key,
        onGenerateRoute: Routes.generateRoute,
      );
    });
  }
}
