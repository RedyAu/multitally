import 'package:flutter/material.dart';
import 'package:multitally/settings.dart';
import 'package:provider/provider.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(builder: (context, settings, child) {
      return Column(
        children: [
          ListTile(
            title: Text('Vibrate on air'),
            subtitle: Text(
                'In Singe Input View, vibrate the device when the selected input becomes on air'),
            trailing: Switch(
                value: settings.vibrateOnAir,
                onChanged: (v) {
                  settings.vibrateOnAir = v;
                }),
          ),
          ListTile(
            title: Text('Update frequency'),
            subtitle: Text(
                'Higher frequency means more stress on the network and the video switcher.\nKeep in mind: Each tally device makes requests for itself!'),
            trailing: DropdownButton(
                // records go brr
                items: <(String, int)>[
                  ('500 ms', 500),
                  ('1 s', 1000),
                  ('2 s', 2000),
                  ('5 s', 5000),
                  ('10 s', 10000),
                  ('30 s', 30000),
                ]
                    .map(
                      (e) => DropdownMenuItem(
                        child: Text(e.$1),
                        value: e.$2,
                      ),
                    )
                    .toList(),
                value: settings.updateFrequencySetting,
                onChanged: (v) {
                  settings.updateFrequencySetting = v!;
                }),
          )
        ],
      );
    });
  }
}
