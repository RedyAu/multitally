import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../connection.dart';
import '../../settings.dart';
import 'cam_indicator.dart';

class SingleCamPage extends StatelessWidget {
  final int camId;
  const SingleCamPage(this.camId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SettingsProvider, ConnectionProvider>(
        builder: (context, settings, connection, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.alphaBlend(
              indicatorTheme.backgroundFor[connection.cams[camId]]!
                  .withAlpha(170),
              Theme.of(context).colorScheme.background),
          title: TextFormField(
            initialValue: settings.camNames[camId],
            onFieldSubmitted: (value) {
              var camNames = settings.camNames;
              camNames[camId] = value;
              settings.camNames = camNames;
            },
            decoration: const InputDecoration(hintText: 'Name your camera'),
          ),
          actions: [],
        ),
        backgroundColor: indicatorTheme.backgroundFor[connection.cams[camId]],
        extendBody: true,
        bottomNavigationBar: Row(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: ConnectionIndicator(),
              ),
              shape: StadiumBorder(),
            ),
          ],
        ),
        body: Center(
          child: Text(
            (camId + 1).toString(),
            style: indicatorTheme.textStyleFor[connection.cams[camId]],
          ),
        ),
      );
    });
  }
}
