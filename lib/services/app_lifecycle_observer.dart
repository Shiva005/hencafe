import 'package:flutter/widgets.dart';
import 'package:hencafe/services/session_manager.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  void start() {
    WidgetsBinding.instance.addObserver(this);
  }

  void stop() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      if (state == AppLifecycleState.resumed) {
        SessionManager.generateNewSessionId();
      }
    }
  }
}
