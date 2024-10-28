import 'dart:convert'; // Necessário para jsonDecode
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

  // Método para converter um Map em um HeartRateRecord
  factory HeartRateRecord.fromMap(Map<String, dynamic> map) {
    // Verifica se `points` é uma string e, se for, decodifica para uma lista
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
