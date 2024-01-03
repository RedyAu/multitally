import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import '../../connection_provider.dart';
import '../../settings_provider.dart';
import 'cam_indicator.dart';
import 'single_cam.dart';

class AllCamsPage extends StatefulWidget {
  const AllCamsPage({super.key});

  @override
  State<AllCamsPage> createState() => _AllCamsPageState();
}

class _AllCamsPageState extends State<AllCamsPage> {
  late ConnectionProvider _connectionProvider;

  @override
  void initState() {
    super.initState();
    _connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
    Future.delayed(Duration.zero)
        .then((value) => _connectionProvider.disconnect());
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();

    return Consumer2<SettingsProvider, ConnectionProvider>(
        builder: (context, settings, connection, child) {
      return Scaffold(
        appBar: AppBar(
            title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("All inputs"),
            const ConnectionIndicator(),
          ],
        )),
        body: Stack(
          fit: StackFit.expand,
          children: [
            OrientationBuilder(builder: (context, orientation) {
              return Flex(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  direction: (orientation == Orientation.landscape)
                      ? Axis.horizontal
                      : Axis.vertical,
                  children: List<int>.generate(connection.cams.length, (i) => i)
                      .map((i) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => SingleCamPage(i))),
                        child: CamIndicator(
                            i, connection.cams[i], settings.camNames[i]),
                      ),
                    );
                  }).toList());
            }),
            IgnorePointer(
              child: AnimatedOpacity(
                opacity:
                    (connection.error == null || connection.connection == null)
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
      );
    });
  }
}
