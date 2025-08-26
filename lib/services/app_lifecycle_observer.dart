import 'package:flutter/widgets.dart';
import 'package:hencafe/services/services.dart';
import 'package:hencafe/services/session_manager.dart';

import '../utils/my_logger.dart'; // import your logger

class AppLifecycleObserver extends WidgetsBindingObserver {
  final BuildContext context;

  AppLifecycleObserver(this.context);

  void start() {
    WidgetsBinding.instance.addObserver(this);
  }

  void stop() {
    WidgetsBinding.instance.removeObserver(this);
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
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        // App came to foreground
        SessionManager.generateNewSessionId();
        startSession();
        break;

      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        // App went to background or is disposed
        await endSession();
        break;

      case AppLifecycleState.inactive:
        // Do nothing (inactive is just temporary, e.g., phone call, lock screen)
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }
}
