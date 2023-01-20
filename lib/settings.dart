import 'package:flutter/material.dart';

enum CamState { live, preview, online, offline }

class IndicatorTheme {
  Map<CamState, Color> backgroundFor;
  Map<CamState, TextStyle> textStyleFor;

  IndicatorTheme(this.backgroundFor, this.textStyleFor);
}

class SettingsProvider extends ChangeNotifier {
  static bool _initialized = false;
  bool get initialized => _initialized;

  IndicatorTheme get indicatorTheme => IndicatorTheme({
        CamState.live: Colors.red,
        CamState.preview: Colors.green,
        CamState.online: Colors.blue,
        CamState.offline: Colors.black12,
      }, {
        CamState.live: const TextStyle(fontSize: 60, color: Colors.white),
        CamState.preview: const TextStyle(fontSize: 60, color: Colors.white),
        CamState.online: const TextStyle(fontSize: 60, color: Colors.white),
        CamState.offline: const TextStyle(fontSize: 60, color: Colors.grey),
      });

  void initialize() async {
    _initialized = true;
    return;
  }
}
