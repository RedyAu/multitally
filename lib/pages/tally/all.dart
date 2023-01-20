import 'package:feelworld_tally/settings.dart';
import 'package:feelworld_tally/pages/tally/cam_indicator.dart';
import 'package:flutter/material.dart';

class AllCamsPage extends StatelessWidget {
  const AllCamsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: const [
                Expanded(
                  child: CamIndicator(
                    '1',
                    CamState.live,
                  ),
                ),
                Expanded(
                  child: CamIndicator(
                    '2',
                    CamState.online,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: const [
                Expanded(
                  child: CamIndicator(
                    '3',
                    CamState.preview,
                  ),
                ),
                Expanded(
                  child: CamIndicator(
                    '4',
                    CamState.offline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
