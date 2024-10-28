import 'dart:convert'; 
import 'package:flutter_application/models/sensor.dart';

class HeartRateRecord {
  final int? id;
  final int bpm;
  final DateTime dateTime;
  final List<SensorValue> dataPoints;

  HeartRateRecord({
    this.id,
    required this.bpm,
    required this.dateTime,
    required this.dataPoints,
  });

  // Method that converts object in a list
  factory HeartRateRecord.fromMap(Map<String, dynamic> map) {
    // Json Decode verify if it's a string or not
    final points = map['points'];
    final List<dynamic> pointsList = points is String ? jsonDecode(points) : points;

    return HeartRateRecord(
      id: map['id'] as int?,
      bpm: map['bpm'] as int,
      dateTime: DateTime.parse(map['dateTime'] as String),
      dataPoints: pointsList
          .map((point) => SensorValue.fromMap(point as Map<String, dynamic>))
          .toList(),
    );
  }
}
