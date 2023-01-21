import 'package:feelworld_tally/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CamIndicator extends StatelessWidget {
  final CamState state;
  final String camId;

  const CamIndicator(
    this.camId,
    this.state, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(builder: (context, provider, child) {
      return Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            color: provider.indicatorTheme.backgroundFor[state]),
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child:
              Text(camId, style: provider.indicatorTheme.textStyleFor[state]),
        ),
      );
    });
  }
}
