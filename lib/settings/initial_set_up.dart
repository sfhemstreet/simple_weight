import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_weight/icons/scale_icon.dart';
import 'package:simple_weight/styles/styles.dart';

class InitialSetUp extends StatefulWidget{
  @override 
  _InitialSetUpState createState() => _InitialSetUpState();
}

class _InitialSetUpState extends State<InitialSetUp>{

  


  static const int MIN_CALORIES = 1200;
  static const int MIN_WEIGHT = 120;
  int _goalWeight = 0;
  int _calorieTarget = 0;
  bool _weightIsSet = false;
  bool _calorieIsSet = false;


  Widget build(BuildContext context){

    final _children = <Widget>[];

    if(!_weightIsSet){
      _children.add(
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                bottom: 10,
                top: 50,
                left: 60,
                right: 60,
              ),
              child: CupertinoTextField(
                prefix: Padding( 
                  padding: EdgeInsets.all(4),
                  child: Icon(ScaleIcon.weight, color: CupertinoColors.inactiveGray,),
                ),
                placeholder: "Enter Goal Weight",
                autocorrect: false,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onChanged: (text){
                  // Input will always be text, parse to num if possible
                  int newWeight = int.tryParse(text) ?? 0;

                  if(newWeight >= MIN_WEIGHT){
                    setState(() {
                      _goalWeight = newWeight;
                    });
                  }
                  else{
                    setState(() {
                      _goalWeight = 0;
                    });
                  }
                }, 
                textAlign: TextAlign.center,
              ),
            ),
            CupertinoButton.filled(
              child: Text('Submit', style: Styles.buttonTextStyle), 
              onPressed: () async {
                if(_goalWeight > MIN_WEIGHT){
                  // obtain shared preferences
                  final prefs = await SharedPreferences.getInstance();
                  // set goal weight value
                  prefs.setInt('weight_target', _goalWeight);
                  
                  setState(() {
                    _weightIsSet = true;
                  });
                }
              },
              //padding: EdgeInsets.symmetric(vertical: 8, horizontal: 36),
              //minSize: 25,
            ), 
          ],
        )
      );
    } 
    if(_weightIsSet && !_calorieIsSet){
      _children.add(
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                bottom: 10,
                top: 50,
                left: 60,
                right: 60,
              ),
              child: CupertinoTextField(
                prefix: Padding( 
                  padding: EdgeInsets.all(4),
                  child: Icon(ScaleIcon.weight, color: CupertinoColors.inactiveGray,),
                ),
                placeholder: "Enter Calorie Target",
                autocorrect: false,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onChanged: (text){
                  // Input will always be text, parse to num if possible
                  int newCalories = int.tryParse(text) ?? 0;

                  if(newCalories >= MIN_WEIGHT){
                    setState(() {
                      _calorieTarget = newCalories;
                    });
                  }
                  else{
                    setState(() {
                      _calorieTarget = 0;
                    });
                  }
                }, 
                textAlign: TextAlign.center,
              ),
            ),
            CupertinoButton.filled(
              child: Text('Submit', style: Styles.buttonTextStyle), 
              onPressed: () async {
                if(_calorieTarget > MIN_CALORIES){
                  // obtain shared preferences
                  final prefs = await SharedPreferences.getInstance();
                  // set goal weight value
                  prefs.setInt('calorie_target', _calorieTarget);
                  
                  setState(() {
                    _calorieIsSet = true;
                  });
                }
              },
              //padding: EdgeInsets.symmetric(vertical: 8, horizontal: 36),
              //minSize: 25,
            ), 
          ],
        ),
      );
    }

    if(_weightIsSet && _calorieIsSet){
      Navigator.of(context).pop();
    }

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text("Simple Weight"),
          ),
          SliverPadding(
            padding: EdgeInsets.only(top: 10),
            sliver: SliverList( 
              delegate: SliverChildListDelegate(_children)
            ),
          ),
        ],
      ),
    );
  }
}