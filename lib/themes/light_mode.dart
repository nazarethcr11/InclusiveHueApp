import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    onSurface: Colors.black,
    primary: Color.fromRGBO(16, 76, 123, 1),
    secondary: Color.fromRGBO(251, 206, 123, 1),
    tertiary: Colors.grey.shade600,
    inversePrimary: Color.fromRGBO(70, 68, 68, 1),
    inverseSurface: Colors.grey.shade300,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.grey.shade900,
    contentTextStyle: TextStyle(color: Colors.white),
  ),
);