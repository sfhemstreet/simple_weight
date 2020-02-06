import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:simple_weight/database/calorie_data.dart';
import 'package:simple_weight/database/weight_data.dart';

/// DB interactions class.
class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;
  static const String DB_NAME = 'simple_weight_db_9.db';

  Future<Database> get database async {
    if (_database != null){
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    final _db = await openDatabase(path, version: 1, onCreate: _createDB);
    return _db;
  }

  void _createDB(Database db, int version) async {
    // We need to create the tables in the database.
    Batch batch = db.batch();
    batch.execute(
      '''
      CREATE TABLE weights (
        time TEXT PRIMARY KEY,
        weight REAL,
        day_of_week TEXT,
        hours_since_epoch INTEGER
      )
      '''
    );
    batch.execute(
      '''
      CREATE TABLE calories (
        time TEXT PRIMARY KEY,
        calories INTEGER,
        day_of_week TEXT,
        hours_since_epoch INTEGER
      );
      '''
    );
    
    await batch.commit();
  }

  /// Inserts calorie into calories table, replaces old data if same day is given. 
  Future<void> insertCalories(CalorieData calories) async {
    final Database db = await database;

    await db.insert(
      'calories',
      calories.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCalories(CalorieData calories) async {
    final db = await database;

    await db.update(
      'calories',
      calories.toMap(),
      where: "time = ?",
      whereArgs: [calories.time],
    );
  }

  Future<void> deleteCalories(String time) async {
    final db = await database;

    await db.delete(
      'calories',
      where: "time = ?",
      whereArgs: [time],
    );
  }

  Future<List<CalorieData>> getAllCalories() async {
    final db = await database;
    var res = await db.query("calories", orderBy: "hours_since_epoch ASC");
    List<CalorieData> list =
      res.isNotEmpty ? res.map((c) => CalorieData.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> deleteAllCalories() async {
    final db = await database;

    await db.delete( 
      'calories',
    );
  }

  Future<void> insertWeight(WeightData weight) async {
    final Database db = await database;

    await db.insert(
      'weights',
      weight.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateWeight(WeightData weight) async {
    final db = await database;

    await db.update(
      'weights',
      weight.toMap(),
      where: "time = ?",
      whereArgs: [weight.time],
    );
  }

  Future<void> deleteWeight(String time) async {
    final db = await database;

    await db.delete(
      'weights',
      where: "time = ?",
      whereArgs: [time],
    );
  }

  Future<void> deleteAllWeights() async {
    final db = await database;

    await db.delete(
      'weights',
    );
  }

  Future<List<WeightData>> getAllWeights() async {
    final db = await database;
    var res = await db.query("weights", orderBy: "hours_since_epoch ASC");
    List<WeightData> list =
        res.isNotEmpty ? res.map((w) => WeightData.fromMap(w)).toList() : [];
    return list;
  }

}
