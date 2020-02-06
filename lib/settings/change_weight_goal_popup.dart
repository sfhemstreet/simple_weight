import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_weight/icons/scale_icon.dart';
import 'package:simple_weight/utils/constants.dart';

class ChangeGoalWeightPopUp extends StatefulWidget{
  @override 
  _ChangeGoalWeightPopUpState createState() => _ChangeGoalWeightPopUpState();
}

class _ChangeGoalWeightPopUpState extends State<ChangeGoalWeightPopUp>{

  int _weight = 0;

  Widget build(BuildContext context){

    final screenHeight = MediaQuery.of(context).size.height;
    double bottomPadding = 150;

    if(screenHeight > 680){
      bottomPadding = 230;
    }

    return CupertinoActionSheet(
      title: Text("Set Goal Weight"),
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
                    child: Icon(ScaleIcon.weight, color: CupertinoColors.inactiveGray,),
                  ),
                  placeholder: "Enter Weight",
                  autofocus: true,
                  autocorrect: false,
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  textInputAction: TextInputAction.done,
                  onChanged: (text){
                    // Input will always be text, parse to num if possible
                    int newWeight = int.tryParse(text) ?? 0;
                    
                    if(newWeight >= Constants.MIN_WEIGHT_TARGET && newWeight <= Constants.MAX_WEIGHT){
                      setState(() {
                        _weight = newWeight;
                      });
                    }
                    else{
                      setState(() {
                        _weight = 0;
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
                    child: Text('Submit Goal Weight') ,
                    onPressed: () async {
                      
                      if(_weight >= Constants.MIN_WEIGHT_TARGET && _weight <= Constants.MAX_WEIGHT){
                        // obtain shared preferences
                        final prefs = await SharedPreferences.getInstance();

                        // set goal weight value
                        prefs.setInt('weight_target', _weight);

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