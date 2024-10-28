import 'dart:convert';

import 'package:flutter_application/models/heartRate.dart';
import 'package:flutter_application/models/sensor.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  //Get Database
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }
  
  //Initialize Database
  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'my_database.db');

    
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE steps (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL UNIQUE,
            stepCount INTEGER NOT NULL
          )
        ''');
        await db.execute('''
           CREATE TABLE heart_rate (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            bpm INTEGER NOT NULL,
            dateTime TEXT NOT NULL,
            points TEXT
          )
        ''');
      },
    );
  }

  //Insert  steps into the database
  Future<int> insertOrUpdateStep(int stepCount) async {
  final db = await database;

  // Format Date Time
  String formattedDate = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';

  // Verify if the new Date it's equal to the one on DB
  var result = await db.query(
    'steps',
    where: 'date = ?',
    whereArgs: [formattedDate],
  );

  if (result.isNotEmpty) {
    //Retived the total Steps
    int currentStepCount = result.first['stepCount'] as int;

    // Update the Steps on DB
    return await db.update(
      'steps',
      {'stepCount': currentStepCount + stepCount}, 
      where: 'date = ?',
      whereArgs: [formattedDate],
    );
  } else {
    //Insert a new entery if it does not exist
    return await db.insert('steps', {
      'date': formattedDate,
      'stepCount': stepCount,
    });
  }
}

  //Get Steps by Date
 Future<List<Map<String, dynamic>>> getStepsByDate(DateTime date) async {
  final db = await database;
  String formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  // Consulta os passos filtrando pela data
  return await db.query(
    'steps',
    where: 'date = ?',
    whereArgs: [formattedDate],
  );
}

  //Delete Spets by Date
  Future<int> deleteStepByDate(String date) async {
    final db = await database;
    return await db.delete(
      'steps',
      where: 'date = ?',
      whereArgs: [date],
    );
  }

  //Insert Heart Rate in to DB
   Future<int> insertHeartRate(int bpm, DateTime dateTime, List<Map<String, dynamic>> points) async {
    final db = await database;

    // Serialize My DataPoints List to Json
    String pointsJson = jsonEncode(points);

    return await db.insert('heart_rate', {
      'bpm': bpm,
      'dateTime': dateTime.toIso8601String(),
      'points': pointsJson,
    });
    }

  //Get Heart Rate 
  Future<List<HeartRateRecord>> getHeartRateHistory() async {
  final db = await database; 
  final List<Map<String, dynamic>> maps = await db.query('heart_rate');

  return List.generate(maps.length, (i) {
    return HeartRateRecord(
      id: maps[i]['id'], // Certifique-se de que 'id' existe no seu banco de dados
      bpm: maps[i]['bpm'],
      dateTime: DateTime.parse(maps[i]['dateTime']),
      dataPoints: (maps[i]['dataPoints'] != null && maps[i]['dataPoints'] is String)
          ? (json.decode(maps[i]['dataPoints']) as List<dynamic>)
              .map((point) => SensorValue(
                  time: DateTime.parse(point['time']),
                  value: point['value']))
              .toList()
          : [], // Se dataPoints for null ou não for uma string, retorna uma lista vazia
    );
  });
}

  // Get Heart Rate by it's ID
  Future<HeartRateRecord?> getHeartRateById(int id) async {
  final db = await database; // Sua função para obter a instância do banco de dados
  final maps = await db.query(
    'heart_rate', // Nome da tabela
    where: 'id = ?',
    whereArgs: [id],
  );

  if (maps.isNotEmpty) {
    return HeartRateRecord.fromMap(maps.first);
  } else {
    return null; // Registro não encontrado
  }
}

  //Delete  Heart Rate by it's ID
   Future<void> deleteHeartRate(int id) async {
    final db = await database;
    await db.delete(
      'heart_rate',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
