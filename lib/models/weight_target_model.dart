import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_weight/utils/constants.dart';

class WeightTargetModel {
  static final _streamController = StreamController<WeightTarget>.broadcast();

  WeightTargetModel() {
    _getTarget();
  }

  Stream<WeightTarget> get weightTargetStream => _streamController.stream.asBroadcastStream();

  void _getTarget() async {
    try{
      // obtain shared preferences
      final prefs = await SharedPreferences.getInstance();
      final int weightTarget = prefs.getInt('Weight_target') ?? Constants.DEFAULT_GOAL_WEIGHT;

      final WeightTarget myTarget = WeightTarget(weightTarget); 

      _streamController.add(myTarget);
    } 
    catch(err){
      print(err);
    } 
  }

  void updateTarget(int weightTarget) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('Weight_target', weightTarget);
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

class WeightTarget {
  final int _weight;

  int get weight => _weight;

  WeightTarget(this._weight);
}