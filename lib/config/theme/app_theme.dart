import 'package:flutter/material.dart';

class AppTheme {
  final bool isDarkMode;
  AppTheme({this.isDarkMode = false});
  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        colorSchemeSeed: const Color.fromARGB(255, 40, 105, 245),
      );
  AppTheme copyWith({
    int? selectedColor,
    bool? isDarkMode,
  }) =>
      AppTheme(
        isDarkMode: isDarkMode ?? this.isDarkMode,
      );
}
