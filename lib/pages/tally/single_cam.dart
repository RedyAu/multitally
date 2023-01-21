import 'package:feelworld_tally/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleCamPage extends StatelessWidget {
  final String camId;
  const SingleCamPage(this.camId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor:
              provider.indicatorTheme.backgroundFor[provider.cams[camId]],
          title: TextFormField(
            initialValue: provider.descriptionForCam[camId] ?? '',
            onFieldSubmitted: (value) => provider.descriptionForCam
                .update(camId, (_) => value, ifAbsent: () => value),
            decoration: const InputDecoration(hintText: 'Name your camera'),
          ),
          actions: [],
        ),
        backgroundColor:
            provider.indicatorTheme.backgroundFor[provider.cams[camId]],
        body: Center(
          child: Text(
            camId,
            style: provider.indicatorTheme.textStyleFor[provider.cams[camId]],
          ),
        ),
      );
    });
  }
}
