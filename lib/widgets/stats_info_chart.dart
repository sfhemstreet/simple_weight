import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:simple_weight/models/calorie_target_model.dart';
import 'package:simple_weight/models/weight_target_model.dart';
import 'package:simple_weight/styles/styles.dart';
import 'package:simple_weight/utils/constants.dart';
import 'package:simple_weight/utils/weight_analysis.dart';
import 'package:simple_weight/utils/calorie_analysis.dart';

class StatsInfoChart extends StatelessWidget{
  final CalorieAnalysis calorieInfo;
  final WeightAnalysis weightInfo;

  StatsInfoChart(this.weightInfo, this.calorieInfo);

  @override 
  Widget build(BuildContext context){
    
    CalorieTarget calorieTarget = Provider.of<CalorieTarget>(context);
    WeightTarget weightTarget = Provider.of<WeightTarget>(context);

    if(calorieTarget == null){
      calorieTarget = CalorieTarget(Constants.DEFAULT_CALORIE_TARGET);
    }

    if(weightTarget == null){
      weightTarget = WeightTarget(Constants.DEFAULT_GOAL_WEIGHT);
    }

    // Only display "0" if its zero, not "0.0"
    final String overallWeightLossCheckZero = weightInfo.overallWeightLoss == 0 ?
      weightInfo.overallWeightLoss.toStringAsFixed(0) : weightInfo.overallWeightLoss.toStringAsFixed(1);

    // Add "+" in front of number if greater than  zero.
    final String overallWeightLossText = weightInfo.overallWeightLoss > 0 ? 
      "+" + overallWeightLossCheckZero : overallWeightLossCheckZero;

    // Make number red if above zero, blue otherwise
    final Color overallWeightLossColor = weightInfo.overallWeightLoss > 0 ? 
      CupertinoColors.destructiveRed : CupertinoColors.activeGreen;

    // Only display "0" if its zero, not "0.0"
    final String averageWeightLossCheckZero = weightInfo.averageWeightLossPerWeek == 0 ?
      weightInfo.averageWeightLossPerWeek.toStringAsFixed(0) : weightInfo.averageWeightLossPerWeek.toStringAsFixed(1);

    // Add "+" in front of number if greater than  zero.
    final String averageWeightLossPerWeekText = weightInfo.averageWeightLossPerWeek > 0 ? 
      "+" + averageWeightLossCheckZero : averageWeightLossCheckZero;

    // Make number red if above zero, blue otherwise
    final Color avgWeightLossPerWeekColor = weightInfo.averageWeightLossPerWeek > 0 ? 
      CupertinoColors.destructiveRed : CupertinoColors.activeGreen;

    // Make number red if above calorie target, blue otherwise
    final Color weekendCaloriesColor = calorieInfo.weekendAverage > calorieTarget.calories ? 
      CupertinoColors.destructiveRed : CupertinoColors.activeGreen;

    // Make number red if above calorie target, blue otherwise
    final Color weekdayCalorieColor = calorieInfo.weekdayAverage > calorieTarget.calories ? 
      CupertinoColors.destructiveRed : CupertinoColors.activeGreen;

    // Configure gradient settings for Dark and Light Modes
    final Brightness brightness = MediaQuery.platformBrightnessOf(context);
      
    final Color containerColor = brightness == Brightness.dark ? 
      Color.fromRGBO(0, 0, 0, 0) : Color.fromRGBO(255, 255, 255, 0.0);

    // The spaces in the 1st Text widgets in each row are there 
    // to line up the 2nd items in the row in a straight column.
    // There is probably a better way to do this but this was the most straight forward.
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 90, left: 20, right: 0),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 0),
              padding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: containerColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Calorie Stats 
                  Padding(
                    padding: EdgeInsets.only(left: 0, right: 8, top: 8, bottom: 8),
                    child: Text(
                      "Calories:", 
                      style: TextStyle(decoration: TextDecoration.underline, decorationColor: CupertinoColors.inactiveGray),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text("Daily Calorie Target:       ", style: Styles.descriptor),
                        Text("${calorieTarget.calories} calories"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text("Average Weekend:         ", style: Styles.descriptor),
                        Text("${calorieInfo.weekendAverage}", 
                          style: DefaultTextStyle.of(context).style.copyWith(color: weekendCaloriesColor)),
                        Text(" calories"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text("Average Weekday:         ", style: Styles.descriptor),
                        Text("${calorieInfo.weekdayAverage}", 
                          style: DefaultTextStyle.of(context).style.copyWith(color: weekdayCalorieColor)),
                        Text(" calories"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text("Lowest Calorie Day:       ", style: Styles.descriptor),
                        Text("${calorieInfo.minCalorie.calories}  ${calorieInfo.minCalorie.time}"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text("Highest Calorie Day:      ", style: Styles.descriptor),
                        Text("${calorieInfo.maxCalorie.calories}  ${calorieInfo.maxCalorie.time}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 0),
              padding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 0),
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
                color: containerColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Weight Stats
                  Padding(
                    padding: EdgeInsets.only(left: 0, right: 8, top: 8, bottom: 8),
                    child: Text(
                      "Weight:", 
                      style: TextStyle(decoration: TextDecoration.underline, decorationColor: CupertinoColors.inactiveGray),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text("Goal Weight:                   ", style: Styles.descriptor),
                        Text("${weightTarget.weight}"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text("Overall Weight Loss:      ", style: Styles.descriptor),
                        Text("$overallWeightLossText", 
                          style: DefaultTextStyle.of(context).style.copyWith(color: overallWeightLossColor)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text("Avg Loss Per Week:       ", style: Styles.descriptor),
                        Text("$averageWeightLossPerWeekText", 
                          style: DefaultTextStyle.of(context).style.copyWith(color: avgWeightLossPerWeekColor)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text("Average Weight:             ", style: Styles.descriptor),
                        Text("${weightInfo.averageWeight.toStringAsFixed(1)}"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text("Lowest Weight:               ", style: Styles.descriptor),
                        Text("${weightInfo.minWeight.weight}  ${weightInfo.minWeight.time}"),
                      ],
                    ),   
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("Highest Weight:              ", style: Styles.descriptor),
                        Text("${weightInfo.maxWeight.weight}  ${weightInfo.maxWeight.time}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
      
  }
}
