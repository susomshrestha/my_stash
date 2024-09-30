import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212),
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF219ebc), // accent color
    onPrimary: Colors.white, // text in accent color
    secondary: Color(0xFF1f1f1e), // bg other than scaffold bg
    onSecondary: Color(0xFFe0e0e1), // text in bg other than scaffold bg
    surface: Color(0xFF121212), // scaffold bg
    onSurface: Color(0xFF626262), // text in scaffold bg
    error: Colors.redAccent,
    onError: Colors.white,
  ),
);
