import 'package:feelworld_tally/pages/tally/all_cams.dart';
import 'package:feelworld_tally/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsProvider>(
      create: (_) => SettingsProvider()..initialize(),
      child: MaterialApp(
        title: 'Feelworld Tally',
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        home: const AllCamsPage(),
      ),
    );
  }
}
