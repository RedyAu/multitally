import 'package:feelworld_tally/pages/tally/all_cams.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../connection.dart';
import '../../settings.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({Key? key}) : super(key: key);

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  var controller = TextEditingController();
  bool isConnecting = false;
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Feelworld Tally")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Consumer2<SettingsProvider, ConnectionProvider>(
                builder: (context, settings, connection, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Welcome!",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 16),
                  Text(
                      "This is an unofficial Tally Light app for Feelworld devices.\nKnown to support: Feelworld L1, L2 Plus, RGBlink mini"),
                  SizedBox(height: 16),
                  Text(
                      "Enter the IP address of the device you want to connect to:"),
                  TextField(
                    controller: controller,
                  ),
                  SizedBox(height: 16),
                  if (error.isNotEmpty) ...[
                    Text(error, style: TextStyle(color: Colors.red)),
                    SizedBox(height: 16),
                  ],
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: FilledButton(
                          onPressed: () async {
                            setState(() {
                              isConnecting = true;
                            });
                            try {
                              await connection.connectTo(controller.text);
                              setState(() {
                                isConnecting = false;
                                error = "";
                              });
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AllCamsPage()));
                            } catch (e) {
                              isConnecting = false;
                              setState(() {
                                error = '$e';
                              });
                            }
                          },
                          child: isConnecting
                              ? LinearProgressIndicator()
                              : Text("Connect"),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            connection.connectTo(null);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AllCamsPage()));
                          },
                          child: Text("Demo"),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
