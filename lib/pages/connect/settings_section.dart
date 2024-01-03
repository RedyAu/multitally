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
                'In Singe Camera View, vibrate the device when the selected camera becomes on air'),
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
                items: [
                  DropdownMenuItem(child: Text('500 ms'), value: 500),
                  DropdownMenuItem(child: Text('1 s'), value: 1000),
                  DropdownMenuItem(child: Text('2 s'), value: 2000),
                  DropdownMenuItem(child: Text('5 s'), value: 5000),
                  DropdownMenuItem(child: Text('10 s'), value: 10000),
                  DropdownMenuItem(child: Text('30 s'), value: 30000),
                ],
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
