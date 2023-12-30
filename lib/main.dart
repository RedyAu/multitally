import 'package:feelworld_tally/pages/connect/page.dart';
import 'package:feelworld_tally/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'connection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsProvider>(
            create: (_) => SettingsProvider()),
        ChangeNotifierProvider<ConnectionProvider>(
            create: (_) => ConnectionProvider()),
      ],
      child: MaterialApp(
        title: 'Feelworld Tally',
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        home: const ConnectPage(),
      ),
    );
  }
}
