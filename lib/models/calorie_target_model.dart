import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_weight/utils/constants.dart';

class CalorieTargetModel {
  static final _streamController = StreamController<CalorieTarget>.broadcast();

  CalorieTargetModel() {
    _getTarget();
  }

  Stream<CalorieTarget> get calorieTargetStream => _streamController.stream.asBroadcastStream();

  void _getTarget() async {
    try{
      // obtain shared preferences
      final prefs = await SharedPreferences.getInstance();
      final int calorieTarget = prefs.getInt('calorie_target') ?? Constants.DEFAULT_CALORIE_TARGET;

      final CalorieTarget myTarget = CalorieTarget(calorieTarget); 

      _streamController.add(myTarget);
    } 
    catch(err){
      print(err);
    } 
  }

  void updateTarget(int calorieTarget) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('calorie_target', calorieTarget);
    }
    catch(err){
      print('Error adding todays new weight');
      print(err);
    }
    finally{
      _getTarget();
    }
  }
  
  void dispose(){
    _streamController.close();
  }
}

class CalorieTarget {
  final int _calories;

  int get calories => _calories;

  CalorieTarget(this._calories);
}