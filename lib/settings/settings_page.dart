import 'package:flutter/cupertino.dart';
import 'package:simple_weight/settings/change_daily_calorie_target_popup.dart';
import 'package:simple_weight/settings/change_weight_goal_popup.dart';
import 'package:simple_weight/settings/delete_data_popup.dart';
import 'package:simple_weight/settings/edit_calorie_history.dart';
import 'package:simple_weight/settings/edit_weight_history.dart';

/// Settings Page contains list of actions for user settings
class SettingsPage extends StatelessWidget{

  void _pushChangeWeightGoal(BuildContext context){
    showCupertinoModalPopup(
      context: context, 
      builder: (BuildContext context) => ChangeGoalWeightPopUp(),
    );
  }

  void _pushChangeDailyCalorieTarget(BuildContext context){
    showCupertinoModalPopup(
      context: context, 
      builder: (BuildContext context) => ChangeDailyCalorieTargetPopUp(),
    );
  }

  void _pushEditWeights(BuildContext context){
    Navigator.push(context, CupertinoPageRoute(
      fullscreenDialog: true,
      builder: (context) => EditWeightHistory(),
    ));
  }

  void _pushEditCalories(BuildContext context){
    Navigator.push(context, CupertinoPageRoute(
      fullscreenDialog: true,
      builder: (context) => EditCalorieHistory(),
    ));
  }

  void _pushDeleteData(BuildContext context){
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => DeleteDataPopUp(),
    );
  }

  @override 
  Widget build(BuildContext context){
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text('Settings'),
          heroTag: "Settings Page",
        ),
        SliverPadding(
          padding: EdgeInsets.only(top: 0),
          sliver: SliverList( 
            delegate: SliverChildListDelegate([

              // Change Weight Goal Button
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.separator
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                child: CupertinoButton(
                  onPressed: () => _pushChangeWeightGoal(context),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Change Goal Weight", style: DefaultTextStyle.of(context).style), 
                    Icon(CupertinoIcons.bookmark),
                  ],
                  ),
                ),
              ),

              // Change Daily Calorie Target Button
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.separator
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                child: CupertinoButton(
                  onPressed: () => _pushChangeDailyCalorieTarget(context),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Change Daily Calorie Target", style: DefaultTextStyle.of(context).style), 
                    Icon(CupertinoIcons.bookmark),
                  ],
                  ),
                ),
              ),

              // Edit Weights Button
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.separator
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                child: CupertinoButton(
                  onPressed: () => _pushEditWeights(context),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Edit Past Weights", style: DefaultTextStyle.of(context).style), 
                    Icon(CupertinoIcons.pencil),
                  ],
                  ),
                ),
              ),

              // Edit Calories Button
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.separator
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                child: CupertinoButton(
                  onPressed: () => _pushEditCalories(context),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Edit Past Calories", style: DefaultTextStyle.of(context).style), 
                    Icon(CupertinoIcons.pencil),
                  ],
                  ),
                ),
              ),

              // Delete Data Button
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.separator
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                child: CupertinoButton(
                  onPressed: () => _pushDeleteData(context),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Delete Data", style: DefaultTextStyle.of(context).style), 
                    Icon(CupertinoIcons.delete),
                  ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}