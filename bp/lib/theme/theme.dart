//
// @file theme.dart
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief
// @date 2025-05-14
//

import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 238, 238, 238),
    elevation: 1.0,
    foregroundColor: Color.fromARGB(138, 0, 0, 0),
    shadowColor: Color.fromARGB(255, 66, 66, 66),
  ),
  brightness: Brightness.light,
  cardTheme: const CardTheme(
    color: Color.fromARGB(255, 238, 238, 238),
    shadowColor: Color.fromARGB(255, 66, 66, 66),
  ),
  colorScheme: const ColorScheme.light(
    error: Color.fromARGB(255, 255, 0, 0),
    onError: Color.fromARGB(255, 255, 255, 255),
    onSurface: Color.fromARGB(115, 0, 0, 0),
    onPrimary: Color.fromARGB(138, 0, 0, 0),
    onSecondary: Color.fromARGB(221, 0, 0, 0),
    onTertiary: Color.fromARGB(255, 0, 0, 0),
    primary: Color.fromARGB(255, 238, 238, 238),
    secondary: Color.fromARGB(255, 224, 224, 224),
    shadow: Color.fromARGB(255, 66, 66, 66),
    surface: Color.fromARGB(255, 245, 245, 245),
    tertiary: Color.fromARGB(255, 253, 216, 53),
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Color.fromARGB(255, 245, 245, 245),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16.0),
      ),
    ),
  ),
  filledButtonTheme: const FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll<Color>(
        Color.fromARGB(255, 224, 224, 224),
      ),
      elevation: WidgetStatePropertyAll<double>(0.0),
      foregroundColor: WidgetStatePropertyAll<Color>(
        Color.fromARGB(221, 0, 0, 0),
      ),
      shape: WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromARGB(255, 253, 216, 53),
    elevation: 0.0,
    foregroundColor: Color.fromARGB(255, 0, 0, 0),
    highlightElevation: 0.0,
    hoverElevation: 0.0,
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStateColor.resolveWith(
        (Set<WidgetState> state) {
          if (state.contains(WidgetState.hovered)) {
            return Color.fromARGB(255, 0, 0, 0);
          }
          return Color.fromARGB(255, 97, 97, 97);
        },
      ),
    ),
  ),
  indicatorColor: const Color.fromARGB(255, 0, 0, 0),
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 238, 238, 238),
    indicatorColor: Color.fromARGB(255, 253, 216, 53),
    shadowColor: Color.fromARGB(255, 66, 66, 66),
  ),
  navigationDrawerTheme: const NavigationDrawerThemeData(
    backgroundColor: Color.fromARGB(255, 238, 238, 238),
    elevation: 2.0,
    indicatorColor: Color.fromARGB(255, 253, 216, 53),
    indicatorShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16.0),
      ),
    ),
    shadowColor: Color.fromARGB(255, 66, 66, 66),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 245, 245, 245),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith(
      (Set<WidgetState> state) {
        if (state.contains(WidgetState.selected)) {
          return Color.fromARGB(255, 253, 216, 53);
        }
        return Color.fromARGB(221, 0, 0, 0);
      },
    ),
    thumbIcon: WidgetStateProperty.resolveWith(
      (Set<WidgetState> state) {
        if (state.contains(WidgetState.selected)) {
          return Icon(
            Icons.check,
            color: Color.fromARGB(255, 245, 245, 245),
          );
        }
        return Icon(
          Icons.close,
          color: Color.fromARGB(255, 245, 245, 245),
        );
      },
    ),
    trackOutlineColor: WidgetStateProperty.resolveWith(
      (Set<WidgetState> state) {
        if (state.contains(WidgetState.selected)) {
          return null;
        }
        return Color.fromARGB(221, 0, 0, 0);
      },
    ),
  ),
  useMaterial3: true,
);

final ThemeData darkTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 66, 66, 66),
    elevation: 1.0,
    foregroundColor: Color.fromARGB(179, 255, 255, 255),
    shadowColor: Color.fromARGB(255, 238, 238, 238),
  ),
  brightness: Brightness.dark,
  cardTheme: const CardTheme(
    color: Color.fromARGB(255, 66, 66, 66),
    shadowColor: Color.fromARGB(255, 189, 189, 189),
  ),
  colorScheme: const ColorScheme.dark(
    error: Color.fromARGB(255, 255, 0, 0),
    onError: Color.fromARGB(255, 255, 255, 255),
    onSurface: Color.fromARGB(153, 255, 255, 255),
    onPrimary: Color.fromARGB(179, 255, 255, 255),
    onSecondary: Color.fromARGB(255, 255, 255, 255),
    onTertiary: Color.fromARGB(255, 0, 0, 0),
    primary: Color.fromARGB(255, 66, 66, 66),
    secondary: Color.fromARGB(255, 97, 97, 97),
    shadow: Color.fromARGB(255, 189, 189, 189),
    surface: Color.fromARGB(255, 33, 33, 33),
    tertiary: Color.fromARGB(255, 253, 216, 53),
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Color.fromARGB(255, 33, 33, 33),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16.0),
      ),
    ),
  ),
  filledButtonTheme: const FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll<Color>(
        Color.fromARGB(255, 97, 97, 97),
      ),
      elevation: WidgetStatePropertyAll<double>(0.0),
      foregroundColor: WidgetStatePropertyAll<Color>(
        Color.fromARGB(255, 255, 255, 255),
      ),
      shape: WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromARGB(255, 253, 216, 53),
    elevation: 0.0,
    foregroundColor: Color.fromARGB(255, 0, 0, 0),
    highlightElevation: 0.0,
    hoverElevation: 0.0,
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStateColor.resolveWith(
        (Set<WidgetState> state) {
          if (state.contains(WidgetState.hovered)) {
            return Color.fromARGB(255, 0, 0, 0);
          }
          return Color.fromARGB(255, 97, 97, 97);
        },
      ),
    ),
  ),
  indicatorColor: const Color.fromARGB(255, 255, 255, 255),
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 66, 66, 66),
    indicatorColor: Color.fromARGB(255, 253, 216, 53),
    shadowColor: Color.fromARGB(255, 238, 238, 238),
  ),
  navigationDrawerTheme: const NavigationDrawerThemeData(
    backgroundColor: Color.fromARGB(255, 66, 66, 66),
    elevation: 2.0,
    indicatorColor: Color.fromARGB(255, 253, 216, 53),
    indicatorShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16.0),
      ),
    ),
    shadowColor: Color.fromARGB(255, 238, 238, 238),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 33, 33, 33),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith(
      (Set<WidgetState> state) {
        if (state.contains(WidgetState.selected)) {
          return Color.fromARGB(255, 253, 216, 53);
        }
        return Color.fromARGB(255, 255, 255, 255);
      },
    ),
    thumbIcon: WidgetStateProperty.resolveWith(
      (Set<WidgetState> state) {
        if (state.contains(WidgetState.selected)) {
          return Icon(
            Icons.check,
            color: Color.fromARGB(255, 33, 33, 33),
          );
        }
        return Icon(
          Icons.close,
          color: Color.fromARGB(255, 33, 33, 33),
        );
      },
    ),
    trackOutlineColor: WidgetStateProperty.resolveWith(
      (Set<WidgetState> state) {
        if (state.contains(WidgetState.selected)) {
          return null;
        }
        return Color.fromARGB(255, 255, 255, 255);
      },
    ),
  ),
  useMaterial3: true,
);
