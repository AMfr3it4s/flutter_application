import 'package:flutter/material.dart';
import 'package:flutter_application/utils/db_helper.dart';
import 'package:flutter_application/widgets/custom_card_home.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  final dbHelper = DatabaseHelper();
  String todayStepCount = "0";
  String lastBpm = "0";
  int totalWaterIntake = 0;

  //Fetch Spets
   Future<void> _fetchTodaySteps() async {
    List<Map<String, dynamic>> steps = await dbHelper.getStepsByDate(DateTime.now());
    
    if (steps.isNotEmpty) {
      int count = steps.first['stepCount'];
      setState(() {
        todayStepCount = count.toString();
        });
    }
  }
  //Fetch  BPM
  Future<void> _fetchLastBpm() async{
    final dbHelper = DatabaseHelper();
    int? bpm = await dbHelper.getLastBpm();
    setState(() {
      lastBpm = bpm?.toString() ?? "0"; 
    });
  }
  //Fetch Water
  Future<void> _fetchTotalWaterIntake() async {
  final db = await DatabaseHelper().database;
  final List<Map<String, dynamic>> results = await db.query(
    'water_intake',
    where: 'data = ?', // Corrigido o campo para 'data' para que seja consistente
    whereArgs: [DateTime.now().toIso8601String().substring(0, 10)], // Formato de data YYYY-MM-DD
  );

  if (results.isEmpty) {
    setState(() {
      totalWaterIntake = 0;
    });
  } else {
    setState(() {
      totalWaterIntake = results.fold<int>(0, (sum, row) => sum + row['quantity'] as int);
    });
  }
}

  @override
  void initState() {
    super.initState();
    _fetchTodaySteps();
    _fetchLastBpm();
    _fetchTotalWaterIntake();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        color: const Color.fromRGBO(239, 235, 206, 1),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              CustomCardHome(title: "Today's Total Steps ", value: todayStepCount, unit: "Steps", icon: Icons.local_fire_department),
              CustomCardHome(title: "Last Heart Beat Measure",value:lastBpm, unit: "Bpm", icon: Icons.heart_broken_rounded),
              CustomCardHome(title: "Today's Water Comsuption",value: totalWaterIntake.toString(), unit: "Ml", icon: Icons.water_drop_rounded),
            ]
          ),
        ),
      ),
    );
  }
}

