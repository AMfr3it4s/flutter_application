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
  int stepsToSave = 50; 

  final db = DatabaseHelper();

  //Initialize Geolocator if has permissions
  Future<void> initialize() async {
    bool hasPermission = await _checkLocationPermission();
    if (hasPermission) {
      _initializeGeolocator();
    }
  }
  //Check if user concibed  to share location data
  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }
  //Initialize Geolocator
  void _initializeGeolocator() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.requestPermission();
    }

    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        //5
        distanceFilter: 1, 
      ),
    ).listen((Position position) {
      _calculateSteps(position);
    });
  }
  //Calculate Spets based on Position
  void _calculateSteps(Position position) async {
    if (lastPosition != null) {
      double distance = Geolocator.distanceBetween(
        lastPosition!.latitude,
        lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );

      // Filter minimum  distance to avoid counting small movements as steps
      //8
      if (distance > 4) {
        totalDistance += distance;

        int newStepCount = (totalDistance / stepLength).floor();

        if (newStepCount > stepCount) {
          stepCount = newStepCount;

          // Save in DB on each int number
          if (stepCount % stepsToSave == 0) {
            await db.insertOrUpdateStep(stepCount);
          }
        }
      }
    }
    lastPosition = position;
  }
  
}
