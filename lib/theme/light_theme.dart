import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color(0xFFF4F4F4),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF4F4F4),
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF219ebc), // accent color
    onPrimary: Colors.white, // text in accent color
    secondary: Color(0xFFFFFFFF), // bg other than scaffold bg
    onSecondary: Color(0xFF242424), // used as primary text
    surface: Color(0xFFE0E0E0), // scaffold bg
    onSurface: Color(0xFF626262), // used as lighter text
    error: Colors.redAccent,
    onError: Colors.white,
    
  ),
);
