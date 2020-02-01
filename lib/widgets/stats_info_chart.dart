import 'package:flutter/cupertino.dart';
import 'package:simple_weight/database/calorie_data.dart';
import 'package:simple_weight/database/weight_data.dart';
import 'package:simple_weight/utils/weight_analysis.dart';
import 'package:simple_weight/utils/calorie_analysis.dart';

class StatsInfoChart extends StatelessWidget{
  CalorieAnalysis calorieInfo;
  WeightAnalysis weightInfo;

  StatsInfoChart({List<WeightData> weightData, List<CalorieData> calorieData}){
    this.calorieInfo = CalorieAnalysis(calorieData);
    this.weightInfo = WeightAnalysis(weightData);
  }

  @override 
  Widget build(BuildContext context){
    final num overallWeightLoss = weightInfo.overallWeightLoss;
    final Color weightLossColor = overallWeightLoss <= 0 ? CupertinoColors.activeBlue : CupertinoColors.destructiveRed;
    final overallWeightLossText = overallWeightLoss > 0 ? "+" + overallWeightLoss.toStringAsFixed(1) : overallWeightLoss.toStringAsFixed(1);

    return Container(
      padding: EdgeInsets.only(top: 0, left: 6, right: 6, bottom: 100),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CupertinoColors.inactiveGray,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: CupertinoColors.inactiveGray,
                ),
              ),
            ),
            child: Text("Calorie Stats:"),
          ),
          Row(  
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Avg Weekend: ${calorieInfo.weekendAverage}"),
              Text("Avg Weekday: ${calorieInfo.weekdayAverage}"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Min: ${calorieInfo.minCalorie.calories} "),
              Text("Max: ${calorieInfo.maxCalorie.calories} "),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("${calorieInfo.minCalorie.time}"),
              Text("${calorieInfo.maxCalorie.time}"),
            ],
          ),
          Container(
             padding: EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: CupertinoColors.inactiveGray,
                ),
              ),
            ),
            child: Text("Weight Stats:"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Overall Weight Loss: "),
                  Text(overallWeightLossText, style: TextStyle(color: weightLossColor),)
                ],
              ),
              Text("Avg Weight: ${weightInfo.averageWeight.toStringAsFixed(1)}"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Min: ${weightInfo.minWeight.weight}"),
              Text("Max: ${weightInfo.maxWeight.weight}"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("${weightInfo.minWeight.time}"),
              Text("${weightInfo.maxWeight.time}"),
            ],
          ),
        ],
      ),
    );
  }
}
