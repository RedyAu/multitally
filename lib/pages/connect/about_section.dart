import 'dart:io';

import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:mailto/mailto.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../settings_provider.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  bool get isIOS => Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(builder: (context, settings, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              '''
MultiTally ${settings.packageInfo.version}+${settings.packageInfo.buildNumber}
by Benedek Fodor (RedyAu)''',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          SizedBox(
            height: 50,
            child: FadingEdgeScrollView.fromScrollView(
              child: ListView(
                shrinkWrap: true,
                controller: ScrollController(),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(6),
                children: [
                  const SizedBox(width: 5),
                  ElevatedButton.icon(
                    label: Text(isIOS ? 'Learn More' : 'Buy Me a Coffee?'),
                    onPressed: () => launchUrl(Uri.parse(isIOS
                        ? 'https://github.com/redyau/multitally'
                        : 'https://revolut.me/redyau')),
                    icon: Icon(isIOS ? Icons.bookmark : Icons.coffee),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      launchUrl(Uri.parse(Mailto(
                        to: ['multitally@fodor.pro'],
                        subject:
                            'Bug report - MultiTally ${settings.packageInfo.version}+${settings.packageInfo.buildNumber}',
                        body: '''
Write your bug report or suggestion here.
If you can, please attach a screenshot or a screen recording.''',
                      ).toString()));
                    },
                    icon: const Icon(Icons.bug_report),
                    label: const Text('Report a Bug'),
                  ),
                  if (!isIOS)
                    TextButton.icon(
                      label: const Text('Source Code'),
                      onPressed: () => launchUrl(
                          Uri.parse('https://github.com/redyau/multitally')),
                      icon: const Icon(Icons.code),
                    ),
                  const SizedBox(width: 5),
                  TextButton.icon(
                    label: const Text('Licenses'),
                    onPressed: () => showLicensePage(
                        context: context,
                        applicationName: 'MultiTally',
                        applicationLegalese: '© 2023 Benedek Fodor',
                        applicationVersion:
                            '${settings.package.version}+${settings.packageInfo.buildNumber}'),
                    icon: const Icon(Icons.gavel),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
