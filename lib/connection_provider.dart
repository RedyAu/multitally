import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'api.dart';
import 'settings_provider.dart';

enum CamState { live, preview, online, offline }

class ConnectionProvider extends ChangeNotifier {
  FConnection? connection;
  DateTime? lastUpdate;
  bool ticker = false;
  String? error = 'Not connected';
  bool _shouldDisconnect = false;
  bool get shouldDisconnect => _shouldDisconnect;
  set shouldDisconnect(bool value) {
    _shouldDisconnect = value;
    notifyListeners();
  }

  List<CamState> cams = List.generate(4, (index) => CamState.offline);

  Future<String?> connectTo(String? address) async {
    shouldDisconnect = false;

    // Demo mode
    if (address == null) {
      Random random = Random();
      Future.doWhile(() async {
        cams = List.generate(4, (index) => CamState.values[random.nextInt(4)]);

        lastUpdate = DateTime.now();
        ticker = !ticker;
        notifyListeners();

        await Future.delayed(Duration(milliseconds: updateFrequency));
        return !shouldDisconnect;
      }).then((value) {
        shouldDisconnect = false;
        print("Demo done.");
      });
      return null;
    }

    // Real mode
    var parts = address.split(':');
    var ipaddress = InternetAddress(parts[0]);
    var port = parts.length > 1 ? int.parse(parts[1]) : 1000;
    connection = FConnection(ipaddress, port);
    await connection!.connect();
    notifyListeners();
    Future.doWhile(() async {
      await update();

      lastUpdate = DateTime.now();
      ticker = !ticker;
      notifyListeners();

      await Future.delayed(Duration(milliseconds: updateFrequency));
      return !shouldDisconnect;
    }).then((value) {
      shouldDisconnect = false;
      print("Disconnected.");
    });
    return null;
  }

  update() async {
    try {
      var data = await connection!.getRawState();
      int preview = data[0];
      int live = data[1];

      cams = List.generate(4, (index) => CamState.offline);
      cams[preview] = CamState.preview;
      cams[live] = CamState.live;
      error = null;
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  void disconnect() {
    print("Disconnecting");
    error = 'Not connected';
    shouldDisconnect = true;
    connection = null;
  }
}
