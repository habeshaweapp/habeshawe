import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier{

  ThemeMode _themeMode = ThemeMode.light;

  get themeMode => _themeMode;

  toogleTheme(bool isDark){
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}