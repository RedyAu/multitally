import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import '../../connection.dart';
import '../../settings.dart';
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
    _connectionProvider.disconnect();
    super.dispose();
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
            const Text("All cameras"),
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
            )
          ],
        )),
        body: OrientationBuilder(builder: (context, orientation) {
          return Flex(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              direction: (orientation == Orientation.landscape)
                  ? Axis.horizontal
                  : Axis.vertical,
              children:
                  List<int>.generate(connection.cams.length, (i) => i).map((i) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SingleCamPage(i))),
                    child: CamIndicator(
                        i, connection.cams[i], settings.descriptionForCam[i]),
                  ),
                );
              }).toList());
        }),
      );
    });
  }
}
