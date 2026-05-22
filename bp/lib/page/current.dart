//
// @file current.dart
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief Source code of the current page responsive layout implementation.
// @date 2025-05-14
//

import 'package:flutter/material.dart';
import 'package:veloo/localization/translation.dart';
import 'package:veloo/page/desktop/analysis.dart';
import 'package:veloo/page/desktop/import.dart';
import 'package:veloo/page/desktop/settings.dart';
import 'package:veloo/page/desktop/trips.dart';
import 'package:veloo/page/mobile/analysis.dart';
import 'package:veloo/page/mobile/import.dart';
import 'package:veloo/page/mobile/settings.dart';
import 'package:veloo/page/mobile/trips.dart';
import 'package:veloo/responsive/layout.dart';

const List<ResponsiveLayout> page = [
  ResponsiveLayout(
    mobileLayout: ImportPageMobileLayout(),
    desktopLayout: ImportPageDesktopLayout(selectedIndex: 0),
  ),
  ResponsiveLayout(
    mobileLayout: AnalysisPageMobileLayout(),
    desktopLayout: AnalysisPageDesktopLayout(selectedIndex: 1),
  ),
  ResponsiveLayout(
    mobileLayout: TripsPageMobileLayout(),
    desktopLayout: TripsPageDesktopLayout(selectedIndex: 2),
  ),
  ResponsiveLayout(
    mobileLayout: SettingsPageMobileLayout(),
    desktopLayout: SettingsPageDesktopLayout(selectedIndex: 3),
  ),
];

const List<Map<String, dynamic>> item = [
  {
    'icon': Icons.upload_file,
    'index': 0,
    'label': 'import',
    'tooltip': '',
  },
  {
    'icon': Icons.query_stats,
    'index': 1,
    'label': 'analysis',
    'tooltip': '',
  },
  {
    'icon': Icons.directions_bike_rounded,
    'index': 2,
    'label': 'trips',
    'tooltip': '',
  },
  {
    'icon': Icons.settings,
    'index': 3,
    'label': 'settings',
    'tooltip': '',
  },
];

class CurrentPage extends StatefulWidget {
  final int index;

  const CurrentPage({super.key, required this.index});

  @override
  State<CurrentPage> createState() => _CurrentPageState();
}

class _CurrentPageState extends State<CurrentPage> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page[selectedIndex],
      bottomNavigationBar: MediaQuery.of(context).size.width <= 1024.0
      ? Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 1.0,
              color: Theme.of(context).navigationBarTheme.shadowColor!,
              spreadRadius: 0.1,
            ),
          ],
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Theme.of(context).navigationBarTheme.backgroundColor,
            indicatorColor: Theme.of(context).navigationBarTheme.indicatorColor,
            shadowColor: Theme.of(context).navigationBarTheme.shadowColor,
          ),
          child: NavigationBar(
            destinations: List.generate(item.length, (index) {
              return NavigationDestination(
                icon: Icon(
                  item[index]['icon'],
                  color: selectedIndex == index
                  ? Theme.of(context).colorScheme.onTertiary
                  : Theme.of(context).colorScheme.onPrimary,
                  size: 20.0,
                ),
                label: translate(context, item[index]['label']),
                tooltip: translate(context, item[index]['tooltip']),
              );
            }),
            labelTextStyle: WidgetStateProperty.resolveWith((state) {
              if (state.contains(WidgetState.selected)) {
                return TextStyle(
                  color: Theme.of(context).indicatorColor,
                  fontSize: 12.0,
                  overflow: TextOverflow.ellipsis,
                );
              }
              return TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 12.0,
                overflow: TextOverflow.ellipsis,
              );
            }),
            onDestinationSelected: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
            selectedIndex: selectedIndex,
          ),
        ),
      ) : SizedBox.shrink(),
    );
  }
}
