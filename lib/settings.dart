import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static const double camIdSize = 150;
  static const double nameSize = 50;

  IndicatorTheme get indicatorTheme => IndicatorTheme({
        CamState.live: Colors.red,
        CamState.preview: Colors.green,
        CamState.online: Colors.blueGrey,
        CamState.offline: Colors.black12,
      }, {
        CamState.live:
            const TextStyle(color: Colors.white, fontSize: camIdSize),
        CamState.preview:
            const TextStyle(color: Colors.white, fontSize: camIdSize),
        CamState.online:
            const TextStyle(color: Colors.white, fontSize: camIdSize),
        CamState.offline:
            const TextStyle(color: Colors.grey, fontSize: camIdSize),
      });

  Map<String, String> _descriptionForCam = {};
  Map<String, String> get descriptionForCam => _descriptionForCam;
  set descriptionForCam(Map<String, String> desciptionMap) {
    _descriptionForCam = desciptionMap;
    SharedPreferences.getInstance().then(
      (prefs) {
        desciptionMap.forEach((key, value) {
          prefs.setString("cam-desc_$key", value);
        });
        prefs.setStringList("cam-desc-keys", desciptionMap.keys.toList());
      },
    );
    notifyListeners();
  }

  void initialize() async {
    Random random = Random();
    Future.doWhile(() async {
      cams = {
        "1": CamState.values[random.nextInt(4)],
        "2": CamState.values[random.nextInt(4)],
        "3": CamState.values[random.nextInt(4)],
        "4": CamState.values[random.nextInt(4)],
      };
      await Future.delayed(const Duration(seconds: 1));
      return true;
    });

    SharedPreferences prefs;

    prefs = await SharedPreferences.getInstance();

    _descriptionForCam = Map.fromEntries(
        (prefs.getStringList("cam-desc-keys") ?? [])
            .map((k) => MapEntry(k, prefs.getString("cam-desc_$k")!)));

    _initialized = true;
    return;
  }
}
