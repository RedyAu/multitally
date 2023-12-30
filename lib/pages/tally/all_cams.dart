import 'package:feelworld_tally/pages/tally/single_cam.dart';
import 'package:feelworld_tally/settings.dart';
import 'package:feelworld_tally/pages/tally/cam_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import '../../connection.dart';

class AllCamsPage extends StatelessWidget {
  const AllCamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();

    return Scaffold(
      appBar: AppBar(
          title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("All cameras"),
          Text(
            "Connected: 127.0.0.1",
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      )),
      body: Consumer2<SettingsProvider, ConnectionProvider>(
          builder: (context, settings, connection, child) {
        return OrientationBuilder(builder: (context, orientation) {
          return Flex(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              direction: (orientation == Orientation.landscape)
                  ? Axis.horizontal
                  : Axis.vertical,
              children: connection.cams.entries
                  .map((e) => Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => SingleCamPage(e.key))),
                          child: CamIndicator(e.key, e.value,
                              settings.descriptionForCam[e.value]),
                        ),
                      ))
                  .toList());
        });
      }),
    );
  }
}
