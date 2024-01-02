import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'api.dart';
import 'settings.dart';

enum CamState { live, preview, online, offline }

class ConnectionProvider extends ChangeNotifier {
  BuildContext context;
  late Duration updateFrequency;
  ConnectionProvider(this.context) {
    updateFrequency =
        Provider.of<SettingsProvider>(context, listen: false).updateFrequency;
  }

  FConnection? connection;
  DateTime? lastUpdate;
  bool ticker = false;
  String? error = 'Not connected';
  bool shouldDisconnect = false;

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

        await Future.delayed(updateFrequency);
        return !shouldDisconnect;
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

      await Future.delayed(updateFrequency);

      return !shouldDisconnect;
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
    notifyListeners();
    connection = null;
  }
}
