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
          backgroundColor: indicatorTheme.backgroundFor[connection.cams[camId]],
          title: /*TextFormField(
            initialValue: settings.descriptionForCam[camId] ?? '',
            onFieldSubmitted: (value) {
              settings.descriptionForCam
                .update(camId, (_) => value, ifAbsent: () => value);
            },
            decoration: const InputDecoration(hintText: 'Name your camera'),
          ),*/
              Row(
            children: [
              // small green circle
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  color: connection.ticker
                      ? (connection.error != null ? Colors.red : Colors.green)
                      : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              (connection.error == null)
                  ? Text(
                      "Connected: ${connection.connection?.address.address}",
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  : Text(
                      "${connection.error}",
                      style: Theme.of(context).textTheme.bodySmall,
                    )
            ],
          ),
          actions: [],
        ),
        backgroundColor: indicatorTheme.backgroundFor[connection.cams[camId]],
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
