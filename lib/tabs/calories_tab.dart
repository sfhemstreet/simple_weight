import 'package:flutter/cupertino.dart';
import 'package:simple_weight/models/calorie_model.dart';
import 'package:simple_weight/widgets/described_calories.dart';
import 'package:simple_weight/widgets/calorie_list.dart';

class CaloriesTab extends StatefulWidget{
  CaloriesTab({Key key}):super(key: key); 
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
      _calorieModel.addTodaysCalorie(_totalCalories);
    }
  }

  @override
  Widget build(BuildContext context) {
  
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text('Calories'),
        ),
        SliverPadding( 
          padding: EdgeInsets.all(10),
          sliver: SliverList( 
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Column(  
                    children: <Widget>[
                      Center(  
                        child: Row(  
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            describedCalories(description: 'Total Calories: ', calories: _totalCalories),
                            describedCalories(description: 'Calories Remaining: ', calories: _leftCalories)
                          ],
                        )
                      ),
                      Center(  
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,  
                          children: <Widget>[
                            CupertinoButton(
                              onPressed: _onSubtractCalories,
                              child: Icon(CupertinoIcons.minus_circled)
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                              child: Text(
                                '$_newCalories', 
                                style: TextStyle(fontSize: 30),
                              )
                            ),
                            CupertinoButton(
                              onPressed: _onAddCalories,
                              child: Icon(CupertinoIcons.add_circled)
                            ),
                          ],
                        ),
                      ),
                    ]
                  ),
                ),
                Padding( 
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
                  child:  CupertinoButton.filled(
                    child: Text('Add to Daily Total') ,
                    onPressed: () => _onSubmitCalories(),
                    padding: EdgeInsets.all(10.0),
                ),
                )
                
              ], 
            ),
          ),
        ),
        CalorieList(),
      ],
    ); 
  }
}