import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/heartRate.dart'; // Contains the HeartRateRecord class definition

class ChartDialogContent extends StatelessWidget {
  final HeartRateRecord record;

  const ChartDialogContent({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (record.dataPoints.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('No data available for this record.'),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 400,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            '${record.bpm} BPM',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Measured on ${_formatDateTime(record.dateTime)}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: record.dataPoints.map((e) {
                      final xValue = e.time
                          .difference(record.dataPoints.first.time)
                          .inSeconds
                          .toDouble();
                      final yValue = e.value;
                      return FlSpot(xValue, yValue);
                    }).toList(),
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 2,
                    dotData: FlDotData(show: false),
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    axisNameWidget: const Text('Time (seconds)'),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: const Text('BPM'),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: TextStyle(fontSize: 12),
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
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                minY: record.dataPoints
                    .map((e) => e.value)
                    .reduce((a, b) => a < b ? a : b),
                maxY: record.dataPoints
                    .map((e) => e.value)
                    .reduce((a, b) => a > b ? a : b),
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final date =
        '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    final time =
        '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$date at $time';
  }
}
