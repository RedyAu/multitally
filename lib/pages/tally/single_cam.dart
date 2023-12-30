import 'package:feelworld_tally/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../connection.dart';
import 'cam_indicator.dart';

class SingleCamPage extends StatelessWidget {
  final String camId;
  const SingleCamPage(this.camId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SettingsProvider, ConnectionProvider>(
        builder: (context, settings, connection, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: indicatorTheme.backgroundFor[connection.cams[camId]],
          title: TextFormField(
            initialValue: settings.descriptionForCam[camId] ?? '',
            onFieldSubmitted: (value) => settings.descriptionForCam
                .update(camId, (_) => value, ifAbsent: () => value),
            decoration: const InputDecoration(hintText: 'Name your camera'),
          ),
          actions: [],
        ),
        backgroundColor: indicatorTheme.backgroundFor[connection.cams[camId]],
        body: Center(
          child: Text(
            camId,
            style: indicatorTheme.textStyleFor[connection.cams[camId]],
          ),
        ),
      );
    });
  }
}
