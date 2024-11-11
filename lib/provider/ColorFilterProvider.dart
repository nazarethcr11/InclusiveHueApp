import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inclusive_hue_app/provider/color_transformation.dart';

class ColorFilterProvider extends ChangeNotifier {
  bool isToggled = false;
  double? colorAdjustment; // Inicialmente nulo
  double? severity;        // Inicialmente nulo
  String colorType = 'PROTANOMALY';
  bool _isLoaded = false;  // Indicador para saber si las preferencias han sido cargadas

  bool get isLoaded => _isLoaded;

  ColorFilterProvider() {
    _loadPreferences();  // Cargar las preferencias al iniciar
  }

  // Cargar las preferencias guardadas en SharedPreferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    isToggled = prefs.getBool('isToggled') ?? false;
    colorAdjustment = prefs.getDouble('colorAdjustment') ?? 50.0;
    severity = prefs.getDouble('severity') ?? 50.0;
    colorType = prefs.getString('colorType') ?? 'PROTANOMALY';
    _isLoaded = true;  // Marcar como cargado
    notifyListeners();  // Notificar a los listeners que se han cargado los valores
  }

  // Guardar las preferencias actualizadas
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isToggled', isToggled);
    await prefs.setDouble('colorAdjustment', colorAdjustment!);
    await prefs.setDouble('severity', severity!);
    await prefs.setString('colorType', colorType);
  }

  // Actualizar los valores y guardarlos
  void updateColorFilter({required bool toggled, required double adjustment, required double severityValue, required String type}) {
    isToggled = toggled;
    colorAdjustment = adjustment;
    severity = severityValue;
    colorType = type;
    _savePreferences();  // Guardar los valores actualizados
    notifyListeners();
  }

  // Obtener el filtro de color basado en los valores actuales
  ColorFilter get colorFilter {
    if (isToggled) {
      return getColorFilterForTypeAndSeverity(colorType, severity! / 100, colorAdjustment! / 100);
    } else {
      return ColorFilter.mode(Colors.transparent, BlendMode.multiply);
    }
  }
}
