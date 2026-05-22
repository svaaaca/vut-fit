//
// @file import.dart
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief Source code of the desktop import page implementation.
// @date 2025-05-14
//

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:veloo/localization/translation.dart';
import 'package:veloo/page/current.dart';
import 'package:veloo/provider/provider.dart';

class ImportPageDesktopLayout extends StatefulWidget {
  final int selectedIndex;

  const ImportPageDesktopLayout({super.key, required this.selectedIndex});

  @override
  State<ImportPageDesktopLayout> createState() => _ImportPageDesktopLayoutState();
}

class _ImportPageDesktopLayoutState extends State<ImportPageDesktopLayout> {
  DropzoneViewController? dropzone;

  Future<void> selectFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['fit', 'gpx', 'kml', 'tcx'],
      type: FileType.custom,
      withData: true,
    );
    if (result != null && context.mounted) {
      Provider.of<TripProvider>(context, listen: false).setFile(result.files.first);
    }
  }

  Future<void> generateAnalysis(BuildContext context) async {
    if (Provider.of<TripProvider>(context, listen: false).fileData != null) {
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
                content: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 24.0,
                    children: [
                      Text(
                        translate(context, 'generating'),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 24.0,
                          overflow: TextOverflow.clip,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Transform.scale(
                        scale: 1.4,
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(
                    color: Theme.of(context).indicatorColor,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          );
        },
        context: context,
      );
      // final url = Uri.parse('https://svaaaca.pythonanywhere.com/fastapi/analyse');
      final url = Uri.parse('http://127.0.0.1:8000/fastapi/analyse');
      final request = http.MultipartRequest('POST', url);
      request.fields['average_speed'] = Provider.of<TripProvider>(context, listen: false).averageSpeedData.toString();
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          Provider.of<TripProvider>(context, listen: false).fileData!.bytes!,
          filename: basename(Provider.of<TripProvider>(context, listen: false).fileData!.name),
        ),
      );
      request.fields['level'] = Provider.of<TripProvider>(context, listen: false).levelData.name;
      request.fields['locale'] = Platform.localeName;
      request.fields['units'] = Provider.of<UnitsProvider>(context, listen: false).unitsData.name;
      final response = await request.send();
      if (response.statusCode == 200) {
        final trip = await response.stream.bytesToString();
        if (context.mounted) {
          Navigator.of(context).pop();
          Provider.of<TripProvider>(context, listen: false).setTrip(trip);
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                CurrentPage(index: 1),
              reverseTransitionDuration: Duration.zero,
              transitionDuration: Duration.zero,
            ),
          );
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
                      translate(context, 'generation_success'),
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
      else {
        if (context.mounted) {
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
                      translate(context, 'upload_error'),
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
                      translate(context, 'error'),
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
    }
    else {
      if (context.mounted) {
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
                    translate(context, 'upload_missing'),
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
                    translate(context, 'error'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(context, 'import_file'),
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
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 32.0),
                              child: Center(
                                child: Text(
                                  translate(context, 'browse_files'),
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
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: DropzoneView(
                                        onCreated: (controller) => dropzone = controller,
                                        onDropFile: (drop) async {
                                          final bytes = await dropzone!.getFileData(drop);
                                          final name = await dropzone!.getFilename(drop);
                                          if (context.mounted) {
                                            Provider.of<TripProvider>(context, listen: false).setFile(
                                              PlatformFile(
                                                bytes: bytes,
                                                name: name,
                                                size: bytes.length,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 32.0,
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.cloud_upload,
                                              size: 32.0,
                                              color: Theme.of(context).colorScheme.onSecondary,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 32.0,
                                                top: 8.0,
                                              ),
                                              child: Text(
                                                translate(context, 'drop_file'),
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.onSecondary,
                                                  fontSize: 16.0,
                                                  overflow: TextOverflow.clip,
                                                ),
                                              ),
                                            ),
                                            FilledButton(
                                              onPressed: () {
                                                selectFile(context);
                                              },
                                              child: Text(
                                                translate(context, 'choose_file'),
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  overflow: TextOverflow.clip,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 32.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 16.0,
                                children: [
                                  FloatingActionButton.extended(
                                    icon: const Icon(Icons.upload),
                                    label: Text(
                                      translate(context, 'generate_analysis'),
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                    onPressed: () {
                                      generateAnalysis(context);
                                    },
                                  ),
                                  Text(
                                    Provider.of<TripProvider>(context).fileData != null
                                    ? Provider.of<TripProvider>(context).fileData!.name
                                    : translate(context, 'no_file_chosen'),
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSecondary,
                                      fontSize: 16.0,
                                      fontWeight: Provider.of<TripProvider>(context).fileData != null ? FontWeight.bold : null,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 1.0,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        heroTag: 'desktop',
        onPressed: () {
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
                      translate(context, 'import_help'),
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
                      translate(context, 'help'),
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
        },
        child: const Icon(Icons.info_outlined),
      ),
    );
  }
}
