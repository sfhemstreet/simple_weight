import 'dart:async';
import 'package:simple_weight/database/database.dart';
import 'package:simple_weight/database/weight_data.dart';

class WeightModel {
  static DBProvider database = DBProvider.db;
  static final _streamController = StreamController<List<WeightData>>.broadcast();
  
  
  WeightModel() {
    _getWeights();
  }

  Stream<List<WeightData>> get weightStream => _streamController.stream.asBroadcastStream();

  /// Get all weight info from DB, convert to WeightData (so we can use it in MultiProvider), add to stream sink.
  void _getWeights() async {
    try{
      final results = await database.getAllWeights();

      _streamController.add(results);
    } 
    catch(err){
      print(err);
    } 
  }

  void addTodaysWeight(num weight) async {
    final newWeight = new WeightData(weight: weight);
    try{
      await database.insertWeight(newWeight);  
    }
    catch(err){
      print('Error adding todays new weight');
      print(err);
    }
    finally{
      _getWeights();
    }
  }

  void insertWeight(WeightData weightData) async {
    try{
      await database.insertWeight(weightData);
    }
    catch(err){
      print('Error inserting new weight');
      print(err);
    }
    finally{
      _getWeights();
    }
  }

  void deleteAllWeights() async {
    try{
      await database.deleteAllWeights();
    }
    catch(error){
      print(error);
    }
    finally{
      _getWeights();
    }
  }

  void dispose(){
    _streamController.close();
  }
}