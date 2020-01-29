import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/models/calorie_model.dart';

class CaloriesTab extends StatefulWidget{
  @override 
  _CaloriesTabState createState() => _CaloriesTabState();
}

class _CaloriesTabState extends State<CaloriesTab>{
  num _newCalories = 200;
  num _totalCalories;
  num _leftCalories;
  CalorieModel _calorieModel = CalorieModel();

  @override
  void initState() {
    super.initState();
    _totalCalories =  0;
    _leftCalories = 1600;
  }

  void _onAddCalories(){
    setState(() {
      _newCalories = _newCalories + 100;
    });
  }

  void _onSubtractCalories(){
    if(_newCalories >= 200){
      setState(() {
        _newCalories -= 100;
      });
    }
  }

  void _onSubmitCalories(){
    if(_newCalories > 0){
      setState(() {
        _totalCalories += _newCalories;
        _leftCalories -= _newCalories;
      });
      // addes to the db and triggers stream to refire
      _calorieModel.addCalorie(_totalCalories);
    }
  }

  @override
  Widget build(BuildContext context) {
  
    return CustomScrollView(
      slivers: const <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text('Calories'),
        ),
      ],
    ); 
  }
}