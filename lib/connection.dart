import 'dart:io';
import 'dart:math';

import 'package:feelworld_tally/api.dart';
import 'package:flutter/material.dart';

enum CamState { live, preview, online, offline }

class ConnectionProvider extends ChangeNotifier {
  FConnection? connection;

  Map<String, CamState> _cams = {
    "1": CamState.offline,
    "2": CamState.offline,
    "3": CamState.offline,
    "4": CamState.offline,
  };
  Map<String, CamState> get cams => _cams;
  set cams(Map<String, CamState> cams) {
    _cams = cams;
    notifyListeners();
  }

  Future<String?> connectTo(String? address) async {
    // Demo mode
    if (address == null) {
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
      return null;
    }

    // Real mode
    var ipaddress = InternetAddress(address.split(':')[0]);
    var port = int.tryParse(address.split(':')[1]) ?? 1000;
    connection = FConnection(ipaddress, port);
    try {
      await connection!.connect();
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
