import 'package:flutter/material.dart';
import 'package:hencafe/services/app_lifecycle_observer.dart';
import 'package:hencafe/services/services.dart';
import 'package:hencafe/services/session_manager.dart';
import 'package:hencafe/utils/my_logger.dart';
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
  late final AppLifecycleObserver _lifecycleObserver = AppLifecycleObserver(
    context,
  );

  @override
  void initState() {
    super.initState();
    _lifecycleObserver.start();
    SessionManager.generateNewSessionId();
    Future.delayed(const Duration(seconds: 2), () {
      startSession();
    });
  }

  @override
  void dispose() {
    _lifecycleObserver.stop();
    endSession();
    super.dispose();
  }

  Future<void> startSession() async {
    var res = await AuthServices().appSessionStart(context);
    logger.d(res.apiResponse![0].responseDetails);
  }

  Future<void> endSession() async {
    var res = await AuthServices().appSessionEnd(context);
    logger.d(res.apiResponse![0].responseDetails);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(
      builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          theme: AppTheme.themeData,
          initialRoute: AppRoutes.welcome,
          scaffoldMessengerKey: SnackbarHelper.key,
          navigatorKey: NavigationHelper.key,
          onGenerateRoute: Routes.generateRoute,
        );
      },
    );
  }
}
