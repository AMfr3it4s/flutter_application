import 'package:flutter_application/utils/db_helper.dart';
import 'package:geolocator/geolocator.dart';

class StepCounterService {
  final dbHelper = DatabaseHelper();
  static final StepCounterService _instance = StepCounterService._internal();
  factory StepCounterService() => _instance;
  StepCounterService._internal();

  double totalDistance = 0.0;
  int stepCount = 0;
  double stepLength = 0.78;
  Position? lastPosition;

  // Initialize Geolocator with permission check
  Future<void> initialize() async {
    bool hasPermission = await _checkLocationPermission();
    if (hasPermission) {
      _initializeGeolocator();
    }
  }

  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      // You can show a message to the user if needed.
      return false;
    }
    return true;
  }

  void _initializeGeolocator() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.requestPermission();
    }

    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),
    ).listen((Position position) {
      _calculateSteps(position);
    });
  }

  void _calculateSteps(Position position) async {
    if (lastPosition != null) {
      double distance = Geolocator.distanceBetween(
        lastPosition!.latitude,
        lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );
      if (distance > 4) {
        totalDistance += distance;

        int newStepCount = (totalDistance / stepLength).floor();

        if (newStepCount > stepCount) {
          stepCount = newStepCount;
          await _addSteps(stepCount);
        }
      }
    }
    lastPosition = position;
  }

  Future<void> _addSteps(int stepCount) async {
    await dbHelper.insertOrUpdateStep(stepCount);
  }
}
