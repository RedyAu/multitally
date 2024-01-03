import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../connection_provider.dart';
import '../../settings_provider.dart';

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
      CamState.live: const TextStyle(color: Colors.white, fontSize: camIdSize),
      CamState.preview:
          const TextStyle(color: Colors.white, fontSize: camIdSize),
      CamState.online:
          const TextStyle(color: Colors.white, fontSize: camIdSize),
      CamState.offline:
          const TextStyle(color: Colors.grey, fontSize: camIdSize),
    });

class CamIndicator extends StatelessWidget {
  final CamState state;
  final int camId;
  final String camName;

  const CamIndicator(
    this.camId,
    this.state,
    this.camName, {
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
                Text((camId + 1).toString(),
                    style: indicatorTheme.textStyleFor[state]),
                if (camName.isNotEmpty)
                  Text(camName,
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

class ConnectionIndicator extends StatelessWidget {
  const ConnectionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionProvider>(builder: (context, connection, child) {
      return Row(
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
      );
    });
  }
}
