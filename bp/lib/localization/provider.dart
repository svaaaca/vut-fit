//
// @file provider.dart
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief
// @date 2025-05-14
//

import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  late Locale _localeData;

  LanguageProvider() {
    final String deviceLocale = WidgetsBinding.instance.platformDispatcher.locale.languageCode.toLowerCase();
    if (deviceLocale == 'cs' || deviceLocale == 'sk') {
      _localeData = const Locale('cs');
    }
    else {
      _localeData = const Locale('en');
    }
  }

  Locale get localeData => _localeData;

  set locale(Locale localeData) {
    _localeData = localeData;
    notifyListeners();
  }

  void setLocale(Locale localeData) {
    _localeData = localeData;
    notifyListeners();
  }
}
