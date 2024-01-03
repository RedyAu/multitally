import 'package:flutter/material.dart';
import 'package:multitally/pages/connect/settings_section.dart';
import 'package:provider/provider.dart';

import '../../connection.dart';
import '../../settings.dart';
import '../tally/all_cams.dart';
import 'about_section.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({Key? key}) : super(key: key);

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  TextEditingController controller = TextEditingController();
  bool isConnecting = false;
  String error = "";

  @override
  void didChangeDependencies() {
    if (controller.text.isEmpty) {
      controller.text = Provider.of<SettingsProvider>(context).address;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Consumer2<SettingsProvider, ConnectionProvider>(
                builder: (context, settings, connection, child) {
              return settings.initialized
                  ? SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 32),
                          Text("MultiTally",
                              style: Theme.of(context).textTheme.headlineLarge,
                              textAlign: TextAlign.center),
                          SizedBox(height: 32),
                          Text(
                            "Connect",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(height: 16),
                          Text(
                              "This is an unofficial Tally Light app for devices made by Feelworld.\nKnown to support: Feelworld L1, L2 Plus, RGBlink mini"),
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
                                child: ElevatedButton(
                                  onPressed: () {
                                    connection.connectTo(null);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AllCamsPage()));
                                  },
                                  child: Text("Demo"),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                flex: 3,
                                child: FilledButton(
                                  onPressed: () async {
                                    setState(() {
                                      isConnecting = true;
                                    });
                                    try {
                                      await connection
                                          .connectTo(controller.text);
                                      setState(() {
                                        isConnecting = false;
                                        error = "";
                                      });
                                      settings.address = controller.text;

                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AllCamsPage()));
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
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Settings",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SettingsSection(),
                          SizedBox(height: 16),
                          Text(
                            "About",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          AboutSection(),
                        ],
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            }),
          ),
        ),
      ),
    );
  }
}
