import 'package:flutter/material.dart';

import '../main.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  toogleTheme(bool isDark) {
    _themeMode = !isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}
