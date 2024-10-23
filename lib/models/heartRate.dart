import 'sensor.dart';

class HeartRateRecord {
  final int bpm;
  final DateTime dateTime;
  final List<SensorValue> dataPoints;

  HeartRateRecord({
    required this.bpm,
    required this.dateTime,
    required this.dataPoints,
  });
}
