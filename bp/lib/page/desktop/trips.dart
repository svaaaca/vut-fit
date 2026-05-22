//
// @file trips.dart
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief Source code of the desktop trips page implementation.
// @date 2025-05-14
//

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veloo/localization/provider.dart';
import 'package:veloo/localization/translation.dart';
import 'package:veloo/page/current.dart';
import 'package:veloo/provider/provider.dart';

class TripsPageDesktopLayout extends StatefulWidget {
    final int selectedIndex;

  const TripsPageDesktopLayout({super.key, required this.selectedIndex});

  @override
  State<TripsPageDesktopLayout> createState() => _TripsPageDesktopLayoutState();
}

class _TripsPageDesktopLayoutState extends State<TripsPageDesktopLayout> {
  List<Map<String, dynamic>> trips = [];

  @override
  void initState() {
    super.initState();
    loadTrips();
  }

  Future<void> deleteTrip(int index) async {
    final delete = await showDialog<bool>(
      barrierDismissible: false,
      builder: (context) => Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 512.0,
          ),
          child: AlertDialog(
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  translate(context, 'cancel'),
                  style: TextStyle(
                    fontSize: 12.0,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.error,
                  ),
                ),
                child: Text(
                  translate(context, 'delete'),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onError,
                    fontSize: 12.0,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ],
            actionsAlignment: MainAxisAlignment.center,
            actionsOverflowAlignment: OverflowBarAlignment.end,
            actionsOverflowButtonSpacing: 8.0,
            content: Text(
              translate(context, 'delete_trip_analysis'),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 12.0,
                overflow: TextOverflow.clip,
              ),
              textAlign: TextAlign.center,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(
                color: Theme.of(context).indicatorColor,
                width: 1.0,
              ),
            ),
            title: Text(
              translate(context, 'warning'),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 16.0,
                overflow: TextOverflow.ellipsis,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      context: context,
    );
    if (delete == true) {
      final preferences = await SharedPreferences.getInstance();
      final List<String> list = preferences.getStringList('trips') ?? [];
      if (index >= 0 && index < list.length) {
        list.removeAt(index);
        await preferences.setStringList('trips', list);
        setState(() {
          trips = list.map((trip) => jsonDecode(trip) as Map<String, dynamic>).toList();
        });
      }
    }
  }

  Future<void> loadTrips() async {
    final preferences = await SharedPreferences.getInstance();
    final List<String> trip = preferences.getStringList('trips') ?? [];
    final List<Map<String, dynamic>> list = trip.map((trip) => jsonDecode(trip) as Map<String, dynamic>).toList();
    setState(() {
      trips = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(context, 'saved_trips'),
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
            child: trips.isEmpty
            ? LayoutBuilder(
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
                                  translate(context, 'empty_list'),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSecondary,
                                    fontSize: 18.0,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 16.0,
                                    children: [
                                      Icon(
                                        Icons.warning_amber_rounded,
                                        size: 32.0,
                                      ),
                                      Text(
                                        translate(context, 'no_saved_trips'),
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSecondary,
                                          fontSize: 16.0,
                                          overflow: TextOverflow.clip,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            )
            : LayoutBuilder(
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
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 32.0),
                              child: Center(
                                child: Text(
                                  translate(context, 'trip_list'),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSecondary,
                                    fontSize: 18.0,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Column(
                                  children: trips.map<Widget>((trip) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 32.0),
                                      child: Row(
                                        spacing: 32.0,
                                        children: [
                                          Expanded(
                                            child: Card(
                                              child: SizedBox(
                                                height: 64.0,
                                                child: Center(
                                                  child: ListTile(
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                    horizontalTitleGap: 16.0,
                                                    leading: Icon(
                                                      Icons.bolt_rounded,
                                                      color: Theme.of(context).colorScheme.onSecondary,
                                                      size: 32.0,
                                                    ),
                                                    onTap: () {
                                                      Provider.of<TripProvider>(context, listen: false).setTrip(trip['trip']);
                                                      Navigator.pushReplacement(
                                                        context,
                                                        PageRouteBuilder(
                                                          pageBuilder: (context, animation, secondaryAnimation) =>
                                                            CurrentPage(index: 1),
                                                          reverseTransitionDuration: Duration.zero,
                                                          transitionDuration: Duration.zero,
                                                        ),
                                                      );
                                                    },
                                                    title: Text(
                                                      trip['name'],
                                                      style: TextStyle(
                                                        color: Theme.of(context).colorScheme.onSecondary,
                                                        fontSize: 16.0,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    trailing: Text(
                                                      NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 2).format(trip['statistics']['difficulty_index']),
                                                      style: TextStyle(
                                                        color: Theme.of(context).colorScheme.onSecondary,
                                                        fontSize: 16.0,
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
                                    );
                                  }).toList(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: FilledButton(
                                    onPressed: () async {
                                      final clear = await showDialog<bool>(
                                        barrierDismissible: false,
                                        builder: (context) => Align(
                                          alignment: Alignment.center,
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: 768.0,
                                            ),
                                            child: AlertDialog(
                                              actions: [
                                                FilledButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(false);
                                                  },
                                                  child: Text(
                                                    translate(context, 'cancel'),
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      overflow: TextOverflow.clip,
                                                    ),
                                                  ),
                                                ),
                                                FilledButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(true);
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor: WidgetStatePropertyAll(
                                                      Theme.of(context).colorScheme.error,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    translate(context, 'remove'),
                                                    style: TextStyle(
                                                      color: Theme.of(context).colorScheme.onError,
                                                      fontSize: 14.0,
                                                      overflow: TextOverflow.clip,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              actionsAlignment: MainAxisAlignment.center,
                                              actionsOverflowAlignment: OverflowBarAlignment.end,
                                              actionsOverflowButtonSpacing: 8.0,
                                              content: Text(
                                                translate(context, 'remove_trip_list'),
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.onSecondary,
                                                  fontSize: 14.0,
                                                  overflow: TextOverflow.clip,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8.0),
                                                side: BorderSide(
                                                  color: Theme.of(context).indicatorColor,
                                                  width: 1.0,
                                                ),
                                              ),
                                              title: Text(
                                                translate(context, 'warning'),
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.onSecondary,
                                                  fontSize: 24.0,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                        context: context,
                                      );
                                      if (clear == true && context.mounted) {
                                        final preferences = await SharedPreferences.getInstance();
                                        await preferences.clear();
                                        if (context.mounted) {
                                          Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation, secondaryAnimation) =>
                                                CurrentPage(index: 2),
                                              reverseTransitionDuration: Duration.zero,
                                              transitionDuration: Duration.zero,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: Text(
                                      translate(context, 'remove_trips'),
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
