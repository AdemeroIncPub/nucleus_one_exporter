import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'application/settings.dart';
import 'gui/export_settings_screen.dart';

void main() {
  _initializeDependencies();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
      ),
      home: const ExportSettingsScreen(),
    );
  }
}

void _initializeDependencies() {
  final gi = GetIt.I;
  gi.registerSingleton<StorageBoxWrapper>(StorageBoxWrapper());
}
