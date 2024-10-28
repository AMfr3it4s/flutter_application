class SensorValue {
  final DateTime time;
  final double value;

  SensorValue({required this.time, required this.value});

  factory SensorValue.fromMap(Map<String, dynamic> map) {
    return SensorValue(
      time: DateTime.parse(map['time'] as String),
      value: map['value'] as double,
    );
  }
}
