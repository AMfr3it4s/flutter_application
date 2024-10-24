import 'package:flutter/material.dart';
import 'package:flutter_application/widgets/dates.dart';
import 'package:flutter_application/widgets/graph.dart';
import 'package:flutter_application/widgets/info.dart' hide Stats;
import 'package:flutter_application/widgets/stats.dart';
import 'package:flutter_application/widgets/steps.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:radial_progress/radial_progress.dart';
import 'package:emojis/emojis.dart';

class ActivityView extends StatefulWidget {
  const ActivityView({super.key});

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  late Stream<StepCount> _stepCountStream;
  int _totalSteps = 0; 
  final List<int> _stepsHistory = []; 
  final int _goalSteps = 10000; // Meta
  double _distanceTraveled = 0.0; // em km
  double _caloriesBurned = 0.0; // em kcal
  late Timer _resetTimer;
  double _percent = 0.0;
  
  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _startResetTimer(); 
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
          if (_stepsHistory.isEmpty || DateTime.now().day != DateTime.now().add(const Duration(days: -1)).day) {
            _stepsHistory.add(_totalSteps);
            _totalSteps = 0; 
          }
          _updatePercent();
        });
      },
      onError: (error) {
        
      },
    );
  }

  void _updatePercent() {
  setState(() {
    _percent = _totalSteps /_goalSteps;
    print("Percent: $_percent");
  });
}

  void _startResetTimer() {
    _resetTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (DateTime.now().hour == 0 && DateTime.now().minute == 0) {
        setState(() {
          _stepsHistory.add(_totalSteps); 
          _totalSteps = 0; 
          _distanceTraveled = 0.0; 
          _caloriesBurned = 0.0; 
        });
      }
    });
  }

  @override
  void dispose() {
    _resetTimer.cancel(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 235, 206, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(239, 235, 206, 1),
        title: const Text(" Today's Activity", 
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold
        ) ,),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Dates(),
            const SizedBox(height: 15),
            const Steps(),
            const SizedBox(height: 15),
            const Graph(),
            const SizedBox(height: 30),
            const Info(), 
            const SizedBox(height: 15),
            const Stats(),
            const SizedBox(height: 15),
            RadialProgressWidget(
              percent: 0.3,
              diameter: 180,
              bgLineColor: const Color.fromRGBO(47, 62, 70, 0.2),
              progressLineColors: const  [ Color.fromRGBO(47, 62, 70, 1)],
              progressLineWidth: 16,
              startAngle: StartAngle.top,
              centerChild:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                  _percent < 0.2 ? "You Can do it!" : _percent < 0.5 ? "Good Job!" : _percent < 0.7 ? "Great Job!" : _percent >= 1 ? "You are on Fire" : "Excellent",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                  fontWeight: FontWeight.bold
              ),
              ), 
              Text(_percent < 0.2 ? Emojis.winkingFace : _percent < 0.5 ? Emojis.grinningFace : _percent <0.7 ? Emojis.upsideDownFace : _percent >= 1? Emojis.fire : Emojis.astonishedFace,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 30,
                  ),
              ),
              const  SizedBox(height: 10),
              Text("$_totalSteps",
                  maxLines: 2,
                  style: const TextStyle(
                  fontWeight: FontWeight.bold)
              ),
              ],
                
              )
               
              ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _totalSteps += 100; 
                  _distanceTraveled = _totalSteps * 0.0008;
                  _caloriesBurned = _totalSteps * 0.05;
                  _updatePercent();
                });
              },
              child: const Text("Test Add Steps"),
            ),
          ],
        ),
      ),
    );
  }  
}
