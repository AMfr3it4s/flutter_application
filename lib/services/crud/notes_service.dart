import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

// Exceptions
class DatabaseAlreadyOpenException implements Exception {}

class UnableToGetDocumentsDirectory implements Exception {}

class DatabaseNotOpen implements Exception {}

class CouldNotDeleteUser implements Exception {}

class UserAlreadyExists implements Exception {}

class UserNotFoundException implements Exception {}
//Create DatabaseUser class inside this file

class NotesService {
  Database? _db;

  Future<DatabaseUser> getUser({required String email}) async {
    final database = _getDatabaseOrThrow();
    final result = await database.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (result.isEmpty) {
      throw UserNotFoundException();
    } else {
      return DatabaseUser.fromRow(result.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final database = _getDatabaseOrThrow();
    final result = await database.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (result.isNotEmpty) {
      throw UserAlreadyExists();
    }

    final userId =
        await database.insert(userTable, {emailColumn: email.toLowerCase()});

    return DatabaseUser(id: userId, email: email);
  }

  Future<void> deleteUser({required String email}) async {
    final database = _getDatabaseOrThrow();
    final deletedCount = await database.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toUpperCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow() {
    final database = _db;
    if (database == null) {
      throw DatabaseNotOpen();
    } else {
      return database;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final documentsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(documentsPath.path, dbName);
      final database = await openDatabase(dbPath);
      _db = database;
      //Create User Table
      await database.execute(createUserTable);
      //Create Note Table
      await database.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<void> close() async {
    final database = _db;

    if (database == null) {
      throw DatabaseNotOpen();
    } else {
      await database.close();
    }
    _db = null;
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;
  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final String? title;
  final String? image;
  final bool isSyncedWithCloud;

  DatabaseNote(
      {required this.id,
      required this.userId,
      required this.text,
      this.title,
      this.image,
      required this.isSyncedWithCloud});

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        title = map[titleColumn] as String?,
        image = map[imageColumn] as String?,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;
  @override
  String toString() =>
      'Note, ID = $id, userId = $userId, synced = $isSyncedWithCloud, text = $text, title = $title, image = $image';
  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseEuroMillion {
  final int id;
  final int userId;
  final String dayOFWeek;
  final String date;
  final List<int> numbers;
  final List<int> stars;
  final bool isFirstPrizeAwarded;

  DatabaseEuroMillion(
      {required this.id,
      required this.userId,
      required this.dayOFWeek,
      required this.date,
      required this.numbers,
      required this.stars,
      required this.isFirstPrizeAwarded});

  DatabaseEuroMillion.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        dayOFWeek = map[dayOFWeekColumn] as String,
        date = map[dateColumn] as String,
        numbers = (map[numbersColumn] as String)
            .split(',')
            .map((e) => int.parse(e))
            .toList(),
        stars = (map[starsColumn] as String)
            .split(',')
            .map((e) => int.parse(e))
            .toList(),
        isFirstPrizeAwarded =
            (map[isFirstPrizeAwardedColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Euromillions, ID = $id, userId = $userId, dayOfWeek = $dayOFWeek, date = $date, numbers = $numbers, stars = $stars, firstPrize = $isFirstPrizeAwarded';

  @override
  bool operator ==(covariant DatabaseEuroMillion other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const titleColumn = 'title';
const imageColumn = 'image';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
const eurimillionTable = 'euromillion';
const dayOFWeekColumn = 'day_of_week';
const dateColumn = 'date';
const numbersColumn = 'numbers';
const starsColumn = 'stars';
const isFirstPrizeAwardedColumn = 'is_first_prize_awarded';

// Table Creation
const createUserTable = ''' CREATE TABLE IF NOT EXISTS "user"  (
      "id" INTEGER NOT NULL,
      "email" TEXT NOT NULL UNIQUE,
      PRIMARY KEY("id" AUTOINCREMENT)
      );
      ''';
const createNoteTable = ''' CREATE TABLE IF NOT EXISTS "note"  (
      "id" INTEGER NOT NULL,
      "user_id" INTEGER NOT NULL,
      "text" TEXT,
      "title" TEXT,
      "image" TEXT,
      "is_synced_with_cloud" INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY("user_id") REFERENCES "user"("id"),
      PRIMARY KEY("id" AUTOINCREMENT)
      );
      ''';

const createEuroMillionTable = ''' CREATE TABLE IF NOT EXISTS "euromillion"  (
      "id" INTEGER NOT NULL,
      "user_id" INTEGER NOT NULL,
      "day_of_week" TEXT NOT NULL,
      "date" TEXT NOT NULL,
      "numbers" TEXT NOT NULL,
      "STARTS" TEXT NOT NULL,
      "is_first_prize_awarded" INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY("user_id") REFERENCES "user"("id"),
      PRIMARY KEY("id" AUTOINCREMENT)
       );''';
