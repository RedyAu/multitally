import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static bool _initialized = false;
  bool get initialized => _initialized;

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
    SharedPreferences prefs;

    prefs = await SharedPreferences.getInstance();

    _descriptionForCam = Map.fromEntries(
        (prefs.getStringList("cam-desc-keys") ?? [])
            .map((k) => MapEntry(k, prefs.getString("cam-desc_$k")!)));

    _initialized = true;
    return;
  }
}
