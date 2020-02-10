import 'package:flutter/cupertino.dart';
import 'package:simple_weight/models/calorie_model.dart';
import 'package:simple_weight/models/calorie_target_model.dart';
import 'package:simple_weight/models/weight_model.dart';
import 'package:simple_weight/models/weight_target_model.dart';
import 'package:simple_weight/styles/styles.dart';
import 'package:simple_weight/utils/constants.dart';
import 'package:simple_weight/widgets/restart_widget.dart';



class DeleteDataPopUp extends StatelessWidget{

  final WeightModel _weightModel = WeightModel();
  final CalorieModel _calorieModel = CalorieModel();

  Widget build(BuildContext context){
    return CupertinoActionSheet(
      title: Text("Delete Simple Weight Data", style: Styles.biggerText.copyWith(color: CupertinoColors.black),),
      message: Text("Warning, data deletion is permanent.", style: TextStyle(color: CupertinoColors.black)),
      actions: <Widget>[
        // Delete All Data
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          child: Text("Delete All Data"),
          onPressed: (){
            showCupertinoDialog(
              context: context,
              builder: (BuildContext context){
                return CupertinoAlertDialog(
                  title: Text("Delete All Data",),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Are you sure?"),
                  ),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text("Cancel"),
                      onPressed: (){
                        // Two Pops to close both menus
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      child: Text("Yes"),
                      onPressed: (){
                        _weightModel.deleteAllWeights();
                        _calorieModel.deleteAllCalories();
                        CalorieTargetModel().updateTarget(Constants.DEFAULT_CALORIE_TARGET);
                        WeightTargetModel().updateTarget(Constants.DEFAULT_GOAL_WEIGHT);
                        // Two Pops to close both menus
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();

                        RestartWidget.restartApp(context);
                      },
                    ),
                  ],
                );
              }
            );
          }, 
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context).pop(),
        child: Text("Cancel"),
      ),
    );
  }
}
