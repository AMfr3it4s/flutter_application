import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

class ActivityView extends StatefulWidget {
  const ActivityView({super.key});

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  late Stream<StepCount> _stepCountStream;
  int _totalSteps = 0; // Contagem de passos do dia atual
  List<int> _stepsHistory = []; // Histórico de passos por dia
  final int _goalSteps = 10000; // Meta
  double _distanceTraveled = 0.0; // em km
  double _caloriesBurned = 0.0; // em kcal
  late Timer _resetTimer;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _startResetTimer(); // Inicia o temporizador para resetar passos
  }

  void _requestPermissions() async {
    var status = await Permission.activityRecognition.status;
    if (!status.isGranted) {
      await Permission.activityRecognition.request();
    }
    if (await Permission.activityRecognition.isGranted) {
      _startListeningToSteps();
    }
  }

  void _startListeningToSteps() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(
      (StepCount stepCount) {
        setState(() {
          _totalSteps = stepCount.steps;
          _distanceTraveled = _totalSteps * 0.0008;
          _caloriesBurned = _totalSteps * 0.05;
          if (_stepsHistory.isEmpty || DateTime.now().day != DateTime.now().add(Duration(days: -1)).day) {
            // Armazena passos e reinicia contagem diária se for um novo dia
            _stepsHistory.add(_totalSteps);
            _totalSteps = 0; // Reinicia a contagem de passos do dia
          }
        });
      },
      onError: (error) {
        print("Error listening Steps: $error");
      },
    );
  }

  void _startResetTimer() {
    // Define o temporizador para resetar a contagem de passos à meia-noite
    _resetTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (DateTime.now().hour == 0 && DateTime.now().minute == 0) {
        setState(() {
          _stepsHistory.add(_totalSteps); // Armazena o total de passos antes de resetar
          _totalSteps = 0; // Reinicia a contagem de passos do dia
          _distanceTraveled = 0.0; // Reinicia a distância percorrida
          _caloriesBurned = 0.0; // Reinicia as calorias queimadas
        });
      }
    });
  }

  @override
  void dispose() {
    _resetTimer.cancel(); // Cancela o temporizador ao descartar o widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 235, 206, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(239, 235, 206, 1),
        title: const Text('Pedometer App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 150.0,
              lineWidth: 15.0,
              percent: _totalSteps / _goalSteps,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$_totalSteps",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Today's Steps",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              progressColor: Colors.green,
              backgroundColor: Colors.grey,
            ),
            const SizedBox(height: 20),
            _buildStatistics(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _totalSteps += 100; // Adiciona 10 passos ao total
                  _distanceTraveled = _totalSteps * 0.0008;
                  _caloriesBurned = _totalSteps * 0.05;
                });
              },
              child: Text("Test Add Steps"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      "${_distanceTraveled.toStringAsFixed(2)} km",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Text("Distance Traveled"),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "${_caloriesBurned.toStringAsFixed(2)} kcal",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Text("Burned Calories"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  
}
