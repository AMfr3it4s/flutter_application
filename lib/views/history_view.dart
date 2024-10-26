import 'package:flutter/material.dart';
import '../models/heartRate.dart';
import '../components/chart_preview.dart';

class HistoryPage extends StatefulWidget {
  final List<HeartRateRecord> history;
  final Function(int) onDelete;

  const HistoryPage({super.key, required this.history, required this.onDelete});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late List<HeartRateRecord> _history;

  @override
  void initState() {
    super.initState();
    // Make a copy of the history to allow modifications
    _history = List<HeartRateRecord>.from(widget.history);
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
            child: ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red),
              title: Text('${record.bpm} BPM'),
              subtitle: Text(
                _formatDateTime(record.dateTime),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _deleteRecord(index);
                },
              ),
              onTap: () {
                // Optional: Navigate to a detailed view if desired
                _showChartDialog(context, record);
              },
            ),
          );
        },
      ),
    );
  }

  void _deleteRecord(int index) {
    setState(() {
      widget.onDelete(index);
      _history.removeAt(index);
    });
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
          child: ChartDialogContent(record: record),
        );
      },
    );
  }
}
