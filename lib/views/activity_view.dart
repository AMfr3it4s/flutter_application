import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application/utils/databa_helper.dart';
import 'package:flutter_application/widgets/dates.dart';
import 'package:flutter_application/widgets/graph.dart';
//import 'package:flutter_application/widgets/info.dart' hide Stats;
import 'package:flutter_application/widgets/stats.dart';
import 'package:flutter_application/widgets/steps.dart';

class ActivityView extends StatefulWidget {
  const ActivityView({super.key});

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  final dbHelper = DatabaseHelper();
  String todayStepCount = "0";
  static const int stepsPerMinute = 100; // Time
  static const double caloriesPerStep = 0.04; // Calories
  static const double metersPerStep = 0.8; // Distance
  double timeInMinutes = 0.0;
  int  caloriesBurned = 0;
  double distanceInMeters = 0.0;
  
  //Receive Data From Database Today's  Steps
  Future<void> _fetchTodaySteps() async {
    List<Map<String, dynamic>> steps = await dbHelper.getStepsByDate(DateTime.now());
    
    if (steps.isNotEmpty) {
      int count = steps.first['stepCount'];
      setState(() {
        todayStepCount = count.toString();
        // Calcular as métricas
        var metrics = calculateMetrics(count);
        timeInMinutes = metrics['timeInMinutes'];
        caloriesBurned = metrics['caloriesBurned'];
        distanceInMeters = metrics['distanceInMeters'];
      });
    }
  }

  Future<void> _addSteps(int stepCount) async {
    await dbHelper.insertOrUpdateStep(stepCount);
  }

  //Calculate Variavels
  Map<String, dynamic> calculateMetrics(int stepCount) {
    // Calculate Time
    double timeInMinutes = stepCount / stepsPerMinute;

    // Calculate Calories
    int caloriesBurned = (stepCount * caloriesPerStep).toInt();

    //Calculate Distance
    double distanceInMeters = stepCount * metersPerStep;

    return {
      'timeInMinutes': timeInMinutes,
      'caloriesBurned': caloriesBurned,
      'distanceInMeters': distanceInMeters,
    };
  }
 
  @override
  void initState() {
    super.initState();
    _fetchTodaySteps();
 
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 235, 206, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(239, 235, 206, 1),
        title: const Text(
          "Today's Activity",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Dates(),
            const SizedBox(height: 15),
            Steps(steps: todayStepCount),
            const SizedBox(height: 15),
            const Graph(),
            const SizedBox(height: 30),
            //const Info(),
            //const SizedBox(height: 15),
            Stats(calories:caloriesBurned,  distance: distanceInMeters,  time: timeInMinutes ),
            const SizedBox(height: 15),
          ElevatedButton(
          onPressed: () async{
            await _addSteps(60);
            
          },
          child: Text('Adicionar Passos do Dia'),)
            ],
        ),
      ),
    );
  }
}
