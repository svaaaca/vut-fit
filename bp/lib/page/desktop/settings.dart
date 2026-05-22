//
// @file settings.dart
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief Source code of the desktop settings page implementation.
// @date 2025-05-14
//

import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:provider/provider.dart';
import 'package:veloo/localization/provider.dart';
import 'package:veloo/localization/translation.dart';
import 'package:veloo/page/current.dart';
import 'package:veloo/provider/provider.dart';
import 'package:veloo/theme/provider.dart';

class SettingsPageDesktopLayout extends StatefulWidget {
  final int selectedIndex;

  const SettingsPageDesktopLayout({super.key, required this.selectedIndex});

  @override
  State<SettingsPageDesktopLayout> createState() => _SettingsPageDesktopLayoutState();
}

class _SettingsPageDesktopLayoutState extends State<SettingsPageDesktopLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(context, 'settings'),
          style: TextStyle(
            fontSize: 24.0,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: Row(
        children: [
          NavigationDrawer(
            onDestinationSelected: (int index) {
              if (index != widget.selectedIndex) {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                      CurrentPage(index: index),
                    reverseTransitionDuration: Duration.zero,
                    transitionDuration: Duration.zero,
                  ),
                );
              }
            },
            selectedIndex: widget.selectedIndex,
            tilePadding: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 8.0,
            ),
            children: List.generate(item.length, (index) {
              return NavigationDrawerDestination(
                icon: Icon(
                  item[index]['icon'],
                  color: widget.selectedIndex == index
                  ? Theme.of(context).colorScheme.onTertiary
                  : Theme.of(context).colorScheme.onPrimary,
                  size: 32.0,
                ),
                label: Text(
                  translate(context, item[index]['label']),
                  style: TextStyle(
                    color: widget.selectedIndex == index
                    ? Theme.of(context).colorScheme.onTertiary
                    : Theme.of(context).colorScheme.onPrimary,
                    fontSize: 16.0,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 32.0),
                              child: Center(
                                child: Text(
                                  translate(context, 'application'),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSecondary,
                                    fontSize: 18.0,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 32.0),
                              child: Row(
                                spacing: 32.0,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Center(
                                            child: Text(
                                              translate(context, 'appearance'),
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSecondary,
                                                fontSize: 16.0,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          child: SizedBox(
                                            height: 64.0,
                                            child: Center(
                                              child: ListTile(
                                                leading: Icon(
                                                  Icons.dark_mode,
                                                  color: Theme.of(context).colorScheme.onSecondary,
                                                  size: 32.0,
                                                ),
                                                title: Text(
                                                  translate(context, 'dark_mode'),
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.onSecondary,
                                                    fontSize: 16.0,
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                                trailing: Switch(
                                                  activeColor: Theme.of(context).colorScheme.tertiary,
                                                  onChanged: (bool value) {
                                                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                                                  },
                                                  value: Theme.of(context).brightness == Brightness.dark,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Center(
                                            child: Text(
                                              translate(context, 'language'),
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSecondary,
                                                fontSize: 16.0,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          child: SizedBox(
                                            height: 64.0,
                                            child: Center(
                                              child: ListTile(
                                                leading: Icon(
                                                  Icons.language,
                                                  color: Theme.of(context).colorScheme.onSecondary,
                                                  size: 32.0,
                                                ),
                                                title: DropdownMenu<Locale>(
                                                  dropdownMenuEntries: [
                                                    DropdownMenuEntry<Locale>(
                                                      label: translate(context, 'czech'),
                                                      style: ButtonStyle(
                                                        foregroundColor: WidgetStatePropertyAll(
                                                          Theme.of(context).colorScheme.onSecondary,
                                                        ),
                                                        textStyle: WidgetStatePropertyAll(
                                                          TextStyle(
                                                            fontSize: 16.0,
                                                            overflow: TextOverflow.clip,
                                                          ),
                                                        ),
                                                      ),
                                                      value: Locale('cs'),
                                                    ),
                                                    DropdownMenuEntry<Locale>(
                                                      label: translate(context, 'english'),
                                                      style: ButtonStyle(
                                                        foregroundColor: WidgetStatePropertyAll(
                                                          Theme.of(context).colorScheme.onSecondary,
                                                        ),
                                                        textStyle: WidgetStatePropertyAll(
                                                          TextStyle(
                                                            fontSize: 16.0,
                                                            overflow: TextOverflow.clip,
                                                          ),
                                                        ),
                                                      ),
                                                      value: Locale('en'),
                                                    ),
                                                  ],
                                                  enableSearch: false,
                                                  expandedInsets: EdgeInsets.all(0.0),
                                                  focusNode: FocusNode(canRequestFocus: false),
                                                  initialSelection: Localizations.localeOf(context),
                                                  inputDecorationTheme: InputDecorationTheme(
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(8.0),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    suffixIconColor: Theme.of(context).colorScheme.onSecondary,
                                                  ),
                                                  menuStyle: MenuStyle(
                                                    backgroundColor: WidgetStatePropertyAll(
                                                      Theme.of(context).colorScheme.primary,
                                                    ),
                                                    elevation: WidgetStatePropertyAll(1.0),
                                                    shadowColor: WidgetStatePropertyAll(
                                                      Theme.of(context).colorScheme.shadow,
                                                    ),
                                                    shape: WidgetStatePropertyAll(
                                                      RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        side: BorderSide.none,
                                                      ),
                                                    ),
                                                    side: WidgetStatePropertyAll(
                                                      BorderSide(
                                                        color: Theme.of(context).colorScheme.shadow,
                                                      ),
                                                    ),
                                                  ),
                                                  onSelected: (Locale? newLocale) {
                                                    if (newLocale != null) {
                                                      Provider.of<LanguageProvider>(context, listen: false).setLocale(newLocale);
                                                      Navigator.pushReplacement(
                                                        context,
                                                        PageRouteBuilder(
                                                          pageBuilder: (context, animation, secondaryAnimation) =>
                                                            CurrentPage(index: 3),
                                                          reverseTransitionDuration: Duration.zero,
                                                          transitionDuration: Duration.zero,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  textStyle: TextStyle(
                                                    color: Theme.of(context).colorScheme.onSecondary,
                                                    fontSize: 16.0,
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 32.0),
                              child: Center(
                                child: Text(
                                  translate(context, 'measurement'),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSecondary,
                                    fontSize: 18.0,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 32.0),
                              child: Row(
                                spacing: 32.0,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Center(
                                            child: Text(
                                              translate(context, 'units'),
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSecondary,
                                                fontSize: 16.0,
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          child: SizedBox(
                                            height: 64.0,
                                            child: Center(
                                              child: ListTile(
                                                leading: Icon(
                                                  Icons.linear_scale_rounded,
                                                  color: Theme.of(context).colorScheme.onSecondary,
                                                  size: 32.0,
                                                ),
                                                title: DropdownMenu<Units>(
                                                  dropdownMenuEntries: [
                                                    DropdownMenuEntry<Units>(
                                                      label: translate(context, 'metric'),
                                                      style: ButtonStyle(
                                                        foregroundColor: WidgetStatePropertyAll(
                                                          Theme.of(context).colorScheme.onSecondary,
                                                        ),
                                                        textStyle: WidgetStatePropertyAll(
                                                          TextStyle(
                                                            fontSize: 16.0,
                                                            overflow: TextOverflow.clip,
                                                          ),
                                                        ),
                                                      ),
                                                      value: Units.metric,
                                                    ),
                                                    DropdownMenuEntry<Units>(
                                                      label: translate(context, 'imperial'),
                                                      style: ButtonStyle(
                                                        foregroundColor: WidgetStatePropertyAll(
                                                          Theme.of(context).colorScheme.onSecondary,
                                                        ),
                                                        textStyle: WidgetStatePropertyAll(
                                                          TextStyle(
                                                            fontSize: 16.0,
                                                            overflow: TextOverflow.clip,
                                                          ),
                                                        ),
                                                      ),
                                                      value: Units.imperial,
                                                    ),
                                                  ],
                                                  enableSearch: false,
                                                  expandedInsets: EdgeInsets.all(0.0),
                                                  focusNode: FocusNode(canRequestFocus: false),
                                                  initialSelection: Provider.of<UnitsProvider>(context).unitsData,
                                                  inputDecorationTheme: InputDecorationTheme(
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(8.0),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    suffixIconColor: Theme.of(context).colorScheme.onSecondary,
                                                  ),
                                                  menuStyle: MenuStyle(
                                                    backgroundColor: WidgetStatePropertyAll(
                                                      Theme.of(context).colorScheme.primary,
                                                    ),
                                                    elevation: WidgetStatePropertyAll(1.0),
                                                    shadowColor: WidgetStatePropertyAll(
                                                      Theme.of(context).colorScheme.shadow,
                                                    ),
                                                    shape: WidgetStatePropertyAll(
                                                      RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        side: BorderSide.none,
                                                      ),
                                                    ),
                                                    side: WidgetStatePropertyAll(
                                                      BorderSide(
                                                        color: Theme.of(context).colorScheme.shadow,
                                                      ),
                                                    ),
                                                  ),
                                                  onSelected: (Units? newUnits) async {
                                                    if (newUnits != null && newUnits != Provider.of<UnitsProvider>(context, listen: false).unitsData) {
                                                      Provider.of<UnitsProvider>(context, listen: false).setUnits(newUnits);
                                                      if (newUnits.name == 'imperial') {
                                                        Provider.of<TripProvider>(context, listen: false).setImperial();
                                                      }
                                                      if (newUnits.name == 'metric') {
                                                        Provider.of<TripProvider>(context, listen: false).setMetric();
                                                      }
                                                    }
                                                  },
                                                  textStyle: TextStyle(
                                                    color: Theme.of(context).colorScheme.onSecondary,
                                                    fontSize: 16.0,
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Center(
                                            child: Text(
                                              translate(context, 'speed'),
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSecondary,
                                                fontSize: 16.0,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          child: SizedBox(
                                            height: 64.0,
                                            child: Center(
                                              child: ListTile(
                                                leading: Icon(
                                                  Icons.speed_rounded,
                                                  color: Theme.of(context).colorScheme.onSecondary,
                                                  size: 32.0,
                                                ),
                                                title: Consumer2<TripProvider, UnitsProvider>(
                                                  builder: (context, tripProvider, unitsProvider, child) {
                                                    return InputQty.int(
                                                      decoration: QtyDecorationProps(
                                                        isBordered: false,
                                                        isCollapsed: false,
                                                        minusBtn: IconButton(
                                                          icon: Icon(
                                                            Icons.remove_rounded,
                                                            color: tripProvider.averageSpeedData == 1
                                                            ? Theme.of(context).colorScheme.onSurface
                                                            : Theme.of(context).colorScheme.onSecondary,
                                                          ),
                                                          iconSize: 32.0,
                                                          onLongPress: () {},
                                                          onPressed: tripProvider.averageSpeedData == 1
                                                          ? null
                                                          : () async {
                                                            tripProvider.setSpeed(tripProvider.averageSpeedData - 1);
                                                          },
                                                          padding: const EdgeInsets.all(0.0),
                                                        ),
                                                        plusBtn: IconButton(
                                                          icon: Icon(
                                                            Icons.add_rounded,
                                                            color: tripProvider.averageSpeedData == (unitsProvider.unitsData.name == 'metric' ? 64 : 40)
                                                            ? Theme.of(context).colorScheme.onSurface
                                                            : Theme.of(context).colorScheme.onSecondary,
                                                          ),
                                                          iconSize: 32.0,
                                                          onLongPress: () {},
                                                          onPressed: tripProvider.averageSpeedData == (unitsProvider.unitsData.name == 'metric' ? 64 : 40)
                                                          ? null
                                                          : () async {
                                                            tripProvider.setSpeed(tripProvider.averageSpeedData + 1);
                                                          },
                                                          padding: const EdgeInsets.all(0.0),
                                                        ),
                                                      ),
                                                      initVal: tripProvider.averageSpeedData,
                                                      key: ValueKey('${tripProvider.averageSpeedData}_${unitsProvider.unitsData.name}'),
                                                      maxVal: unitsProvider.unitsData.name == 'metric' ? 64 : 40,
                                                      minVal: 1,
                                                      onQtyChanged: (value) {
                                                        tripProvider.setSpeed(value);
                                                      },
                                                      qtyFormProps: QtyFormProps(
                                                        cursorColor: Theme.of(context).colorScheme.onPrimary,
                                                        cursorHeight: 16.0,
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.onSecondary,
                                                          fontSize: 16.0,
                                                          overflow: TextOverflow.clip,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                ),
                                                trailing: SizedBox(
                                                  width: 42.0,
                                                  child: Text(
                                                    (Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric') ? 'km/h' : 'mph',
                                                    style: TextStyle(
                                                      color: Theme.of(context).colorScheme.onSecondary,
                                                      fontSize: 16.0,
                                                      overflow: TextOverflow.clip,
                                                    ),
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 32.0),
                              child: Center(
                                child: Text(
                                  translate(context, 'climbs'),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSecondary,
                                    fontSize: 18.0,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 32.0),
                              child: Row(
                                spacing: 32.0,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Center(
                                            child: Text(
                                              translate(context, 'difficulty'),
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSecondary,
                                                fontSize: 16.0,
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          child: SizedBox(
                                            height: 64.0,
                                            child: Center(
                                              child: ListTile(
                                                leading: Icon(
                                                  Icons.bolt_rounded,
                                                  color: Theme.of(context).colorScheme.onSecondary,
                                                  size: 32.0,
                                                ),
                                                title: DropdownMenu<Level>(
                                                  dropdownMenuEntries: [
                                                    DropdownMenuEntry<Level>(
                                                      label: translate(context, 'easy'),
                                                      style: ButtonStyle(
                                                        foregroundColor: WidgetStatePropertyAll(
                                                          Theme.of(context).colorScheme.onSecondary,
                                                        ),
                                                        textStyle: WidgetStatePropertyAll(
                                                          TextStyle(
                                                            fontSize: 16.0,
                                                            overflow: TextOverflow.clip,
                                                          ),
                                                        ),
                                                      ),
                                                      value: Level.easy,
                                                    ),
                                                    DropdownMenuEntry<Level>(
                                                      label: translate(context, 'medium'),
                                                      style: ButtonStyle(
                                                        foregroundColor: WidgetStatePropertyAll(
                                                          Theme.of(context).colorScheme.onSecondary,
                                                        ),
                                                        textStyle: WidgetStatePropertyAll(
                                                          TextStyle(
                                                            fontSize: 16.0,
                                                            overflow: TextOverflow.clip,
                                                          ),
                                                        ),
                                                      ),
                                                      value: Level.medium,
                                                    ),
                                                    DropdownMenuEntry<Level>(
                                                      label: translate(context, 'difficult'),
                                                      style: ButtonStyle(
                                                        foregroundColor: WidgetStatePropertyAll(
                                                          Theme.of(context).colorScheme.onSecondary,
                                                        ),
                                                        textStyle: WidgetStatePropertyAll(
                                                          TextStyle(
                                                            fontSize: 16.0,
                                                            overflow: TextOverflow.clip,
                                                          ),
                                                        ),
                                                      ),
                                                      value: Level.difficult,
                                                    ),
                                                  ],
                                                  enableSearch: false,
                                                  expandedInsets: EdgeInsets.all(0.0),
                                                  focusNode: FocusNode(canRequestFocus: false),
                                                  initialSelection: Provider.of<TripProvider>(context).levelData,
                                                  inputDecorationTheme: InputDecorationTheme(
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(8.0),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    suffixIconColor: Theme.of(context).colorScheme.onSecondary,
                                                  ),
                                                  menuStyle: MenuStyle(
                                                    backgroundColor: WidgetStatePropertyAll(
                                                      Theme.of(context).colorScheme.primary,
                                                    ),
                                                    elevation: WidgetStatePropertyAll(1.0),
                                                    shadowColor: WidgetStatePropertyAll(
                                                      Theme.of(context).colorScheme.shadow,
                                                    ),
                                                    shape: WidgetStatePropertyAll(
                                                      RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        side: BorderSide.none,
                                                      ),
                                                    ),
                                                    side: WidgetStatePropertyAll(
                                                      BorderSide(
                                                        color: Theme.of(context).colorScheme.shadow,
                                                      ),
                                                    ),
                                                  ),
                                                  onSelected: (Level? newLevel) async {
                                                    if (newLevel != null && newLevel != Provider.of<TripProvider>(context, listen: false).levelData) {
                                                      Provider.of<TripProvider>(context, listen: false).setLevel(newLevel);
                                                    }
                                                  },
                                                  textStyle: TextStyle(
                                                    color: Theme.of(context).colorScheme.onSecondary,
                                                    fontSize: 16.0,
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
