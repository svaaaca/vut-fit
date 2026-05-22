//
// @file analysis.dart
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief Source code of the desktop analysis page implementation.
// @date 2025-05-14
//

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veloo/localization/provider.dart';
import 'package:veloo/localization/translation.dart';
import 'package:veloo/page/current.dart';
import 'package:veloo/provider/provider.dart';

class AnalysisPageDesktopLayout extends StatefulWidget {
  final int selectedIndex;

  const AnalysisPageDesktopLayout({super.key, required this.selectedIndex});

  @override
  State<AnalysisPageDesktopLayout> createState() => _AnalysisPageDesktopLayoutState();
}

class _AnalysisPageDesktopLayoutState extends State<AnalysisPageDesktopLayout> with TickerProviderStateMixin {
  late final controller = AnimatedMapController(
    cancelPreviousAnimations: true,
    curve: Curves.easeInOut,
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  List<Map<String, dynamic>> climbs = [];
  List<LatLng> coordinates = [];
  String? elevationProfile;
  LatLng? location;
  String nearbyFinish = '';
  String nearbyStart = '';
  Map<String, double> statistics = {};
  StreamSubscription<Position>? stream;

  @override
  void initState() {
    super.initState();
    if (Provider.of<TripProvider>(context, listen: false).tripData != null) {
      final data = jsonDecode(Provider.of<TripProvider>(context, listen: false).tripData!);
      setState(() {
        climbs = List<Map<String, dynamic>>.from(
          data['climb_profiles'] ?? [],
        );
        coordinates = data['coordinates'].map<LatLng>((coord) =>
          LatLng(coord[0], coord[1])).toList();
        elevationProfile = data['elevation_profile'];
        nearbyFinish = data['nearby_finish'];
        nearbyStart = data['nearby_start'];
        statistics = Map<String, double>.from(
          data['statistics'].map((key, value) => MapEntry(key, (value as num).toDouble())),
        );
      });
      if (coordinates.isNotEmpty) {
        Future.microtask(() {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.mapController.fitCamera(
              CameraFit.bounds(
                bounds: LatLngBounds.fromPoints(coordinates),
                padding: const EdgeInsets.all(16.0),
              ),
            );
          });
        });
      }
    }
  }

  Future<void> getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      if (!mounted) {
        return;
      }
      final settings = await showDialog<bool>(
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
                      Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  child: Text(
                    translate(context, 'settings'),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiary,
                      fontSize: 14.0,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              ],
              actionsAlignment: MainAxisAlignment.center,
              content: Text(
                translate(context, 'allow_access'),
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
                translate(context, 'location'),
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
      if (settings == true) {
        await Geolocator.openLocationSettings();
      }
      return;
    }
    await stream?.cancel();
    stream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
      ),
    ).listen(
      (Position position) {
        final current = LatLng(position.latitude, position.longitude);
        if (!mounted) {
          return;
        }
        setState(() {
          location = current;
        });
        controller.animateTo(
          dest: current,
          rotation: 0.0,
          zoom: 14.0,
        );
      }
    );
  }

  Future<void> saveAnalysis() async {
    final preferences = await SharedPreferences.getInstance();
    Map<String, dynamic> trip = {};
    if (mounted) {
      trip = {
        'key': DateTime.now().toIso8601String(),
        'name': '$nearbyStart > $nearbyFinish',
        'statistics': statistics,
        'trip': Provider.of<TripProvider>(context, listen: false).tripData,
      };
    }
    final List<String> trips = preferences.getStringList('trips') ?? [];
    trips.add(jsonEncode(trip));
    await preferences.setStringList('trips', trips);
    if (mounted) {
      showDialog(
        barrierDismissible: false,
        builder: (context) {
          return Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 768.0,
              ),
              child: AlertDialog(
                actions: [
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      translate(context, 'ok'),
                      style: TextStyle(
                        fontSize: 14.0,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                ],
                actionsAlignment: MainAxisAlignment.center,
                content: Text(
                  translate(context, 'save_success'),
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
                  translate(context, 'success'),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: 24.0,
                    overflow: TextOverflow.ellipsis,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
        context: context,
      );
    }
  }

  @override
  void dispose() {
    stream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(context, 'trip_analysis'),
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
            child: Provider.of<TripProvider>(context, listen: false).tripData == null
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
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 32.0),
                              child: Center(
                                child: Text(
                                  translate(context, 'empty_input'),
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
                                        translate(context, 'no_input_data'),
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
                                  translate(context, 'map'),
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 512.0,
                                    width: double.infinity,
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: Stack(
                                        children: [
                                          FlutterMap(
                                            mapController: controller.mapController,
                                            options: MapOptions(
                                              interactionOptions: const InteractionOptions(
                                                flags: InteractiveFlag.all,
                                              ),
                                            ),
                                            children: [
                                              TileLayer(
                                                tileProvider: CancellableNetworkTileProvider(),
                                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                userAgentPackageName: 'com.example.veloo',
                                              ),
                                              PolylineLayer(
                                                polylines: [
                                                  Polyline(
                                                    borderColor: Theme.of(context).colorScheme.tertiary,
                                                    borderStrokeWidth: 2.0,
                                                    color: Theme.of(context).colorScheme.onTertiary,
                                                    points: coordinates,
                                                    strokeWidth: 4.0,
                                                  ),
                                                ],
                                              ),
                                              MarkerLayer(
                                                markers: [
                                                  Marker(
                                                    height: 24.0,
                                                    point: coordinates.first,
                                                    width: 24.0,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Theme.of(context).colorScheme.tertiary,
                                                          width: 2.0,
                                                        ),
                                                        color: Theme.of(context).colorScheme.onTertiary,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        Icons.play_arrow_rounded,
                                                        color: Theme.of(context).colorScheme.tertiary,
                                                        size: 20.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Marker(
                                                    height: 24.0,
                                                    point: coordinates.last,
                                                    width: 24.0,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Theme.of(context).colorScheme.tertiary,
                                                          width: 2.0,
                                                        ),
                                                        color: Theme.of(context).colorScheme.onTertiary,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        Icons.stop_rounded,
                                                        color: Theme.of(context).colorScheme.tertiary,
                                                        size: 20.0,
                                                      ),
                                                    ),
                                                  ),
                                                  if (location != null)
                                                    Marker(
                                                      height: 24.0,
                                                      point: location!,
                                                      width: 24.0,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Theme.of(context).colorScheme.tertiary,
                                                            width: 2.0,
                                                          ),
                                                          color: Theme.of(context).colorScheme.onTertiary,
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Icon(
                                                          Icons.my_location_rounded,
                                                          color: Theme.of(context).colorScheme.tertiary,
                                                          size: 20.0,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              RichAttributionWidget(
                                                attributions: [
                                                  TextSourceAttribution(
                                                    translate(context, 'osm_contributors'),
                                                    onTap: () {
                                                      launchUrl(Uri.parse('https://openstreetmap.org/copyright'));
                                                    },
                                                    textStyle: TextStyle(
                                                      fontSize: 14.0,
                                                      overflow: TextOverflow.clip,
                                                    ),
                                                  ),
                                                ],
                                                popupBackgroundColor: Theme.of(context).colorScheme.surface,
                                                showFlutterMapAttribution: false,
                                              ),
                                              Scalebar(
                                                alignment: Alignment.bottomLeft,
                                                length: ScalebarLength.l,
                                              ),
                                            ],
                                          ),
                                          Positioned(
                                            left: 4.0,
                                            top: 4.0,
                                            child: IconButton(
                                              onPressed: () {
                                                controller.animatedFitCamera(
                                                  cameraFit: CameraFit.bounds(
                                                    bounds: LatLngBounds.fromPoints(coordinates),
                                                    padding: const EdgeInsets.all(16.0),
                                                  ),
                                                  rotation: 0.0,
                                                );
                                              },
                                              icon: Icon(Icons.center_focus_strong_rounded),
                                              tooltip: translate(context, 'center'),
                                            ),
                                          ),
                                          Positioned(
                                            right: 4.0,
                                            top: 4.0,
                                            child: Column(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.zoom_in),
                                                  onPressed: () {
                                                    controller.animatedZoomIn();
                                                  },
                                                  tooltip: translate(context, 'zoom_in'),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.zoom_out),
                                                  onPressed: () {
                                                    controller.animatedZoomOut();
                                                  },
                                                  tooltip: translate(context, 'zoom_out'),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.my_location),
                                                  onPressed: () {
                                                    getLocation();
                                                  },
                                                  tooltip: translate(context, 'my_location'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 32.0),
                              child: Center(
                                child: Text(
                                  translate(context, 'elevation_profile'),
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 16.0 / 8.0,
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: elevationProfile != null
                                      ? Image.memory(
                                        base64Decode(elevationProfile!),
                                        fit: BoxFit.fill,
                                      )
                                      : SizedBox.shrink(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 32.0),
                              child: Center(
                                child: Text(
                                  translate(context, 'statistics'),
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
                                            title: Text(
                                              translate(context, 'difficulty_index'),
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSecondary,
                                                fontSize: 16.0,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            trailing: Text(
                                              NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 2).format(statistics['difficulty_index']),
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
                            ),
                            Padding(
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
                                              Icons.straighten_rounded,
                                              color: Theme.of(context).colorScheme.onSecondary,
                                              size: 32.0,
                                            ),
                                            title: Text(
                                              translate(context, 'distance'),
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSecondary,
                                                fontSize: 16.0,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            trailing: Text(
                                              '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 2).format(statistics['distance']))} ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'km' : 'mi'}',
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
                                  Expanded(
                                    child: Card(
                                      child: SizedBox(
                                        height: 64.0,
                                        child: Center(
                                          child: ListTile(
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                            horizontalTitleGap: 16.0,
                                            leading: Icon(
                                              Icons.access_time_rounded,
                                              color: Theme.of(context).colorScheme.onSecondary,
                                              size: 32.0,
                                            ),
                                            title: Text(
                                              translate(context, 'estimated_time'),
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSecondary,
                                                fontSize: 16.0,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            trailing: Text(
                                              (statistics['estimated_time'] as double) >= 1
                                              ? '${(statistics['estimated_time'] as double).floor()}:${(((statistics['estimated_time'] as double) * 60) % 60).round().toString().padLeft(2, '0')} h'
                                              : '${((statistics['estimated_time'] as double) * 60).round()} min',
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
                            ),
                            Padding(
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
                                              Icons.height_rounded,
                                              color: Theme.of(context).colorScheme.onSecondary,
                                              size: 32.0,
                                            ),
                                            title: Text(
                                              translate(context, 'elevation'),
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSecondary,
                                                fontSize: 16.0,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            trailing: Text(
                                              '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 0).format(statistics['elevation']))} ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'm' : 'ft'}',
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
                                  Expanded(
                                    child: Card(
                                      child: SizedBox(
                                        height: 64.0,
                                        child: Center(
                                          child: ListTile(
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                            horizontalTitleGap: 16.0,
                                            leading: Icon(
                                              Icons.functions_rounded,
                                              color: Theme.of(context).colorScheme.onSecondary,
                                              size: 32.0,
                                            ),
                                            title: Text(
                                              '${translate(context, 'elevation')} / ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'km' : 'mi'}',
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSecondary,
                                                fontSize: 16.0,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            trailing: Text(
                                              '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 2).format(statistics['elevation_mean']))} ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'm' : 'ft'}',
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
                            ),
                            Padding(
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
                                              Icons.trending_up_rounded,
                                              color: Theme.of(context).colorScheme.onSecondary,
                                              size: 32.0,
                                            ),
                                            title: Text(
                                              translate(context, 'elevation_gain'),
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSecondary,
                                                fontSize: 16.0,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            trailing: Text(
                                              '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 0).format(statistics['elevation_gain']))} ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'm' : 'ft'}',
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
                                  Expanded(
                                    child: Card(
                                      child: SizedBox(
                                        height: 64.0,
                                        child: Center(
                                          child: ListTile(
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                            horizontalTitleGap: 16.0,
                                            leading: Icon(
                                              Icons.functions_rounded,
                                              color: Theme.of(context).colorScheme.onSecondary,
                                              size: 32.0,
                                            ),
                                            title: Text(
                                              '${translate(context, 'elevation_gain')} / ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'km' : 'mi'}',
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSecondary,
                                                fontSize: 16.0,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            trailing: Text(
                                              '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 2).format(statistics['elevation_gain_mean']))} ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'm' : 'ft'}',
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
                            ),
                            Padding(
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
                                              Icons.trending_down_rounded,
                                              color: Theme.of(context).colorScheme.onSecondary,
                                              size: 32.0,
                                            ),
                                            title: Text(
                                              translate(context, 'elevation_loss'),
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSecondary,
                                                fontSize: 16.0,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            trailing: Text(
                                              '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 0).format(statistics['elevation_loss']))} ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'm' : 'ft'}',
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
                                  Expanded(
                                    child: Card(
                                      child: SizedBox(
                                        height: 64.0,
                                        child: Center(
                                          child: ListTile(
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                            horizontalTitleGap: 16.0,
                                            leading: Icon(
                                              Icons.functions_rounded,
                                              color: Theme.of(context).colorScheme.onSecondary,
                                              size: 32.0,
                                            ),
                                            title: Text(
                                              '${translate(context, 'elevation_loss')} / ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'km' : 'mi'}',
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSecondary,
                                                fontSize: 16.0,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            trailing: Text(
                                              '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 2).format(statistics['elevation_loss_mean']))} ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'm' : 'ft'}',
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
                            ),
                            Padding(
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
                                              Icons.arrow_upward_rounded,
                                              color: Theme.of(context).colorScheme.onSecondary,
                                              size: 32.0,
                                            ),
                                            title: Text(
                                              translate(context, 'altitude_maximum'),
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSecondary,
                                                fontSize: 16.0,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            trailing: Text(
                                              '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 0).format(statistics['altitude_maximum']))} ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'm' : 'ft'}',
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
                                  Expanded(
                                    child: Card(
                                      child: SizedBox(
                                        height: 64.0,
                                        child: Center(
                                          child: ListTile(
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                            horizontalTitleGap: 16.0,
                                            leading: Icon(
                                              Icons.arrow_downward_rounded,
                                              color: Theme.of(context).colorScheme.onSecondary,
                                              size: 32.0,
                                            ),
                                            title: Text(
                                              translate(context, 'altitude_minimum'),
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSecondary,
                                                fontSize: 16.0,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            trailing: Text(
                                              '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 0).format(statistics['altitude_minimum']))} ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'm' : 'ft'}',
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
                            ),
                            Padding(
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
                                              Icons.terrain_rounded,
                                              color: Theme.of(context).colorScheme.onSecondary,
                                              size: 32.0,
                                            ),
                                            title: Text(
                                              translate(context, 'altitude_mean'),
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSecondary,
                                                fontSize: 16.0,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            trailing: Text(
                                              '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 2).format(statistics['altitude_mean']))} ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'm' : 'ft'}',
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
                                  Expanded(
                                    child: Card(
                                      child: SizedBox(
                                        height: 64.0,
                                        child: Center(
                                          child: ListTile(
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                            horizontalTitleGap: 16.0,
                                            leading: Icon(
                                              Icons.speed_rounded,
                                              color: Theme.of(context).colorScheme.onSecondary,
                                              size: 32.0,
                                            ),
                                            title: Text(
                                              translate(context, 'average_speed'),
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSecondary,
                                                fontSize: 16.0,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            trailing: Text(
                                              '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 0).format(statistics['average_speed']))} ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'km/h' : 'mph'}',
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
                            ),
                            climbs.isNotEmpty
                            ? Padding(
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
                            ) : SizedBox.shrink(),
                            Column(
                              children: climbs.map<Widget>((climb) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 32.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 32.0),
                                        child: AspectRatio(
                                          aspectRatio: 16.0 / 8.0,
                                            child: Card(
                                              clipBehavior: Clip.antiAlias,
                                              child: climb['profile'] != null
                                              ? Image.memory(
                                                  base64Decode(climb['profile']),
                                                  fit: BoxFit.fill,
                                                )
                                              : const SizedBox.shrink(),
                                            ),
                                        ),
                                      ),
                                      Padding(
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
                                                      title: Text(
                                                        translate(context, 'difficulty_index'),
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.onSecondary,
                                                          fontSize: 16.0,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                        NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 2).format(climb['statistics']['difficulty_index']),
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
                                      ),
                                      Padding(
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
                                                        Icons.location_pin,
                                                        color: Theme.of(context).colorScheme.onSecondary,
                                                        size: 32.0,
                                                      ),
                                                      title: Text(
                                                        translate(context, 'top'),
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.onSecondary,
                                                          fontSize: 16.0,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                        climb['statistics']['nearby'],
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
                                            Expanded(
                                              child: Card(
                                                child: SizedBox(
                                                  height: 64.0,
                                                  child: Center(
                                                    child: ListTile(
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                      horizontalTitleGap: 16.0,
                                                      leading: Icon(
                                                        Icons.straighten_rounded,
                                                        color: Theme.of(context).colorScheme.onSecondary,
                                                        size: 32.0,
                                                      ),
                                                      title: Text(
                                                        translate(context, 'distance'),
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.onSecondary,
                                                          fontSize: 16.0,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                        '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 2).format(climb['statistics']['distance']))} ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'km' : 'mi'}',
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
                                      ),
                                      Padding(
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
                                                        Icons.near_me_rounded,
                                                        color: Theme.of(context).colorScheme.onSecondary,
                                                        size: 32.0,
                                                      ),
                                                      title: Text(
                                                        translate(context, 'gradient_mean'),
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.onSecondary,
                                                          fontSize: 16.0,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                        '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 1).format(climb['statistics']['gradient_mean']))} %',
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
                                            Expanded(
                                              child: Card(
                                                child: SizedBox(
                                                  height: 64.0,
                                                  child: Center(
                                                    child: ListTile(
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                      horizontalTitleGap: 16.0,
                                                      leading: Icon(
                                                        Icons.call_made_rounded,
                                                        color: Theme.of(context).colorScheme.onSecondary,
                                                        size: 32.0,
                                                      ),
                                                      title: Text(
                                                        translate(context, 'gradient_mean_positive'),
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.onSecondary,
                                                          fontSize: 16.0,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                        '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 1).format(climb['statistics']['gradient_mean_positive']))} %',
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
                                      ),
                                      Padding(
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
                                                        Icons.warning_amber_rounded,
                                                        color: Theme.of(context).colorScheme.onSecondary,
                                                        size: 32.0,
                                                      ),
                                                      title: Text(
                                                        translate(context, 'gradient_maximum'),
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.onSecondary,
                                                          fontSize: 16.0,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                        '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 1).format(climb['statistics']['gradient_maximum']))} %',
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
                                            Expanded(
                                              child: Card(
                                                child: SizedBox(
                                                  height: 64.0,
                                                  child: Center(
                                                    child: ListTile(
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                      horizontalTitleGap: 16.0,
                                                      leading: Icon(
                                                        Icons.height_rounded,
                                                        color: Theme.of(context).colorScheme.onSecondary,
                                                        size: 32.0,
                                                      ),
                                                      title: Text(
                                                        translate(context, 'elevation'),
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.onSecondary,
                                                          fontSize: 16.0,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                        '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 0).format(climb['statistics']['elevation']))} ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'm' : 'ft'}',
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
                                      ),
                                      Padding(
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
                                                        Icons.functions_rounded,
                                                        color: Theme.of(context).colorScheme.onSecondary,
                                                        size: 32.0,
                                                      ),
                                                      title: Text(
                                                        '${translate(context, 'elevation')} / ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'km' : 'mi'}',
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.onSecondary,
                                                          fontSize: 16.0,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                        '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 2).format(climb['statistics']['elevation_mean']))} ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'm' : 'ft'}',
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
                                            Expanded(
                                              child: Card(
                                                child: SizedBox(
                                                  height: 64.0,
                                                  child: Center(
                                                    child: ListTile(
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                      horizontalTitleGap: 16.0,
                                                      leading: Icon(
                                                        Icons.trending_up_rounded,
                                                        color: Theme.of(context).colorScheme.onSecondary,
                                                        size: 32.0,
                                                      ),
                                                      title: Text(
                                                        translate(context, 'elevation_gain'),
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.onSecondary,
                                                          fontSize: 16.0,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                        '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 0).format(climb['statistics']['elevation_gain']))} ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'm' : 'ft'}',
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
                                      ),
                                      Padding(
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
                                                        Icons.functions_rounded,
                                                        color: Theme.of(context).colorScheme.onSecondary,
                                                        size: 32.0,
                                                      ),
                                                      title: Text(
                                                        '${translate(context, 'elevation_gain')} / ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'km' : 'mi'}',
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.onSecondary,
                                                          fontSize: 16.0,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                        '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 2).format(climb['statistics']['elevation_gain_mean']))} ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'm' : 'ft'}',
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
                                            Expanded(
                                              child: Card(
                                                child: SizedBox(
                                                  height: 64.0,
                                                  child: Center(
                                                    child: ListTile(
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                      horizontalTitleGap: 16.0,
                                                      leading: Icon(
                                                        Icons.trending_down_rounded,
                                                        color: Theme.of(context).colorScheme.onSecondary,
                                                        size: 32.0,
                                                      ),
                                                      title: Text(
                                                        translate(context, 'elevation_loss'),
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.onSecondary,
                                                          fontSize: 16.0,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                        '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 0).format(climb['statistics']['elevation_loss']))} ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'm' : 'ft'}',
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
                                      ),
                                      Padding(
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
                                                        Icons.functions_rounded,
                                                        color: Theme.of(context).colorScheme.onSecondary,
                                                        size: 32.0,
                                                      ),
                                                      title: Text(
                                                        '${translate(context, 'elevation_loss')} / ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'km' : 'mi'}',
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.onSecondary,
                                                          fontSize: 16.0,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                        '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 2).format(climb['statistics']['elevation_loss_mean']))} ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'm' : 'ft'}',
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
                                            Expanded(
                                              child: Card(
                                                child: SizedBox(
                                                  height: 64.0,
                                                  child: Center(
                                                    child: ListTile(
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                      horizontalTitleGap: 16.0,
                                                      leading: Icon(
                                                        Icons.arrow_upward_rounded,
                                                        color: Theme.of(context).colorScheme.onSecondary,
                                                        size: 32.0,
                                                      ),
                                                      title: Text(
                                                        translate(context, 'altitude_maximum'),
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.onSecondary,
                                                          fontSize: 16.0,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                        '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 0).format(climb['statistics']['altitude_maximum']))} ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'm' : 'ft'}',
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
                                      ),
                                      Padding(
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
                                                        Icons.arrow_downward_rounded,
                                                        color: Theme.of(context).colorScheme.onSecondary,
                                                        size: 32.0,
                                                      ),
                                                      title: Text(
                                                        translate(context, 'altitude_minimum'),
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.onSecondary,
                                                          fontSize: 16.0,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                        '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 0).format(climb['statistics']['altitude_minimum']))} ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'm' : 'ft'}',
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
                                            Expanded(
                                              child: Card(
                                                child: SizedBox(
                                                  height: 64.0,
                                                  child: Center(
                                                    child: ListTile(
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                      horizontalTitleGap: 16.0,
                                                      leading: Icon(
                                                        Icons.landscape_rounded,
                                                        color: Theme.of(context).colorScheme.onSecondary,
                                                        size: 32.0,
                                                      ),
                                                      title: Text(
                                                        translate(context, 'altitude_mean'),
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.onSecondary,
                                                          fontSize: 16.0,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                        '${(NumberFormat.decimalPatternDigits(locale: Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode, decimalDigits: 2).format(climb['statistics']['altitude_mean']))} ${Provider.of<UnitsProvider>(context, listen: false).unitsData.name == 'metric' ? 'm' : 'ft'}',
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
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 32.0),
                              child: Center(
                                child: Text(
                                  translate(context, 'actions'),
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
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    FilledButton(
                                      onPressed: () async {
                                        final save = await showDialog<bool>(
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
                                                        Theme.of(context).colorScheme.tertiary,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      translate(context, 'save'),
                                                      style: TextStyle(
                                                        color: Theme.of(context).colorScheme.onTertiary,
                                                        fontSize: 14.0,
                                                        overflow: TextOverflow.clip,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                actionsAlignment: MainAxisAlignment.center,
                                                content: Text(
                                                  translate(context, 'save_trip_analysis'),
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
                                                  translate(context, 'confirm'),
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
                                        if (save == true && context.mounted) {
                                          saveAnalysis();
                                        }
                                      },
                                      child: Text(
                                        translate(context, 'save_analysis'),
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ),
                                    FilledButton(
                                      onPressed: () async {
                                        final delete = await showDialog<bool>(
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
                                                      translate(context, 'delete'),
                                                      style: TextStyle(
                                                        color: Theme.of(context).colorScheme.onError,
                                                        fontSize: 14.0,
                                                        overflow: TextOverflow.clip,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                actionsAlignment: MainAxisAlignment.center,
                                                content: Text(
                                                  translate(context, 'delete_trip_analysis'),
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
                                        if (delete == true && context.mounted) {
                                          Provider.of<TripProvider>(context, listen: false).setFile(null);
                                          Provider.of<TripProvider>(context, listen: false).setTrip(null);
                                          Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation, secondaryAnimation) =>
                                                CurrentPage(index: 0),
                                              reverseTransitionDuration: Duration.zero,
                                              transitionDuration: Duration.zero,
                                            ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        translate(context, 'delete_analysis'),
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          overflow: TextOverflow.clip,
                                        ),
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
