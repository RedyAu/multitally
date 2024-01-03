import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import '../../connection_provider.dart';
import '../../settings_provider.dart';
import 'cam_indicator.dart';

class SingleCamPage extends StatefulWidget {
  final int camId;
  const SingleCamPage(this.camId, {super.key});

  @override
  State<SingleCamPage> createState() => _SingleCamPageState();
}

class _SingleCamPageState extends State<SingleCamPage> {
  CamState prevCamState = CamState.offline;
  @override
  void didChangeDependencies() {
    ConnectionProvider connection =
        Provider.of<ConnectionProvider>(context, listen: true);
    SettingsProvider settings =
        Provider.of<SettingsProvider>(context, listen: true);

    if (settings.vibrateOnAir &&
        connection.cams[widget.camId] == CamState.live &&
        prevCamState != CamState.live) {
      Vibration.vibrate(duration: 1000, amplitude: 255);
    }
    prevCamState = connection.cams[widget.camId];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SettingsProvider, ConnectionProvider>(
        builder: (context, settings, connection, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.alphaBlend(
            Theme.of(context).colorScheme.background.withAlpha(130),
            indicatorTheme.backgroundFor[connection.cams[widget.camId]]!,
          ),
          title: TextFormField(
            initialValue: settings.camNames[widget.camId],
            style: TextStyle(fontSize: 18),
            onFieldSubmitted: (value) {
              var camNames = settings.camNames;
              camNames[widget.camId] = value;
              settings.camNames = camNames;
            },
            decoration: const InputDecoration(hintText: 'Name your input'),
          ),
          actions: [],
        ),
        backgroundColor:
            indicatorTheme.backgroundFor[connection.cams[widget.camId]],
        extendBody: true,
        body: Stack(
          alignment: Alignment.topRight,
          children: [
            Stack(
              fit: StackFit.expand,
              children: [
                Center(
                  child: Text(
                    (widget.camId + 1).toString(),
                    style: indicatorTheme
                        .textStyleFor[connection.cams[widget.camId]],
                  ),
                ),
                IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: (connection.error == null ||
                            connection.connection == null)
                        ? 0
                        : 1,
                    duration: Duration(milliseconds: 500),
                    child: Stack(
                      children: [
                        Container(color: Colors.black.withAlpha(150)),
                        Center(
                          child: CircularProgressIndicator(),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10)),
                    color:
                        Theme.of(context).colorScheme.background.withAlpha(130),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: ConnectionIndicator(),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
