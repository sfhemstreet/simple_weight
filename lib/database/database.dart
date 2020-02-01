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
  static const String DB_NAME = 'simple_weight_db.db';

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
        hours_since_epoch INTEGER
      )
      '''
    );
    batch.execute(
      '''
      CREATE TABLE calories (
        time TEXT PRIMARY KEY,
        calories INTEGER,
        hours_since_epoch INTEGER
      );
      '''
    );
    await batch.commit();

    await _insertSampleData(db);
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

  Future<List<CalorieData>> calories() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('calories');

    // Convert the List<Map<String, dynamic> into a List<CalorieData>.
    return List.generate(maps.length, (i) {
      return CalorieData(
        time: maps[i]['time'],
        calories: maps[i]['calories']
      );
    });
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

  Future<List<WeightData>> weights() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('weights');

    // Convert the List<Map<String, dynamic> into a List<WeightData>.
    return List.generate(maps.length, (i) {
      return WeightData(
        time: maps[i]['time'],
        weight: maps[i]['weight']
      );
    });
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

  /// This inserts sample information so the app has data already.
  Future<void> _insertSampleData(Database db) async {

    insertWeight(WeightData(time: "January 2, 2020", weight: 146.4));
    insertWeight(WeightData(time: "January 3, 2020", weight: 144.8));
    insertWeight(WeightData(time: "January 7, 2020", weight: 144));
    insertWeight(WeightData(time: "January 8, 2020", weight: 141.8));
    insertWeight(WeightData(time: "January 9, 2020", weight: 140.2));
    insertWeight(WeightData(time: "January 10, 2020", weight: 141.8));
    insertWeight(WeightData(time: "January 12, 2020", weight: 144));
    insertWeight(WeightData(time: "January 13, 2020", weight: 144.4));
    insertWeight(WeightData(time: "January 14, 2020", weight: 140.8));
    insertWeight(WeightData(time: "January 15, 2020", weight: 140.8));
    insertWeight(WeightData(time: "January 16, 2020", weight: 140.6));
    insertWeight(WeightData(time: "January 17, 2020", weight: 140.8));
    insertWeight(WeightData(time: "January 18, 2020", weight: 142.2));
    insertWeight(WeightData(time: "January 23, 2020", weight: 144.7));
    insertWeight(WeightData(time: "January 24, 2020", weight: 143.8));
    insertWeight(WeightData(time: "January 25, 2020", weight: 142.8));
    insertWeight(WeightData(time: "January 26, 2020", weight: 143.8));
    insertWeight(WeightData(time: "January 27, 2020", weight: 143.8));
    insertWeight(WeightData(time: "January 28, 2020", weight: 141.8));
    insertWeight(WeightData(time: "January 29, 2020", weight: 140.2));
    insertWeight(WeightData(time: "January 30, 2020", weight: 141.4));

    insertCalories(CalorieData(time: "January 2, 2020", calories: 1600));
    insertCalories(CalorieData(time: "January 3, 2020", calories: 1500));
    insertCalories(CalorieData(time: "January 7, 2020", calories: 1400));
    insertCalories(CalorieData(time: "January 8, 2020", calories: 1400));
    insertCalories(CalorieData(time: "January 9, 2020", calories: 1500));
    insertCalories(CalorieData(time: "January 10, 2020", calories: 1600));
    insertCalories(CalorieData(time: "January 12, 2020", calories: 1700));
    insertCalories(CalorieData(time: "January 13, 2020", calories: 1500));
    insertCalories(CalorieData(time: "January 14, 2020", calories: 1500));
    insertCalories(CalorieData(time: "January 15, 2020", calories: 1400));
    insertCalories(CalorieData(time: "January 16, 2020", calories: 1600));
    insertCalories(CalorieData(time: "January 17, 2020", calories: 1500));
    insertCalories(CalorieData(time: "January 18, 2020", calories: 1600));
    insertCalories(CalorieData(time: "January 23, 2020", calories: 1400));
    insertCalories(CalorieData(time: "January 24, 2020", calories: 1500));
    insertCalories(CalorieData(time: "January 25, 2020", calories: 1600));
    insertCalories(CalorieData(time: "January 26, 2020", calories: 1500));
    insertCalories(CalorieData(time: "January 27, 2020", calories: 1500));
    insertCalories(CalorieData(time: "January 28, 2020", calories: 1600));
    insertCalories(CalorieData(time: "January 29, 2020", calories: 1600));
    insertCalories(CalorieData(time: "January 30, 2020", calories: 1400));

  }
}
