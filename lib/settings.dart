import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

int updateFrequency = 1000;

class SettingsProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  static bool _initialized = false;
  bool get initialized => _initialized;

  int _updateFrequencySetting = 1000;
  int get updateFrequencySetting => _updateFrequencySetting;
  set updateFrequencySetting(int value) {
    _updateFrequencySetting = value;
    updateFrequency = value;
    notifyListeners();
    _prefs.setInt('updateFrequencySetting', value);
  }

  bool _vibrateOnAir = false;
  bool get vibrateOnAir => _vibrateOnAir;
  set vibrateOnAir(bool value) {
    _vibrateOnAir = value;
    notifyListeners();
    _prefs.setBool('vibrateOnAir', value);
  }

  String _address = '';
  String get address => _address;
  set address(String value) {
    _address = value;
    notifyListeners();
    _prefs.setString('address', value);
  }

  void initialize(GlobalKey navigatorKey) async {
    _prefs = await SharedPreferences.getInstance();
    ScaffoldMessengerState scaffoldMessenger =
        ScaffoldMessenger.of(navigatorKey.currentContext!);

    try {
      _updateFrequencySetting =
          _prefs.getInt('updateFrequencySetting') ?? _updateFrequencySetting;
      updateFrequency = _updateFrequencySetting;
      _vibrateOnAir = _prefs.getBool('vibrateOnAir') ?? _vibrateOnAir;
      _address = _prefs.getString('address') ?? _address;
    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(
          'Error loading settings: $e',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        showCloseIcon: true,
        closeIconColor: Colors.white,
        duration: Duration(minutes: 99),
      ));
    }

    _initialized = true;
    notifyListeners();
    return;
  }
}
