import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this package for date formatting.

import '../models/sensor.dart';

class ChartComp extends StatelessWidget {
  final List<SensorValue> allData;

  const ChartComp({super.key, required this.allData});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: allData.map((e) => FlSpot(e.time.millisecondsSinceEpoch.toDouble(), e.value)).toList(),
            isCurved: false,
            color: Colors.red,
            barWidth: 2,
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            axisNameWidget: const Text('Time', style: TextStyle(fontSize: 12)),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              interval: _calculateInterval(), // Dynamically calculate the interval
              getTitlesWidget: (value, meta) {
                // Format the timestamp value to display time.
                DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return Text(
                  DateFormat('HH:mm:ss').format(date), // Format time as needed.
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            axisNameWidget: const Text('BPM', style: TextStyle(fontSize: 12)),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: true),
      ),
    );
  }

  double _calculateInterval() {
    // Calculate the interval based on the time range in the data
    double minTimestamp = allData.first.time.millisecondsSinceEpoch.toDouble();
    double maxTimestamp = allData.last.time.millisecondsSinceEpoch.toDouble();
    double timeRange = maxTimestamp - minTimestamp;

    // Define intervals based on the range (e.g., every 10 minutes, every hour, etc.)
    if (timeRange > 3600000) { // More than 1 hour
      return 3600000; // 1-hour intervals
    } else if (timeRange > 600000) { // More than 10 minutes
      return 600000; // 10-minute intervals
    } else if (timeRange > 60000) { // More than 1 minute
      return 60000; // 1-minute intervals
    } else {
      return 10000; // 10-second intervals for shorter ranges
    }
  }
}
