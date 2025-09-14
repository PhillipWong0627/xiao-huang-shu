import 'package:flutter/material.dart';

ThemeData buildTheme() {
  final base = ThemeData.light();
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: const Color(0xFF0066FF),
      secondary: const Color(0xFFFF6B00),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
    scaffoldBackgroundColor: const Color(0xFFF7F8FA),
    useMaterial3: true,
  );
}
