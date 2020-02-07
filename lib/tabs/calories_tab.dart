import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/database/calorie_data.dart';
import 'package:simple_weight/models/calorie_model.dart';
import 'package:simple_weight/models/calorie_target_model.dart';
import 'package:simple_weight/styles/styles.dart';
import 'package:simple_weight/settings/settings_page.dart';
import 'package:simple_weight/utils/constants.dart';
import 'package:simple_weight/utils/time_convert.dart';
import 'package:simple_weight/widgets/described_calories.dart';
import 'package:simple_weight/widgets/calorie_list.dart';

class CaloriesTab extends StatefulWidget{
  CaloriesTab({Key key}):super(key: key); 
  @override 
  _CaloriesTabState createState() => _CaloriesTabState();
}

class _CaloriesTabState extends State<CaloriesTab>{
  int _caloriesToAdd = 200;
  int _totalCalories;
  int _remainingCalories;
  int _calorieTarget;
  CalorieModel _calorieModel = CalorieModel();


  @override
  void initState(){
    super.initState();
    _calorieTarget = Constants.DEFAULT_CALORIE_TARGET;
    _totalCalories =  0;
    _remainingCalories = _calorieTarget;
  }

 
  void _checkTodaysCalories(BuildContext context) async {
    
    final historicCalories = Provider.of<List<CalorieData>>(context, listen: false);

    // Check date of last list item, if historic calories has items.
    // Set _totalCalories and _remainingCalories to display correct amount
    // if calories for today already exist.
    if(historicCalories != null && historicCalories.length > 0){
      final CalorieData latest = historicCalories[historicCalories.length - 1];
      final String today = TimeConvert().getFormattedString();
      
      if(latest.time == today){
        setState(() {
          _totalCalories = latest.calories;
          _remainingCalories = _calorieTarget - latest.calories;
        });
      }  
    }
    // This is here if the user deletes all the data and theres still state left over
    // from before data was deleted. It resets the total and remaining calorie display.
    if(historicCalories != null && historicCalories.length == 0){
      setState(() {
        _totalCalories = 0;
        _remainingCalories = _calorieTarget;
      });
    }
  }

  void _onAddCalories(){
    if(_caloriesToAdd + 100 <= Constants.MAX_CALORIES){
      setState(() {
        _caloriesToAdd = _caloriesToAdd + 100;
      });
    }
  }

  void _onSubtractCalories(){
    if(_caloriesToAdd >= 100){
      setState(() {
        _caloriesToAdd -= 100;
      });
    }
  }

  void _onSubmitCalories(){
    if(_caloriesToAdd >= 0){
      setState(() {
        _totalCalories += _caloriesToAdd;
        _remainingCalories -= _caloriesToAdd;
      });
      // adds to the db and triggers stream to refire
      _calorieModel.addTodaysCalorie(_totalCalories);
    }
  }

  void _pushSettings(BuildContext context){
    Navigator.push(context, CupertinoPageRoute(
      builder: (context) => SettingsPage(),
    ));
  }

  @override
  Widget build(BuildContext context){

    final CalorieTarget calorieTarget = Provider.of<CalorieTarget>(context);

    if(calorieTarget != null && calorieTarget.calories != _calorieTarget){
      setState(() {
        _calorieTarget = calorieTarget.calories;
      });
    }

    _checkTodaysCalories(context);
    
     // Configure gradient settings for Dark and Light Modes
    final Brightness brightness = MediaQuery.platformBrightnessOf(context);

    final List<Color> gradient = brightness == Brightness.dark ? Styles.darkGradient : Styles.lightGradient;

    final Color containerColor = brightness == Brightness.dark ? Styles.darkContainer : Styles.lightContainer;
  
    return Container(
      decoration: BoxDecoration(  
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text('Calories'),
            trailing: CupertinoButton(
              onPressed: () => _pushSettings(context),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              minSize: 20,
              child: Icon(CupertinoIcons.settings),
            ),
            heroTag: "Calories Tab",
          ),
          SliverPadding( 
            padding: EdgeInsets.all(0),
            sliver: SliverList( 
              delegate: SliverChildListDelegate(
                [
                  Container(
                    color: containerColor,
                    padding: EdgeInsets.only(top: 10),
                    child: Column(  
                      children: <Widget>[
                        Center(  
                          child: Row(  
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              describedCalories(description: 'Total Calories: ', calories: _totalCalories, max: _calorieTarget),
                              describedCalories(description: 'Remaining: ', calories: _remainingCalories, max: _calorieTarget)
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
                                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                                child: Text(
                                  '$_caloriesToAdd', 
                                  style: Styles.biggerText,
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
                  Container(
                    color: containerColor, 
                    padding: EdgeInsets.only(top: 0, bottom: 10, right: 100, left: 100),
                    child:  CupertinoButton.filled(
                      child: Text("Add to Today's Total", style: Styles.buttonTextStyle,),
                      onPressed: () => _onSubmitCalories(),
                      padding: EdgeInsets.all(10.0),
                    ),
                  ),
                ], 
              ),
            ),
          ),
          CalorieList(),
        ],
      ),
    ); 
  }
}