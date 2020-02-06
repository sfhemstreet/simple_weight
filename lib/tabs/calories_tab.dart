import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_weight/database/calorie_data.dart';
import 'package:simple_weight/models/calorie_model.dart';
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
  int _newCalories = 200;
  int _totalCalories;
  int _leftCalories;
  int _calorieTarget;
  CalorieModel _calorieModel = CalorieModel();

  @override
  void initState(){
    super.initState();
    _calorieTarget = 1600;
    _totalCalories =  0;
    _leftCalories = _calorieTarget;
  }

  // Checks to see if prev calories were saved today so we can disoplay correct total / remaining
  void _checkTodaysCalories(BuildContext context) async {

    
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
    final int calorieTarget = prefs.getInt('calorie_target') ?? 1600;

    _calorieTarget = calorieTarget;
    
    // Check with DB to see if we have data for today.
    final historicCalories = Provider.of<List<CalorieData>>(context, listen: false);

    // Only do this if we have data
    if(historicCalories != null && historicCalories.length > 0){
      final latest = historicCalories[historicCalories.length - 1];
      final today = TimeConvert().getFormattedString();
      // We want to display the current calorie count for today if it exists in the DB.
      if(latest.time == today){
        setState(() {
          _totalCalories = latest.calories;
          _leftCalories = _calorieTarget - _totalCalories;
        });
      }  
    }
    // This is here if the user deletes all the data and theres still state left over
    // from before data was deleted. It resets the total and remaining calorie display.
    if(historicCalories != null && historicCalories.length == 0){
      setState(() {
        _totalCalories = 0;
        _leftCalories = _calorieTarget;
      });
    }
  }

  void _onAddCalories(){
    if(_newCalories + 100 <= Constants.MAX_CALORIES){
      setState(() {
        _newCalories = _newCalories + 100;
      });
    }
  }

  void _onSubtractCalories(){
    if(_newCalories >= 100){
      setState(() {
        _newCalories -= 100;
      });
    }
  }

  void _onSubmitCalories(){
    if(_newCalories >= 0){
      setState(() {
        _totalCalories += _newCalories;
        _leftCalories -= _newCalories;
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

    _checkTodaysCalories(context);

     // Configure gradient settings for Dark and Light Modes
    final Brightness brightness = MediaQuery.platformBrightnessOf(context);

    final List<Color> gradient = brightness == Brightness.dark ? Styles.darkGradient : Styles.lightGradient;

    final Color containerColor = brightness == Brightness.dark ? Color.fromRGBO(0, 0, 0, 0.7) : Color.fromRGBO(255, 255, 255, 0.7);
  
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
                              describedCalories(description: 'Remaining: ', calories: _leftCalories, max: _calorieTarget)
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
                                  '$_newCalories', 
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