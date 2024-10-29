import 'package:flutter/material.dart';
import 'package:flutter_application/models/heart_rate.dart';
import 'package:flutter_application/utils/db_helper.dart';
import '../components/chart_preview.dart';

class HistoryPage extends StatefulWidget {
  final List<HeartRateRecord> history;
  final Function(int) onDelete;

  const HistoryPage({super.key, required this.history, required this.onDelete});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late List<HeartRateRecord> _history = []; 

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final dbHelper = DatabaseHelper();
    try {
      final records = await dbHelper.getHeartRateHistory();
      setState(() {
        _history = records;
      });
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 235, 206, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(239, 235, 206, 1),
        title: const Text('History'),
      ),
      body: ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final record = _history[index];
          return Card(
            color: const Color.fromRGBO(47, 62, 70, 1),
            child: ListTile(
              leading: const Icon(Icons.favorite, color: Color.fromRGBO(249, 110, 70, 1)),
              title: Text('${record.bpm} BPM', style: TextStyle(color: Colors.white)),
              subtitle: Text(
                _formatDateTime(record.dateTime),
                style: TextStyle(color: Colors.white),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.white),
                onPressed: () {
                  _deleteRecord(index);
                },
              ),
              onTap: () {
                _showChartDialog(context, record);
              },
            ),
          );
        },
      ),
    );
  }

  void _deleteRecord(int index) async {
    final dbHelper = DatabaseHelper();
    final recordId = _history[index].id; 
    if (recordId != null) { 
      await dbHelper.deleteHeartRate(recordId);
      setState(() {
        _history.removeAt(index);
        widget.onDelete(index);
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    final time = '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$date at $time';
  }

  void _showChartDialog(BuildContext context, HeartRateRecord record) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ChartDialogContent(recordId: record.id!), 
        );
      },
    );
  }
}
