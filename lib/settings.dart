import 'dart:math';

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

  Map<String, CamState> _cams = {
    "1": CamState.online,
    "2": CamState.live,
    "3": CamState.preview,
    "4": CamState.offline,
  };
  Map<String, CamState> get cams => _cams;
  set cams(Map<String, CamState> cams) {
    _cams = cams;
    notifyListeners();
  }

  IndicatorTheme get indicatorTheme => IndicatorTheme({
        CamState.live: Colors.red,
        CamState.preview: Colors.green,
        CamState.online: Colors.blueGrey,
        CamState.offline: Colors.black12,
      }, {
        CamState.live: const TextStyle(color: Colors.white),
        CamState.preview: const TextStyle(color: Colors.white),
        CamState.online: const TextStyle(color: Colors.white),
        CamState.offline: const TextStyle(color: Colors.grey),
      });

  void initialize() async {
    _initialized = true;
    Random random = Random();
    Future.doWhile(() async {
      cams = {
        "1": CamState.values[random.nextInt(4)],
        "2": CamState.values[random.nextInt(4)],
        "3": CamState.values[random.nextInt(4)],
        "4": CamState.values[random.nextInt(4)],
      };
      await Future.delayed(Duration(seconds: 1));
      return true;
    });
    return;
  }
}
