import 'package:flutter/material.dart';
import 'package:hencafe/services/app_lifecycle_observer.dart';
import 'package:hencafe/services/session_manager.dart';
import 'package:hencafe/values/app_routes.dart';
import 'package:hencafe/values/app_strings.dart';
import 'package:hencafe/values/app_theme.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'helpers/navigation_helper.dart';
import 'helpers/snackbar_helper.dart';
import 'routes.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final AppLifecycleObserver _lifecycleObserver = AppLifecycleObserver();

  @override
  void initState() {
    super.initState();
    _lifecycleObserver.start();
    SessionManager.generateNewSessionId();
  }

  @override
  void dispose() {
    _lifecycleObserver.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(builder: (context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: AppTheme.themeData,
        initialRoute: AppRoutes.welcome,
        scaffoldMessengerKey: SnackbarHelper.key,
        navigatorKey: NavigationHelper.key,
        onGenerateRoute: Routes.generateRoute,
      );
    });
  }
}
