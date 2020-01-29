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
  static const String DB_NAME = 'simple_weight.db';

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
        weight int
      )
      '''
    );
    batch.execute(
      '''
        CREATE TABLE calories (
        time TEXT PRIMARY KEY,
        calories INTEGER
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
    var res = await db.query("calories");
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
    var res = await db.query("weights");
    List<WeightData> list =
        res.isNotEmpty ? res.map((w) => WeightData.fromMap(w)).toList() : [];
    return list;
  }

  /// This inserts sample information so the app has data already.
  Future<void> _insertSampleData(Database db) async {
    Batch batchInsert = db.batch();
    batchInsert.rawInsert(
      '''
      INSERT INTO weights 
      VALUES ('January 2, 2020', 146.4)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO weights 
      VALUES ('January 3, 2020', 144.8)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO weights 
      VALUES ('January 7, 2020', 144)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO weights 
      VALUES ('January 8, 2020', 141.8)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO weights 
      VALUES ('January 9, 2020', 140.2)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO weights 
      VALUES ('January 10, 2020', 141.8)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO weights 
      VALUES ('January 12, 2020', 144)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO weights 
      VALUES ('January 13, 2020', 144.4)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO weights 
      VALUES ('January 14, 2020', 140.8)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO weights 
      VALUES ('January 15, 2020', 140.8)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO weights 
      VALUES ('January 16, 2020', 140.6)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO weights 
      VALUES ('January 17, 2020', 140.8)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO weights 
      VALUES ('January 18, 2020', 142.2)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO weights 
      VALUES ('January 23, 2020', 144.7)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO weights 
      VALUES ('January 24, 2020', 143.8)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO weights 
      VALUES ('January 25, 2020', 144.2)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO weights 
      VALUES ('January 26, 2020', 143.9)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO weights 
      VALUES ('January 27, 2020', 143.4)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO calories 
      VALUES ('January 2, 2020', 1400)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO calories 
      VALUES ('January 3, 2020', 1600)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO calories 
      VALUES ('January 7, 2020', 1400)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO calories 
      VALUES ('January 8, 2020', 1500)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO calories 
      VALUES ('January 9, 2020', 1440)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO calories 
      VALUES ('January 10, 2020', 1700)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO calories 
      VALUES ('January 12, 2020', 1300)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO calories 
      VALUES ('January 13, 2020', 1600)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO calories 
      VALUES ('January 14, 2020', 1500)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO calories 
      VALUES ('January 15, 2020', 1600)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO calories 
      VALUES ('January 16, 2020', 1400)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO calories 
      VALUES ('January 17, 2020', 1300)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO calories 
      VALUES ('January 18, 2020', 1400)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO calories 
      VALUES ('January 23, 2020', 1600)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO calories 
      VALUES ('January 24, 2020', 1600)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO calories 
      VALUES ('January 25, 2020', 1600)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO calories 
      VALUES ('January 26, 2020', 1500)
      '''
    );
    batchInsert.rawInsert(
      '''
      INSERT INTO calories 
      VALUES ('January 27, 2020', 1500)
      '''
    );
    await batchInsert.commit();
  }
}
