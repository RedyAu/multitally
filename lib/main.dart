import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'connection.dart';
import 'pages/connect/page.dart';
import 'settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsProvider>(
      create: (_) => SettingsProvider(),
      child: ChangeNotifierProvider<ConnectionProvider>(
        create: (context) => ConnectionProvider(context),
        child: MaterialApp(
          title: 'MultiTally',
          theme: ThemeData.from(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.amber, brightness: Brightness.dark)),
          home: const ConnectPage(),
        ),
      ),
    );
  }
}
