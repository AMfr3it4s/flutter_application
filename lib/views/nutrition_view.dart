import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/utils/db_helper.dart';
import 'package:path/path.dart';

class NutritionView extends StatefulWidget {
  const NutritionView({super.key});

  @override
  _NutritionViewState createState() => _NutritionViewState();
}

class _NutritionViewState extends State<NutritionView> {
  int totalWaterIntake = 0;


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
    _fetchTotalWaterIntake();
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 235, 206, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(239, 235, 206, 1),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: const Color.fromRGBO(47, 62, 70, 1),
              margin: const EdgeInsets.all(16.0),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Total Water Intake Today",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "$totalWaterIntake ml",
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                await DatabaseHelper().addWaterIntake();
                final snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                duration: Duration(seconds: 2),
                content: AwesomeSnackbarContent(
                title: 'Success',
                message: 'Additional glass of water drunk: 250ml',
                contentType: ContentType.success,
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                _fetchTotalWaterIntake();
              },
              child: const Icon(
                Icons.water_drop,
                size: 100, // Tamanho do ícone
                color: Color.fromRGBO(249, 110, 70, 1) // Cor do ícone
              ),
            ),
          ],
        ),
      ),
    );
  }
}

