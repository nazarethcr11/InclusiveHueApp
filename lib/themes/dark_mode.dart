import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Color.fromRGBO(38, 38, 38, 1.0),  // Color oscuro para la superficie
    primary: Color.fromRGBO(16, 76, 123, 1),// Mismo color primario
    secondary: Color.fromRGBO(66, 65, 65, 1.0), // Ajustado para ser menos brillante
    tertiary: Colors.grey[400], // Gris más claro para el modo oscuro
    inversePrimary: Color.fromRGBO(200, 200, 200, 1), // Color inverso ajustado para legibilidad
    onPrimary: Colors.white, // Texto sobre el color primario debe ser blanco
    inverseSurface: Colors.grey.shade300,// Color inverso para la superficie
  ),
);