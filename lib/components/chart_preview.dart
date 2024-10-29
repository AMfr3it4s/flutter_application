import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application/models/heart_rate.dart';
import 'package:flutter_application/utils/db_helper.dart';


class ChartDialogContent extends StatefulWidget {
  final int recordId; 

  const ChartDialogContent({super.key, required this.recordId});

  @override
  _ChartDialogContentState createState() => _ChartDialogContentState();
}

class _ChartDialogContentState extends State<ChartDialogContent> {
  HeartRateRecord? record; 
  bool isLoading = true; 

  @override
  void initState() {
    super.initState();
    _fetchRecordData(); 
  }

  //Fetch Data from DB
  Future<void> _fetchRecordData() async {
  final dbHelper = DatabaseHelper();
  final fetchedRecord = await dbHelper.getHeartRateById(widget.recordId);
  setState(() {
    record = fetchedRecord;
    isLoading = false;
  });
}


  //UI Design
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator()); 
    }

    if (record == null || record!.dataPoints.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('No data available for this record.'),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(47, 62, 70, 1),
        borderRadius: BorderRadius.circular(16),
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 400,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            '${record!.bpm} BPM',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            'Measured on ${_formatDateTime(record!.dateTime)}',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: record!.dataPoints.map((e) {
                      final xValue = e.time
                          .difference(record!.dataPoints.first.time)
                          .inSeconds
                          .toDouble();
                      final yValue = e.value;
                      return FlSpot(xValue, yValue);
                    }).toList(),
                    isCurved: true,
                    color: Color.fromRGBO(249, 110, 70, 1),
                    barWidth: 2,
                    dotData: FlDotData(show: false),
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    axisNameWidget: const Text('Time (seconds)', style: TextStyle(color: Colors.white),),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: const Text('BPM', style: TextStyle(color: Colors.white),),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: TextStyle(fontSize: 12,color: Colors.white),
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
                minY: record!.dataPoints
                    .map((e) => e.value)
                    .reduce((a, b) => a < b ? a : b),
                maxY: record!.dataPoints
                    .map((e) => e.value)
                    .reduce((a, b) => a > b ? a : b),
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); 
            },style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(249, 110, 70, 1)
            ),
            child: Text('Close', style: TextStyle(
              color: Colors.white
            ),),
          ),
        ],
      ),
    );
  }

  //Format Date Time
  String _formatDateTime(DateTime dateTime) {
    final date =
        '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    final time =
        '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$date at $time';
  }
}
