//
// @file main.dart
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief Source code of the main app implementation.
// @date 2025-05-14
//

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:veloo/localization/provider.dart';
import 'package:veloo/page/current.dart';
import 'package:veloo/provider/provider.dart';
import 'package:veloo/theme/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LanguageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TripProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UnitsProvider(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LanguageProvider>(context).localeData;

    return Consumer4<LanguageProvider, ThemeProvider, TripProvider, UnitsProvider>(
      builder: (context, languageProvider, themeProvider, tripProvider, unitsProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const CurrentPage(index: 0),
          locale: locale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('cs'),
            Locale('en'),
          ],
          theme: Provider.of<ThemeProvider>(context).themeData,
        );
      },
    );
  }
}
