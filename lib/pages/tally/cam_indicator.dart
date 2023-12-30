import 'package:feelworld_tally/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../connection.dart';

class IndicatorTheme {
  Map<CamState, Color> backgroundFor;
  Map<CamState, TextStyle> textStyleFor;

  IndicatorTheme(this.backgroundFor, this.textStyleFor);
}

  const double camIdSize = 150;
  const double nameSize = 50;

IndicatorTheme get indicatorTheme => IndicatorTheme({
        CamState.live: Colors.red,
        CamState.preview: Colors.green,
        CamState.online: Colors.blueGrey,
        CamState.offline: Colors.black12,
      }, {
        CamState.live:
            const TextStyle(color: Colors.white, fontSize: camIdSize),
        CamState.preview:
            const TextStyle(color: Colors.white, fontSize: camIdSize),
        CamState.online:
            const TextStyle(color: Colors.white, fontSize: camIdSize),
        CamState.offline:
            const TextStyle(color: Colors.grey, fontSize: camIdSize),
      });

class CamIndicator extends StatelessWidget {
  final CamState state;
  final String camId;
  final String? camDescription;

  const CamIndicator(
    this.camId,
    this.state,
    this.camDescription, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(builder: (context, provider, child) {
      return Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            color: indicatorTheme.backgroundFor[state]),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              children: [
                Text(camId, style: indicatorTheme.textStyleFor[state]),
                if (camDescription != null)
                  Text(camDescription!,
                      style: indicatorTheme.textStyleFor[state]!
                          .copyWith(fontSize: nameSize))
              ],
            ),
          ),
        ),
      );
    });
  }
}
