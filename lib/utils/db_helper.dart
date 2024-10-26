import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'my_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE steps (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL UNIQUE,
            stepCount INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertOrUpdateStep(int stepCount) async {
  final db = await database;

  // Formatar a data atual
  String formattedDate = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';

  // Verificar se já existe uma entrada para a data atual
  var result = await db.query(
    'steps',
    where: 'date = ?',
    whereArgs: [formattedDate],
  );

  if (result.isNotEmpty) {
    // Recupera a contagem atual de passos
    int currentStepCount = result.first['stepCount'] as int;

    // Atualiza a contagem de passos somando o novo valor
    return await db.update(
      'steps',
      {'stepCount': currentStepCount + stepCount}, // Soma os passos
      where: 'date = ?',
      whereArgs: [formattedDate],
    );
  } else {
    // Insere uma nova entrada se não existir
    return await db.insert('steps', {
      'date': formattedDate,
      'stepCount': stepCount,
    });
  }
}


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




  Future<int> deleteStepByDate(String date) async {
    final db = await database;
    return await db.delete(
      'steps',
      where: 'date = ?',
      whereArgs: [date],
    );
  }
}
