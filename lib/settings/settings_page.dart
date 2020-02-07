import 'package:flutter/cupertino.dart';
import 'package:simple_weight/settings/change_daily_calorie_target_popup.dart';
import 'package:simple_weight/settings/change_weight_goal_popup.dart';
import 'package:simple_weight/settings/delete_data_popup.dart';
import 'package:simple_weight/settings/edit_calorie_history.dart';
import 'package:simple_weight/settings/edit_weight_history.dart';
import 'package:simple_weight/styles/styles.dart';
import 'package:simple_weight/widgets/list_button.dart';

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

    // Configure gradient settings for Dark and Light Modes
    final Brightness brightness = MediaQuery.platformBrightnessOf(context);

    final List<Color> gradient = brightness == Brightness.dark ? Styles.darkGradient : Styles.lightGradient;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: gradient,
        ),
      ),
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text('Settings'),
            heroTag: "Settings Page",
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: 0,
            ),
            sliver: SliverList( 
              delegate: SliverChildListDelegate([

                // Change Weight Goal Button
                ListButton(
                  onPressed: () => _pushChangeWeightGoal(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Change Goal Weight", style: DefaultTextStyle.of(context).style), 
                      Icon(CupertinoIcons.bookmark),
                    ],
                  ),
                ),

                // Change Daily Calorie Target Button
                ListButton(
                  onPressed: () => _pushChangeDailyCalorieTarget(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Change Daily Calorie Target", style: DefaultTextStyle.of(context).style), 
                      Icon(CupertinoIcons.bookmark),
                    ],
                  ),
                ),

                // Edit Weights Button
                ListButton(
                  onPressed: () => _pushEditWeights(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Edit Weight History", style: DefaultTextStyle.of(context).style), 
                      Icon(CupertinoIcons.pencil),
                    ],
                  ),
                ),
                
                // Edit Calories Button
                ListButton(
                  onPressed: () => _pushEditCalories(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Edit Calorie History", style: DefaultTextStyle.of(context).style), 
                      Icon(CupertinoIcons.pencil),
                    ],
                  ),
                ),

                // Delete Data Button
                ListButton(
                  onPressed: () => _pushDeleteData(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Delete Data", style: DefaultTextStyle.of(context).style), 
                      Icon(CupertinoIcons.delete),
                    ],
                  ),
                ),

              ]),
            ),
          ),
        ],
      ),
    );
  }
}