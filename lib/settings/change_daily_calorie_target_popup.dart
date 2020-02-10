import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/icons/silverware_icon.dart';
import 'package:simple_weight/models/calorie_target_model.dart';
import 'package:simple_weight/utils/constants.dart';

class ChangeDailyCalorieTargetPopUp extends StatefulWidget{
  @override 
  _ChangeDailyCalorieTargetPopUpState createState() => _ChangeDailyCalorieTargetPopUpState();
}

class _ChangeDailyCalorieTargetPopUpState extends State<ChangeDailyCalorieTargetPopUp>{
 
  int _calories = 0;

  Widget build(BuildContext context){

    final screenHeight = MediaQuery.of(context).size.height;
    double bottomPadding = 150;

    if(screenHeight > 680){
      bottomPadding = 230;
    }

    final CalorieTarget currentCalorieTarget = Provider.of<CalorieTarget>(context);

    String calorieTargetText = currentCalorieTarget == null ? 
      Constants.DEFAULT_CALORIE_TARGET.toString() : currentCalorieTarget.calories.toString();

    return CupertinoActionSheet(
      title: Text("Set Daily Calorie Target"),
      message: Text("Current calorie target: $calorieTargetText"),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50),
                child: CupertinoTextField(
                  prefix: Padding( 
                    padding: EdgeInsets.all(4),
                    child: Icon(SilverwareIcon.cutlery, color: CupertinoColors.inactiveGray,),
                  ),
                  placeholder: "Enter Calories",
                  autofocus: true,
                  autocorrect: false,
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  textInputAction: TextInputAction.done,
                  onChanged: (text){
                    // Input will always be text, parse to num if possible
                    int newCalories = int.tryParse(text) ?? 0;

                    if(newCalories >= Constants.MIN_CALORIE_TARGET && newCalories <= Constants.MAX_CALORIES){
                      setState(() {
                        _calories = newCalories;
                      });
                    }
                    else{
                      setState(() {
                        _calories = 0;
                      });
                    }
                  }, 
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    child: Text('Cancel') ,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: Text('Submit Calorie Target') ,
                    onPressed: () async {
                      if(_calories >= Constants.MIN_CALORIE_TARGET && _calories <= Constants.MAX_CALORIES){
                        // set goal weight value
                        CalorieTargetModel().updateTarget(_calories);

                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context).pop(),
        child: Text("Cancel"),
      ),
    );
  }
}