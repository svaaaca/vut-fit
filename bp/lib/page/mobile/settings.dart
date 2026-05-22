//
// @file settings.dart
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief Source code of the mobile settings page implementation.
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

class SettingsPageMobileLayout extends StatefulWidget {
  const SettingsPageMobileLayout({super.key});

  @override
  State<SettingsPageMobileLayout> createState() => _SettingsPageMobileLayoutState();
}

class _SettingsPageMobileLayoutState extends State<SettingsPageMobileLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(context, 'settings'),
          style: TextStyle(
            fontSize: 18.0,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      shape: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.shadow,
                          width: 0.4,
                        ),
                        top: BorderSide(
                          color: Theme.of(context).colorScheme.shadow,
                          width: 0.4,
                        ),
                      ),
                      tileColor: Theme.of(context).colorScheme.primary,
                      title: Text(
                        translate(context, 'application'),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 14.0,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 48.0,
                      child: Center(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          horizontalTitleGap: 4.0,
                          leading: Icon(
                            Icons.dark_mode,
                            color: Theme.of(context).colorScheme.onSecondary,
                            size: 20.0,
                          ),
                          title: Text(
                            translate(context, 'dark_mode'),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 12.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: Transform.scale(
                            scale: 0.8,
                            child: Switch(
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
                    SizedBox(
                      height: 48.0,
                      child: Center(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          horizontalTitleGap: 4.0,
                          leading: Icon(
                            Icons.language,
                            color: Theme.of(context).colorScheme.onSecondary,
                            size: 20.0,
                          ),
                          title: Text(
                            translate(context, 'language'),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 12.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: SizedBox(
                            width: 136.0,
                            child: Transform.scale(
                              alignment: Alignment.centerRight,
                              scale: 0.8,
                              child: DropdownMenu<Locale>(
                                dropdownMenuEntries: [
                                  DropdownMenuEntry<Locale>(
                                    label: translate(context, 'czech'),
                                    style: ButtonStyle(
                                      foregroundColor: WidgetStatePropertyAll(
                                        Theme.of(context).colorScheme.onSecondary,
                                      ),
                                      textStyle: WidgetStatePropertyAll(
                                        TextStyle(
                                          fontSize: 12.0,
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
                                          fontSize: 12.0,
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
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.onSecondary,
                                      width: 1.0,
                                    ),
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
                                  fontSize: 14.0,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      shape: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.shadow,
                          width: 0.4,
                        ),
                        top: BorderSide(
                          color: Theme.of(context).colorScheme.shadow,
                          width: 0.4,
                        ),
                      ),
                      tileColor: Theme.of(context).colorScheme.primary,
                      title: Text(
                        translate(context, 'measurement'),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 14.0,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 48.0,
                      child: Center(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          horizontalTitleGap: 4.0,
                          leading: Icon(
                            Icons.linear_scale_rounded,
                            color: Theme.of(context).colorScheme.onSecondary,
                            size: 20.0,
                          ),
                          title: Text(
                            translate(context, 'units'),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 12.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: SizedBox(
                            width: 136.0,
                            child: Transform.scale(
                              alignment: Alignment.centerRight,
                              scale: 0.8,
                              child: DropdownMenu<Units>(
                                dropdownMenuEntries: [
                                  DropdownMenuEntry<Units>(
                                    label: translate(context, 'metric'),
                                    style: ButtonStyle(
                                      foregroundColor: WidgetStatePropertyAll(
                                        Theme.of(context).colorScheme.onSecondary,
                                      ),
                                      textStyle: WidgetStatePropertyAll(
                                        TextStyle(
                                          fontSize: 12.0,
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
                                          fontSize: 12.0,
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
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.onSecondary,
                                      width: 1.0,
                                    ),
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
                                  fontSize: 14.0,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 48.0,
                      child: Center(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          horizontalTitleGap: 4.0,
                          leading: Icon(
                            Icons.speed_rounded,
                            color: Theme.of(context).colorScheme.onSecondary,
                            size: 20.0,
                          ),
                          title: Text(
                            translate(context, 'speed'),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 12.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: SizedBox(
                            width: 172.0,
                            child: Row(
                              children: [
                                Transform.scale(
                                  alignment: Alignment.centerRight,
                                  scale: 0.8,
                                  child: Consumer2<TripProvider, UnitsProvider>(
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
                                            iconSize: 20.0,
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
                                            iconSize: 20.0,
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
                                          cursorHeight: 12.0,
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.onSecondary,
                                            fontSize: 14.0,
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                      );
                                    }
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    Provider.of<UnitsProvider>(context, listen:false).unitsData.name == 'metric' ? 'km/h' : 'mph',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSecondary,
                                      fontSize: 12.0,
                                      overflow: TextOverflow.clip,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      shape: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.shadow,
                          width: 0.4,
                        ),
                        top: BorderSide(
                          color: Theme.of(context).colorScheme.shadow,
                          width: 0.4,
                        ),
                      ),
                      tileColor: Theme.of(context).colorScheme.primary,
                      title: Text(
                        translate(context, 'climbs'),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 14.0,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 48.0,
                      child: Center(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          horizontalTitleGap: 4.0,
                          leading: Icon(
                            Icons.bolt_rounded,
                            color: Theme.of(context).colorScheme.onSecondary,
                            size: 20.0,
                          ),
                          title: Text(
                            translate(context, 'difficulty'),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 12.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: SizedBox(
                            width: 136.0,
                            child: Transform.scale(
                              alignment: Alignment.centerRight,
                              scale: 0.8,
                              child: DropdownMenu<Level>(
                                dropdownMenuEntries: [
                                  DropdownMenuEntry<Level>(
                                    label: translate(context, 'easy'),
                                    style: ButtonStyle(
                                      foregroundColor: WidgetStatePropertyAll(
                                        Theme.of(context).colorScheme.onSecondary,
                                      ),
                                      textStyle: WidgetStatePropertyAll(
                                        TextStyle(
                                          fontSize: 12.0,
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
                                          fontSize: 12.0,
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
                                          fontSize: 12.0,
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
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.onSecondary,
                                      width: 1.0,
                                    ),
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
                                ),
                                onSelected: (Level? newLevel) async {
                                  if (newLevel != null && newLevel != Provider.of<TripProvider>(context, listen: false).levelData) {
                                    Provider.of<TripProvider>(context, listen: false).setLevel(newLevel);
                                  }
                                },
                                textStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 14.0,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
