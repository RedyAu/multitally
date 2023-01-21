import 'package:feelworld_tally/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CamIndicator extends StatelessWidget {
  final CamState state;
  final String camId;
  final String? camDescription;

  const CamIndicator(
    this.camId,
    this.state,
    this.camDescription, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(builder: (context, provider, child) {
      return Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            color: provider.indicatorTheme.backgroundFor[state]),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              children: [
                Text(camId, style: provider.indicatorTheme.textStyleFor[state]),
                if (camDescription != null)
                  Text(camDescription!,
                      style: provider.indicatorTheme.textStyleFor[state]!
                          .copyWith(fontSize: SettingsProvider.nameSize))
              ],
            ),
          ),
        ),
      );
    });
  }
}
