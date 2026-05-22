//
// @file provider.dart
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief
// @date 2025-05-14
//

import 'package:flutter/material.dart';
import 'package:veloo/theme/theme.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _themeData;

  ThemeProvider() {
    final deviceTheme = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    if (deviceTheme == Brightness.light) {
      _themeData = lightTheme;
    }
    else {
      _themeData = darkTheme;
    }
  }

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightTheme) {
      _themeData = darkTheme;
    }
    else {
      _themeData = lightTheme;
    }
    notifyListeners();
  }
}
