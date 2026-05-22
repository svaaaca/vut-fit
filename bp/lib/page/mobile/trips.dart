//
// @file trips.dart
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief Source code of the mobile trips page implementation.
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

class TripsPageMobileLayout extends StatefulWidget {
  const TripsPageMobileLayout({super.key});

  @override
  State<TripsPageMobileLayout> createState() => _TripsPageMobileLayoutState();
}

class _TripsPageMobileLayoutState extends State<TripsPageMobileLayout> {
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
            fontSize: 18.0,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: trips.isEmpty
      ? LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
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
                        translate(context, 'empty_list'),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 14.0,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 8.0,
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  size: 20.0,
                                ),
                                Text(
                                  translate(context, 'no_saved_trips'),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSecondary,
                                    fontSize: 12.0,
                                    overflow: TextOverflow.clip,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
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
      )
      : LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
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
                        translate(context, 'trip_list'),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 14.0,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Column(
                      children: trips.map<Widget>((trip) {
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          horizontalTitleGap: 4.0,
                          leading: Icon(
                            Icons.bolt_rounded,
                            color: Theme.of(context).colorScheme.onSecondary,
                            size: 20.0,
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
                              fontSize: 12.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: Text(
                            NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 2).format(trip['statistics']['difficulty_index']),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 12.0,
                              overflow: TextOverflow.clip,
                            ),
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
                                        translate(context, 'remove'),
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
                                    translate(context, 'remove_trip_list'),
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
                            fontSize: 12.0,
                            overflow: TextOverflow.clip,
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
