import 'package:material_ui/material_ui.dart';

ThemeData buildLightTheme() => ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D5FD0)),
);

ThemeData buildDarkTheme() => ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF1D5FD0),
    brightness: Brightness.dark,
  ),
);
