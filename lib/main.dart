import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'connection_provider.dart';
import 'pages/connect/page.dart';
import 'settings_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConnectionProvider>(
      create: (context) => ConnectionProvider(),
      child: ChangeNotifierProvider<SettingsProvider>(
        create: (_) => SettingsProvider()..initialize(navigatorKey),
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
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
