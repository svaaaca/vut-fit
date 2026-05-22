//
// @file provider.dart
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief Source code of the trip and units providers implementation.
// @date 2025-05-14
//

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class TripProvider with ChangeNotifier {
  int _averageSpeedData = 20;
  PlatformFile? _fileData;
  Level _levelData = Level.easy;
  String? _tripData;

  int get averageSpeedData => _averageSpeedData;
  PlatformFile? get fileData => _fileData;
  Level get levelData => _levelData;
  String? get tripData => _tripData;

  set speed(int averageSpeedData) {
    _averageSpeedData = averageSpeedData;
    notifyListeners();
  }

  set file(PlatformFile? fileData) {
    _fileData = fileData;
    notifyListeners();
  }

  set level(Level levelData) {
    _levelData = levelData;
    notifyListeners();
  }

  set trip(String? tripData) {
    _tripData = tripData;
    notifyListeners();
  }

  void setImperial() {
    _averageSpeedData = (_averageSpeedData * 0.6213711922373).round();
    notifyListeners();
  }

  void setMetric() {
    _averageSpeedData = (_averageSpeedData * 1.609344).round();
    notifyListeners();
  }

  void setSpeed(int averageSpeedData) {
    _averageSpeedData = averageSpeedData;
    notifyListeners();
  }

  void setFile(PlatformFile? fileData) {
    _fileData = fileData;
    notifyListeners();
  }

  void setLevel(Level levelData) {
    _levelData = levelData;
    notifyListeners();
  }

  void setTrip(String? tripData) {
    _tripData = tripData;
    notifyListeners();
  }
}

class UnitsProvider with ChangeNotifier {
  Units _unitsData = Units.metric;

  Units get unitsData => _unitsData;

  set units(Units unitsData) {
    _unitsData = unitsData;
    notifyListeners();
  }

  void setUnits(Units unitsData) {
    _unitsData = unitsData;
    notifyListeners();
  }
}

enum Level {
  difficult,
  easy,
  medium,
}

enum Units {
  imperial,
  metric,
}
