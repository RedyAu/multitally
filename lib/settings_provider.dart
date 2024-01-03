import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

int updateFrequency = 1000;

class SettingsProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  late PackageInfo packageInfo;
  PackageInfo get package => packageInfo;

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

  List<String> _camNames = List.generate(4, (index) => '');
  List<String> get camNames => _camNames;
  set camNames(List<String> value) {
    print(value);
    _camNames = value;
    notifyListeners();
    _prefs.setStringList('camNames', value);
  }

  void initialize(GlobalKey navigatorKey) async {
    ScaffoldMessengerState scaffoldMessenger =
        ScaffoldMessenger.of(navigatorKey.currentContext!);

    try {
      packageInfo = await PackageInfo.fromPlatform();

      _prefs = await SharedPreferences.getInstance();
      _updateFrequencySetting =
          _prefs.getInt('updateFrequencySetting') ?? _updateFrequencySetting;
      updateFrequency = _updateFrequencySetting;
      _vibrateOnAir = _prefs.getBool('vibrateOnAir') ?? _vibrateOnAir;
      _address = _prefs.getString('address') ?? _address;
      _camNames = _prefs.getStringList('camNames') ?? _camNames;
    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(
          'Error loading settings: $e',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        showCloseIcon: true,
        closeIconColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        duration: Duration(minutes: 99),
      ));
    }

    _initialized = true;
    notifyListeners();
    return;
  }
}
