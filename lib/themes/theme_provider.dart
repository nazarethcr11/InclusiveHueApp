import 'package:flutter/material.dart';
import 'package:inclusive_hue_app/themes/dark_mode.dart';
import 'package:inclusive_hue_app/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  //default theme
  ThemeData _themeData = lightMode;
  //get theme
  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    _themeData = _themeData == lightMode ? darkMode : lightMode;
    notifyListeners();
  }
}