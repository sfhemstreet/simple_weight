import 'dart:async';
import 'package:simple_weight/database/database.dart';
import 'package:simple_weight/database/calorie_data.dart';

class CalorieModel {
  static DBProvider database = DBProvider.db;
  static final _streamController = StreamController<List<CalorieData>>.broadcast();
  
  CalorieModel() {
    _getCalories();
  }

  Stream<List<CalorieData>> get calorieStream => _streamController.stream.asBroadcastStream();

  /// Get all weight info from DB, convert to WeightData (so we can use it in MultiProvider), add to stream sink.
  void _getCalories() async {
    try{
      final results = await database.getAllCalories();

      _streamController.add(results);
    } 
    catch(err){
      print(err);
    } 
  }

  void addTodaysCalorie(num calories) async {
    final newCalories = new CalorieData(calories: calories);
    try{
      await database.insertCalories(newCalories);  
    }
    catch(err){
      print('Error adding todays new calories');
      print(err);
    }
    finally{
      _getCalories();
    }
  }

  void insertCalories(CalorieData calorieData) async {
    try{
      await database.insertCalories(calorieData);
    }
    catch(err){
      print('Error inserting new calories');
      print(err);
    }
    finally{
      _getCalories();
    }
  }
  
  void deleteCalories(CalorieData calorieData) async {
    try{
      await database.deleteCalories(calorieData.time);
    }
    catch(error){
      print(error);
    }
    finally{
      _getCalories();
    }
  }

  void deleteAllCalories() async {
    try{
      await database.deleteAllCalories();
    }
    catch(error){
      print(error);
    }
    finally{
      _getCalories();
    }
  }

  void dispose(){
    _streamController.close();
  }
}

