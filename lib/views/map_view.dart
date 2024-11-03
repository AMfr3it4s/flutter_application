import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class MapsView extends StatefulWidget {
  const MapsView({super.key});

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  LatLng? _currentLocation;
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _checkPermissions(); 
  }

  Future<void> _checkPermissions() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      _getLocation();
      _listenLocationChanges();
    } else if (status.isDenied) {
      // ASk Permission
      var result = await Permission.location.request();
      if (result.isGranted) {
        _getLocation();
        _listenLocationChanges();
      } 
    } 
  }

  void _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    _mapController.move(_currentLocation!, 15);
  }

  void _listenLocationChanges() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),
    ).listen((Position position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_currentLocation!, 15);
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 235, 206, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(239, 235, 206, 1),
        title: Center(
    child: Text(
      'World Map',
      style: TextStyle(
        color: Colors.black, 
        fontSize: 30, 
        fontWeight: FontWeight.bold, 
      ),
    ),
  ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentLocation ?? LatLng(40.6412, -8.65362),
                initialZoom: 15,
                maxZoom: 20,
                minZoom: 10,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                const MapCompass.cupertino(
                  hideIfRotatedNorth: true,
                ),
                if (_currentLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentLocation!,
                        width: 80,
                        height: 80,
                        child: Icon(
                          Icons.location_on_rounded,
                          color: const Color.fromRGBO(249, 110, 70, 1),
                          size: 40,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
