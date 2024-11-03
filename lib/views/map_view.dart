import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application/utils/db_helper.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart'; 
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class MapsView extends StatefulWidget {
  const MapsView({super.key});

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  LatLng? _currentLocation;
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionStreamSubscription;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _waypoints = [];
  final ImagePicker _picker = ImagePicker(); 
  File? _imageFile; 
  List<LatLng> _routePoints = [];
  final double zoom = 15; 

  @override
  void initState() {
    super.initState();
    _checkPermissions(); 
    _fetchWaypoints(); 
  }

  // Permissions for Location
  Future<void> _checkPermissions() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      _getLocation();
      _listenLocationChanges();
    } else if (status.isDenied) {
      var result = await Permission.location.request();
      if (result.isGranted) {
        _getLocation();
        _listenLocationChanges();
      } 
    } 
  }

  // Get Geolocator Location
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
    _mapController.move(_currentLocation!, zoom);
  }

  // Get Waypoints
  void _fetchWaypoints() async {
    final waypoints = await _databaseHelper.fetchWaypoints();
    setState(() {
      _waypoints = waypoints;
    });
  }

  // Add waypoints and fetch after added
  void _addWaypoint(LatLng position, String label, String imagePath) async {
    Map<String, dynamic> waypoint = {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'label': label,
      'imagePath': imagePath,
    };

    await _databaseHelper.insertWaypoint(waypoint);
    _fetchWaypoints(); 
  }

  // Continuous listening for location changes
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
      _mapController.move(_currentLocation!, zoom);
    });
  }

  // Show Waypoint Details
  Future<void> _showWaypointDetails(Map<String, dynamic> waypoint) async {
    final waypointLocation = LatLng(waypoint['latitude'], waypoint['longitude']);
    final currentLocation = _currentLocation;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(47, 62, 70, 1),
          title: Text(waypoint['label'], style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (waypoint['imagePath'] != null && waypoint['imagePath'].isNotEmpty)
                Image.file(
                  File(waypoint['imagePath']),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
            ],
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromRGBO(249, 110, 70, 1)
                ),
                onPressed: () async {
                  if (currentLocation != null) {
                    _routePoints = await _calculateRoute(currentLocation, waypointLocation);
                    setState(() {});
                  }
                  Navigator.of(context).pop();
                },
                child: Text('Directions', style: TextStyle(color: Colors.white)),
              ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.2)
                    ),
                    onPressed: () async{
                       await _databaseHelper.deleteWaypoint(waypoint['id']); 
                        _fetchWaypoints(); 
                        Navigator.of(context).pop(); 
                    },
                    child: Text('Delete', style: TextStyle(color: Colors.white)),
                  ),SizedBox(width: 20),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.2)
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  
                ],
              ),
            ),
            
          ],
        );
      },
    );
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
            'Location Map',
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
                onTap: (tapPosition, point) {
                  _showAddWaypointDialog(point); 
                },
                initialCenter: _currentLocation ?? LatLng(40.6412, -8.65362),
                initialZoom: 15,
                maxZoom: 20,
                minZoom: 10,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.flutter_application',
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
                    ] + _waypoints.map((waypoint) {
                      return Marker(
                        point: LatLng(waypoint['latitude'], waypoint['longitude']),
                        width: 80,
                        height: 80,
                        child: GestureDetector(
                          onTap: () => _showWaypointDetails(waypoint), 
                          child: Column(
                            children: [
                              Icon(Icons.location_on, color: Colors.blue, size: 40),
                              if (waypoint['label'] != null)
                                Text(
                                  waypoint['label'],
                                  style: TextStyle(color: Colors.black),
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                   if (_routePoints.isNotEmpty)
                    PolylineLayer(
                    polylines: [
                    Polyline(
                      points: _routePoints,
                      color: const Color.fromRGBO(249, 110, 70, 1),
                      strokeWidth: 4,
                    ),
                  ],
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Add Waypoints when clicked
  Future<void> _showAddWaypointDialog(LatLng position) async {
    String label = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(47, 62, 70, 1),
          title: Text('New Waypoint', style: TextStyle(
            color: Colors.white
          )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => label = value,
                decoration: InputDecoration(hintText: 'Introduce a Title here', hintStyle: TextStyle(
                  color: Colors.white
                ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              // Take Picture
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:Colors.black.withAlpha(150)
                ),
                onPressed: () async {
                  final pickedFile = await _picker.pickImage(
                    source: ImageSource.camera, 
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _imageFile = File(pickedFile.path);
                    });
                  }
                },
                child: Text('Take a Picture', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromRGBO(249, 110, 70, 1),
              ),
              onPressed: () {
                if (label.isNotEmpty && _imageFile != null) {
                  _addWaypoint(position, label, _imageFile!.path);
                } else if (label.isNotEmpty) {
                  _addWaypoint(position, label, '');
                }
                Navigator.of(context).pop();
              },
              child: Text('Save', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.3),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

}

//Calculate Route Line Based on API
Future<List<LatLng>> _calculateRoute(LatLng start, LatLng end) async {
  final String apiKey = '5b3ce3597851110001cf6248107cd2f9bbdc45a08b952ffd1f8d9ea2'; 
  final String url =
      'https://api.openrouteservice.org/v2/directions/driving-car?start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}';

  final response = await http.get(Uri.parse(url), headers: {
    'Authorization': apiKey,
    'Content-Type': 'application/json'
  });

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final coordinates = data['features'][0]['geometry']['coordinates'] as List;
    return coordinates
        .map((coord) => LatLng(coord[1], coord[0]))
        .toList();
  } else {
    throw Exception('Failed to load route');
  }
}