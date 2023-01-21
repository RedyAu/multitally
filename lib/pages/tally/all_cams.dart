import 'package:feelworld_tally/settings.dart';
import 'package:feelworld_tally/pages/tally/cam_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

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
      body: Consumer<SettingsProvider>(builder: (context, provider, child) {
        return GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          children: provider.cams.entries
              .map((e) => CamIndicator(e.key, e.value))
              .toList(),
        );
      }),
    );
  }
}
